import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:blue_collar_tracker/core/theme/app_theme.dart';
import 'package:blue_collar_tracker/features/attendance/providers/attendance_provider.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  late Timer _clockTimer;
  DateTime _currentTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    _clockTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _currentTime = DateTime.now();
        });
      }
    });
  }

  @override
  void dispose() {
    _clockTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final attendance = Provider.of<AttendanceProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;
    final isWide = size.width > 768;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 48,
              height: 32,
              child: Image.asset(
                'assets/images/jay_logo.png',
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Attendance Tracker',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: isDark ? Colors.white : const Color(0xFF1E293B),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: isWide ? _buildWideLayout(attendance, isDark) : _buildMobileLayout(attendance, isDark),
      ),
    );
  }

  Widget _buildMobileLayout(AttendanceProvider attendance, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildClockCard(attendance, isDark),
        const SizedBox(height: 20),
        _buildActionButtons(attendance, isDark),
        const SizedBox(height: 20),
        _buildShiftInfoCards(attendance, isDark),
        const SizedBox(height: 20),
        _buildCalendarCard(attendance, isDark),
        const SizedBox(height: 24),
        _buildHistorySection(attendance, isDark),
      ],
    );
  }

  Widget _buildWideLayout(AttendanceProvider attendance, bool isDark) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left Column
        Expanded(
          flex: 5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildClockCard(attendance, isDark),
              const SizedBox(height: 20),
              _buildActionButtons(attendance, isDark),
              const SizedBox(height: 20),
              _buildShiftInfoCards(attendance, isDark),
            ],
          ),
        ),
        const SizedBox(width: 24),
        // Right Column
        Expanded(
          flex: 6,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildCalendarCard(attendance, isDark),
              const SizedBox(height: 24),
              _buildHistorySection(attendance, isDark),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildClockCard(AttendanceProvider attendance, bool isDark) {
    final formattedTime = DateFormat('hh:mm:ss a').format(_currentTime);
    final formattedDate = DateFormat('EEEE, d MMMM yyyy').format(_currentTime);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF1E293B), const Color(0xFF0F172A)]
              : [Colors.white, const Color(0xFFF1F5F9)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? Colors.white.withValues(alpha: 0.08) : Colors.black.withValues(alpha: 0.04),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            formattedTime,
            style: GoogleFonts.poppins(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
              color: isDark ? Colors.white : AppTheme.royalBlue,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            formattedDate,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isDark ? Colors.white.withValues(alpha: 0.6) : Colors.black54,
            ),
          ),
          if (attendance.isClockedIn && attendance.clockInTime != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppTheme.emeraldGreen.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(100),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppTheme.emeraldGreen,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Active session started at ${DateFormat('hh:mm a').format(attendance.clockInTime!)}',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.emeraldGreen,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActionButtons(AttendanceProvider attendance, bool isDark) {
    return Row(
      children: [
        Expanded(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: attendance.isClockedIn ? null : () => _handleClockAction(attendance, true),
              borderRadius: BorderRadius.circular(18),
              child: Ink(
                padding: const EdgeInsets.symmetric(vertical: 18),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: attendance.isClockedIn
                        ? [Colors.grey.shade300, Colors.grey.shade400]
                        : [AppTheme.royalBlue, const Color(0xFF3B82F6)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: attendance.isClockedIn
                      ? []
                      : [
                          BoxShadow(
                            color: AppTheme.royalBlue.withValues(alpha: 0.35),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.login_rounded, color: Colors.white, size: 22),
                    const SizedBox(width: 10),
                    Text(
                      'Check In',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: !attendance.isClockedIn ? null : () => _handleClockAction(attendance, false),
              borderRadius: BorderRadius.circular(18),
              child: Ink(
                padding: const EdgeInsets.symmetric(vertical: 18),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: !attendance.isClockedIn
                        ? [Colors.grey.shade300, Colors.grey.shade400]
                        : [const Color(0xFFEF4444), const Color(0xFFDC2626)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: !attendance.isClockedIn
                      ? []
                      : [
                          BoxShadow(
                            color: const Color(0xFFEF4444).withValues(alpha: 0.35),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.logout_rounded, color: Colors.white, size: 22),
                    const SizedBox(width: 10),
                    Text(
                      'Check Out',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _handleClockAction(AttendanceProvider attendance, bool clockIn) {
    attendance.toggleClockIn();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          clockIn ? 'Successfully clocked in!' : 'Successfully clocked out!',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: clockIn ? AppTheme.emeraldGreen : Colors.redAccent,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildShiftInfoCards(AttendanceProvider attendance, bool isDark) {
    return Row(
      children: [
        // Current Shift Card
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: isDark ? Colors.white.withValues(alpha: 0.08) : Colors.black.withValues(alpha: 0.04),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'SHIFT',
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                        color: isDark ? Colors.white.withValues(alpha: 0.5) : Colors.black45,
                      ),
                    ),
                    Icon(
                      Icons.schedule_rounded,
                      size: 16,
                      color: isDark ? Colors.white30 : Colors.black38,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Day Shift (Gen)',
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '09:00 AM - 05:00 PM',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: isDark ? Colors.white.withValues(alpha: 0.5) : Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        // Working Hours Card
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: isDark ? Colors.white.withValues(alpha: 0.08) : Colors.black.withValues(alpha: 0.04),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'LOGGED HOURS',
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                        color: isDark ? Colors.white.withValues(alpha: 0.5) : Colors.black45,
                      ),
                    ),
                    Icon(
                      Icons.trending_up_rounded,
                      size: 16,
                      color: attendance.isClockedIn ? AppTheme.emeraldGreen : (isDark ? Colors.white30 : Colors.black38),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  attendance.getTodayWorkingHours(),
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: attendance.isClockedIn ? AppTheme.emeraldGreen : (isDark ? Colors.white : const Color(0xFF1E293B)),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  attendance.isClockedIn ? 'Ticking session...' : 'Not active yet',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: attendance.isClockedIn ? AppTheme.emeraldGreen.withValues(alpha: 0.8) : (isDark ? Colors.white.withValues(alpha: 0.5) : Colors.black54),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCalendarCard(AttendanceProvider attendance, bool isDark) {
    final now = DateTime.now();
    final year = now.year;
    final month = now.month;
    final monthName = DateFormat('MMMM yyyy').format(now);

    final firstDay = DateTime(year, month, 1);
    final lastDay = DateTime(year, month + 1, 0);
    final daysInMonth = lastDay.day;
    final startWeekday = firstDay.weekday; // Mon=1, Sun=7
    final prependedCells = startWeekday - 1;

    final totalGridCells = prependedCells + daysInMonth;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? Colors.white.withValues(alpha: 0.08) : Colors.black.withValues(alpha: 0.04),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.1 : 0.03),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                monthName,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF1E293B),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.royalBlue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Text(
                  'Current Month',
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.royalBlue,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Day labels
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: ['M', 'T', 'W', 'T', 'F', 'S', 'S'].map((day) {
              return Expanded(
                child: Center(
                  child: Text(
                    day,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white.withValues(alpha: 0.4) : Colors.black38,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 8),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 1,
            ),
            itemCount: totalGridCells,
            itemBuilder: (context, index) {
              if (index < prependedCells) {
                return const SizedBox.shrink();
              }

              final dayNum = index - prependedCells + 1;
              final dayDate = DateTime(year, month, dayNum);
              final isToday = dayDate.day == now.day && dayDate.month == now.month && dayDate.year == now.year;

              // Check status from history
              String dayStatus = 'None';
              for (final record in attendance.history) {
                final recDate = record['date'] as DateTime;
                if (recDate.day == dayNum && recDate.month == month && recDate.year == year) {
                  dayStatus = record['status'] as String;
                  break;
                }
              }

              // Visual styling based on status
              Color? bgColor;
              Color? textColor;
              BoxBorder? border;

              if (isToday) {
                border = Border.all(color: AppTheme.royalBlue, width: 2);
              }

              if (dayStatus == 'Present') {
                bgColor = AppTheme.emeraldGreen.withValues(alpha: 0.15);
                textColor = AppTheme.emeraldGreen;
              } else if (dayStatus == 'Leave') {
                bgColor = Colors.amber.withValues(alpha: 0.15);
                textColor = Colors.amber.shade800;
              } else if (dayDate.weekday == DateTime.saturday || dayDate.weekday == DateTime.sunday) {
                textColor = isDark ? Colors.white.withValues(alpha: 0.3) : Colors.black26;
              } else {
                textColor = isDark ? Colors.white : const Color(0xFF1E293B);
              }

              return Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: bgColor,
                  shape: BoxShape.circle,
                  border: border,
                ),
                child: Text(
                  dayNum.toString(),
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: isToday || dayStatus != 'None' ? FontWeight.bold : FontWeight.w500,
                    color: textColor,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          // Legend
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegendItem('Present', AppTheme.emeraldGreen),
              const SizedBox(width: 16),
              _buildLegendItem('Leave', Colors.amber.shade700),
              const SizedBox(width: 16),
              _buildLegendItem('Weekend', Colors.grey),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.3),
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 1.5),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildHistorySection(AttendanceProvider attendance, bool isDark) {
    final list = attendance.history;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Attendance History',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : const Color(0xFF1E293B),
              ),
            ),
            Text(
              'Past logs',
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.white.withValues(alpha: 0.4) : Colors.black45,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (list.isEmpty)
          Container(
            padding: const EdgeInsets.symmetric(vertical: 32),
            alignment: Alignment.center,
            child: Text(
              'No previous attendance logs found.',
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: isDark ? Colors.white30 : Colors.black38,
              ),
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: list.length,
            separatorBuilder: (context, index) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final record = list[index];
              final date = record['date'] as DateTime;
              final dayStr = DateFormat('dd MMM').format(date);
              final weekdayStr = DateFormat('EEE').format(date);
              final clockIn = record['clockIn'] as String;
              final clockOut = record['clockOut'] as String;
              final hours = record['hours'] as String;
              final status = record['status'] as String;

              final isLeave = status == 'Leave';

              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDark ? Colors.white.withValues(alpha: 0.08) : Colors.black.withValues(alpha: 0.04),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Date block
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppTheme.royalBlue.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            dayStr,
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.royalBlue,
                            ),
                          ),
                          Text(
                            weekdayStr,
                            style: GoogleFonts.poppins(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: isDark ? Colors.white60 : Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Times info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.login_rounded,
                                size: 12,
                                color: isDark ? Colors.white30 : Colors.black38,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                clockIn,
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: isDark ? Colors.white70 : Colors.black87,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Icon(
                                Icons.logout_rounded,
                                size: 12,
                                color: isDark ? Colors.white30 : Colors.black38,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                clockOut,
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: isDark ? Colors.white70 : Colors.black87,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Duration: $hours',
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: isDark ? Colors.white38 : Colors.black45,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Status Badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: isLeave
                            ? Colors.amber.withValues(alpha: 0.12)
                            : AppTheme.emeraldGreen.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Text(
                        status,
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: isLeave ? Colors.amber.shade700 : AppTheme.emeraldGreen,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
      ],
    );
  }
}
