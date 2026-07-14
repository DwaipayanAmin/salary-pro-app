import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:blue_collar_tracker/features/dashboard/providers/role_provider.dart';
import 'package:blue_collar_tracker/features/attendance/providers/attendance_provider.dart';
import 'package:blue_collar_tracker/features/earnings/providers/earnings_provider.dart';
import 'package:blue_collar_tracker/features/profile/providers/profile_provider.dart';
import 'package:blue_collar_tracker/core/providers/theme_provider.dart';

class AppStateProviders {
  static List<SingleChildWidget> get providers => [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => RoleProvider()),
        ChangeNotifierProvider(create: (_) => AttendanceProvider()),
        ChangeNotifierProvider(create: (_) => EarningsProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
      ];
}
