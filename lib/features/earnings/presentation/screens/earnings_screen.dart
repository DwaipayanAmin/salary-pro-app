import 'package:flutter/material.dart';
import 'package:blue_collar_tracker/core/theme/route_transitions.dart';
import 'package:blue_collar_tracker/features/earnings/presentation/screens/overtime_screen.dart';
import 'package:blue_collar_tracker/features/earnings/presentation/screens/reports_screen.dart';
import 'package:blue_collar_tracker/features/earnings/presentation/screens/esi_screen.dart';
import 'package:blue_collar_tracker/features/earnings/presentation/screens/pf_screen.dart';
import 'package:blue_collar_tracker/features/earnings/presentation/screens/payslip_screen.dart';

class EarningsScreen extends StatelessWidget {
  const EarningsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ListTile(
          title: const Text('Overtime'),
          onTap: () => Navigator.of(context).push(RouteTransitions.slideIn(const OvertimeScreen())),
        ),
        ListTile(
          title: const Text('ESI Details'),
          onTap: () => Navigator.of(context).push(RouteTransitions.slideIn(const EsiScreen())),
        ),
        ListTile(
          title: const Text('PF Details'),
          onTap: () => Navigator.of(context).push(RouteTransitions.slideIn(const PfScreen())),
        ),
        ListTile(
          title: const Text('Payslips'),
          onTap: () => Navigator.of(context).push(RouteTransitions.slideIn(const PayslipScreen())),
        ),
        ListTile(
          title: const Text('Reports'),
          onTap: () => Navigator.of(context).push(RouteTransitions.slideIn(const ReportsScreen())),
        ),
      ],
    );
  }
}
