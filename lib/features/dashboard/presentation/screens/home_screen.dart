import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/route_transitions.dart';
import '../../providers/role_provider.dart';
import '../../../profile/providers/profile_provider.dart';
import '../../../earnings/presentation/screens/overtime_screen.dart';
import '../../../earnings/presentation/screens/payslip_screen.dart';
import '../../../shift/presentation/screens/shift_screen.dart';
import '../../../attendance/presentation/screens/leave_management_screen.dart';
import '../../../attendance/presentation/screens/calendar_attendance_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeRole = ref.watch(activeRoleProvider);
    final activeConfig = ROLE_CONFIGS[activeRole]!;
    final activityState = ref.watch(activityProvider(activeRole));
    final profileState = ref.watch(profileProvider(activeRole));
    final themeMode = ref.watch(themeModeProvider);
    final isDark = themeMode == AppThemeMode.dark;

    final currencyFormat = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);
    final currentTime = DateFormat('EEEE, dd MMMM').format(DateTime.now());

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Dynamic Greeting Header
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          currentTime,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.0,
                            color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        profileState.when(
                          data: (profile) => Text(
                            'Namaste, ${profile.fullName.split(' ').first} 👋',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              letterSpacing: -0.5,
                            ),
                          ),
                          loading: () => const Text(
                            'Loading profile...',
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          error: (_, __) => const Text(
                            'Welcome Back 👋',
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        // Theme Toggle
                        Container(
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF1E293B) : Colors.grey.shade100,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: Icon(
                              isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
                              size: 20,
                              color: isDark ? AppTheme.accentColor : AppTheme.primaryColor,
                            ),
                            onPressed: () {
                              ref.read(themeModeProvider.notifier).state =
                                  isDark ? AppThemeMode.light : AppThemeMode.dark;
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        // Notifications
                        Container(
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF1E293B) : Colors.grey.shade100,
                            shape: BoxShape.circle,
                          ),
                          child: Stack(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.notifications_none_outlined, size: 20),
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('All local systems operating normally. Database fully synced.'),
                                      backgroundColor: Colors.blue,
                                    ),
                                  );
                                },
                              ),
                              Positioned(
                                right: 12,
                                top: 12,
                                child: Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // 2. Beautiful Animated Role Switcher Carousel
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ACTIVE WORKER PROFILE',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                        color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 85,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        itemCount: UserRole.values.length,
                        separatorBuilder: (context, index) => const SizedBox(width: 10),
                        itemBuilder: (context, index) {
                          final role = UserRole.values[index];
                          final config = ROLE_CONFIGS[role]!;
                          final isSelected = role == activeRole;

                          return GestureDetector(
                            onTap: () {
                              ref.read(activeRoleProvider.notifier).state = role;
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              curve: Curves.easeOutCubic,
                              width: 155,
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                              decoration: BoxDecoration(
                                gradient: isSelected
                                    ? LinearGradient(
                                        colors: [
                                          AppTheme.primaryColor,
                                          const Color(0xFF2E3E56),
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      )
                                    : null,
                                color: isSelected
                                    ? null
                                    : (isDark ? const Color(0xFF1E293B) : Colors.white),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: isSelected
                                      ? AppTheme.accentColor.withOpacity(0.7)
                                      : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                                  width: isSelected ? 1.5 : 1.0,
                                ),
                                boxShadow: isSelected
                                    ? [
                                        BoxShadow(
                                          color: AppTheme.accentColor.withOpacity(0.15),
                                          blurRadius: 10,
                                          spreadRadius: 1,
                                        )
                                      ]
                                    : null,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        config.icon,
                                        size: 18,
                                        color: isSelected ? AppTheme.accentColor : Colors.grey,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          config.title.split(' ').first,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                            color: isSelected ? Colors.white : (isDark ? Colors.white : AppTheme.primaryColor),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    config.category,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: isSelected ? Colors.white70 : Colors.grey.shade500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // 3. Hero Gradient Payout Accrual Card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Card(
                    key: ValueKey<UserRole>(activeRole),
                    elevation: 4,
                    shadowColor: Colors.black12,
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                        width: 1,
                      ),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: isDark
                              ? [const Color(0xFF1E293B), const Color(0xFF0F172A)]
                              : [Colors.white, const Color(0xFFF8FAFC)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'MONTHLY ACCRUED EARNINGS',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.0,
                                  color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: activeConfig.pfApplicable
                                      ? const Color(0xFF10B981).withOpacity(0.12)
                                      : Colors.orange.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  activeConfig.pfApplicable ? 'PF Enrolled' : 'Contract/Gig',
                                  style: TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                    color: activeConfig.pfApplicable ? const Color(0xFF10B981) : Colors.orange,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 18),
                          Row(
                            children: [
                              // Left: Financial Breakdown
                              Expanded(
                                flex: 3,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      activeConfig.baseSalary > 0
                                          ? currencyFormat.format(activeConfig.baseSalary)
                                          : 'Weekly Settled',
                                      style: TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: -0.5,
                                        color: isDark ? Colors.white : AppTheme.primaryColor,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Current Base Pay Rate',
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.grey.shade500,
                                      ),
                                    ),
                                    Text(
                                      '${currencyFormat.format(activeConfig.hourlyRate)}/hr shift-rate',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: isDark ? Colors.grey.shade300 : AppTheme.primaryColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Right: Animated Radial Progress Meter
                              Expanded(
                                flex: 2,
                                child: Column(
                                  children: [
                                    TweenAnimationBuilder<double>(
                                      tween: Tween<double>(begin: 0, end: activeConfig.baseSalary > 0 ? 0.65 : 0.45),
                                      duration: const Duration(milliseconds: 1000),
                                      curve: Curves.easeOutQuint,
                                      builder: (context, value, child) {
                                        return Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            SizedBox(
                                              height: 70,
                                              width: 70,
                                              child: CircularProgressIndicator(
                                                value: value,
                                                strokeWidth: 8,
                                                backgroundColor: isDark ? const Color(0xFF334155) : Colors.grey.shade200,
                                                color: AppTheme.accentColor,
                                                strokeCap: StrokeCap.round,
                                              ),
                                            ),
                                            Text(
                                              '${(value * 100).toInt()}%',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: isDark ? Colors.white : AppTheme.primaryColor,
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      'Monthly Progress',
                                      style: TextStyle(
                                        fontSize: 9,
                                        color: Colors.grey.shade500,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          const Divider(height: 1),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildMiniStat(
                                'Shift Details',
                                activeConfig.shiftType,
                                Icons.schedule,
                                isDark,
                                onTap: () {
                                  Navigator.push(context, createPremiumRoute(const ShiftScreen()));
                                },
                              ),
                              _buildMiniStat('Overtime multiplier', '${activeConfig.otMultiplier}x hourly', Icons.alarm_on_outlined, isDark),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // 4. Weekly Wage Progress Line Chart (FL Chart)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: _buildWagesTrendChart(context, activeConfig.baseSalary, isDark),
              ),

              const SizedBox(height: 20),

              // 5. Quick Services Bento Grid
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'QUICK SERVICES',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                        color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 1.45,
                      ),
                      itemCount: QUICK_ACTIONS.length,
                      itemBuilder: (context, index) {
                        final action = QUICK_ACTIONS[index];
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            gradient: LinearGradient(
                              colors: action.gradientColors,
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: action.gradientColors.first.withOpacity(0.18),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              )
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                if (action.id == 'payslip') {
                                  Navigator.push(context, createPremiumRoute(const PayslipScreen()));
                                } else if (action.id == 'ot_log') {
                                  Navigator.push(context, createPremiumRoute(const OvertimeScreen()));
                                } else if (action.id == 'leave') {
                                  Navigator.push(context, createPremiumRoute(const LeaveManagementScreen()));
                                } else if (action.id == 'calendar') {
                                  Navigator.push(context, createPremiumRoute(const CalendarAttendanceScreen()));
                                } else {
                                  _showActionBottomSheet(context, action, ref, activeRole);
                                }
                              },
                              borderRadius: BorderRadius.circular(16),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.2),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(action.icon, color: Colors.white, size: 20),
                                    ),
                                    Text(
                                      action.label,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // 6. Benefits Slider/Pills
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.stars_outlined, color: AppTheme.accentColor, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          'ROLE COVERAGE & BENEFITS',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.0,
                            color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 38,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        itemCount: activeConfig.benefits.length,
                        separatorBuilder: (context, index) => const SizedBox(width: 8),
                        itemBuilder: (context, index) {
                          final benefit = activeConfig.benefits[index];
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: isDark ? const Color(0xFF1E293B) : Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isDark ? const Color(0xFF334155) : Colors.grey.shade200,
                                width: 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.check_circle, color: const Color(0xFF10B981), size: 14),
                                const SizedBox(width: 6),
                                Text(
                                  benefit,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: isDark ? Colors.white : AppTheme.primaryColor,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // 7. Recent Shift Logs Feed
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'RECENT DIGITAL HANDSHAKES',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                        color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    activityState.when(
                      data: (logs) {
                        if (logs.isEmpty) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 24),
                            child: Center(
                              child: Text(
                                'No recent shifts verified.',
                                style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
                              ),
                            ),
                          );
                        }
                        return ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: logs.length > 4 ? 4 : logs.length,
                          separatorBuilder: (context, index) => const SizedBox(height: 8),
                          itemBuilder: (context, index) {
                            final log = logs[index];
                            IconData logIcon = Icons.info_outline;
                            Color logColor = Colors.blue;

                            if (log.type == 'attendance') {
                              logIcon = Icons.verified_user_outlined;
                              logColor = const Color(0xFF10B981);
                            } else if (log.type == 'salary') {
                              logIcon = Icons.currency_rupee_outlined;
                              logColor = Colors.amber;
                            } else if (log.type == 'ot') {
                              logIcon = Icons.add_alarm_outlined;
                              logColor = Colors.purple;
                            }

                            return Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: isDark ? const Color(0xFF1E293B) : Colors.white,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: isDark ? const Color(0xFF334155) : Colors.grey.shade100,
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: logColor.withOpacity(0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(logIcon, color: logColor, size: 16),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          log.title,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
                                            color: isDark ? Colors.white : AppTheme.primaryColor,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          log.description,
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: Colors.grey.shade500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    _formatRelativeTime(log.timestamp),
                                    style: TextStyle(
                                      fontSize: 9,
                                      color: Colors.grey.shade400,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                      loading: () => const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 24.0),
                          child: CircularProgressIndicator(),
                        ),
                      ),
                      error: (err, stack) => Text('System state log error: $err'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWagesTrendChart(BuildContext context, double baseSalary, bool isDark) {
    // Generate simulated dynamic values based on the active role's financial config
    final double dayMultiplier = baseSalary > 0 ? (baseSalary / 20) : 950.0;
    final List<double> dailyWages = [
      dayMultiplier * 0.95,
      dayMultiplier * 1.05,
      dayMultiplier * 0.85,
      dayMultiplier * 1.20, // overtime inclusion simulation
      dayMultiplier * 1.10,
      dayMultiplier * 1.00,
    ];

    final maxVal = dailyWages.reduce((curr, next) => curr > next ? curr : next) * 1.15;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
          width: 1,
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.analytics_outlined, color: Colors.blue, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      'Wages Accrual (Last 6 Days)',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: isDark ? Colors.white : AppTheme.primaryColor,
                      ),
                    ),
                  ],
                ),
                Text(
                  'Auto-Audit Live',
                  style: TextStyle(
                    fontSize: 9,
                    color: const Color(0xFF10B981),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 140,
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: false),
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 34,
                        getTitlesWidget: (value, meta) {
                          if (value == 0 || value == maxVal) return const SizedBox();
                          return Text(
                            '₹${value.toInt()}',
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 20,
                        getTitlesWidget: (value, meta) {
                          final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
                          if (value.toInt() >= 0 && value.toInt() < days.length) {
                            return Text(
                              days[value.toInt()],
                              style: TextStyle(
                                color: Colors.grey.shade500,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          }
                          return const SizedBox();
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  minX: 0,
                  maxX: 5,
                  minY: 0,
                  maxY: maxVal,
                  lineBarsData: [
                    LineChartBarData(
                      spots: List.generate(
                        dailyWages.length,
                        (index) => FlSpot(index.toDouble(), dailyWages[index]),
                      ),
                      isCurved: true,
                      color: AppTheme.accentColor,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
                          radius: 3,
                          color: AppTheme.accentColor,
                          strokeWidth: 1,
                          strokeColor: Colors.white,
                        ),
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          colors: [
                            AppTheme.accentColor.withOpacity(0.18),
                            AppTheme.accentColor.withOpacity(0.0),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniStat(String label, String value, IconData icon, bool isDark, {VoidCallback? onTap}) {
    final content = Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF334155) : Colors.grey.shade100,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 14, color: isDark ? Colors.grey.shade300 : AppTheme.primaryColor),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontSize: 8, color: Colors.grey, fontWeight: FontWeight.bold)),
            const SizedBox(height: 1),
            Text(
              value,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : AppTheme.primaryColor,
              ),
            ),
          ],
        ),
      ],
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: content,
        ),
      );
    }
    return content;
  }

  String _formatRelativeTime(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    } else {
      return '${diff.inDays}d ago';
    }
  }

  void _showActionBottomSheet(BuildContext context, QuickAction action, WidgetRef ref, UserRole role) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            top: 24,
            left: 20,
            right: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    action.dialogTitle,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                action.dialogDescription,
                style: TextStyle(fontSize: 13, color: Colors.grey.shade500, height: 1.4),
              ),
              const SizedBox(height: 20),
              if (action.id == 'advance') ...[
                const Text('Advance Amount Request (₹)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                const SizedBox(height: 12),
                StatefulBuilder(
                  builder: (context, setModalState) {
                    double slideVal = 4000.0;
                    return Column(
                      children: [
                        Slider(
                          value: slideVal,
                          min: 500.0,
                          max: 10000.0,
                          divisions: 19,
                          label: '₹${slideVal.toInt()}',
                          activeColor: AppTheme.accentColor,
                          onChanged: (val) {
                            setModalState(() {
                              slideVal = val;
                            });
                          },
                        ),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('₹500 (Min)', style: TextStyle(fontSize: 10, color: Colors.grey)),
                            Text('₹10,000 (Max Limit)', style: TextStyle(fontSize: 10, color: Colors.grey)),
                          ],
                        ),
                      ],
                    );
                  }
                ),
              ] else if (action.id == 'ot_log') ...[
                const Text('Hours to Submit', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                const SizedBox(height: 12),
                StatefulBuilder(
                  builder: (context, setModalState) {
                    int selectedIndex = 1;
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ChoiceChip(
                          label: const Text('1.0 Hr'),
                          selected: selectedIndex == 0,
                          onSelected: (_) => setModalState(() => selectedIndex = 0),
                        ),
                        ChoiceChip(
                          label: const Text('2.0 Hrs'),
                          selected: selectedIndex == 1,
                          onSelected: (_) => setModalState(() => selectedIndex = 1),
                        ),
                        ChoiceChip(
                          label: const Text('3.0 Hrs'),
                          selected: selectedIndex == 2,
                          onSelected: (_) => setModalState(() => selectedIndex = 2),
                        ),
                      ],
                    );
                  }
                ),
              ] else if (action.id == 'leave') ...[
                const Text('Reason for Leave', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                const SizedBox(height: 12),
                TextField(
                  style: TextStyle(color: isDark ? Colors.white : AppTheme.primaryColor),
                  decoration: InputDecoration(
                    hintText: 'Enter emergency cause, sickness, or travel info',
                    hintStyle: TextStyle(color: Colors.grey.withOpacity(0.5)),
                  ),
                ),
              ] else if (action.id == 'payslip') ...[
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.picture_as_pdf, color: Colors.red, size: 32),
                  title: Text(
                    'June_2026_Payslip.pdf',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: isDark ? Colors.white : AppTheme.primaryColor),
                  ),
                  subtitle: const Text('Size: 1.2 MB • Ready for Offline View', style: TextStyle(fontSize: 11)),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.picture_as_pdf, color: Colors.red, size: 32),
                  title: Text(
                    'May_2026_Payslip.pdf',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: isDark ? Colors.white : AppTheme.primaryColor),
                  ),
                  subtitle: const Text('Size: 1.1 MB • Ready for Offline View', style: TextStyle(fontSize: 11)),
                ),
              ],
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  final notifier = ref.read(activityProvider(role).notifier);
                  String logTitle = '';
                  String logDesc = '';

                  if (action.id == 'advance') {
                    logTitle = 'Advance Requested';
                    logDesc = 'Requested an interest-free advance of ₹4,000. Payout pending approval.';
                  } else if (action.id == 'ot_log') {
                    logTitle = 'OT Hours Submitted';
                    logDesc = 'Logged overtime hours. Awaiting line-manager RFID confirmation.';
                  } else if (action.id == 'leave') {
                    logTitle = 'Leave Applied';
                    logDesc = 'Submitted casual sick leave request. Status: Under review.';
                  } else {
                    logTitle = 'Payslip Accessed';
                    logDesc = 'Downloaded June 2026 PDF Payslip to device offline storage.';
                  }

                  await notifier.logNewActivity(
                    title: logTitle,
                    type: action.id == 'ot_log' ? 'ot' : 'general',
                    description: logDesc,
                  );

                  Navigator.pop(context);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          const Icon(Icons.check_circle, color: Colors.white),
                          const SizedBox(width: 8),
                          Text('${action.label} processed in local SQLite database!'),
                        ],
                      ),
                      backgroundColor: const Color(0xFF10B981),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(action.id == 'payslip' ? 'DOWNLOAD ALL' : 'SUBMIT REQUEST'),
              ),
            ],
          ),
        );
      },
    );
  }
}
