import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'core/providers/app_state_providers.dart';
import 'features/splash/presentation/screens/splash_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: AppStateProviders.providers,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Salary Pro',
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
