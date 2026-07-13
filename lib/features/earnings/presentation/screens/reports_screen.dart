import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../core/theme/app_theme.dart';

class ReportsScreen extends ConsumerStatefulWidget {
  const ReportsScreen({super.key});

  @override
  ConsumerState<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends ConsumerState<ReportsScreen> {
  bool _isGeneratingReport = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark ? Colors.white : AppTheme.primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: const Text('AUDITED STATS & REPORTS'),
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
                // 1. Core Summary Metrics Cards
                Row(
                  children: [
                    Expanded(
                      child: _buildMetricCard(
                        'ATTENDANCE RATIO',
                        '96.2%',
                        'Excellent (Target > 92%)',
                        Icons.check_circle_outline,
                        const Color(0xFF10B981),
                        isDark,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildMetricCard(
                        'TOTAL HOURS LOGGED',
                        '174.5 Hrs',
                        'Including 16.5h Overtime',
                        Icons.av_timer_outlined,
                        Colors.blue,
                        isDark,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // 2. Beautiful Monthly Shift Calendar Overview
                const Text(
                  'MONTHLY SHIFT CALENDAR (JULY 2026)',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.0, color: Colors.grey),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E293B) : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                    ),
                  ),
                  child: Column(
                    children: [
                      // Calendar days header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: ['M', 'T', 'W', 'T', 'F', 'S', 'S']
                            .map((day) => Expanded(
                                  child: Center(
                                    child: Text(
                                      day,
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Colors.grey),
                                    ),
                                  ),
                                ))
                            .toList(),
                      ),
                      const SizedBox(height: 10),
                      // Mock visual Grid of calendar days
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 7,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                        ),
                        itemCount: 31,
                        itemBuilder: (context, index) {
                          final day = index + 1;
                          // Code for day states: 0=Future, 1=Attended, 2=Absent/Hold, 3=Leave, 4=Sunday/Holiday
                          int dayState = 1; // Attended default
                          if (day > 12) {
                            dayState = 0; // Future
                          } else if (day == 5 || day == 12) {
                            dayState = 4; // Sunday/Holiday
                          } else if (day == 8) {
                            dayState = 3; // Leave
                          } else if (day == 11) {
                            dayState = 2; // Absent/Late
                          }

                          Color boxColor = Colors.transparent;
                          Color textColor = primaryColor;
                          Border? border;

                          switch (dayState) {
                            case 0: // Future
                              boxColor = Colors.transparent;
                              border = Border.all(color: isDark ? const Color(0xFF334155) : Colors.grey.shade200);
                              textColor = Colors.grey;
                              break;
                            case 1: // Attended
                              boxColor = const Color(0xFF10B981).withOpacity(0.15);
                              border = Border.all(color: const Color(0xFF10B981).withOpacity(0.3));
                              textColor = const Color(0xFF10B981);
                              break;
                            case 2: // Absent
                              boxColor = Colors.red.withOpacity(0.12);
                              border = Border.all(color: Colors.red.withOpacity(0.3));
                              textColor = Colors.red;
                              break;
                            case 3: // Leave
                              boxColor = Colors.amber.withOpacity(0.15);
                              border = Border.all(color: Colors.amber.withOpacity(0.3));
                              textColor = Colors.amber.shade700;
                              break;
                            case 4: // Weekend
                              boxColor = isDark ? const Color(0xFF0F172A) : Colors.grey.shade100;
                              textColor = Colors.grey;
                              break;
                          }

                          return Container(
                            decoration: BoxDecoration(
                              color: boxColor,
                              border: border,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(
                                '$day',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
                                  color: textColor,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      const Divider(),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildLegendDot('Present', const Color(0xFF10B981)),
                          _buildLegendDot('Leave', Colors.amber),
                          _buildLegendDot('Absent', Colors.red),
                          _buildLegendDot('Holiday', Colors.grey),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // 3. Weekly Hours Worked Chart using FL Chart
                const Text(
                  'WEEKLY HOURS WORKED (LAST 4 WEEKS)',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.0, color: Colors.grey),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E293B) : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Weekly Target: 40.0 Hrs',
                            style: TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Avg: 43.6h / Week',
                            style: TextStyle(fontSize: 11, color: Colors.blue.shade500, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        height: 140,
                        child: BarChart(
                          BarChartData(
                            alignment: BarChartAlignment.spaceAround,
                            maxY: 55,
                            barTouchData: BarTouchData(enabled: false),
                            titlesData: FlTitlesData(
                              show: true,
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (value, meta) {
                                    final labels = ['Wk 1', 'Wk 2', 'Wk 3', 'Wk 4'];
                                    if (value >= 0 && value < labels.length) {
                                      return Text(
                                        labels[value.toInt()],
                                        style: TextStyle(color: Colors.grey.shade500, fontSize: 9, fontWeight: FontWeight.bold),
                                      );
                                    }
                                    return const SizedBox();
                                  },
                                ),
                              ),
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 24,
                                  getTitlesWidget: (value, meta) {
                                    if (value == 0 || value == 40 || value == 50) {
                                      return Text(
                                        '${value.toInt()}h',
                                        style: TextStyle(color: Colors.grey.shade500, fontSize: 9, fontWeight: FontWeight.bold),
                                      );
                                    }
                                    return const SizedBox();
                                  },
                                ),
                              ),
                              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            ),
                            gridData: const FlGridData(show: false),
                            borderData: FlBorderData(show: false),
                            barGroups: [
                              BarChartGroupData(
                                x: 0,
                                barRods: [BarChartRodData(toY: 42.5, color: const Color(0xFF10B981), width: 18, borderRadius: BorderRadius.circular(4))],
                              ),
                              BarChartGroupData(
                                x: 1,
                                barRods: [BarChartRodData(toY: 39.0, color: Colors.blue, width: 18, borderRadius: BorderRadius.circular(4))],
                              ),
                              BarChartGroupData(
                                x: 2,
                                barRods: [BarChartRodData(toY: 48.0, color: Colors.purple, width: 18, borderRadius: BorderRadius.circular(4))],
                              ),
                              BarChartGroupData(
                                x: 3,
                                barRods: [BarChartRodData(toY: 45.0, color: const Color(0xFF10B981), width: 18, borderRadius: BorderRadius.circular(4))],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // 4. Export Print-ready PDF report button
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E293B) : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Compile Ledger & Attendance Record',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Generates a comprehensive PDF file summarizing your hours worked, overtime authorizations, base wage accruals, and PF logs for the current quarter.',
                        style: TextStyle(fontSize: 11, color: Colors.grey.shade500, height: 1.4),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: _isGeneratingReport
                                  ? null
                                  : () {
                                      _simulateReportGeneration(context);
                                    },
                              icon: _isGeneratingReport
                                  ? const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.amber),
                                    )
                                  : const Icon(Icons.picture_as_pdf_outlined, size: 16),
                              label: Text(_isGeneratingReport ? 'COMPILING LEDGER...' : 'EXPORT PRINT-READY REPORT'),
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: AppTheme.accentColor),
                                foregroundColor: AppTheme.accentColor,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMetricCard(String title, String val, String subtitle, IconData icon, Color color, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? const Color(0xFF334155) : Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontSize: 9, color: Colors.grey, fontWeight: FontWeight.bold)),
              Icon(icon, color: color, size: 16),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            val,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Space Grotesk'),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendDot(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color.withOpacity(0.25), shape: BoxShape.circle, border: Border.all(color: color, width: 1)),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(fontSize: 9, color: Colors.grey, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Future<void> _simulateReportGeneration(BuildContext context) async {
    setState(() {
      _isGeneratingReport = true;
    });

    await Future.delayed(const Duration(milliseconds: 1500));

    setState(() {
      _isGeneratingReport = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 8),
            Text('Ledger Report (Q2_2026_ledger.pdf) compiled successfully!'),
          ],
        ),
        backgroundColor: const Color(0xFF10B981),
      ),
    );
  }
}
