import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:blue_collar_tracker/core/theme/app_theme.dart';
import 'package:blue_collar_tracker/core/theme/route_transitions.dart';
import 'package:blue_collar_tracker/features/profile/providers/profile_provider.dart';
import 'package:blue_collar_tracker/features/attendance/providers/attendance_provider.dart';
import 'package:blue_collar_tracker/features/attendance/presentation/screens/calendar_attendance_screen.dart';
import 'package:blue_collar_tracker/features/attendance/presentation/screens/leave_management_screen.dart';
import 'package:blue_collar_tracker/features/earnings/presentation/screens/payslip_screen.dart';
import 'package:blue_collar_tracker/features/earnings/presentation/screens/earnings_screen.dart';
import 'package:blue_collar_tracker/features/profile/presentation/screens/profile_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profile = Provider.of<ProfileProvider>(context);
    final attendance = Provider.of<AttendanceProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await Future.delayed(const Duration(milliseconds: 600));
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Company Logo & Name Header
                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppTheme.royalBlue, AppTheme.emeraldGreen],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.royalBlue.withValues(alpha: 0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.diversity_3_rounded,
                          size: 22,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'MJ HRMS',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                              color: isDark ? Colors.white : AppTheme.royalBlue,
                            ),
                          ),
                          Text(
                            'Madhu Jayanti International Pvt. Ltd.',
                            style: GoogleFonts.poppins(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: isDark ? Colors.white.withValues(alpha: 0.5) : Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Greeting Header: Welcome, Employee.
                Text(
                  'Welcome, Employee.',
                  style: GoogleFonts.poppins(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                    color: isDark ? Colors.white : const Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Here is your enterprise HR summary for today.',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: isDark ? Colors.white.withValues(alpha: 0.5) : Colors.black54,
                  ),
                ),

                const SizedBox(height: 24),

                // Section Title: Summaries
                Text(
                  'Summary Overview',
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white70 : AppTheme.royalBlue,
                  ),
                ),
                const SizedBox(height: 12),

                // Four Summary Cards (2x2 Grid)
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  childAspectRatio: 1.15,
                  children: [
                    // 1. Attendance Summary Card
                    _buildSummaryCard(
                      context: context,
                      title: 'Attendance',
                      value: attendance.isClockedIn ? 'Clocked In' : 'Clocked Out',
                      subtext: attendance.isClockedIn ? 'Shift Time Active' : 'Not Active',
                      icon: Icons.timer_rounded,
                      color: AppTheme.emeraldGreen,
                      onTap: () {
                        // Toggle or navigate
                        attendance.toggleClockIn();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              attendance.isClockedIn 
                                  ? 'Successfully clocked in!' 
                                  : 'Successfully clocked out!',
                              style: GoogleFonts.poppins(),
                            ),
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: attendance.isClockedIn ? AppTheme.emeraldGreen : AppTheme.royalBlue,
                            margin: const EdgeInsets.all(16),
                          ),
                        );
                      },
                    ),
                    // 2. Leave Summary Card
                    _buildSummaryCard(
                      context: context,
                      title: 'Leave',
                      value: '${profile.availableLeaves.toStringAsFixed(1)} Days',
                      subtext: 'Paid Leave Balance',
                      icon: Icons.beach_access_rounded,
                      color: AppTheme.royalBlue,
                      onTap: () {
                        Navigator.push(
                          context,
                          RouteTransitions.slideIn(const LeaveManagementScreen()),
                        );
                      },
                    ),
                    // 3. Salary Summary Card
                    _buildSummaryCard(
                      context: context,
                      title: 'Salary',
                      value: '₹${profile.netSalary.toStringAsFixed(0)}',
                      subtext: 'Net Monthly (No OT)',
                      icon: Icons.payments_rounded,
                      color: Colors.amber.shade800,
                      onTap: () {
                        _showSalaryDetailDialog(context, profile);
                      },
                    ),
                    // 4. Shift Summary Card
                    _buildSummaryCard(
                      context: context,
                      title: 'Shift',
                      value: '${profile.shift} Shift',
                      subtext: profile.shift == 'Day' ? '08:00 AM - 05:30 PM' : '08:00 PM - 05:30 AM',
                      icon: Icons.schedule_rounded,
                      color: Colors.purple.shade700,
                      onTap: () {
                        _showShiftSelectionDialog(context, profile);
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 28),

                // Quick Actions Grid Title
                Text(
                  'Quick Actions',
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white70 : AppTheme.royalBlue,
                  ),
                ),
                const SizedBox(height: 12),

                // Quick Actions Grid (Exactly 5 Items: Attendance, Leave, Salary, Payslip, Profile)
                GridView.count(
                  crossAxisCount: 3,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.95,
                  children: [
                    _buildQuickActionItem(
                      context: context,
                      title: 'Attendance',
                      icon: Icons.today_rounded,
                      color: AppTheme.emeraldGreen,
                      onTap: () {
                        Navigator.push(
                          context,
                          RouteTransitions.slideIn(const CalendarAttendanceScreen()),
                        );
                      },
                    ),
                    _buildQuickActionItem(
                      context: context,
                      title: 'Leave',
                      icon: Icons.beach_access_rounded,
                      color: AppTheme.royalBlue,
                      onTap: () {
                        Navigator.push(
                          context,
                          RouteTransitions.slideIn(const LeaveManagementScreen()),
                        );
                      },
                    ),
                    _buildQuickActionItem(
                      context: context,
                      title: 'Salary',
                      icon: Icons.account_balance_wallet_rounded,
                      color: Colors.amber.shade800,
                      onTap: () {
                        Navigator.push(
                          context,
                          RouteTransitions.slideIn(const EarningsScreen()),
                        );
                      },
                    ),
                    _buildQuickActionItem(
                      context: context,
                      title: 'Payslip',
                      icon: Icons.receipt_long_rounded,
                      color: Colors.teal.shade700,
                      onTap: () {
                        Navigator.push(
                          context,
                          RouteTransitions.slideIn(const PayslipScreen()),
                        );
                      },
                    ),
                    _buildQuickActionItem(
                      context: context,
                      title: 'Profile',
                      icon: Icons.person_outline_rounded,
                      color: Colors.indigo.shade700,
                      onTap: () {
                        Navigator.push(
                          context,
                          RouteTransitions.slideIn(const ProfileScreen()),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard({
    required BuildContext context,
    required String title,
    required String value,
    required String subtext,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Material(
      color: isDark ? const Color(0xFF1E293B) : Colors.white,
      borderRadius: BorderRadius.circular(16),
      elevation: 0,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark ? Colors.white10 : const Color(0xFFE2E8F0),
            ),
          ),
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white60 : Colors.black54,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: color, size: 16),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtext,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: isDark ? Colors.white38 : Colors.black45,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActionItem({
    required BuildContext context,
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Material(
      color: isDark ? const Color(0xFF1E293B) : Colors.white,
      borderRadius: BorderRadius.circular(14),
      elevation: 0,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isDark ? Colors.white10 : const Color(0xFFE2E8F0),
            ),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white87 : const Color(0xFF334155),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSalaryDetailDialog(BuildContext context, ProfileProvider profile) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Salary Breakdown',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : AppTheme.royalBlue,
                    ),
                  ),
                  Text(
                    'Excl. Overtime',
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Colors.amber.shade800,
                    ),
                  ),
                ],
              ),
              const Divider(height: 24, thickness: 1),
              _buildSalaryDetailRow('Basic Pay', '₹${profile.basic.toStringAsFixed(2)}', isDark),
              _buildSalaryDetailRow('HRA (House Rent Allowance)', '₹${profile.hra.toStringAsFixed(2)}', isDark),
              _buildSalaryDetailRow('Special Allowance', '₹${profile.specialAllowance.toStringAsFixed(2)}', isDark),
              _buildSalaryDetailRow('Bonus', '₹${profile.bonus.toStringAsFixed(2)}', isDark),
              _buildSalaryDetailRow('Incentive', '₹${profile.incentive.toStringAsFixed(2)}', isDark),
              const Divider(height: 20, thickness: 1),
              _buildSalaryDetailRow('PF Deduction (Provident Fund)', '- ₹${profile.pf.toStringAsFixed(2)}', isDark, isDeduction: true),
              _buildSalaryDetailRow('ESI Deduction (State Insurance)', '- ₹${profile.esi.toStringAsFixed(2)}', isDark, isDeduction: true),
              const Divider(height: 24, thickness: 1),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Net Salary (Take Home)',
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xFF1E293B),
                    ),
                  ),
                  Text(
                    '₹${profile.netSalary.toStringAsFixed(2)}',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.emeraldGreen,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      RouteTransitions.slideIn(const PayslipScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.royalBlue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text(
                    'View & Download Payslips',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSalaryDetailRow(String label, String value, bool isDark, {bool isDeduction = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: isDark ? Colors.white60 : Colors.black54,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isDeduction 
                  ? Colors.red.shade600 
                  : (isDark ? Colors.white80 : const Color(0xFF334155)),
            ),
          ),
        ],
      ),
    );
  }

  void _showShiftSelectionDialog(BuildContext context, ProfileProvider profile) {
    showDialog(
      context: context,
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return AlertDialog(
          backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            'Select Shift Schedule',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : AppTheme.royalBlue,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildShiftOption(context, profile, 'Day', '08:00 AM - 05:30 PM', Icons.wb_sunny_rounded, Colors.orange),
              const SizedBox(height: 12),
              _buildShiftOption(context, profile, 'Night', '08:00 PM - 05:30 AM', Icons.nightlight_round, Colors.indigo),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Close',
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.grey),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildShiftOption(
    BuildContext context,
    ProfileProvider profile,
    String shiftName,
    String timing,
    IconData icon,
    Color color,
  ) {
    final isSelected = profile.shift == shiftName;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: () {
        profile.updateShift(shiftName);
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Successfully updated to $shiftName Shift!',
              style: GoogleFonts.poppins(),
            ),
            behavior: SnackBarBehavior.floating,
            backgroundColor: AppTheme.emeraldGreen,
            margin: const EdgeInsets.all(16),
          ),
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected 
                ? AppTheme.royalBlue 
                : (isDark ? Colors.white10 : const Color(0xFFE2E8F0)),
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
          color: isSelected 
              ? AppTheme.royalBlue.withValues(alpha: 0.05) 
              : Colors.transparent,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$shiftName Shift',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: isDark ? Colors.white : const Color(0xFF1E293B),
                    ),
                  ),
                  Text(
                    timing,
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: isDark ? Colors.white.withValues(alpha: 0.5) : Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle_rounded,
                color: AppTheme.royalBlue,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}
