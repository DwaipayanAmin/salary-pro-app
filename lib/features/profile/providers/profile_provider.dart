import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/database/local_database.dart';

class WorkerProfile {
  final String role;
  final String fullName;
  final String pfNumber;
  final String bankName;
  final String bankAccount;
  final String emergencyContact;
  final String emergencyPhone;
  final String? lastSynced;

  WorkerProfile({
    required this.role,
    required this.fullName,
    required this.pfNumber,
    required this.bankName,
    required this.bankAccount,
    required this.emergencyContact,
    required this.emergencyPhone,
    this.lastSynced,
  });

  Map<String, dynamic> toMap() {
    return {
      'role': role,
      'fullName': fullName,
      'pfNumber': pfNumber,
      'bankName': bankName,
      'bankAccount': bankAccount,
      'emergencyContact': emergencyContact,
      'emergencyPhone': emergencyPhone,
      'lastSynced': lastSynced,
    };
  }

  factory WorkerProfile.fromMap(Map<String, dynamic> map) {
    return WorkerProfile(
      role: map['role'] as String,
      fullName: map['fullName'] as String,
      pfNumber: map['pfNumber'] as String,
      bankName: map['bankName'] as String,
      bankAccount: map['bankAccount'] as String,
      emergencyContact: map['emergencyContact'] as String,
      emergencyPhone: map['emergencyPhone'] as String,
      lastSynced: map['lastSynced'] as String?,
    );
  }
}

class ProfileNotifier extends StateNotifier<AsyncValue<WorkerProfile>> {
  final UserRole activeRole;
  final LocalDatabase _db = LocalDatabase.instance;

  ProfileNotifier(this.activeRole) : super(const AsyncValue.loading()) {
    loadProfile();
  }

  Future<void> loadProfile() async {
    try {
      state = const AsyncValue.loading();
      final database = await _db.database;
      final roleStr = activeRole.toString().split('.').last;

      final List<Map<String, dynamic>> maps = await database.query(
        'profile',
        where: 'role = ?',
        whereArgs: [roleStr],
      );

      if (maps.isNotEmpty) {
        state = AsyncValue.data(WorkerProfile.fromMap(maps.first));
      } else {
        // Fallback or seed if profile not found
        final fallbackProfile = WorkerProfile(
          role: roleStr,
          fullName: 'Industrial Operator',
          pfNumber: 'PF-9983-XYZ',
          bankName: 'Industrial Bank',
          bankAccount: 'XXXX-XXXX-9999',
          emergencyContact: 'Emergency Supervisor',
          emergencyPhone: '+91-99999-88888',
          lastSynced: DateTime.now().toIso8601String(),
        );
        await database.insert('profile', fallbackProfile.toMap());
        state = AsyncValue.data(fallbackProfile);
      }
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> updateProfile({
    required String fullName,
    required String bankName,
    required String bankAccount,
    required String emergencyContact,
    required String emergencyPhone,
  }) async {
    try {
      final database = await _db.database;
      final roleStr = activeRole.toString().split('.').last;

      await database.update(
        'profile',
        {
          'fullName': fullName,
          'bankName': bankName,
          'bankAccount': bankAccount,
          'emergencyContact': emergencyContact,
          'emergencyPhone': emergencyPhone,
          'lastSynced': DateTime.now().toIso8601String(),
        },
        where: 'role = ?',
        whereArgs: [roleStr],
      );

      await loadProfile();
    } catch (e) {
      // Offline fallback
    }
  }
}

final profileProvider = StateNotifierProvider.family<ProfileNotifier, AsyncValue<WorkerProfile>, UserRole>((ref, role) {
  return ProfileNotifier(role);
});
