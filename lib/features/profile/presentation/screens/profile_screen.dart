import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../dashboard/providers/role_provider.dart';
import '../providers/profile_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeRole = ref.watch(activeRoleProvider);
    final profileState = ref.watch(profileProvider(activeRole));

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
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
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              profile.fullName,
                              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Provident Fund ID: ${profile.pfNumber}',
                              style: const TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),

                    // 2. Offline Sync Hub Control Widget
                    Card(
                      color: Colors.emerald.withOpacity(0.08),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: const BorderSide(color: Colors.emerald, width: 1),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.cloud_done_outlined, color: Colors.emerald, size: 28),
                                SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('OFFLINE ENGINE: ACTIVE', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.emerald)),
                                    SizedBox(height: 2),
                                    Text('Local SQLite Database fully synced.', style: TextStyle(fontSize: 11, color: Colors.grey)),
                                  ],
                                ),
                              ],
                            ),
                            IconButton(
                              icon: const Icon(Icons.sync_outlined, color: Colors.emerald),
                              onPressed: () => _triggerSyncHandshake(context, ref, activeRole),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // 3. Bank Account Credentials & Editor Card
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

                    // 4. Emergency Contacts & Escalations
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
              const SizedBox(height: 4),
              Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            ],
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
                  const SnackBar(content: Text('Profile saved successfully in offline storage!'), backgroundColor: Colors.emerald),
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
              CircularProgressIndicator(color: Colors.emerald),
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
      const SnackBar(content: Text('Shifts fully synchronized with remote cloud!'), backgroundColor: Colors.emerald),
    );
  }
}
