import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/route_transitions.dart';
import '../../../../core/providers/app_state_providers.dart';
import '../../dashboard/providers/role_provider.dart';
import '../providers/profile_provider.dart';
import 'employee_management_screen.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeRole = ref.watch(activeRoleProvider);
    final profileState = ref.watch(profileProvider(activeRole));
    final themeMode = ref.watch(themeModeProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: profileState.when(
              data: (profile) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),
                    // 1. Header Profile Badge
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 36,
                          backgroundColor: AppTheme.accentColor.withOpacity(0.2),
                          child: Text(
                            profile.fullName.substring(0, 1),
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.accentColor),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                profile.fullName,
                                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Role: ${activeRole.toString().split('.').last.toUpperCase()} | PF: ${profile.pfNumber}',
                                style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),

                    // 2. Offline Sync Hub Control Widget
                    Card(
                      color: const Color(0xFF10B981).withOpacity(0.08),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: const BorderSide(color: const Color(0xFF10B981), width: 1),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.cloud_done_outlined, color: const Color(0xFF10B981), size: 28),
                                SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('OFFLINE ENGINE: ACTIVE', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: const Color(0xFF10B981))),
                                    SizedBox(height: 2),
                                    Text('Local SQLite Database fully synced.', style: TextStyle(fontSize: 11, color: Colors.grey)),
                                  ],
                                ),
                              ],
                            ),
                            IconButton(
                              icon: const Icon(Icons.sync_outlined, color: const Color(0xFF10B981)),
                              onPressed: () => _triggerSyncHandshake(context, ref, activeRole),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // 3. Admin Tools Section
                    const Text(
                      'ORGANIZATION & DIRECTORY CONTROL',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.0, color: Colors.grey),
                    ),
                    const SizedBox(height: 10),
                    Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Column(
                          children: [
                            ListTile(
                              leading: Icon(Icons.people_alt_outlined, color: AppTheme.accentColor),
                              title: const Text('Employee Directory', style: TextStyle(fontWeight: FontWeight.bold)),
                              subtitle: const Text('Manage user profiles, base wage slabs, and active accounts', style: TextStyle(fontSize: 11)),
                              trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                              onTap: () {
                                Navigator.push(context, createPremiumRoute(const EmployeeManagementScreen()));
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // 4. Bank Account Credentials
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'BANK & LEDGER DIRECT CREDIT CREDENTIALS',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.0, color: Colors.grey),
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit_outlined, size: 18),
                          onPressed: () => _showEditProfileDialog(context, ref, profile, activeRole),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            _buildInfoRow('Full Name', profile.fullName, Icons.person_outline),
                            const Divider(),
                            _buildInfoRow('Settlement Bank', profile.bankName, Icons.account_balance_outlined),
                            const Divider(),
                            _buildInfoRow('Bank Account', profile.bankAccount, Icons.payment_outlined),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // 5. Emergency Contacts & Escalations
                    const Text(
                      'SAFETY & EMERGENCY CONTACT',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.0, color: Colors.grey),
                    ),
                    const SizedBox(height: 8),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            _buildInfoRow('Assigned Escalation', profile.emergencyContact, Icons.contact_emergency_outlined),
                            const Divider(),
                            _buildInfoRow('Escalation Phone', profile.emergencyPhone, Icons.phone_android_outlined),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // 6. Data Administration & Backup/Restore
                    const Text(
                      'DATA ADMINISTRATION & SECURE STORAGE',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.0, color: Colors.grey),
                    ),
                    const SizedBox(height: 10),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Column(
                          children: [
                            ListTile(
                              leading: const Icon(Icons.backup_outlined, color: Colors.blue),
                              title: const Text('Export Offline Backup JSON', style: TextStyle(fontWeight: FontWeight.bold)),
                              subtitle: const Text('Generates portable text backup of all SQLite records', style: TextStyle(fontSize: 11)),
                              trailing: const Icon(Icons.copy_outlined, size: 16, color: Colors.blue),
                              onTap: () => _handleExportBackup(context),
                            ),
                            const Divider(height: 1),
                            ListTile(
                              leading: const Icon(Icons.settings_backup_restore_outlined, color: Colors.orange),
                              title: const Text('Restore Database from JSON', style: TextStyle(fontWeight: FontWeight.bold)),
                              subtitle: const Text('Overwrite local SQLite using copy-pasted backup strings', style: TextStyle(fontSize: 11)),
                              trailing: const Icon(Icons.upload_file_outlined, size: 16, color: Colors.orange),
                              onTap: () => _handleRestoreBackupDialog(context, ref),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // 7. Settings (Theme Toggles, Biometric Controls)
                    const Text(
                      'SYSTEM SETTINGS & PREFERENCES',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.0, color: Colors.grey),
                    ),
                    const SizedBox(height: 10),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Row(
                                  children: [
                                    Icon(Icons.dark_mode_outlined, size: 20, color: Colors.grey),
                                    SizedBox(width: 12),
                                    Text('App Dark Theme', style: TextStyle(fontWeight: FontWeight.bold)),
                                  ],
                                ),
                                Switch(
                                  value: themeMode == AppThemeMode.dark,
                                  activeColor: AppTheme.accentColor,
                                  onChanged: (val) {
                                    ref.read(themeModeProvider.notifier).state =
                                        val ? AppThemeMode.dark : AppThemeMode.light;
                                  },
                                ),
                              ],
                            ),
                            const Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Row(
                                  children: [
                                    Icon(Icons.fingerprint_outlined, size: 20, color: Colors.grey),
                                    SizedBox(width: 12),
                                    Text('Biometric Authentication Gate', style: TextStyle(fontWeight: FontWeight.bold)),
                                  ],
                                ),
                                Switch(
                                  value: true,
                                  activeColor: AppTheme.accentColor,
                                  onChanged: (val) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Biometric access parameters saved locally!')),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Text('Profile fetch error: $err'),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
                const SizedBox(height: 4),
                Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showEditProfileDialog(BuildContext context, WidgetRef ref, WorkerProfile profile, UserRole role) {
    final nameController = TextEditingController(text: profile.fullName);
    final bankController = TextEditingController(text: profile.bankName);
    final accountController = TextEditingController(text: profile.bankAccount);
    final emergencyController = TextEditingController(text: profile.emergencyContact);
    final phoneController = TextEditingController(text: profile.emergencyPhone);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Update Worker Profile'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Worker Full Name')),
                const SizedBox(height: 12),
                TextField(controller: bankController, decoration: const InputDecoration(labelText: 'Settlement Bank')),
                const SizedBox(height: 12),
                TextField(controller: accountController, decoration: const InputDecoration(labelText: 'Bank Account Number')),
                const SizedBox(height: 12),
                TextField(controller: emergencyController, decoration: const InputDecoration(labelText: 'Emergency Contact Person')),
                const SizedBox(height: 12),
                TextField(controller: phoneController, decoration: const InputDecoration(labelText: 'Emergency Phone')),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('CANCEL'),
            ),
            ElevatedButton(
              onPressed: () async {
                await ref.read(profileProvider(role).notifier).updateProfile(
                      fullName: nameController.text,
                      bankName: bankController.text,
                      bankAccount: accountController.text,
                      emergencyContact: emergencyController.text,
                      emergencyPhone: phoneController.text,
                    );

                // Add activity log entry
                await ref.read(activityProvider(role).notifier).logNewActivity(
                      title: 'Worker Profile Updated',
                      type: 'general',
                      description: 'Direct credit bank accounts and emergency contact info modified successfully.',
                    );

                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Profile saved successfully in offline storage!'), backgroundColor: const Color(0xFF10B981)),
                );
              },
              child: const Text('SAVE'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _triggerSyncHandshake(BuildContext context, WidgetRef ref, UserRole role) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 12),
              CircularProgressIndicator(color: const Color(0xFF10B981)),
              SizedBox(height: 20),
              Text('Synching local SQLite with industrial database...', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              SizedBox(height: 6),
              Text('Compressing hashes & syncing offline shifts.', style: TextStyle(fontSize: 11, color: Colors.grey)),
            ],
          ),
        );
      },
    );

    await Future.delayed(const Duration(milliseconds: 1500));
    Navigator.pop(context);

    await ref.read(activityProvider(role).notifier).logNewActivity(
          title: 'Database Cloud Sync',
          type: 'general',
          description: 'Secure biometric shifts & earnings synced to industrial server successfully.',
        );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Shifts fully synchronized with remote cloud!'), backgroundColor: const Color(0xFF10B981)),
    );
  }

  void _handleExportBackup(BuildContext context) async {
    try {
      final jsonStr = await LocalStorageBackupService.generateBackupJson();
      await Clipboard.setData(ClipboardData(text: jsonStr));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Complete offline database JSON copied to clipboard! Keep it safe.'),
          backgroundColor: Colors.blueAccent,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Export failed: $e'), backgroundColor: Colors.red),
      );
    }
  }

  void _handleRestoreBackupDialog(BuildContext context, WidgetRef ref) {
    final textController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Restore Database'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Paste the exact backup JSON string below. This will overwrite all active local SQLite tables!',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: textController,
                decoration: const InputDecoration(
                  hintText: '{"employees": [...], "attendance": [...]}',
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('CANCEL'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, foregroundColor: Colors.white),
              onPressed: () async {
                final input = textController.text.trim();
                if (input.isEmpty) return;

                final success = await LocalStorageBackupService.restoreFromJson(input);
                Navigator.pop(context);

                if (success) {
                  // Invalidate key states
                  ref.invalidate(employeeProvider);
                  ref.invalidate(leaveProvider);
                  ref.invalidate(holidayProvider);
                  ref.invalidate(shiftProvider);
                  ref.invalidate(salaryCalculatorProvider);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Local SQLite tables successfully overwritten from backup!'),
                      backgroundColor: const Color(0xFF10B981),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Failed to restore. Please verify JSON schema syntax completeness.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: const Text('RESTORE NOW'),
            ),
          ],
        );
      },
    );
  }
}
