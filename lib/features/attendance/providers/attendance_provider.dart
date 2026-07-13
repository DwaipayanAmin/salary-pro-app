import 'package:flutter/material.dart';

class AttendanceProvider extends ChangeNotifier {
  bool _isClockedIn = false;

  bool get isClockedIn => _isClockedIn;

  void toggleClockIn() {
    _isClockedIn = !_isClockedIn;
    notifyListeners();
  }
}
