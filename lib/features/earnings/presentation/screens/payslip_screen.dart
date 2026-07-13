import 'package:flutter/material.dart';

class PayslipScreen extends StatelessWidget {
  const PayslipScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Payslip')),
      body: const Center(child: Text('Payslip Screen')),
    );
  }
}
