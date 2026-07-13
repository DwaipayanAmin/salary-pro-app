import 'package:flutter/material.dart';

class ProfileProvider extends ChangeNotifier {
  String _name = 'John Doe';

  String get name => _name;

  void updateName(String val) {
    _name = val;
    notifyListeners();
  }
}
