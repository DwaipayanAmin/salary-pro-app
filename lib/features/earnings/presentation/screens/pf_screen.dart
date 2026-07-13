import 'package:flutter/material.dart';

class PfScreen extends StatelessWidget {
  const PfScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PF Details')),
      body: const Center(child: Text('PF Details Screen')),
    );
  }
}
