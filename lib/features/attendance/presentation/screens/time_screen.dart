import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:blue_collar_tracker/features/attendance/providers/attendance_provider.dart';
import 'package:blue_collar_tracker/features/attendance/presentation/screens/calendar_attendance_screen.dart';
import 'package:blue_collar_tracker/features/attendance/presentation/screens/leave_management_screen.dart';
import 'package:blue_collar_tracker/core/theme/route_transitions.dart';

class TimeScreen extends StatelessWidget {
  const TimeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final attendance = Provider.of<AttendanceProvider>(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () => attendance.toggleClockIn(),
            child: Text(attendance.isClockedIn ? 'Clock Out' : 'Clock In'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                RouteTransitions.slideIn(const CalendarAttendanceScreen()),
              );
            },
            child: const Text('Calendar View'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                RouteTransitions.slideIn(const LeaveManagementScreen()),
              );
            },
            child: const Text('Leave Management'),
          ),
        ],
      ),
    );
  }
}
