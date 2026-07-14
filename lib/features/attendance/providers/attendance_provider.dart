import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AttendanceProvider extends ChangeNotifier {
  bool _isClockedIn = false;
  DateTime? _clockInTime;
  
  final List<Map<String, dynamic>> _history = [
    {
      'date': DateTime(2026, 7, 13),
      'clockIn': '09:02 AM',
      'clockOut': '05:45 PM',
      'hours': '8h 43m',
      'status': 'Present',
    },
    {
      'date': DateTime(2026, 7, 10),
      'clockIn': '08:55 AM',
      'clockOut': '05:30 PM',
      'hours': '8h 35m',
      'status': 'Present',
    },
    {
      'date': DateTime(2026, 7, 9),
      'clockIn': '09:15 AM',
      'clockOut': '05:32 PM',
      'hours': '8h 17m',
      'status': 'Present',
    },
    {
      'date': DateTime(2026, 7, 8),
      'clockIn': '09:00 AM',
      'clockOut': '05:05 PM',
      'hours': '8h 05m',
      'status': 'Present',
    },
    {
      'date': DateTime(2026, 7, 7),
      'clockIn': '---',
      'clockOut': '---',
      'hours': '0h 00m',
      'status': 'Leave',
    },
    {
      'date': DateTime(2026, 7, 6),
      'clockIn': '08:58 AM',
      'clockOut': '05:15 PM',
      'hours': '8h 17m',
      'status': 'Present',
    },
  ];

  bool get isClockedIn => _isClockedIn;
  DateTime? get clockInTime => _clockInTime;
  List<Map<String, dynamic>> get history => List.unmodifiable(_history);

  void toggleClockIn() {
    if (_isClockedIn) {
      // Clocking out
      if (_clockInTime != null) {
        final now = DateTime.now();
        final diff = now.difference(_clockInTime!);
        final hours = diff.inHours;
        final minutes = diff.inMinutes % 60;
        
        _history.insert(0, {
          'date': _clockInTime!,
          'clockIn': DateFormat('hh:mm a').format(_clockInTime!),
          'clockOut': DateFormat('hh:mm a').format(now),
          'hours': '${hours}h ${minutes}m',
          'status': 'Present',
        });
      }
      _isClockedIn = false;
      _clockInTime = null;
    } else {
      // Clocking in
      _isClockedIn = true;
      _clockInTime = DateTime.now();
    }
    notifyListeners();
  }

  String getTodayWorkingHours() {
    if (!_isClockedIn || _clockInTime == null) {
      return '00h 00m';
    }
    final now = DateTime.now();
    final diff = now.difference(_clockInTime!);
    final hours = diff.inHours;
    final minutes = diff.inMinutes % 60;
    return '${hours.toString().padLeft(2, '0')}h ${minutes.toString().padLeft(2, '0')}m';
  }
}
