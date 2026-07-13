import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:blue_collar_tracker/features/attendance/presentation/screens/time_screen.dart';
import 'package:blue_collar_tracker/features/earnings/presentation/screens/earnings_screen.dart';
import 'package:blue_collar_tracker/features/profile/presentation/screens/profile_screen.dart';
import 'package:blue_collar_tracker/features/shift/presentation/screens/shift_screen.dart';
import 'package:blue_collar_tracker/features/dashboard/providers/role_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const TimeScreen(),
    const ShiftScreen(),
    const EarningsScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final roleProvider = Provider.of<RoleProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Salary Pro (${roleProvider.currentRole})'),
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.timer), label: 'Attendance'),
          BottomNavigationBarItem(icon: Icon(Icons.schedule), label: 'Shifts'),
          BottomNavigationBarItem(icon: Icon(Icons.payments), label: 'Earnings'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
