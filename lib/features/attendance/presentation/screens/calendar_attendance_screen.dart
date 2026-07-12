import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/providers/app_state_providers.dart';
import '../../../dashboard/providers/role_provider.dart';
import '../../../attendance/providers/attendance_provider.dart';

class CalendarAttendanceScreen extends ConsumerStatefulWidget {
  const CalendarAttendanceScreen({super.key});

  @override
  ConsumerState<CalendarAttendanceScreen> createState() => _CalendarAttendanceScreenState();
}

class _CalendarAttendanceScreenState extends ConsumerState<CalendarAttendanceScreen> {
  final DateTime _selectedMonth = DateTime(2026, 7); // July 2026

  @override
  Widget build(BuildContext context) {
    final activeRole = ref.watch(activeRoleProvider);
    final activeRoleStr = activeRole.toString().split('.').last;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final attendanceState = ref.watch(attendanceProvider(activeRole));
    final holidayState = ref.watch(holidayProvider);
    final leavesState = ref.watch(leaveProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('ATTENDANCE CALENDAR'),
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
                // 1. Month Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      DateFormat('MMMM yyyy').format(_selectedMonth).toUpperCase(),
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981).withOpacity(0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'July Ledger Open',
                        style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: const Color(0xFF10B981)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // 2. Calendar Grid
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E293B) : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                    ),
                  ),
                  child: Column(
                    children: [
                      // Weekday Names Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: ['M', 'T', 'W', 'T', 'F', 'S', 'S'].map((day) {
                          return Expanded(
                            child: Center(
                              child: Text(
                                day,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 12),
                      const Divider(),
                      const SizedBox(height: 12),

                      // Monthly Grid (July 2026 starts on Wednesday, so 2 empty spaces)
                      attendanceState.when(
                        data: (attendanceLogs) {
                          final Map<int, String> dayStatuses = {};

                          // Map logs to day
                          for (final log in attendanceLogs) {
                            try {
                              final dt = DateTime.parse(log.date);
                              if (dt.month == 7 && dt.year == 2026) {
                                dayStatuses[dt.day] = 'Present';
                              }
                            } catch (_) {}
                          }

                          // Map holidays to status
                          holidayState.maybeWhen(
                            data: (holidays) {
                              for (final hol in holidays) {
                                try {
                                  final dt = DateTime.parse(hol.date);
                                  if (dt.month == 7 && dt.year == 2026) {
                                    dayStatuses[dt.day] = 'Holiday';
                                  }
                                } catch (_) {}
                              }
                            },
                            orElse: () {},
                          );

                          // Map leaves to status
                          leavesState.maybeWhen(
                            data: (leaves) {
                              final myLeaves = leaves.where((l) => l.employeeId == 'emp_$activeRoleStr' && l.status == 'Approved');
                              for (final lv in myLeaves) {
                                try {
                                  final start = DateTime.parse(lv.startDate);
                                  final end = DateTime.parse(lv.endDate);
                                  for (int day = start.day; day <= end.day; day++) {
                                    dayStatuses[day] = 'Leave';
                                  }
                                } catch (_) {}
                              }
                            },
                            orElse: () {},
                          );

                          // Build grid days
                          final List<Widget> dayWidgets = [];

                          // 2 empty placeholders for July 2026 (Wednesday start)
                          dayWidgets.add(Expanded(child: Container()));
                          dayWidgets.add(Expanded(child: Container()));

                          for (int day = 1; day <= 31; day++) {
                            final status = dayStatuses[day] ?? 'Absent';
                            Color statusColor = Colors.transparent;
                            Color textColor = isDark ? Colors.white : Colors.black;
                            BoxDecoration decoration = const BoxDecoration();

                            if (status == 'Present') {
                              statusColor = const Color(0xFF10B981);
                              textColor = Colors.white;
                              decoration = const BoxDecoration(
                                color: const Color(0xFF10B981),
                                shape: BoxShape.circle,
                              );
                            } else if (status == 'Holiday') {
                              statusColor = Colors.blue;
                              textColor = Colors.white;
                              decoration = const BoxDecoration(
                                color: Colors.blue,
                                shape: BoxShape.circle,
                              );
                            } else if (status == 'Leave') {
                              statusColor = Colors.orange;
                              textColor = Colors.white;
                              decoration = const BoxDecoration(
                                color: Colors.orange,
                                shape: BoxShape.circle,
                              );
                            } else {
                              // Sabbatical / Weekend or Unmarked
                              if (day % 7 == 4 || day % 7 == 5) {
                                // Weekend (Saturday or Sunday)
                                statusColor = Colors.grey.withOpacity(0.12);
                                decoration = BoxDecoration(
                                  color: Colors.grey.withOpacity(0.15),
                                  shape: BoxShape.circle,
                                );
                              }
                            }

                            dayWidgets.add(
                              Expanded(
                                child: AspectRatio(
                                  aspectRatio: 1,
                                  child: Container(
                                    margin: const EdgeInsets.all(4),
                                    decoration: decoration,
                                    child: Center(
                                      child: Text(
                                        '$day',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                          color: textColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );

                            if (dayWidgets.length == 7) {
                              // Completed week, output row
                              final row = Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: List.from(dayWidgets),
                              );
                              dayWidgets.clear();
                              // Add spacing and the row
                              // (In real layout, we need to wrap row or lists)
                            }
                          }

                          // Layout the rows of the calendar grid
                          final List<Widget> finalWeeks = [];
                          List<Widget> currentWeek = [];

                          // July 2026 layout helper
                          // Placeholder offsets (Wednesday start)
                          currentWeek.add(Expanded(child: Container()));
                          currentWeek.add(Expanded(child: Container()));

                          for (int day = 1; day <= 31; day++) {
                            final status = dayStatuses[day];
                            Color statusColor = Colors.transparent;
                            Color textColor = isDark ? Colors.white : Colors.black;
                            BoxDecoration decoration = const BoxDecoration();

                            if (status == 'Present') {
                              decoration = BoxDecoration(
                                color: const Color(0xFF10B981),
                                shape: BoxShape.circle,
                              );
                              textColor = Colors.white;
                            } else if (status == 'Holiday') {
                              decoration = BoxDecoration(
                                color: Colors.blue.shade500,
                                shape: BoxShape.circle,
                              );
                              textColor = Colors.white;
                            } else if (status == 'Leave') {
                              decoration = BoxDecoration(
                                color: Colors.orange.shade500,
                                shape: BoxShape.circle,
                              );
                              textColor = Colors.white;
                            } else {
                              // Absent or Sabbatical
                              final dt = DateTime(2026, 7, day);
                              final isWeekend = dt.weekday == DateTime.saturday || dt.weekday == DateTime.sunday;
                              if (isWeekend) {
                                decoration = BoxDecoration(
                                  color: isDark ? const Color(0xFF0F172A) : Colors.grey.shade100,
                                  shape: BoxShape.circle,
                                );
                                textColor = Colors.grey;
                              } else {
                                decoration = BoxDecoration(
                                  border: Border.all(color: Colors.red.withOpacity(0.3)),
                                  shape: BoxShape.circle,
                                );
                                textColor = Colors.red;
                              }
                            }

                            currentWeek.add(
                              Expanded(
                                child: AspectRatio(
                                  aspectRatio: 1,
                                  child: Container(
                                    margin: const EdgeInsets.all(4),
                                    decoration: decoration,
                                    child: Center(
                                      child: Text(
                                        '$day',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                          color: textColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );

                            if (currentWeek.length == 7) {
                              finalWeeks.add(Row(children: List.from(currentWeek)));
                              currentWeek.clear();
                            }
                          }

                          if (currentWeek.isNotEmpty) {
                            while (currentWeek.length < 7) {
                              currentWeek.add(Expanded(child: Container()));
                            }
                            finalWeeks.add(Row(children: List.from(currentWeek)));
                          }

                          return Column(children: finalWeeks);
                        },
                        loading: () => const Center(child: CircularProgressIndicator()),
                        error: (err, __) => Text('Error loading calendar: $err'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // 3. Status Legend
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF0F172A) : Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildLegendItem('Present', const Color(0xFF10B981)),
                      _buildLegendItem('Absent', Colors.red),
                      _buildLegendItem('Leave', Colors.orange),
                      _buildLegendItem('Holiday', Colors.blue),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // 4. Upcoming Public Holidays list
                const Text(
                  'JULY HOLIDAYS & PUBLIC TIME-OFF',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.0, color: Colors.grey),
                ),
                const SizedBox(height: 10),
                holidayState.when(
                  data: (holidays) {
                    final julyHols = holidays.where((h) => h.date.startsWith('2026-07') || h.date.contains('-07-')).toList();
                    if (julyHols.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 24),
                        child: Center(
                          child: Text('No custom holidays set in July.', style: TextStyle(color: Colors.grey, fontSize: 12)),
                        ),
                      );
                    }

                    return ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: julyHols.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final hol = julyHols[index];
                        final parsedDate = DateTime.tryParse(hol.date) ?? DateTime.now();
                        final formattedDate = DateFormat('dd MMMM (EEEE)').format(parsedDate);

                        return Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF1E293B) : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isDark ? const Color(0xFF334155) : Colors.grey.shade200,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    hol.name,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    formattedDate,
                                    style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                                  ),
                                ],
                              ),
                              if (hol.isPaid)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.withOpacity(0.12),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Text(
                                    'Paid Off',
                                    style: TextStyle(fontSize: 8, color: Colors.blue, fontWeight: FontWeight.bold),
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, __) => Text('Error: $e'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey),
        ),
      ],
    );
  }
}
