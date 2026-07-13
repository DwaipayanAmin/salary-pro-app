import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class LocalDatabase {
  static final LocalDatabase instance = LocalDatabase._init();
  static Database? _database;

  LocalDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('blue_collar_tracker.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 2,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future _createDB(Database db, int version) async {
    // 1. Attendance Table
    await db.execute('''
      CREATE TABLE attendance (
        id TEXT PRIMARY KEY,
        date TEXT NOT NULL,
        checkInTime TEXT NOT NULL,
        checkOutTime TEXT,
        hoursWorked REAL DEFAULT 0.0,
        isOvertimeApproved INTEGER DEFAULT 0,
        role TEXT NOT NULL
      )
    ''');

    // 2. Earnings Ledger Table
    await db.execute('''
      CREATE TABLE earnings (
        id TEXT PRIMARY KEY,
        yearMonth TEXT NOT NULL,
        basicSalary REAL NOT NULL,
        hoursOvertime REAL DEFAULT 0.0,
        allowancePaid REAL DEFAULT 0.0,
        pfDeducted REAL DEFAULT 0.0,
        role TEXT NOT NULL,
        syncState TEXT NOT NULL DEFAULT 'synced'
      )
    ''');

    // 3. System Activity Logs Table
    await db.execute('''
      CREATE TABLE activities (
        id TEXT PRIMARY KEY,
        timestamp TEXT NOT NULL,
        title TEXT NOT NULL,
        type TEXT NOT NULL,
        description TEXT NOT NULL,
        role TEXT NOT NULL
      )
    ''');

    // 4. Worker Profile Table (for legacy/backwards compatibility)
    await db.execute('''
      CREATE TABLE profile (
        role TEXT PRIMARY KEY,
        fullName TEXT NOT NULL,
        pfNumber TEXT NOT NULL,
        bankName TEXT NOT NULL,
        bankAccount TEXT NOT NULL,
        emergencyContact TEXT NOT NULL,
        emergencyPhone TEXT NOT NULL,
        lastSynced TEXT
      )
    ''');

    // Create Version 2 Tables
    await _createTablesVersion2(db);

    // Seed Initial Data (Version 1 & 2)
    await _seedInitialData(db);
  }

  Future _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await _createTablesVersion2(db);
      await _migrateDataToVersion2(db);
    }
  }

  Future _createTablesVersion2(Database db) async {
    // 5. Employees Table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS employees (
        id TEXT PRIMARY KEY,
        fullName TEXT NOT NULL,
        role TEXT NOT NULL,
        pfNumber TEXT NOT NULL,
        bankName TEXT NOT NULL,
        bankAccount TEXT NOT NULL,
        emergencyContact TEXT NOT NULL,
        emergencyPhone TEXT NOT NULL,
        baseSalary REAL NOT NULL,
        hourlyRate REAL NOT NULL,
        shiftType TEXT NOT NULL,
        otMultiplier REAL NOT NULL,
        email TEXT,
        phone TEXT,
        status TEXT NOT NULL DEFAULT 'active'
      )
    ''');

    // 6. Leaves Table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS leaves (
        id TEXT PRIMARY KEY,
        employeeId TEXT NOT NULL,
        leaveType TEXT NOT NULL,
        startDate TEXT NOT NULL,
        endDate TEXT NOT NULL,
        reason TEXT,
        status TEXT NOT NULL,
        appliedDate TEXT NOT NULL
      )
    ''');

    // 7. Holidays Table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS holidays (
        id TEXT PRIMARY KEY,
        date TEXT NOT NULL,
        name TEXT NOT NULL,
        isPaid INTEGER DEFAULT 1
      )
    ''');

    // 8. Shifts Table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS shifts (
        id TEXT PRIMARY KEY,
        employeeId TEXT NOT NULL,
        date TEXT NOT NULL,
        shiftType TEXT NOT NULL,
        startTime TEXT,
        endTime TEXT,
        notes TEXT
      )
    ''');
  }

  Future _migrateDataToVersion2(Database db) async {
    // If we're upgrading, migrate profiles to employees table
    try {
      final List<Map<String, dynamic>> profiles = await db.query('profile');
      for (final prof in profiles) {
        final role = prof['role'] as String;
        final id = 'emp_$role';
        
        // Match with default configs
        double baseSalary = 18500;
        double hourlyRate = 90;
        String shiftType = 'Shift A (08:00 - 16:30)';
        double otMultiplier = 1.5;

        if (role == 'office') {
          baseSalary = 26000;
          hourlyRate = 130;
          shiftType = 'General Shift (09:30 - 18:00)';
          otMultiplier = 1.0;
        } else if (role == 'warehouse') {
          baseSalary = 16200;
          hourlyRate = 80;
          shiftType = 'Shift B (14:00 - 22:30)';
          otMultiplier = 1.5;
        } else if (role == 'apprentice') {
          baseSalary = 10500;
          hourlyRate = 50;
          shiftType = 'Apprentice Shift (08:30 - 17:00)';
          otMultiplier = 1.25;
        } else if (role == 'contract') {
          baseSalary = 0;
          hourlyRate = 110;
          shiftType = 'Flexible Hours (On-Demand)';
          otMultiplier = 1.5;
        } else if (role == 'qualityChecker') {
          baseSalary = 28500;
          hourlyRate = 150;
          shiftType = 'Day Shift (09:00 - 17:30)';
          otMultiplier = 1.5;
        }

        await db.insert('employees', {
          'id': id,
          'fullName': prof['fullName'],
          'role': role,
          'pfNumber': prof['pfNumber'],
          'bankName': prof['bankName'],
          'bankAccount': prof['bankAccount'],
          'emergencyContact': prof['emergencyContact'],
          'emergencyPhone': prof['emergencyPhone'],
          'baseSalary': baseSalary,
          'hourlyRate': hourlyRate,
          'shiftType': shiftType,
          'otMultiplier': otMultiplier,
          'email': '${role}@salarypro.com',
          'phone': '+91-98765-43210',
          'status': 'active',
        }, conflictAlgorithm: ConflictAlgorithm.ignore);
      }
    } catch (e) {
      // Ignored
    }
  }

  Future _seedInitialData(Database db) async {
    final now = DateTime.now().toIso8601String();

    // 1. Seed Profile Table (for Legacy Compat)
    final roles = ['factory', 'office', 'warehouse', 'apprentice', 'contract', 'qualityChecker'];
    final names = ['Ram Kumar', 'Anjali Sharma', 'Sunil Yadav', 'Rajesh Patra', 'Karan Johar', 'Dwaipayan Amin'];
    final pfAccounts = ['PF-8947-AB9', 'PF-4421-CD3', 'PF-5512-EF6', 'N/A (Apprentice)', 'N/A (Contract)', 'PF-1039-QP8'];
    final bankNames = ['State Bank of India', 'HDFC Bank', 'ICICI Bank', 'Punjab National Bank', 'State Bank of India', 'Axis Bank'];
    final bankAccounts = ['XXXX-XXXX-8821', 'XXXX-XXXX-8822', 'XXXX-XXXX-8823', 'XXXX-XXXX-8824', 'XXXX-XXXX-8825', 'XXXX-XXXX-0077'];
    final emergencyContacts = ['Family Member', 'Spouse', 'Brother', 'Father', 'Mother', 'Sujata Amin (Mother)'];
    final emergencyPhones = ['+91-98765-43211', '+91-98765-43212', '+91-98765-43213', '+91-98765-43214', '+91-98765-43215', '+91-99321-12345'];

    for (int i = 0; i < roles.length; i++) {
      await db.insert('profile', {
        'role': roles[i],
        'fullName': names[i],
        'pfNumber': pfAccounts[i],
        'bankName': bankNames[i],
        'bankAccount': bankAccounts[i],
        'emergencyContact': emergencyContacts[i],
        'emergencyPhone': emergencyPhones[i],
        'lastSynced': now,
      }, conflictAlgorithm: ConflictAlgorithm.replace);

      // Seed baseline activities
      await db.insert('activities', {
        'id': 'seed_act_1_${roles[i]}',
        'timestamp': DateTime.now().subtract(const Duration(hours: 4)).toIso8601String(),
        'title': 'Shift Automated Punch-In',
        'type': 'attendance',
        'description': 'Marked active and present on industrial floor via geo-fencing check.',
        'role': roles[i],
      }, conflictAlgorithm: ConflictAlgorithm.replace);

      await db.insert('activities', {
        'id': 'seed_act_2_${roles[i]}',
        'timestamp': DateTime.now().subtract(const Duration(days: 4)).toIso8601String(),
        'title': 'Monthly Stipend Settled',
        'type': 'salary',
        'description': 'Direct bank payment initiated for completed pay cycle ledger.',
        'role': roles[i],
      }, conflictAlgorithm: ConflictAlgorithm.replace);
    }

    // 2. Seed Employees Table
    final baseSalaries = [18500.0, 26000.0, 16200.0, 10500.0, 0.0, 28500.0];
    final hourlyRates = [90.0, 130.0, 80.0, 50.0, 110.0, 150.0];
    final shiftTypes = [
      'Shift A (08:00 - 16:30)',
      'General Shift (09:30 - 18:00)',
      'Shift B (14:00 - 22:30)',
      'Apprentice Shift (08:30 - 17:00)',
      'Flexible Hours (On-Demand)',
      'Day Shift (09:00 - 17:30)'
    ];
    final otMultipliers = [1.5, 1.0, 1.5, 1.25, 1.5, 1.5];

    for (int i = 0; i < roles.length; i++) {
      await db.insert('employees', {
        'id': 'emp_${roles[i]}',
        'fullName': names[i],
        'role': roles[i],
        'pfNumber': pfAccounts[i],
        'bankName': bankNames[i],
        'bankAccount': bankAccounts[i],
        'emergencyContact': emergencyContacts[i],
        'emergencyPhone': emergencyPhones[i],
        'baseSalary': baseSalaries[i],
        'hourlyRate': hourlyRates[i],
        'shiftType': shiftTypes[i],
        'otMultiplier': otMultipliers[i],
        'email': '${roles[i]}@salarypro.com',
        'phone': '+91-98765-4321$i',
        'status': 'active',
      }, conflictAlgorithm: ConflictAlgorithm.replace);
    }

    // 3. Seed National Holidays
    final holidays = [
      {'id': 'hol_1', 'date': '2026-01-01', 'name': 'New Year\'s Day', 'isPaid': 1},
      {'id': 'hol_2', 'date': '2026-01-26', 'name': 'Republic Day', 'isPaid': 1},
      {'id': 'hol_3', 'date': '2026-05-01', 'name': 'May Day / Labour Day', 'isPaid': 1},
      {'id': 'hol_4', 'date': '2026-08-15', 'name': 'Independence Day', 'isPaid': 1},
      {'id': 'hol_5', 'date': '2026-10-02', 'name': 'Gandhi Jayanti', 'isPaid': 1},
      {'id': 'hol_6', 'date': '2026-11-08', 'name': 'Diwali festival', 'isPaid': 1},
      {'id': 'hol_7', 'date': '2026-12-25', 'name': 'Christmas Day', 'isPaid': 1},
    ];
    for (final hol in holidays) {
      await db.insert('holidays', hol, conflictAlgorithm: ConflictAlgorithm.replace);
    }

    // 4. Seed Leave requests
    final leaveRequests = [
      {
        'id': 'leave_seed_1',
        'employeeId': 'emp_qualityChecker',
        'leaveType': 'Casual',
        'startDate': '2026-07-06',
        'endDate': '2026-07-07',
        'reason': 'Family function attendance',
        'status': 'Approved',
        'appliedDate': '2026-07-01',
      },
      {
        'id': 'leave_seed_2',
        'employeeId': 'emp_qualityChecker',
        'leaveType': 'Sick',
        'startDate': '2026-07-20',
        'endDate': '2026-07-20',
        'reason': 'Regular medical checkup',
        'status': 'Pending',
        'appliedDate': '2026-07-10',
      },
      {
        'id': 'leave_seed_3',
        'employeeId': 'emp_factory',
        'leaveType': 'Casual',
        'startDate': '2026-07-15',
        'endDate': '2026-07-16',
        'reason': 'Travel to hometown',
        'status': 'Approved',
        'appliedDate': '2026-07-05',
      }
    ];
    for (final lv in leaveRequests) {
      await db.insert('leaves', lv, conflictAlgorithm: ConflictAlgorithm.replace);
    }

    // 5. Seed some initial earnings for qualityChecker (Dwaipayan Amin)
    final initialEarnings = [
      {
        'id': 'earn_qualityChecker_2026-06',
        'yearMonth': '2026-06',
        'basicSalary': 28500.0,
        'hoursOvertime': 12.0,
        'allowancePaid': 2400.0,
        'pfDeducted': 3420.0, // 12% of basic
        'role': 'qualityChecker',
        'syncState': 'synced'
      },
      {
        'id': 'earn_qualityChecker_2026-05',
        'yearMonth': '2026-05',
        'basicSalary': 28500.0,
        'hoursOvertime': 8.0,
        'allowancePaid': 1800.0,
        'pfDeducted': 3420.0,
        'role': 'qualityChecker',
        'syncState': 'synced'
      },
      {
        'id': 'earn_factory_2026-06',
        'yearMonth': '2026-06',
        'basicSalary': 18500.0,
        'hoursOvertime': 20.0,
        'allowancePaid': 1500.0,
        'pfDeducted': 2220.0,
        'role': 'factory',
        'syncState': 'synced'
      }
    ];
    for (final ern in initialEarnings) {
      await db.insert('earnings', ern, conflictAlgorithm: ConflictAlgorithm.replace);
    }

    // 6. Seed some completed attendance logs for qualityChecker
    final preAttendance = [
      {
        'id': 'att_seed_qc_1',
        'date': '2026-07-01',
        'checkInTime': '2026-07-01T09:00:00',
        'checkOutTime': '2026-07-01T17:30:00',
        'hoursWorked': 8.5,
        'isOvertimeApproved': 0,
        'role': 'qualityChecker'
      },
      {
        'id': 'att_seed_qc_2',
        'date': '2026-07-02',
        'checkInTime': '2026-07-02T08:45:00',
        'checkOutTime': '2026-07-02T19:00:00',
        'hoursWorked': 10.25,
        'isOvertimeApproved': 1,
        'role': 'qualityChecker'
      },
      {
        'id': 'att_seed_qc_3',
        'date': '2026-07-03',
        'checkInTime': '2026-07-03T09:00:00',
        'checkOutTime': '2026-07-03T18:00:00',
        'hoursWorked': 9.0,
        'isOvertimeApproved': 0,
        'role': 'qualityChecker'
      },
    ];
    for (final att in preAttendance) {
      await db.insert('attendance', att, conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }

  // Clear all databases for resetting
  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
