import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:blue_collar_tracker/features/profile/providers/profile_provider.dart';
import 'package:blue_collar_tracker/core/theme/route_transitions.dart';
import 'package:blue_collar_tracker/features/profile/presentation/screens/employee_management_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profile = Provider.of<ProfileProvider>(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Profile: ${profile.name}'),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                RouteTransitions.slideIn(const EmployeeManagementScreen()),
              );
            },
            child: const Text('Employee Management'),
          ),
        ],
      ),
    );
  }
}
