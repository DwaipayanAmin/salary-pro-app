import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/role_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeRole = ref.watch(activeRoleProvider);
    final activeConfig = ROLE_CONFIGS[activeRole]!;
    final activityState = ref.watch(activityProvider(activeRole));
    final themeMode = ref.watch(themeModeProvider);

    final currencyFormat = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.accentColor.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(activeConfig.icon, color: AppTheme.accentColor, size: 24),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Shramik Hub', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                Text(activeConfig.title, style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6))),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(themeMode == ThemeMode.light ? Icons.dark_mode_outlined : Icons.light_mode_outlined),
            onPressed: () {
              ref.read(themeModeProvider.notifier).state =
                  themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Role Selector Banner
              const Text(
                'ACTIVE WORK ROLE',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.0, color: Colors.grey),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 48,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: UserRole.values.length,
                  separatorBuilder: (context, index) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final role = UserRole.values[index];
                    final config = ROLE_CONFIGS[role]!;
                    final isSelected = role == activeRole;

                    return ChoiceChip(
                      label: Row(
                        children: [
                          Icon(config.icon, size: 16, color: isSelected ? Colors.white : Colors.grey),
                          const SizedBox(width: 6),
                          Text(config.title),
                        ],
                      ),
                      selected: isSelected,
                      selectedColor: Theme.of(context).primaryColor,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : Theme.of(context).colorScheme.onSurface,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                      onSelected: (selected) {
                        if (selected) {
                          ref.read(activeRoleProvider.notifier).state = role;
                        }
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),

              // 2. Main Stats Cards (Bento style)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('ACCUMULATED WAGE SUMMARY', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: activeConfig.pfApplicable ? Colors.green.withOpacity(0.1) : Colors.amber.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              activeConfig.pfApplicable ? 'PF Eligible' : 'Gig Wage',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: activeConfig.pfApplicable ? Colors.green : Colors.amber,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            activeConfig.baseSalary > 0
                                ? currencyFormat.format(activeConfig.baseSalary)
                                : 'Daily Settled',
                            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, letterSpacing: -1),
                          ),
                          Text(
                            '${currencyFormat.format(activeConfig.hourlyRate)}/hr base',
                            style: TextStyle(fontSize: 14, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Divider(),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildMiniStat('Shift Schedule', activeConfig.shiftType, Icons.schedule),
                          _buildMiniStat('Overtime rate', '${activeConfig.otMultiplier}x hourly', Icons.add_alarm_outlined),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // 3. Quick Actions
              const Text(
                'QUICK SERVICES',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.0, color: Colors.grey),
              ),
              const SizedBox(height: 12),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.5,
                ),
                itemCount: QUICK_ACTIONS.length,
                itemBuilder: (context, index) {
                  final action = QUICK_ACTIONS[index];
                  return InkWell(
                    onTap: () => _showActionBottomSheet(context, action, ref, activeRole),
                    borderRadius: BorderRadius.circular(16),
                    child: Ink(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: action.gradientColors,
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(action.icon, color: Colors.white, size: 28),
                            Text(
                              action.label,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),

              // 4. Benefits Checklist
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.stars_outlined, color: AppTheme.accentColor),
                          const SizedBox(width: 8),
                          const Text('Role Benefits & Coverages', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ...activeConfig.benefits.map((benefit) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6.0),
                            child: Row(
                              children: [
                                const Icon(Icons.check_circle_outline, color: Colors.emerald, size: 18),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    benefit,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ),
                              ],
                            ),
                          )),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // 5. Recent Logs
              const Text(
                'RECENT SYSTEM LOGS',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.0, color: Colors.grey),
              ),
              const SizedBox(height: 12),
              activityState.when(
                data: (logs) {
                  if (logs.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Text('No recent activity recorded.', style: TextStyle(color: Colors.grey)),
                    );
                  }
                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: logs.length > 5 ? 5 : logs.length,
                    separatorBuilder: (context, index) => const Divider(),
                    itemBuilder: (context, index) {
                      final log = logs[index];
                      IconData logIcon = Icons.info_outline;
                      Color logColor = Colors.blue;

                      if (log.type == 'attendance') {
                        logIcon = Icons.touch_app_outlined;
                        logColor = Colors.emerald;
                      } else if (log.type == 'salary') {
                        logIcon = Icons.currency_rupee;
                        logColor = Colors.amber;
                      } else if (log.type == 'ot') {
                        logIcon = Icons.add_alarm_outlined;
                        logColor = Colors.purple;
                      }

                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: logColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(logIcon, color: logColor, size: 20),
                        ),
                        title: Text(log.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        subtitle: Text(log.description, style: const TextStyle(fontSize: 12)),
                        trailing: Text(
                          _formatRelativeTime(log.timestamp),
                          style: const TextStyle(fontSize: 10, color: Colors.grey),
                        ),
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) => Text('Database Error: $err'),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMiniStat(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
            Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
          ],
        ),
      ],
    );
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
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
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
              const SizedBox(height: 12),
              Text(
                action.dialogDescription,
                style: const TextStyle(fontSize: 14, color: Colors.grey, height: 1.4),
              ),
              const SizedBox(height: 24),
              if (action.id == 'advance') ...[
                const Text('Advance Amount Request (₹)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                const SizedBox(height: 12),
                Slider(
                  value: 4000.0,
                  min: 500.0,
                  max: 10000.0,
                  divisions: 19,
                  label: '₹4,000',
                  activeColor: AppTheme.accentColor,
                  onChanged: (val) {},
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('₹500 (Min)', style: TextStyle(fontSize: 11, color: Colors.grey)),
                    Text('₹10,000 (Max - 50% Limit)', style: TextStyle(fontSize: 11, color: Colors.grey)),
                  ],
                ),
              ] else if (action.id == 'ot_log') ...[
                const Text('Hours to Submit', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ChoiceChip(label: const Text('1.0 Hr'), selected: false, onSelected: (_) {}),
                    ChoiceChip(label: const Text('2.0 Hrs'), selected: true, onSelected: (_) {}),
                    ChoiceChip(label: const Text('3.0 Hrs'), selected: false, onSelected: (_) {}),
                  ],
                ),
              ] else if (action.id == 'leave') ...[
                const Text('Reason for Leave', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                const SizedBox(height: 12),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Enter emergency cause, sickness, or travel info',
                    hintStyle: TextStyle(color: Colors.grey.withOpacity(0.6)),
                  ),
                ),
              ] else if (action.id == 'payslip') ...[
                const ListTile(
                  leading: Icon(Icons.picture_as_pdf, color: Colors.red),
                  title: Text('June_2026_Payslip.pdf'),
                  subtitle: Text('Size: 1.2 MB • Ready for Offline View'),
                ),
                const ListTile(
                  leading: Icon(Icons.picture_as_pdf, color: Colors.red),
                  title: Text('May_2026_Payslip.pdf'),
                  subtitle: Text('Size: 1.1 MB • Ready for Offline View'),
                ),
              ],
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  // Save simulated request to SQLite activities
                  final notifier = ref.read(activityProvider(role).notifier);
                  String logTitle = '';
                  String logDesc = '';

                  if (action.id == 'advance') {
                    logTitle = 'Advance Requested';
                    logDesc = 'Requested an interest-free advance of ₹4,000. Payout pending approval.';
                  } else if (action.id == 'ot_log') {
                    logTitle = 'OT Hours Submitted';
                    logDesc = 'Logged 2.0 extra overtime hours. Awaiting manager RFID audit confirmation.';
                  } else if (action.id == 'leave') {
                    logTitle = 'Leave Applied';
                    logDesc = 'Submitted casual sick leave request. Status: Under review.';
                  } else {
                    logTitle = 'Payslip Accessed';
                    logDesc = 'Downloaded June 2026 PDF Payslip to device offline storage.';
                  }

                  await notifier.logNewActivity(
                    title: logTitle,
                    type: 'general',
                    description: logDesc,
                  );

                  Navigator.pop(context);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          const Icon(Icons.check_circle_outline, color: Colors.white),
                          const SizedBox(width: 8),
                          Text('${action.label} logged successfully in local database!'),
                        ],
                      ),
                      backgroundColor: Colors.emerald,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
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
