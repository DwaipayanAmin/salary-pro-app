import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import '../database/local_database.dart';
import 'package:sqflite/sqflite.dart';
import '../constants/app_constants.dart';

// ==========================================
// 1. DATA MODELS
// ==========================================

class EmployeeModel {
  final String id;
  final String fullName;
  final String role;
  final String pfNumber;
  final String bankName;
  final String bankAccount;
  final String emergencyContact;
  final String emergencyPhone;
  final double baseSalary;
  final double hourlyRate;
  final String shiftType;
  final double otMultiplier;
  final String? email;
  final String? phone;
  final String status;

  EmployeeModel({
    required this.id,
    required this.fullName,
    required this.role,
    required this.pfNumber,
    required this.bankName,
    required this.bankAccount,
    required this.emergencyContact,
    required this.emergencyPhone,
    required this.baseSalary,
    required this.hourlyRate,
    required this.shiftType,
    required this.otMultiplier,
    this.email,
    this.phone,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fullName': fullName,
      'role': role,
      'pfNumber': pfNumber,
      'bankName': bankName,
      'bankAccount': bankAccount,
      'emergencyContact': emergencyContact,
      'emergencyPhone': emergencyPhone,
      'baseSalary': baseSalary,
      'hourlyRate': hourlyRate,
      'shiftType': shiftType,
      'otMultiplier': otMultiplier,
      'email': email,
      'phone': phone,
      'status': status,
    };
  }

  factory EmployeeModel.fromMap(Map<String, dynamic> map) {
    return EmployeeModel(
      id: map['id'] as String,
      fullName: map['fullName'] as String,
      role: map['role'] as String,
      pfNumber: map['pfNumber'] as String,
      bankName: map['bankName'] as String,
      bankAccount: map['bankAccount'] as String,
      emergencyContact: map['emergencyContact'] as String,
      emergencyPhone: map['emergencyPhone'] as String,
      baseSalary: (map['baseSalary'] as num).toDouble(),
      hourlyRate: (map['hourlyRate'] as num).toDouble(),
      shiftType: map['shiftType'] as String,
      otMultiplier: (map['otMultiplier'] as num).toDouble(),
      email: map['email'] as String?,
      phone: map['phone'] as String?,
      status: map['status'] as String,
    );
  }
}

class LeaveModel {
  final String id;
  final String employeeId;
  final String leaveType; // 'Casual' | 'Sick' | 'Earned' | 'Unpaid'
  final String startDate;
  final String endDate;
  final String? reason;
  final String status; // 'Pending' | 'Approved' | 'Rejected'
  final String appliedDate;

  LeaveModel({
    required this.id,
    required this.employeeId,
    required this.leaveType,
    required this.startDate,
    required this.endDate,
    this.reason,
    required this.status,
    required this.appliedDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'employeeId': employeeId,
      'leaveType': leaveType,
      'startDate': startDate,
      'endDate': endDate,
      'reason': reason,
      'status': status,
      'appliedDate': appliedDate,
    };
  }

  factory LeaveModel.fromMap(Map<String, dynamic> map) {
    return LeaveModel(
      id: map['id'] as String,
      employeeId: map['employeeId'] as String,
      leaveType: map['leaveType'] as String,
      startDate: map['startDate'] as String,
      endDate: map['endDate'] as String,
      reason: map['reason'] as String?,
      status: map['status'] as String,
      appliedDate: map['appliedDate'] as String,
    );
  }
}

class HolidayModel {
  final String id;
  final String date;
  final String name;
  final bool isPaid;

  HolidayModel({
    required this.id,
    required this.date,
    required this.name,
    required this.isPaid,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date,
      'name': name,
      'isPaid': isPaid ? 1 : 0,
    };
  }

  factory HolidayModel.fromMap(Map<String, dynamic> map) {
    return HolidayModel(
      id: map['id'] as String,
      date: map['date'] as String,
      name: map['name'] as String,
      isPaid: map['isPaid'] == 1,
    );
  }
}

class ShiftModel {
  final String id;
  final String employeeId;
  final String date;
  final String shiftType; // 'Day' | 'Night' | 'General' | 'Custom'
  final String? startTime;
  final String? endTime;
  final String? notes;

  ShiftModel({
    required this.id,
    required this.employeeId,
    required this.date,
    required this.shiftType,
    this.startTime,
    this.endTime,
    this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'employeeId': employeeId,
      'date': date,
      'shiftType': shiftType,
      'startTime': startTime,
      'endTime': endTime,
      'notes': notes,
    };
  }

  factory ShiftModel.fromMap(Map<String, dynamic> map) {
    return ShiftModel(
      id: map['id'] as String,
      employeeId: map['employeeId'] as String,
      date: map['date'] as String,
      shiftType: map['shiftType'] as String,
      startTime: map['startTime'] as String?,
      endTime: map['endTime'] as String?,
      notes: map['notes'] as String?,
    );
  }
}

class SalaryCalculationResult {
  final String employeeId;
  final String fullName;
  final String roleTitle;
  final String yearMonth;
  final double baseSalary;
  final double daysPresent;
  final double daysAbsent;
  final double daysOnLeave;
  final double totalHoursWorked;
  final double basicEarned;
  final double otHours;
  final double otEarnings;
  final double pfDeduction;
  final double esiDeduction;
  final double allowances;
  final double bonus;
  final double leaveDeductions;
  final double netSalary;

  SalaryCalculationResult({
    required this.employeeId,
    required this.fullName,
    required this.roleTitle,
    required this.yearMonth,
    required this.baseSalary,
    required this.daysPresent,
    required this.daysAbsent,
    required this.daysOnLeave,
    required this.totalHoursWorked,
    required this.basicEarned,
    required this.otHours,
    required this.otEarnings,
    required this.pfDeduction,
    required this.esiDeduction,
    required this.allowances,
    required this.bonus,
    required this.leaveDeductions,
    required this.netSalary,
  });
}

// ==========================================
// 2. STATE NOTIFIERS & PROVIDERS
// ==========================================

// --- A. Employee Management Provider ---
class EmployeeNotifier extends StateNotifier<AsyncValue<List<EmployeeModel>>> {
  final LocalDatabase _db = LocalDatabase.instance;
  final Ref ref;

  EmployeeNotifier(this.ref) : super(const AsyncValue.loading()) {
    loadEmployees();
  }

  Future<void> loadEmployees() async {
    try {
      state = const AsyncValue.loading();
      final database = await _db.database;
      final List<Map<String, dynamic>> maps = await database.query('employees', orderBy: 'fullName ASC');
      final list = maps.map((m) => EmployeeModel.fromMap(m)).toList();
      state = AsyncValue.data(list);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> addEmployee(EmployeeModel employee) async {
    try {
      final database = await _db.database;
      await database.insert('employees', employee.toMap());
      await loadEmployees();
    } catch (e) {
      // Offline safety
    }
  }

  Future<void> updateEmployee(EmployeeModel employee) async {
    try {
      final database = await _db.database;
      await database.update(
        'employees',
        employee.toMap(),
        where: 'id = ?',
        whereArgs: [employee.id],
      );
      await loadEmployees();
    } catch (e) {
      // Offline safety
    }
  }

  Future<void> deleteEmployee(String id) async {
    try {
      final database = await _db.database;
      await database.delete('employees', where: 'id = ?', whereArgs: [id]);
      await loadEmployees();
    } catch (e) {
      // Offline safety
    }
  }
}

final employeeProvider = StateNotifierProvider<EmployeeNotifier, AsyncValue<List<EmployeeModel>>>((ref) {
  return EmployeeNotifier(ref);
});

// --- B. Leave Management Provider ---
class LeaveNotifier extends StateNotifier<AsyncValue<List<LeaveModel>>> {
  final LocalDatabase _db = LocalDatabase.instance;
  final Ref ref;

  LeaveNotifier(this.ref) : super(const AsyncValue.loading()) {
    loadLeaves();
  }

  Future<void> loadLeaves() async {
    try {
      state = const AsyncValue.loading();
      final database = await _db.database;
      final List<Map<String, dynamic>> maps = await database.query('leaves', orderBy: 'appliedDate DESC');
      final list = maps.map((m) => LeaveModel.fromMap(m)).toList();
      state = AsyncValue.data(list);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> applyLeave(LeaveModel leave) async {
    try {
      final database = await _db.database;
      await database.insert('leaves', leave.toMap());
      await loadLeaves();
    } catch (e) {
      // Offline safety
    }
  }

  Future<void> updateLeaveStatus(String id, String status) async {
    try {
      final database = await _db.database;
      await database.update(
        'leaves',
        {'status': status},
        where: 'id = ?',
        whereArgs: [id],
      );
      await loadLeaves();
    } catch (e) {
      // Offline safety
    }
  }
}

final leaveProvider = StateNotifierProvider<LeaveNotifier, AsyncValue<List<LeaveModel>>>((ref) {
  return LeaveNotifier(ref);
});

// --- C. Holiday Management Provider ---
class HolidayNotifier extends StateNotifier<AsyncValue<List<HolidayModel>>> {
  final LocalDatabase _db = LocalDatabase.instance;
  final Ref ref;

  HolidayNotifier(this.ref) : super(const AsyncValue.loading()) {
    loadHolidays();
  }

  Future<void> loadHolidays() async {
    try {
      state = const AsyncValue.loading();
      final database = await _db.database;
      final List<Map<String, dynamic>> maps = await database.query('holidays', orderBy: 'date ASC');
      final list = maps.map((m) => HolidayModel.fromMap(m)).toList();
      state = AsyncValue.data(list);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> addHoliday(HolidayModel holiday) async {
    try {
      final database = await _db.database;
      await database.insert('holidays', holiday.toMap());
      await loadHolidays();
    } catch (e) {
      // Offline safety
    }
  }

  Future<void> deleteHoliday(String id) async {
    try {
      final database = await _db.database;
      await database.delete('holidays', where: 'id = ?', whereArgs: [id]);
      await loadHolidays();
    } catch (e) {
      // Offline safety
    }
  }
}

final holidayProvider = StateNotifierProvider<HolidayNotifier, AsyncValue<List<HolidayModel>>>((ref) {
  return HolidayNotifier(ref);
});

// --- D. Shift Management Provider ---
class ShiftNotifier extends StateNotifier<AsyncValue<List<ShiftModel>>> {
  final LocalDatabase _db = LocalDatabase.instance;
  final Ref ref;

  ShiftNotifier(this.ref) : super(const AsyncValue.loading()) {
    loadShifts();
  }

  Future<void> loadShifts() async {
    try {
      state = const AsyncValue.loading();
      final database = await _db.database;
      final List<Map<String, dynamic>> maps = await database.query('shifts', orderBy: 'date DESC');
      final list = maps.map((m) => ShiftModel.fromMap(m)).toList();
      state = AsyncValue.data(list);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> scheduleShift(ShiftModel shift) async {
    try {
      final database = await _db.database;
      await database.insert('shifts', shift.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
      await loadShifts();
    } catch (e) {
      // Offline safety
    }
  }
}

final shiftProvider = StateNotifierProvider<ShiftNotifier, AsyncValue<List<ShiftModel>>>((ref) {
  return ShiftNotifier(ref);
});

// --- E. Dynamic Salary Calculations Engine Provider ---
final salaryCalculatorProvider = FutureProvider.family<SalaryCalculationResult, String>((ref, employeeId) async {
  final db = LocalDatabase.instance;
  final database = await db.database;

  // Retrieve Employee Configuration
  final List<Map<String, dynamic>> empMaps = await database.query(
    'employees',
    where: 'id = ?',
    whereArgs: [employeeId],
  );

  if (empMaps.isEmpty) {
    throw Exception('Employee not found');
  }

  final emp = EmployeeModel.fromMap(empMaps.first);
  final roleStr = emp.role;
  final now = DateTime.now();
  final yearMonth = '${now.year}-${now.month.toString().padLeft(2, '0')}';

  // Fetch Attendance for the current month
  final List<Map<String, dynamic>> attendanceMaps = await database.query(
    'attendance',
    where: 'role = ? AND date LIKE ?',
    whereArgs: [roleStr, '$yearMonth%'],
  );

  double totalHours = 0.0;
  double otHours = 0.0;
  double daysPresent = 0.0;

  for (final att in attendanceMaps) {
    final worked = (att['hoursWorked'] as num?)?.toDouble() ?? 0.0;
    if (worked > 0) {
      daysPresent += 1.0;
      totalHours += worked;
      if (worked > 8.0) {
        otHours += (worked - 8.0);
      }
    }
  }

  // Fetch Approved Leaves
  final List<Map<String, dynamic>> leaveMaps = await database.query(
    'leaves',
    where: 'employeeId = ? AND status = ? AND startDate LIKE ?',
    whereArgs: [employeeId, 'Approved', '$yearMonth%'],
  );
  double daysOnLeave = leaveMaps.length.toDouble();

  // Calculate Base Earnings
  // If base salary is 0 (Contract/Gig workers), we calculate purely based on hours worked.
  // Otherwise, we calculate proportional to present days out of 26 working days.
  double basicEarned = 0.0;
  if (emp.baseSalary > 0) {
    // Proportional calculation based on 26-day typical work month
    double ratio = (daysPresent + daysOnLeave) / 26.0;
    if (ratio > 1.0) ratio = 1.0;
    basicEarned = emp.baseSalary * ratio;
  } else {
    // Pure Hourly contract
    basicEarned = totalHours * emp.hourlyRate;
  }

  // Overtime Earnings
  double otEarnings = otHours * emp.hourlyRate * emp.otMultiplier;

  // Allowances: ₹150 travel allowance per present day
  double allowances = daysPresent * 150.0;

  // PF & ESI
  // Quality Checker and other standard workers have 12% PF deduction and 0.75% ESIC deduction if applicable.
  final pfApplicable = ROLE_CONFIGS[UserRole.values.firstWhere(
    (e) => e.toString().split('.').last == roleStr,
    orElse: () => UserRole.factory,
  )]?.pfApplicable ?? true;

  double pfDeduction = pfApplicable ? (basicEarned * 0.12) : 0.0;
  double esiDeduction = pfApplicable ? (basicEarned * 0.0075) : 0.0;

  // Leave Deductions (Unpaid leaves)
  double daysAbsent = 26.0 - (daysPresent + daysOnLeave);
  if (daysAbsent < 0) daysAbsent = 0;
  double leaveDeductions = 0.0;
  if (emp.baseSalary > 0 && daysAbsent > 0) {
    leaveDeductions = (emp.baseSalary / 26.0) * daysAbsent;
  }

  // Bonus
  // Quality compliance bonus for Quality Checker (₹2,000) or perfect attendance bonus (₹1,500)
  double bonus = 0.0;
  if (roleStr == 'qualityChecker') {
    bonus = 2000.0;
  } else if (daysAbsent == 0 && daysPresent > 20) {
    bonus = 1500.0;
  }

  double netSalary = basicEarned + otEarnings + allowances + bonus - pfDeduction - esiDeduction - leaveDeductions;
  if (netSalary < 0) netSalary = 0.0;

  return SalaryCalculationResult(
    employeeId: employeeId,
    fullName: emp.fullName,
    roleTitle: ROLE_CONFIGS[UserRole.values.firstWhere(
      (e) => e.toString().split('.').last == roleStr,
      orElse: () => UserRole.factory,
    )]?.title ?? emp.role,
    yearMonth: yearMonth,
    baseSalary: emp.baseSalary,
    daysPresent: daysPresent,
    daysAbsent: daysAbsent,
    daysOnLeave: daysOnLeave,
    totalHoursWorked: totalHours,
    basicEarned: basicEarned,
    otHours: otHours,
    otEarnings: otEarnings,
    pfDeduction: pfDeduction,
    esiDeduction: esiDeduction,
    allowances: allowances,
    bonus: bonus,
    leaveDeductions: leaveDeductions,
    netSalary: netSalary,
  );
});

// ==========================================
// 3. BACKUP, RESTORE & EXPORT SERVICES
// ==========================================

class LocalStorageBackupService {
  static final LocalDatabase _db = LocalDatabase.instance;

  // JSON string backup of all tables
  static Future<String> generateBackupJson() async {
    final database = await _db.database;
    final Map<String, dynamic> backupData = {};

    final tables = ['employees', 'attendance', 'leaves', 'holidays', 'shifts', 'earnings', 'activities', 'profile'];
    for (final table in tables) {
      try {
        final List<Map<String, dynamic>> rows = await database.query(table);
        backupData[table] = rows;
      } catch (e) {
        // Table may not exist yet
      }
    }

    return jsonEncode(backupData);
  }

  // Restore database tables from JSON
  static Future<bool> restoreFromJson(String jsonString) async {
    try {
      final Map<String, dynamic> decoded = jsonDecode(jsonString);
      final database = await _db.database;

      await database.transaction((txn) async {
        for (final table in decoded.keys) {
          final List<dynamic> rows = decoded[table] as List<dynamic>;
          
          // Clear current table contents safely
          await txn.delete(table);

          for (final row in rows) {
            final Map<String, dynamic> rowMap = row as Map<String, dynamic>;
            await txn.insert(table, rowMap, conflictAlgorithm: ConflictAlgorithm.replace);
          }
        }
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  // Export ledger to beautiful printable text/CSV format
  static Future<File> writeBackupToFile() async {
    final jsonStr = await generateBackupJson();
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/salarypro_backup_${DateTime.now().millisecondsSinceEpoch}.json');
    return await file.writeAsString(jsonStr);
  }
}
