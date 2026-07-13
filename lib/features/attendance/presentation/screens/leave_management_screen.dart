import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/providers/app_state_providers.dart';
import '../../../dashboard/providers/role_provider.dart';

class LeaveManagementScreen extends ConsumerStatefulWidget {
  const LeaveManagementScreen({super.key});

  @override
  ConsumerState<LeaveManagementScreen> createState() => _LeaveManagementScreenState();
}

class _LeaveManagementScreenState extends ConsumerState<LeaveManagementScreen> {
  final _reasonController = TextEditingController();
  String _selectedLeaveType = 'Casual';
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final activeRole = ref.watch(activeRoleProvider);
    final activeRoleStr = activeRole.toString().split('.').last;
    final leavesState = ref.watch(leaveProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('LEAVE MANAGEMENT'),
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Leave Balance Cards
                const Text(
                  'ANNUAL TIME-OFF BALANCES',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.0, color: Colors.grey),
                ),
                const SizedBox(height: 10),
                leavesState.when(
                  data: (leaves) {
                    final empLeaves = leaves.where((l) => l.employeeId == 'emp_$activeRoleStr' && l.status == 'Approved');
                    final casualApproved = empLeaves.where((l) => l.leaveType == 'Casual').length;
                    final sickApproved = empLeaves.where((l) => l.leaveType == 'Sick').length;

                    return Row(
                      children: [
                        Expanded(
                          child: _buildBalanceCard(
                            'Casual Leave',
                            '${15 - casualApproved} / 15',
                            'Days Left',
                            Colors.blue,
                            isDark,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildBalanceCard(
                            'Sick Leave',
                            '${10 - sickApproved} / 10',
                            'Days Left',
                            Colors.orange,
                            isDark,
                          ),
                        ),
                      ],
                    );
                  },
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, __) => Text('Error loading balances: $e'),
                ),
                const SizedBox(height: 24),

                // 2. Form to Apply
                const Text(
                  'APPLY FOR TIME-OFF',
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DropdownButtonFormField<String>(
                        value: _selectedLeaveType,
                        decoration: const InputDecoration(labelText: 'Leave Classification'),
                        items: const [
                          DropdownMenuItem(value: 'Casual', child: Text('Casual Leave')),
                          DropdownMenuItem(value: 'Sick', child: Text('Sick Leave / Medical')),
                          DropdownMenuItem(value: 'Earned', child: Text('Earned Holiday')),
                          DropdownMenuItem(value: 'Unpaid', child: Text('Unpaid Sabbatical')),
                        ],
                        onChanged: (val) {
                          if (val != null) {
                            setState(() {
                              _selectedLeaveType = val;
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () => _selectDate(context, true),
                              child: InputDecorator(
                                decoration: const InputDecoration(labelText: 'Start Date'),
                                child: Text(DateFormat('dd MMMM yyyy').format(_startDate), style: const TextStyle(fontSize: 13)),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: InkWell(
                              onTap: () => _selectDate(context, false),
                              child: InputDecorator(
                                decoration: const InputDecoration(labelText: 'End Date'),
                                child: Text(DateFormat('dd MMMM yyyy').format(_endDate), style: const TextStyle(fontSize: 13)),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _reasonController,
                        decoration: const InputDecoration(
                          labelText: 'Reason / Explanation',
                          hintText: 'Enter specific sickness, family trip, or personal emergency info',
                        ),
                        maxLines: 2,
                      ),
                      const SizedBox(height: 18),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => _submitLeaveApplication(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.accentColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: const Text('SUBMIT LEAVE APPLICATION'),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // 3. Past Leaves History & Approval Status
                const Text(
                  'YOUR TIME-OFF SUBMISSIONS',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.0, color: Colors.grey),
                ),
                const SizedBox(height: 10),
                leavesState.when(
                  data: (leaves) {
                    final myLeaves = leaves.where((l) => l.employeeId == 'emp_$activeRoleStr').toList();
                    if (myLeaves.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 40),
                        child: Center(
                          child: Text('No leave history registered.', style: TextStyle(color: Colors.grey)),
                        ),
                      );
                    }

                    return ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: myLeaves.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final lv = myLeaves[index];
                        final isApproved = lv.status == 'Approved';
                        final isPending = lv.status == 'Pending';

                        return Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF1E293B) : Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: isDark ? const Color(0xFF334155) : Colors.grey.shade200,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: lv.leaveType == 'Sick' ? Colors.orange.withOpacity(0.12) : Colors.blue.withOpacity(0.12),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          '${lv.leaveType} Leave',
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            color: lv.leaveType == 'Sick' ? Colors.orange : Colors.blue,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        '${lv.startDate} to ${lv.endDate}',
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: isApproved
                                          ? const Color(0xFF10B981).withOpacity(0.12)
                                          : (isPending ? Colors.amber.withOpacity(0.12) : Colors.red.withOpacity(0.12)),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      lv.status,
                                      style: TextStyle(
                                        fontSize: 9,
                                        fontWeight: FontWeight.bold,
                                        color: isApproved ? const Color(0xFF10B981) : (isPending ? Colors.amber : Colors.red),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              if (lv.reason != null && lv.reason!.isNotEmpty) ...[
                                const SizedBox(height: 8),
                                Text(
                                  '"${lv.reason}"',
                                  style: TextStyle(fontSize: 11, fontStyle: FontStyle.italic, color: Colors.grey.shade500),
                                ),
                              ],
                              if (isPending) ...[
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: Colors.red,
                                        side: const BorderSide(color: Colors.red),
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                                      ),
                                      onPressed: () => _updateStatus(lv.id, 'Rejected'),
                                      child: const Text('Reject', style: TextStyle(fontSize: 11)),
                                    ),
                                    const SizedBox(width: 8),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFF10B981),
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                                      ),
                                      onPressed: () => _updateStatus(lv.id, 'Approved'),
                                      child: const Text('Approve', style: TextStyle(fontSize: 11)),
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        );
                      },
                    );
                  },
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, __) => Text('Error loading requests: $e'),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBalanceCard(String title, String ratio, String subtitle, Color color, bool isDark) {
    return Container(
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
          Text(title, style: const TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Text(
            ratio,
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              fontFamily: 'Space Grotesk',
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(subtitle, style: const TextStyle(fontSize: 10, color: Colors.grey)),
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isStart ? _startDate : _endDate,
      firstDate: DateTime(2026),
      lastDate: DateTime(2027),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
          if (_endDate.isBefore(_startDate)) {
            _endDate = _startDate;
          }
        } else {
          _endDate = picked;
          if (_endDate.isBefore(_startDate)) {
            _startDate = _endDate;
          }
        }
      });
    }
  }

  void _submitLeaveApplication(BuildContext context) async {
    if (_reasonController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid reason for the leave.'), backgroundColor: Colors.red),
      );
      return;
    }

    final activeRole = ref.read(activeRoleProvider);
    final activeRoleStr = activeRole.toString().split('.').last;
    final now = DateTime.now();

    final leaveRequest = LeaveModel(
      id: 'leave_${DateTime.now().millisecondsSinceEpoch}',
      employeeId: 'emp_$activeRoleStr',
      leaveType: _selectedLeaveType,
      startDate: DateFormat('yyyy-MM-dd').format(_startDate),
      endDate: DateFormat('yyyy-MM-dd').format(_endDate),
      reason: _reasonController.text.trim(),
      status: 'Pending',
      appliedDate: DateFormat('yyyy-MM-dd').format(now),
    );

    await ref.read(leaveProvider.notifier).applyLeave(leaveRequest);
    _reasonController.clear();

    await ref.read(activityProvider(activeRole).notifier).logNewActivity(
          title: 'Applied for ${_selectedLeaveType} Leave',
          type: 'attendance',
          description: 'Awaiting line-manager approval for dates: ${leaveRequest.startDate} to ${leaveRequest.endDate}',
        );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Leave application registered offline. Pending approval.'), backgroundColor: Colors.amber),
    );
  }

  void _updateStatus(String id, String status) async {
    await ref.read(leaveProvider.notifier).updateLeaveStatus(id, status);
    ref.invalidate(salaryCalculatorProvider); // Force re-evaluating salary calculations
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Leave status updated to $status.'), backgroundColor: status == 'Approved' ? const Color(0xFF10B981) : Colors.redAccent),
    );
  }
}
