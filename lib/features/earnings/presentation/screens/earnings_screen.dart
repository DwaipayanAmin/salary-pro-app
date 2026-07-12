import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/route_transitions.dart';
import '../../dashboard/providers/role_provider.dart';
import '../providers/earnings_provider.dart';
import 'overtime_screen.dart';
import 'pf_screen.dart';
import 'esi_screen.dart';
import 'payslip_screen.dart';
import 'reports_screen.dart';
import '../../../shift/presentation/screens/shift_screen.dart';

class EarningsScreen extends ConsumerWidget {
  const EarningsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeRole = ref.watch(activeRoleProvider);
    final earningsState = ref.watch(earningsProvider(activeRole));
    final currencyFormat = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final activeRoleStr = activeRole.toString().split('.').last;
    final calculatorState = ref.watch(salaryCalculatorProvider('emp_$activeRoleStr'));

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                const Text(
                  'EARNINGS & PAYROLL LEDGER',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.0, color: Colors.grey),
                ),
                const SizedBox(height: 16),

                // 1. Premium Horizontal Quick Ledger Actions bar
                SizedBox(
                  height: 40,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    children: [
                      _buildQuickBadge(context, 'Payslips', Icons.receipt_long_outlined, Colors.blue, isDark, () {
                        Navigator.push(context, createPremiumRoute(const PayslipScreen()));
                      }),
                      const SizedBox(width: 10),
                      _buildQuickBadge(context, 'Shift Roster', Icons.schedule_outlined, Colors.purple, isDark, () {
                        Navigator.push(context, createPremiumRoute(const ShiftScreen()));
                      }),
                      const SizedBox(width: 10),
                      _buildQuickBadge(context, 'Stats Reports', Icons.analytics_outlined, Colors.orange, isDark, () {
                        Navigator.push(context, createPremiumRoute(const ReportsScreen()));
                      }),
                      const SizedBox(width: 10),
                      _buildQuickBadge(context, 'ESI Scheme', Icons.health_and_safety_outlined, Colors.emerald, isDark, () {
                        Navigator.push(context, createPremiumRoute(const EsiScreen()));
                      }),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                calculatorState.when(
                  data: (calc) {
                    final basicSalary = calc.basicEarned;
                    final otEarnings = calc.otEarnings;
                    final allowances = calc.allowances;
                    final bonus = calc.bonus;
                    final pfDeductions = calc.pfDeduction;

                    final grossEarnings = basicSalary + otEarnings + allowances + bonus;
                    final netSalary = calc.netSalary;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 2. Large visual representation card of Net Wage
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppTheme.primaryColor,
                                const Color(0xFF2E3E56),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: AppTheme.accentColor.withOpacity(0.4),
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.accentColor.withOpacity(0.08),
                                blurRadius: 16,
                                spreadRadius: 2,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'NET PAYOUT ACCUMULATION (${calc.yearMonth})',
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.white.withOpacity(0.65),
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 0.8,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.emerald.withOpacity(0.18),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: const Text(
                                        'Offline Audited',
                                        style: TextStyle(
                                          fontSize: 9,
                                          color: Colors.emerald,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 24),
                                Text(
                                  currencyFormat.format(netSalary),
                                  style: const TextStyle(
                                    fontFamily: 'Space Grotesk',
                                    fontSize: 44,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    letterSpacing: -1,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.08),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    'Gross: ${currencyFormat.format(grossEarnings)}  •  Withholdings: ${currencyFormat.format(pfDeductions + calc.esiDeduction + calc.leaveDeductions)}',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white.withOpacity(0.85),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // 3. Bento Grid of breakdown components
                        const Text(
                          'BREAKDOWN ANALYTICS (TAP TO OPEN COVERAGE)',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.0, color: Colors.grey),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: _buildBreakdownCard(
                                context,
                                'Basic Wage',
                                currencyFormat.format(basicSalary),
                                Icons.wallet_outlined,
                                Colors.blue,
                                null, // Standard basic view
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildBreakdownCard(
                                context,
                                'Overtime Pay',
                                currencyFormat.format(otEarnings),
                                Icons.add_alarm_outlined,
                                Colors.purple,
                                () {
                                  Navigator.push(context, createPremiumRoute(const OvertimeScreen()));
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: _buildBreakdownCard(
                                context,
                                'ESI Scheme Cover',
                                'Cashless Active',
                                Icons.health_and_safety_outlined,
                                Colors.emerald,
                                () {
                                  Navigator.push(context, createPremiumRoute(const EsiScreen()));
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildBreakdownCard(
                                context,
                                'Provident Fund (12%)',
                                '-${currencyFormat.format(pfDeductions)}',
                                Icons.savings_outlined,
                                Colors.red,
                                () {
                                  Navigator.push(context, createPremiumRoute(const PfScreen()));
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // 4. PF / Retirement Ledger card (Tapping opens detailed PF ledger)
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context, createPremiumRoute(const PfScreen()));
                          },
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(Icons.shield_outlined, color: AppTheme.accentColor),
                                          const SizedBox(width: 8),
                                          const Text('Government EPF Contribution', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                                        ],
                                      ),
                                      const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  const Text(
                                    'Your employer matches your Provident Fund contribution (12%) rupee for rupee. Together with interest, this grows your emergency reserve. Tap to view member ledger.',
                                    style: TextStyle(fontSize: 12, color: Colors.grey, height: 1.4),
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      _buildPFStat('Worker Share', currencyFormat.format(pfDeductions)),
                                      _buildPFStat('Employer Match', currencyFormat.format(pfDeductions)),
                                      _buildPFStat('Total Monthly EPF', currencyFormat.format(pfDeductions * 2)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (err, stack) => Text('Database Error: $err'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickBadge(BuildContext context, String label, IconData icon, Color color, bool isDark, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(isDark ? 0.12 : 0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withOpacity(isDark ? 0.3 : 0.2),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 16),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBreakdownCard(BuildContext context, String label, String value, IconData icon, Color color, VoidCallback? onTap) {
    final cardWidget = Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.1), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.bold),
                ),
              ),
              Icon(icon, color: color, size: 18),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  value,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Space Grotesk',
                  ),
                ),
              ),
              if (onTap != null)
                const Icon(Icons.arrow_forward, size: 12, color: Colors.grey),
            ],
          ),
        ],
      ),
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: cardWidget,
      );
    }
    return cardWidget;
  }

  Widget _buildPFStat(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
