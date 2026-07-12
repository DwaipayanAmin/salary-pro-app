import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/providers/app_state_providers.dart';
import '../../../dashboard/providers/role_provider.dart';

class EmployeeManagementScreen extends ConsumerStatefulWidget {
  const EmployeeManagementScreen({super.key});

  @override
  ConsumerState<EmployeeManagementScreen> createState() => _EmployeeManagementScreenState();
}

class _EmployeeManagementScreenState extends ConsumerState<EmployeeManagementScreen> {
  @override
  Widget build(BuildContext context) {
    final employeesState = ref.watch(employeeProvider);
    final activeRole = ref.watch(activeRoleProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('EMPLOYEE DIRECTORY'),
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddEditEmployeeDialog(context, null),
        backgroundColor: AppTheme.accentColor,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.person_add_alt_1_outlined),
        label: const Text('Add Employee'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'ACTIVE WORKFORCE DATABASE',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.0, color: Colors.grey),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: employeesState.when(
                  data: (employees) {
                    if (employees.isEmpty) {
                      return const Center(
                        child: Text('No employees found. Seed the database or add a new one.'),
                      );
                    }

                    return ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      itemCount: employees.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final emp = employees[index];
                        final isSelected = emp.role == activeRole.toString().split('.').last;

                        return Container(
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF1E293B) : Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isSelected
                                  ? AppTheme.accentColor
                                  : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                              width: isSelected ? 1.5 : 1,
                            ),
                          ),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: () {
                              // Switch active user
                              final userRole = UserRole.values.firstWhere(
                                (e) => e.toString().split('.').last == emp.role,
                                orElse: () => UserRole.factory,
                              );
                              ref.read(activeRoleProvider.notifier).state = userRole;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Switched active profile to ${emp.fullName} (${emp.role.toUpperCase()})'),
                                  backgroundColor: const Color(0xFF10B981),
                                ),
                              );
                            },
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
                                          CircleAvatar(
                                            backgroundColor: isSelected
                                                ? AppTheme.accentColor.withOpacity(0.2)
                                                : Colors.grey.withOpacity(0.1),
                                            radius: 20,
                                            child: Text(
                                              emp.fullName.substring(0, 1),
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: isSelected ? AppTheme.accentColor : Colors.grey,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                emp.fullName,
                                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                emp.shiftType,
                                                style: const TextStyle(fontSize: 11, color: Colors.grey),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      if (isSelected)
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: AppTheme.accentColor.withOpacity(0.12),
                                            borderRadius: BorderRadius.circular(20),
                                            border: Border.all(color: AppTheme.accentColor.withOpacity(0.3)),
                                          ),
                                          child: Text(
                                            'ACTIVE USER',
                                            style: TextStyle(
                                              fontSize: 9,
                                              fontWeight: FontWeight.bold,
                                              color: AppTheme.accentColor,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  const Divider(height: 1),
                                  const SizedBox(height: 12),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      _buildCompactInfo('BASE PAY', '₹${emp.baseSalary.toStringAsFixed(0)}'),
                                      _buildCompactInfo('HOURLY RATE', '₹${emp.hourlyRate.toStringAsFixed(0)}'),
                                      _buildCompactInfo('PF ACCOUNT', emp.pfNumber),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      TextButton.icon(
                                        icon: const Icon(Icons.edit_outlined, size: 14),
                                        label: const Text('Edit Profile', style: TextStyle(fontSize: 11)),
                                        onPressed: () => _showAddEditEmployeeDialog(context, emp),
                                      ),
                                      const SizedBox(width: 8),
                                      if (!isSelected)
                                        IconButton(
                                          icon: const Icon(Icons.delete_outline, color: Colors.red, size: 18),
                                          onPressed: () => _confirmDeleteEmployee(context, emp),
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (err, stack) => Center(child: Text('Error loading directory: $err')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCompactInfo(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 8, color: Colors.grey, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
        const SizedBox(height: 2),
        Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
      ],
    );
  }

  void _showAddEditEmployeeDialog(BuildContext context, EmployeeModel? employee) {
    final isEdit = employee != null;
    final idController = TextEditingController(text: isEdit ? employee.id : 'emp_${DateTime.now().millisecondsSinceEpoch}');
    final nameController = TextEditingController(text: isEdit ? employee.fullName : '');
    final pfController = TextEditingController(text: isEdit ? employee.pfNumber : 'PF-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}-AB1');
    final bankNameController = TextEditingController(text: isEdit ? employee.bankName : 'State Bank of India');
    final bankAccController = TextEditingController(text: isEdit ? employee.bankAccount : 'XXXX-XXXX-9921');
    final emergencyContactController = TextEditingController(text: isEdit ? employee.emergencyContact : 'Supervisor');
    final emergencyPhoneController = TextEditingController(text: isEdit ? employee.emergencyPhone : '+91-99999-88888');
    final salaryController = TextEditingController(text: isEdit ? employee.baseSalary.toString() : '20000');
    final hourlyController = TextEditingController(text: isEdit ? employee.hourlyRate.toString() : '100');
    final emailController = TextEditingController(text: isEdit ? employee.email ?? '' : '');
    final phoneController = TextEditingController(text: isEdit ? employee.phone ?? '' : '');
    
    String selectedRole = isEdit ? employee.role : 'factory';
    String selectedShift = isEdit ? employee.shiftType : 'General Shift (09:30 - 18:00)';
    double selectedOtMultiplier = isEdit ? employee.otMultiplier : 1.5;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(isEdit ? 'Modify Employee Profile' : 'New Employee Credentials'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Worker Full Name')),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: selectedRole,
                      decoration: const InputDecoration(labelText: 'System Access Role'),
                      items: const [
                        DropdownMenuItem(value: 'factory', child: Text('Factory Operator')),
                        DropdownMenuItem(value: 'office', child: Text('Office Executive')),
                        DropdownMenuItem(value: 'warehouse', child: Text('Warehouse Handler')),
                        DropdownMenuItem(value: 'apprentice', child: Text('Trade Apprentice')),
                        DropdownMenuItem(value: 'contract', child: Text('Contract Associate')),
                        DropdownMenuItem(value: 'qualityChecker', child: Text('Quality Checker')),
                      ],
                      onChanged: (val) {
                        if (val != null) {
                          setDialogState(() {
                            selectedRole = val;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 12),
                    TextField(controller: salaryController, decoration: const InputDecoration(labelText: 'Monthly Base Salary (₹)'), keyboardType: TextInputType.number),
                    const SizedBox(height: 12),
                    TextField(controller: hourlyController, decoration: const InputDecoration(labelText: 'Hourly Wages Rate (₹)'), keyboardType: TextInputType.number),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: selectedShift,
                      decoration: const InputDecoration(labelText: 'Shift Allocation'),
                      items: const [
                        DropdownMenuItem(value: 'Day Shift (09:00 - 17:30)', child: Text('Day Shift (09:00-17:30)')),
                        DropdownMenuItem(value: 'Night Shift (21:00 - 05:30)', child: Text('Night Shift (21:00-05:30)')),
                        DropdownMenuItem(value: 'General Shift (09:30 - 18:00)', child: Text('General Shift (09:30-18:00)')),
                        DropdownMenuItem(value: 'Flexible Hours (On-Demand)', child: Text('Flexible (On-Demand)')),
                      ],
                      onChanged: (val) {
                        if (val != null) {
                          setDialogState(() {
                            selectedShift = val;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 12),
                    TextField(controller: pfController, decoration: const InputDecoration(labelText: 'Provident Fund (PF) Account ID')),
                    const SizedBox(height: 12),
                    TextField(controller: bankNameController, decoration: const InputDecoration(labelText: 'Settlement Bank')),
                    const SizedBox(height: 12),
                    TextField(controller: bankAccController, decoration: const InputDecoration(labelText: 'Bank Account Number')),
                    const SizedBox(height: 12),
                    TextField(controller: emergencyContactController, decoration: const InputDecoration(labelText: 'Emergency Contact')),
                    const SizedBox(height: 12),
                    TextField(controller: emergencyPhoneController, decoration: const InputDecoration(labelText: 'Emergency Contact Phone')),
                    const SizedBox(height: 12),
                    TextField(controller: emailController, decoration: const InputDecoration(labelText: 'Email Address')),
                    const SizedBox(height: 12),
                    TextField(controller: phoneController, decoration: const InputDecoration(labelText: 'Mobile Phone')),
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
                    if (nameController.text.trim().isEmpty) return;

                    final empModel = EmployeeModel(
                      id: idController.text,
                      fullName: nameController.text.trim(),
                      role: selectedRole,
                      pfNumber: pfController.text.trim(),
                      bankName: bankNameController.text.trim(),
                      bankAccount: bankAccController.text.trim(),
                      emergencyContact: emergencyContactController.text.trim(),
                      emergencyPhone: emergencyPhoneController.text.trim(),
                      baseSalary: double.tryParse(salaryController.text) ?? 20000.0,
                      hourlyRate: double.tryParse(hourlyController.text) ?? 100.0,
                      shiftType: selectedShift,
                      otMultiplier: selectedOtMultiplier,
                      email: emailController.text.trim().isEmpty ? null : emailController.text.trim(),
                      phone: phoneController.text.trim().isEmpty ? null : phoneController.text.trim(),
                      status: 'active',
                    );

                    if (isEdit) {
                      await ref.read(employeeProvider.notifier).updateEmployee(empModel);
                    } else {
                      await ref.read(employeeProvider.notifier).addEmployee(empModel);
                    }

                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(isEdit ? 'Profile saved successfully!' : 'New worker registered in offline database!'),
                        backgroundColor: const Color(0xFF10B981),
                      ),
                    );
                  },
                  child: const Text('SAVE CREDENTIALS'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _confirmDeleteEmployee(BuildContext context, EmployeeModel employee) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Remove Worker Record?'),
          content: Text('Are you sure you want to permanently delete ${employee.fullName} from local SQLite archive? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('CANCEL'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
              onPressed: () async {
                await ref.read(employeeProvider.notifier).deleteEmployee(employee.id);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Employee removed successfully.'), backgroundColor: Colors.redAccent),
                );
              },
              child: const Text('DELETE'),
            ),
          ],
        );
      },
    );
  }
}
