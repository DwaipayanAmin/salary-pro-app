import 'package:flutter/material.dart';

class EmployeeManagementScreen extends StatelessWidget {
  const EmployeeManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Employee Management')),
      body: const Center(child: Text('Employee Management Screen')),
    );
  }
}
