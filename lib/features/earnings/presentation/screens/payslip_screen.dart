import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/providers/app_state_providers.dart';
import '../../../dashboard/providers/role_provider.dart';

class PayslipScreen extends ConsumerStatefulWidget {
  const PayslipScreen({super.key});

  @override
  ConsumerState<PayslipScreen> createState() => _PayslipScreenState();
}

class _PayslipScreenState extends ConsumerState<PayslipScreen> {
  bool _isDownloading = false;
  double _downloadProgress = 0.0;

  @override
  Widget build(BuildContext context) {
    final activeRole = ref.watch(activeRoleProvider);
    final activeRoleStr = activeRole.toString().split('.').last;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark ? Colors.white : AppTheme.primaryColor;
    final currencyFormat = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);

    final calculatorState = ref.watch(salaryCalculatorProvider('emp_$activeRoleStr'));

    return Scaffold(
      appBar: AppBar(
        title: const Text('DIGITAL PAYSLIPS'),
        centerTitle: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Download progress loader overlay if active
                if (_isDownloading) ...[
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E293B) : Colors.amber.shade50,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppTheme.accentColor.withOpacity(0.3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Downloading signed PDF payslip...',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                            Text(
                              '${(_downloadProgress * 100).toInt()}%',
                              style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.accentColor),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        LinearProgressIndicator(
                          value: _downloadProgress,
                          backgroundColor: Colors.grey.shade200,
                          color: AppTheme.accentColor,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],

                // 2. Active Month Payslip card with detailed expansion
                const Text(
                  'MOST RECENT PAYSLIP DETAILS',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.0, color: Colors.grey),
                ),
                const SizedBox(height: 10),
                calculatorState.when(
                  data: (calc) {
                    final double basicEarned = calc.basicEarned;
                    final double otEarned = calc.otEarnings;
                    final double allowances = calc.allowances;
                    final double bonus = calc.bonus;
                    final double gross = basicEarned + otEarned + allowances + bonus;

                    final double pf = calc.pfDeduction;
                    final double esi = calc.esiDeduction;
                    final double leaveDeductions = calc.leaveDeductions;
                    final double totalDeductions = pf + esi + leaveDeductions;

                    final double netPay = calc.netSalary;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Card(
                          clipBehavior: Clip.antiAlias,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(
                              color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                            ),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: isDark
                                    ? [const Color(0xFF1E293B), const Color(0xFF0F172A)]
                                    : [Colors.white, const Color(0xFFF8FAFC)],
                              ),
                            ),
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${calc.yearMonth} Payslip',
                                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                        ),
                                        Text(
                                          'Employee: ${calc.fullName} (${calc.roleTitle})',
                                          style: const TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        _simulateDownload(context, calc.yearMonth);
                                      },
                                      icon: Icon(Icons.download_for_offline_outlined, color: AppTheme.accentColor, size: 28),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                const Divider(),
                                const SizedBox(height: 12),
                                const Text(
                                  'EARNINGS BREAKDOWN',
                                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey),
                                ),
                                const SizedBox(height: 8),
                                _buildRowItem('Basic Base Wages Rate', currencyFormat.format(calc.baseSalary)),
                                _buildRowItem('Pro-rata Basic Earned', currencyFormat.format(basicEarned)),
                                _buildRowItem('Overtime Payout (${calc.otHours.toStringAsFixed(1)} Hrs)', currencyFormat.format(otEarned)),
                                _buildRowItem('Transport & Shift Allowance', currencyFormat.format(allowances)),
                                _buildRowItem('Quality Performance Bonus', currencyFormat.format(bonus)),
                                const SizedBox(height: 4),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Gross Earnings (A)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                                    Text(currencyFormat.format(gross), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                const Divider(),
                                const SizedBox(height: 12),
                                const Text(
                                  'DEDUCTIONS BREAKDOWN',
                                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey),
                                ),
                                const SizedBox(height: 8),
                                _buildRowItem('Employee EPF (12%)', '-${currencyFormat.format(pf)}', isDeduction: true),
                                _buildRowItem('ESIC Medical Cover (0.75%)', '-${currencyFormat.format(esi)}', isDeduction: true),
                                _buildRowItem('Sabbatical Absence (${calc.daysAbsent.toStringAsFixed(0)} Days)', '-${currencyFormat.format(leaveDeductions)}', isDeduction: true),
                                const SizedBox(height: 4),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Total Deductions (B)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.red)),
                                    Text('-${currencyFormat.format(totalDeductions)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.red)),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                const Divider(thickness: 1.5),
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'NET PAYOUT (A - B)',
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                    ),
                                    Text(
                                      currencyFormat.format(netPay),
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xFF10B981),
                                        fontFamily: 'Space Grotesk',
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        
                        // Dynamic statistics
                        const Text(
                          'ATTENDANCE METRICS FOR CURRENT MONTH',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.0, color: Colors.grey),
                        ),
                        const SizedBox(height: 10),
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _buildMetricsColumn('Present', '${calc.daysPresent.toStringAsFixed(0)} Days', const Color(0xFF10B981)),
                                _buildMetricsColumn('Absent', '${calc.daysAbsent.toStringAsFixed(0)} Days', Colors.red),
                                _buildMetricsColumn('On Leave', '${calc.daysOnLeave.toStringAsFixed(0)} Days', Colors.orange),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                  loading: () => const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 40),
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  error: (e, __) => Text('Error loading payslip: $e'),
                ),
                const SizedBox(height: 24),

                // 3. Past Payslips list
                const Text(
                  'PAST PAYROLL LEDGER ENTRIES',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.0, color: Colors.grey),
                ),
                const SizedBox(height: 10),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 2,
                  separatorBuilder: (context, index) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final periods = ['2026-06', '2026-05'];
                    final nets = [29800.0, 29200.0];
                    final refs = ['PAY-SLIP-7734', 'PAY-SLIP-6102'];

                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1E293B) : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isDark ? const Color(0xFF334155) : Colors.grey.shade200,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.blue.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.picture_as_pdf_outlined, color: Colors.redAccent, size: 20),
                              ),
                              const SizedBox(width: 14),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    periods[index],
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    refs[index],
                                    style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    currencyFormat.format(nets[index]),
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: primaryColor),
                                  ),
                                  const SizedBox(height: 2),
                                  const Text(
                                    'Audited & Signed',
                                    style: TextStyle(fontSize: 9, color: const Color(0xFF10B981), fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 10),
                              IconButton(
                                onPressed: () {
                                  _simulateDownload(context, periods[index]);
                                },
                                icon: const Icon(Icons.download_for_offline_outlined, size: 22, color: Colors.grey),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRowItem(String title, String val, {bool isDeduction = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
          ),
          Text(
            val,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isDeduction ? Colors.red.shade400 : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricsColumn(String label, String value, Color color) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Future<void> _simulateDownload(BuildContext context, String period) async {
    if (_isDownloading) return;
    setState(() {
      _isDownloading = true;
      _downloadProgress = 0.0;
    });

    for (int i = 0; i <= 10; i++) {
      await Future.delayed(const Duration(milliseconds: 150));
      setState(() {
        _downloadProgress = i / 10.0;
      });
    }

    setState(() {
      _isDownloading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 8),
            Text('Signed PDF Payslip ($period) downloaded successfully to offline storage.'),
          ],
        ),
        backgroundColor: const Color(0xFF10B981),
      ),
    );
  }
}
