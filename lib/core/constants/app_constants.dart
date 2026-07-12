import 'package:flutter/material.dart';

enum UserRole { factory, office, warehouse, apprentice, contract, qualityChecker }

class RoleConfig {
  final UserRole id;
  final String title;
  final String category;
  final IconData icon;
  final double baseSalary;
  final double hourlyRate;
  final String shiftType;
  final double otMultiplier;
  final bool pfApplicable;
  final List<String> benefits;

  const RoleConfig({
    required this.id,
    required this.title,
    required this.category,
    required this.icon,
    required this.baseSalary,
    required this.hourlyRate,
    required this.shiftType,
    required this.otMultiplier,
    required this.pfApplicable,
    required this.benefits,
  });

  String get idString => id.toString().split('.').last;
}

class QuickAction {
  final String id;
  final String label;
  final IconData icon;
  final List<Color> gradientColors;
  final String dialogTitle;
  final String dialogDescription;

  const QuickAction({
    required this.id,
    required this.label,
    required this.icon,
    required this.gradientColors,
    required this.dialogTitle,
    required this.dialogDescription,
  });
}

class ActivityLog {
  final String id;
  final DateTime timestamp;
  final String title;
  final String type; // 'attendance' | 'salary' | 'ot' | 'general'
  final String description;

  const ActivityLog({
    required this.id,
    required this.timestamp,
    required this.title,
    required this.type,
    required this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'timestamp': timestamp.toIso8601String(),
      'title': title,
      'type': type,
      'description': description,
    };
  }

  factory ActivityLog.fromMap(Map<String, dynamic> map) {
    return ActivityLog(
      id: map['id'] as String,
      timestamp: DateTime.parse(map['timestamp'] as String),
      title: map['title'] as String,
      type: map['type'] as String,
      description: map['description'] as String,
    );
  }
}

const Map<UserRole, RoleConfig> ROLE_CONFIGS = {
  UserRole.factory: RoleConfig(
    id: UserRole.factory,
    title: 'Factory Operator',
    category: 'Manufacturing & Assembly',
    icon: Icons.factory_outlined,
    baseSalary: 18500,
    hourlyRate: 90,
    shiftType: 'Shift A (08:00 - 16:30)',
    otMultiplier: 1.5,
    pfApplicable: true,
    benefits: [
      'Provident Fund (PF)',
      'ESIC Medical Scheme',
      'Night Shift Premium',
      'Perfect Attendance Bonus'
    ],
  ),
  UserRole.office: RoleConfig(
    id: UserRole.office,
    title: 'Office Executive',
    category: 'Administration & HR',
    icon: Icons.business_center_outlined,
    baseSalary: 26000,
    hourlyRate: 130,
    shiftType: 'General Shift (09:30 - 18:00)',
    otMultiplier: 1.0,
    pfApplicable: true,
    benefits: [
      'Provident Fund (PF)',
      'Gratuity Benefit',
      '14 Paid Casual Leaves',
      'Year-End Performance Bonus'
    ],
  ),
  UserRole.warehouse: RoleConfig(
    id: UserRole.warehouse,
    title: 'Warehouse Handler',
    category: 'Logistics & Inventory',
    icon: Icons.local_shipping_outlined,
    baseSalary: 16200,
    hourlyRate: 80,
    shiftType: 'Shift B (14:00 - 22:30)',
    otMultiplier: 1.5,
    pfApplicable: true,
    benefits: [
      'Provident Fund (PF)',
      'ESIC Insurance',
      'Safety Compliance Bonus',
      'Heavy Lifting Allowance'
    ],
  ),
  UserRole.apprentice: RoleConfig(
    id: UserRole.apprentice,
    title: 'Trade Apprentice',
    category: 'Skill Training Program',
    icon: Icons.school_outlined,
    baseSalary: 10500,
    hourlyRate: 50,
    shiftType: 'Apprentice Shift (08:30 - 17:00)',
    otMultiplier: 1.25,
    pfApplicable: false,
    benefits: [
      'State Skill Certification',
      'Dedicated Mentor Support',
      'Meal Subsidy Coupon',
      'Free Safety Gear Kit'
    ],
  ),
  UserRole.contract: RoleConfig(
    id: UserRole.contract,
    title: 'Contract Associate',
    category: 'Gig-based Work',
    icon: Icons.assignment_outlined,
    baseSalary: 0, // Daily rate payout structure
    hourlyRate: 110,
    shiftType: 'Flexible Hours (On-Demand)',
    otMultiplier: 1.5,
    pfApplicable: false,
    benefits: [
      'Weekly Direct Settlement',
      'Flexible Shift Selection',
      'Daily Meal & Travel Allowance',
      'Emergency Medical Cover'
    ],
  ),
  UserRole.qualityChecker: RoleConfig(
    id: UserRole.qualityChecker,
    title: 'Quality Checker',
    category: 'Quality Assurance',
    icon: Icons.fact_check_outlined,
    baseSalary: 28500,
    hourlyRate: 150,
    shiftType: 'Day Shift (09:00 - 17:30)',
    otMultiplier: 1.5,
    pfApplicable: true,
    benefits: [
      'Provident Fund (PF) (12%)',
      'ESIC Healthcare Scheme',
      'Quality Compliance Bonus',
      'Paid Casual Leaves (15)'
    ],
  ),
};

final List<QuickAction> QUICK_ACTIONS = [
  QuickAction(
    id: 'advance',
    label: 'Salary Advance',
    icon: Icons.monetization_on_outlined,
    gradientColors: [Colors.amber, Colors.orange],
    dialogTitle: 'Request Salary Advance',
    dialogDescription:
        'Need money early? Request an advance up to 50% of your current accrued monthly earnings interest-free. Funds transfer instantly upon line-manager approval.',
  ),
  QuickAction(
    id: 'ot_log',
    label: 'Log Overtime',
    icon: Icons.av_timer_outlined,
    gradientColors: [Colors.purple, Colors.indigo],
    dialogTitle: 'Submit Overtime (OT) Hours',
    dialogDescription:
        'Record extra hours spent outside regular shift limits. Submissions are verified against digital RFID swipe gates automatically.',
  ),
  QuickAction(
    id: 'payslip',
    label: 'View Payslips',
    icon: Icons.receipt_long_outlined,
    gradientColors: [Colors.blue, Colors.cyan],
    dialogTitle: 'Interactive Payslips',
    dialogDescription:
        'View, download, or share digitally signed PDF payslips for previous pay periods complete with Tax deductions, PF, and OT breakdowns.',
  ),
  QuickAction(
    id: 'leave',
    label: 'Apply Leave',
    icon: Icons.calendar_today_outlined,
    gradientColors: [Colors.emerald, Colors.teal],
    dialogTitle: 'Apply for Leave / Time-Off',
    dialogDescription:
        'Submit requests for sick leave, casual leave, or unpaid personal days off. Checks active balance dynamically before processing.',
  ),
];
