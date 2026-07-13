import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/database/local_database.dart';
import '../../dashboard/providers/role_provider.dart';

class AttendanceRecord {
  final String id;
  final String date;
  final String checkInTime;
  final String? checkOutTime;
  final double hoursWorked;
  final bool isOvertimeApproved;
  final String role;

  AttendanceRecord({
    required this.id,
    required this.date,
    required this.checkInTime,
    this.checkOutTime,
    required this.hoursWorked,
    required this.isOvertimeApproved,
    required this.role,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date,
      'checkInTime': checkInTime,
      'checkOutTime': checkOutTime,
      'hoursWorked': hoursWorked,
      'isOvertimeApproved': isOvertimeApproved ? 1 : 0,
      'role': role,
    };
  }

  factory AttendanceRecord.fromMap(Map<String, dynamic> map) {
    return AttendanceRecord(
      id: map['id'] as String,
      date: map['date'] as String,
      checkInTime: map['checkInTime'] as String,
      checkOutTime: map['checkOutTime'] as String?,
      hoursWorked: (map['hoursWorked'] as num).toDouble(),
      isOvertimeApproved: map['isOvertimeApproved'] == 1,
      role: map['role'] as String,
    );
  }
}

class AttendanceState {
  final bool isClockedIn;
  final DateTime? clockInTime;
  final Duration elapsedDuration;
  final AsyncValue<List<AttendanceRecord>> history;

  AttendanceState({
    required this.isClockedIn,
    this.clockInTime,
    required this.elapsedDuration,
    required this.history,
  });

  AttendanceState copyWith({
    bool? isClockedIn,
    DateTime? clockInTime,
    Duration? elapsedDuration,
    AsyncValue<List<AttendanceRecord>>? history,
  }) {
    return AttendanceState(
      isClockedIn: isClockedIn ?? this.isClockedIn,
      clockInTime: clockInTime ?? this.clockInTime,
      elapsedDuration: elapsedDuration ?? this.elapsedDuration,
      history: history ?? this.history,
    );
  }
}

class AttendanceNotifier extends StateNotifier<AttendanceState> {
  final UserRole activeRole;
  final Ref ref;
  Timer? _ticker;
  final LocalDatabase _db = LocalDatabase.instance;

  AttendanceNotifier(this.activeRole, this.ref)
      : super(AttendanceState(
          isClockedIn: false,
          elapsedDuration: Duration.zero,
          history: const AsyncValue.loading(),
        )) {
    loadAttendanceHistory();
  }

  Future<void> loadAttendanceHistory() async {
    try {
      final database = await _db.database;
      final roleStr = activeRole.toString().split('.').last;

      final List<Map<String, dynamic>> maps = await database.query(
        'attendance',
        where: 'role = ?',
        whereArgs: [roleStr],
        orderBy: 'date DESC',
      );

      final records = maps.map((map) => AttendanceRecord.fromMap(map)).toList();

      // Check if there is an active check-in (no checkOutTime)
      final activeRecordIndex = records.indexWhere((r) => r.checkOutTime == null);

      if (activeRecordIndex != -1) {
        final activeRecord = records[activeRecordIndex];
        final clockInDateTime = DateTime.parse(activeRecord.checkInTime);
        final elapsed = DateTime.now().difference(clockInDateTime);

        state = state.copyWith(
          isClockedIn: true,
          clockInTime: clockInDateTime,
          elapsedDuration: elapsed,
          history: AsyncValue.data(records),
        );
        _startTimer();
      } else {
        state = state.copyWith(
          isClockedIn: false,
          clockInTime: null,
          elapsedDuration: Duration.zero,
          history: AsyncValue.data(records),
        );
      }
    } catch (e, stack) {
      state = state.copyWith(history: AsyncValue.error(e, stack));
    }
  }

  void _startTimer() {
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.clockInTime != null) {
        state = state.copyWith(
          elapsedDuration: DateTime.now().difference(state.clockInTime!),
        );
      }
    });
  }

  void _stopTimer() {
    _ticker?.cancel();
    _ticker = null;
  }

  Future<void> toggleClockInOut() async {
    try {
      final database = await _db.database;
      final roleStr = activeRole.toString().split('.').last;
      final todayStr = DateTime.now().toIso8601String().substring(0, 10);

      if (!state.isClockedIn) {
        // Perform Clock-In
        final clockInDateTime = DateTime.now();
        final recordId = 'att_${clockInDateTime.millisecondsSinceEpoch}';

        final newRecord = AttendanceRecord(
          id: recordId,
          date: todayStr,
          checkInTime: clockInDateTime.toIso8601String(),
          checkOutTime: null,
          hoursWorked: 0.0,
          isOvertimeApproved: false,
          role: roleStr,
        );

        await database.insert('attendance', newRecord.toMap());

        // Update central activity logs
        await ref.read(activityProvider(activeRole).notifier).logNewActivity(
              title: '${ROLE_CONFIGS[activeRole]?.title} Clocked In',
              type: 'attendance',
              description: 'Successfully checked in via biometric ID verification.',
            );

        await loadAttendanceHistory();
      } else {
        // Perform Clock-Out
        _stopTimer();
        final clockOutDateTime = DateTime.now();
        final clockInDateTime = state.clockInTime ?? clockOutDateTime;
        final elapsedHours = clockOutDateTime.difference(clockInDateTime).inMinutes / 60.0;

        // Update SQLite
        await database.rawUpdate('''
          UPDATE attendance 
          SET checkOutTime = ?, hoursWorked = ?, isOvertimeApproved = ?
          WHERE role = ? AND checkOutTime IS NULL
        ''', [
          clockOutDateTime.toIso8601String(),
          elapsedHours,
          elapsedHours > 8.0 ? 1 : 0, // Mock: approve overtime if shift is > 8h
          roleStr
        ]);

        // Register in activity logger
        await ref.read(activityProvider(activeRole).notifier).logNewActivity(
              title: '${ROLE_CONFIGS[activeRole]?.title} Clocked Out',
              type: 'attendance',
              description: 'Completed shift with ${elapsedHours.toStringAsFixed(2)} hours logged.',
            );

        // Record monthly earnings entry
        final baseRate = ROLE_CONFIGS[activeRole]?.hourlyRate ?? 100.0;
        final normalHours = elapsedHours > 8.0 ? 8.0 : elapsedHours;
        final otHours = elapsedHours > 8.0 ? elapsedHours - 8.0 : 0.0;
        final basicEarned = normalHours * baseRate;

        final yearMonth = '${clockOutDateTime.year}-${clockOutDateTime.month.toString().padLeft(2, '0')}';
        final ledgerId = 'earn_${roleStr}_$yearMonth';

        final List<Map<String, dynamic>> existingLedger = await database.query(
          'earnings',
          where: 'id = ?',
          whereArgs: [ledgerId],
        );

        if (existingLedger.isEmpty) {
          await database.insert('earnings', {
            'id': ledgerId,
            'yearMonth': yearMonth,
            'basicSalary': basicEarned,
            'hoursOvertime': otHours,
            'allowancePaid': 150.0, // Standard daily travel allowance
            'pfDeducted': ROLE_CONFIGS[activeRole]?.pfApplicable == true ? basicEarned * 0.12 : 0.0,
            'role': roleStr,
            'syncState': 'synced',
          });
        } else {
          final cur = existingLedger.first;
          await database.update('earnings', {
            'basicSalary': (cur['basicSalary'] as num).toDouble() + basicEarned,
            'hoursOvertime': (cur['hoursOvertime'] as num).toDouble() + otHours,
            'allowancePaid': (cur['allowancePaid'] as num).toDouble() + 150.0,
            'pfDeducted': (cur['pfDeducted'] as num).toDouble() + (ROLE_CONFIGS[activeRole]?.pfApplicable == true ? basicEarned * 0.12 : 0.0),
          }, where: 'id = ?', whereArgs: [ledgerId]);
        }

        await loadAttendanceHistory();
      }
    } catch (e) {
      // Handle toggle errors
    }
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }
}

// Reactively provide attendance notifier bound to active role
final attendanceProvider = StateNotifierProvider.family<AttendanceNotifier, AttendanceState, UserRole>((ref, role) {
  return AttendanceNotifier(role, ref);
});
