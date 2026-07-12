import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/database/local_database.dart';

class EarningsRecord {
  final String yearMonth;
  final double basicSalary;
  final double hoursOvertime;
  final double allowancePaid;
  final double pfDeducted;
  final String role;
  final String syncState;

  EarningsRecord({
    required this.yearMonth,
    required this.basicSalary,
    required this.hoursOvertime,
    required this.allowancePaid,
    required this.pfDeducted,
    required this.role,
    required this.syncState,
  });

  double get netEarnings {
    final roleConfig = ROLE_CONFIGS[UserRole.values.firstWhere((e) => e.toString().split('.').last == role)];
    final otPay = hoursOvertime * (roleConfig?.hourlyRate ?? 100.0) * (roleConfig?.otMultiplier ?? 1.5);
    return basicSalary + otPay + allowancePaid - pfDeducted;
  }
}

class EarningsNotifier extends StateNotifier<AsyncValue<List<EarningsRecord>>> {
  final UserRole activeRole;
  final LocalDatabase _db = LocalDatabase.instance;

  EarningsNotifier(this.activeRole) : super(const AsyncValue.loading()) {
    loadLedger();
  }

  Future<void> loadLedger() async {
    try {
      state = const AsyncValue.loading();
      final database = await _db.database;
      final roleStr = activeRole.toString().split('.').last;

      final List<Map<String, dynamic>> maps = await database.query(
        'earnings',
        where: 'role = ?',
        whereArgs: [roleStr],
        orderBy: 'yearMonth DESC',
      );

      final records = maps.map((map) {
        return EarningsRecord(
          yearMonth: map['yearMonth'] as String,
          basicSalary: (map['basicSalary'] as num).toDouble(),
          hoursOvertime: (map['hoursOvertime'] as num).toDouble(),
          allowancePaid: (map['allowancePaid'] as num).toDouble(),
          pfDeducted: (map['pfDeducted'] as num).toDouble(),
          role: map['role'] as String,
          syncState: map['syncState'] as String,
        );
      }).toList();

      // If no data exists yet, seed a default ledger record for testing
      if (records.isEmpty) {
        final currentMonth = '${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}';
        final roleConfig = ROLE_CONFIGS[activeRole]!;
        final defaultBasic = roleConfig.baseSalary > 0 ? roleConfig.baseSalary * 0.7 : 8500.0;
        final defaultOT = 6.5;
        final defaultAllowance = 1200.0;
        final defaultPF = roleConfig.pfApplicable ? defaultBasic * 0.12 : 0.0;

        await database.insert('earnings', {
          'id': 'earn_${roleStr}_$currentMonth',
          'yearMonth': currentMonth,
          'basicSalary': defaultBasic,
          'hoursOvertime': defaultOT,
          'allowancePaid': defaultAllowance,
          'pfDeducted': defaultPF,
          'role': roleStr,
          'syncState': 'synced',
        });

        // Retry load
        final List<Map<String, dynamic>> retriedMaps = await database.query(
          'earnings',
          where: 'role = ?',
          whereArgs: [roleStr],
          orderBy: 'yearMonth DESC',
        );

        final retriedRecords = retriedMaps.map((map) {
          return EarningsRecord(
            yearMonth: map['yearMonth'] as String,
            basicSalary: (map['basicSalary'] as num).toDouble(),
            hoursOvertime: (map['hoursOvertime'] as num).toDouble(),
            allowancePaid: (map['allowancePaid'] as num).toDouble(),
            pfDeducted: (map['pfDeducted'] as num).toDouble(),
            role: map['role'] as String,
            syncState: map['syncState'] as String,
          );
        }).toList();

        state = AsyncValue.data(retriedRecords);
      } else {
        state = AsyncValue.data(records);
      }
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> simulateSync() async {
    try {
      final database = await _db.database;
      final roleStr = activeRole.toString().split('.').last;

      await database.update('earnings', {
        'syncState': 'synced',
      }, where: 'role = ?', whereArgs: [roleStr]);

      await loadLedger();
    } catch (e) {
      // Offline fallback
    }
  }
}

final earningsProvider = StateNotifierProvider.family<EarningsNotifier, AsyncValue<List<EarningsRecord>>, UserRole>((ref, role) {
  return EarningsNotifier(role);
});
