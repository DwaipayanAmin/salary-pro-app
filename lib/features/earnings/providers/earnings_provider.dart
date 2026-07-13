import 'package:flutter/material.dart';

class EarningsProvider extends ChangeNotifier {
  double _salary = 0.0;

  double get salary => _salary;

  void updateSalary(double val) {
    _salary = val;
    notifyListeners();
  }
}
