import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_theme.dart';
import '../../dashboard/providers/role_provider.dart';
import '../providers/attendance_provider.dart';

class TimeScreen extends ConsumerStatefulWidget {
  const TimeScreen({super.key});

  @override
  ConsumerState<TimeScreen> createState() => _TimeScreenState();
}

class _TimeScreenState extends ConsumerState<TimeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _fingerprintController;
  late Animation<double> _pulseAnimation;
  String _currentTimeString = '';
  String _currentDateString = '';
  Timer? _clockTimer;

  @override
  void initState() {
    super.initState();
    _fingerprintController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.12).animate(
      CurvedAnimation(parent: _fingerprintController, curve: Curves.easeInOut),
    );

    _updateTime();
    _clockTimer = Timer.periodic(const Duration(seconds: 1), (timer) => _updateTime());
  }

  void _updateTime() {
    final now = DateTime.now();
    setState(() {
      _currentTimeString = DateFormat('hh:mm:ss a').format(now);
      _currentDateString = DateFormat('EEEE, dd MMMM yyyy').format(now);
    });
  }

  @override
  void dispose() {
    _fingerprintController.dispose();
    _clockTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final activeRole = ref.watch(activeRoleProvider);
    final attendanceState = ref.watch(attendanceProvider(activeRole));

    final String activeElapsedTime = _formatDuration(attendanceState.elapsedDuration);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 12),
                // 1. Live Digital Clock Block
                Text(
                  _currentDateString,
                  style: TextStyle(fontSize: 14, color: Colors.grey.withOpacity(0.8), letterSpacing: 0.5),
                ),
                const SizedBox(height: 6),
                Text(
                  _currentTimeString,
                  style: const TextStyle(
                    fontFamily: 'Space Grotesk',
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 28),

                // 2. Main Visual biometric / finger scanner
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 24),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: attendanceState.isClockedIn ? const Color(0xFF10B981).withOpacity(0.3) : Colors.grey.withOpacity(0.2),
                      width: 1.5,
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        attendanceState.isClockedIn ? 'SHIFT IS RUNNING' : 'NOT CLOCKED IN',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                          color: attendanceState.isClockedIn ? const Color(0xFF10B981) : Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        attendanceState.isClockedIn ? activeElapsedTime : 'Hold button to verify ID & punch',
                        style: TextStyle(
                          fontSize: attendanceState.isClockedIn ? 42 : 14,
                          fontWeight: attendanceState.isClockedIn ? FontWeight.bold : FontWeight.normal,
                          fontFamily: 'Space Grotesk',
                          color: attendanceState.isClockedIn ? const Color(0xFF10B981) : Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 36),

                      // Animated Fingerprint Button
                      GestureDetector(
                        onLongPressStart: (_) => _handleBiometricPunch(context, ref, activeRole),
                        child: ScaleTransition(
                          scale: _pulseAnimation,
                          child: Container(
                            height: 120,
                            width: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: RadialGradient(
                                colors: attendanceState.isClockedIn
                                    ? [const Color(0xFF34D399), const Color(0xFF10B981).shade900]
                                    : [AppTheme.accentColor.shade400, AppTheme.accentColor.shade900],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: attendanceState.isClockedIn
                                      ? const Color(0xFF10B981).withOpacity(0.4)
                                      : AppTheme.accentColor.withOpacity(0.4),
                                  blurRadius: 20,
                                  spreadRadius: 2,
                                )
                              ],
                            ),
                            child: Icon(
                              attendanceState.isClockedIn ? Icons.verified_user : Icons.fingerprint,
                              size: 56,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        attendanceState.isClockedIn
                            ? 'Press and hold to Clock-Out'
                            : 'Press and hold to Clock-In',
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // 3. Shift statistics log history
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'PUNCH CARD LEDGER',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.0, color: Colors.grey),
                    ),
                    TextButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.tune_outlined, size: 14),
                      label: const Text('Filter', style: TextStyle(fontSize: 12)),
                    )
                  ],
                ),
                const SizedBox(height: 8),

                attendanceState.history.when(
                  data: (records) {
                    if (records.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 40),
                        child: Column(
                          children: [
                            Icon(Icons.calendar_today_outlined, color: Colors.grey, size: 40),
                            SizedBox(height: 12),
                            Text('No attendance records logged this month.', style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                      );
                    }

                    return ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: records.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final record = records[index];
                        final checkInDate = DateTime.parse(record.checkInTime);
                        final checkOutStr = record.checkOutTime != null
                            ? DateFormat('hh:mm a').format(DateTime.parse(record.checkOutTime!))
                            : 'In Progress';

                        return Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.grey.withOpacity(0.1),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    DateFormat('EEEE, dd MMMM').format(checkInDate),
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Swipe-In: ${DateFormat('hh:mm a').format(checkInDate)}  •  Swipe-Out: $checkOutStr',
                                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                                  ),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                  color: record.checkOutTime != null
                                      ? Colors.blue.withOpacity(0.1)
                                      : const Color(0xFF10B981).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  record.checkOutTime != null
                                      ? '${record.hoursWorked.toStringAsFixed(1)} hrs'
                                      : 'Active',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: record.checkOutTime != null ? Colors.blue : const Color(0xFF10B981),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (err, stack) => Text('Error loading history: $err'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String hours = twoDigits(d.inHours);
    String minutes = twoDigits(d.inMinutes.remainder(60));
    String seconds = twoDigits(d.inSeconds.remainder(60));
    return "$hours:$minutes:$seconds";
  }

  Future<void> _handleBiometricPunch(BuildContext context, WidgetRef ref, UserRole role) async {
    // Show biometric HUD
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const AlertDialog(
          backgroundColor: Color(0xFF1E293B),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 16),
              CircularProgressIndicator(color: Colors.amber),
              SizedBox(height: 24),
              Text(
                'VERIFYING INDUSTRIAL BADGE...',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Space Grotesk',
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                  fontSize: 13,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Simulating RFID & local biometric secure handshake.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 11),
              ),
              SizedBox(height: 16),
            ],
          ),
        );
      },
    );

    await Future.delayed(const Duration(milliseconds: 1200));
    Navigator.pop(context); // Close biometric dialog

    // Trigger state notifier toggle
    await ref.read(attendanceProvider(role).notifier).toggleClockInOut();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            Icon(Icons.fingerprint, color: Colors.white),
            SizedBox(width: 8),
            Text('Biometric verification verified. Punch processed offline.'),
          ],
        ),
        backgroundColor: const Color(0xFF10B981),
      ),
    );
  }
}
