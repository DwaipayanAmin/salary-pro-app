import 'package:flutter/material.dart';

class CalendarAttendanceScreen extends StatelessWidget {
  const CalendarAttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Attendance Calendar')),
      body: const Center(child: Text('Calendar Screen')),
    );
  }
}
