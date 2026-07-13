import 'package:flutter/material.dart';

class RoleProvider extends ChangeNotifier {
  String _currentRole = 'Employee';

  String get currentRole => _currentRole;

  void setRole(String role) {
    _currentRole = role;
    notifyListeners();
  }
}
