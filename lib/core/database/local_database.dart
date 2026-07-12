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
      version: 1,
      onCreate: _createDB,
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

    // 4. Worker Profile Table
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

    // Seed Initial Profile & Activity Data
    await _seedInitialData(db);
  }

  Future _seedInitialData(Database db) async {
    final now = DateTime.now().toIso8601String();

    // Seed default profiles for different roles
    final roles = ['factory', 'office', 'warehouse', 'apprentice', 'contract'];
    final names = ['Ram Kumar', 'Anjali Sharma', 'Sunil Yadav', 'Rajesh Patra', 'Karan Johar'];
    final pfAccounts = ['PF-8947-AB9', 'PF-4421-CD3', 'PF-5512-EF6', 'N/A (Apprentice)', 'N/A (Contract)'];

    for (int i = 0; i < roles.length; i++) {
      await db.insert('profile', {
        'role': roles[i],
        'fullName': names[i],
        'pfNumber': pfAccounts[i],
        'bankName': 'State Bank of India',
        'bankAccount': 'XXXX-XXXX-882${i + 1}',
        'emergencyContact': 'Family Member',
        'emergencyPhone': '+91-98765-4321$i',
        'lastSynced': now,
      });

      // Seed baseline activities
      await db.insert('activities', {
        'id': 'seed_act_1_${roles[i]}',
        'timestamp': DateTime.now().subtract(const Duration(hours: 4)).toIso8601String(),
        'title': 'Shift Automated Punch-In',
        'type': 'attendance',
        'description': 'Marked active and present on industrial floor via geo-fencing check.',
        'role': roles[i],
      });

      await db.insert('activities', {
        'id': 'seed_act_2_${roles[i]}',
        'timestamp': DateTime.now().subtract(const Duration(days: 4)).toIso8601String(),
        'title': 'Monthly Stipend Settled',
        'type': 'salary',
        'description': 'Direct bank transaction initiated for completed pay cycle ledger.',
        'role': roles[i],
      });
    }
  }

  // Clear all databases for resetting
  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
