import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_theme.dart';
import '../../dashboard/providers/role_provider.dart';
import '../providers/earnings_provider.dart';

class EarningsScreen extends ConsumerWidget {
  const EarningsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeRole = ref.watch(activeRoleProvider);
    final earningsState = ref.watch(earningsProvider(activeRole));
    final currencyFormat = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                const Text(
                  'EARNINGS & PAYROLL LEDGER',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.0, color: Colors.grey),
                ),
                const SizedBox(height: 16),

                earningsState.when(
                  data: (records) {
                    if (records.isEmpty) {
                      return const Center(child: Text('No earnings data logged.'));
                    }

                    // Display the most recent ledger record
                    final activeRecord = records.first;
                    final basicSalary = activeRecord.basicSalary;
                    final otHours = activeRecord.hoursOvertime;
                    final allowances = activeRecord.allowancePaid;
                    final pfDeductions = activeRecord.pfDeducted;

                    // Calculate OT pay
                    final otRate = (basicSalary / 160) * 1.5; // Mock OT hourly estimate
                    final otEarnings = otHours * otRate;
                    final grossEarnings = basicSalary + otEarnings + allowances;
                    final netSalary = grossEarnings - pfDeductions;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 1. Large Circular visual representation card of Net Wage
                        Card(
                          color: AppTheme.primaryColor,
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'NET PAYOUT ACUMULATION (${activeRecord.yearMonth})',
                                      style: TextStyle(fontSize: 11, color: Colors.white.withOpacity(0.6), fontWeight: FontWeight.bold),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.15),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Text(
                                        'Offline Audited',
                                        style: TextStyle(fontSize: 10, color: Colors.emerald, fontWeight: FontWeight.bold),
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
                                Text(
                                  'Gross: ${currencyFormat.format(grossEarnings)}  •  Withholdings: ${currencyFormat.format(pfDeductions)}',
                                  style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.7)),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // 2. Bento Grid of breakdown components
                        const Text(
                          'BREAKDOWN ANALYTICS',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.0, color: Colors.grey),
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
                                'Travel & Meal',
                                currencyFormat.format(allowances),
                                Icons.local_taxi_outlined,
                                Colors.emerald,
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
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // 3. PF / Retirement Ledger card
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.shield_outlined, color: AppTheme.accentColor),
                                    const SizedBox(width: 8),
                                    const Text('Government EPF Contribution', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                const Text(
                                  'Your employer matches your Provident Fund contribution (12%) rupee for rupee. Together with interest, this grows your emergency reserve.',
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

  Widget _buildBreakdownCard(BuildContext context, String label, String value, IconData icon, Color color) {
    return Container(
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
              Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.bold)),
              Icon(icon, color: color, size: 18),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'Space Grotesk',
            ),
          ),
        ],
      ),
    );
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
