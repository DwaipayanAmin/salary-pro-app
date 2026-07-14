import 'package:flutter/material.dart';

class ProfileProvider extends ChangeNotifier {
  String _name = 'John Doe';
  String _employeeId = 'MJIL000001';
  String _department = 'Packing';
  String _shift = 'Day'; // 'Day' or 'Night'
  double _availableLeaves = 10.0; // 5 months carried forward (2 leaves per month)
  
  // Salary Structure (Excluding Overtime)
  double _basic = 15000.0;
  double _hra = 6000.0;
  double _specialAllowance = 4000.0;
  double _pf = 1800.0;
  double _esi = 487.5; // typical ESI deduction
  double _bonus = 2000.0;
  double _incentive = 1500.0;
  double _deductions = 2287.5; // PF + ESI
  double _netSalary = 26212.5; // (Basic + HRA + SpecialAllowance + Bonus + Incentive) - Deductions

  String get name => _name;
  String get employeeId => _employeeId;
  String get department => _department;
  String get shift => _shift;
  double get availableLeaves => _availableLeaves;
  
  double get basic => _basic;
  double get hra => _hra;
  double get specialAllowance => _specialAllowance;
  double get pf => _pf;
  double get esi => _esi;
  double get bonus => _bonus;
  double get incentive => _incentive;
  double get deductions => _deductions;
  double get netSalary => _netSalary;

  void updateName(String val) {
    _name = val;
    notifyListeners();
  }

  void updateEmployeeId(String val) {
    _employeeId = val;
    notifyListeners();
  }

  void updateDepartment(String val) {
    _department = val;
    notifyListeners();
  }

  void updateShift(String val) {
    _shift = val;
    notifyListeners();
  }

  void updateAvailableLeaves(double val) {
    _availableLeaves = val;
    notifyListeners();
  }

  void updateSalary({
    required double basic,
    required double hra,
    required double specialAllowance,
    required double pf,
    required double esi,
    required double bonus,
    required double incentive,
    required double deductions,
    required double netSalary,
  }) {
    _basic = basic;
    _hra = hra;
    _specialAllowance = specialAllowance;
    _pf = pf;
    _esi = esi;
    _bonus = bonus;
    _incentive = incentive;
    _deductions = deductions;
    _netSalary = netSalary;
    notifyListeners();
  }
}

