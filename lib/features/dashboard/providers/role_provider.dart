import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/database/local_database.dart';

// Provider for active selected role
final activeRoleProvider = StateProvider<UserRole>((ref) => UserRole.factory);

// Provider for tracking light vs dark theme mode
final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.light);

// StateNotifier to fetch, log, and sync activity logs from local SQLite database
class ActivityNotifier extends StateNotifier<AsyncValue<List<ActivityLog>>> {
  final UserRole activeRole;
  final LocalDatabase _db = LocalDatabase.instance;

  ActivityNotifier(this.activeRole) : super(const AsyncValue.loading()) {
    loadActivities();
  }

  Future<void> loadActivities() async {
    try {
      state = const AsyncValue.loading();
      final database = await _db.database;
      final roleStr = activeRole.toString().split('.').last;

      final List<Map<String, dynamic>> maps = await database.query(
        'activities',
        where: 'role = ?',
        whereArgs: [roleStr],
        orderBy: 'timestamp DESC',
      );

      final logs = maps.map((map) {
        return ActivityLog(
          id: map['id'] as String,
          timestamp: DateTime.parse(map['timestamp'] as String),
          title: map['title'] as String,
          type: map['type'] as String,
          description: map['description'] as String,
        );
      }).toList();

      state = AsyncValue.data(logs);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> logNewActivity({
    required String title,
    required String type,
    required String description,
  }) async {
    try {
      final database = await _db.database;
      final roleStr = activeRole.toString().split('.').last;
      final newId = 'act_${DateTime.now().millisecondsSinceEpoch}';
      final nowStr = DateTime.now().toIso8601String();

      final newLog = {
        'id': newId,
        'timestamp': nowStr,
        'title': title,
        'type': type,
        'description': description,
        'role': roleStr,
      };

      await database.insert('activities', newLog);
      await loadActivities();
    } catch (e) {
      // Gracefully handle database insertion errors in offline state
    }
  }
}

// Provider for loading activities reactively based on the active worker role
final activityProvider = StateNotifierProvider.family<ActivityNotifier, AsyncValue<List<ActivityLog>>, UserRole>((ref, role) {
  return ActivityNotifier(role);
});
enum ThemeMode { light, dark }
