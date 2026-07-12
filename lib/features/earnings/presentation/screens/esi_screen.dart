import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../dashboard/providers/role_provider.dart';

class EsiScreen extends ConsumerWidget {
  const EsiScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeRole = ref.watch(activeRoleProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark ? Colors.white : AppTheme.primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: const Text('ESI HEALTH SCHEME (ESIC)'),
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
                // 1. Digital ESIC Pehchan Card with QR Code
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF15803D), // Forest Green
                        const Color(0xFF166534),
                        const Color(0xFF14532D),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF15803D).withOpacity(0.25),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.12),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(Icons.medical_services_outlined, color: Colors.redAccent, size: 20),
                                ),
                                const SizedBox(width: 10),
                                const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'ESIC PEHCHAN CARD',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                        letterSpacing: 0.8,
                                      ),
                                    ),
                                    Text(
                                      'Employee State Insurance Corporation',
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 8,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.emerald.shade400.withOpacity(0.25),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.emerald.shade300, width: 0.5),
                              ),
                              child: const Text(
                                'Active',
                                style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Left: Details
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'INSURED PERSON NO (IP)',
                                    style: TextStyle(color: Colors.white60, fontSize: 8, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                                  ),
                                  const SizedBox(height: 2),
                                  const Text(
                                    '1114 9382 7701',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Space Grotesk',
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.0,
                                    ),
                                  ),
                                  const SizedBox(height: 18),
                                  const Text(
                                    'BENEFICIARY NAME',
                                    style: TextStyle(color: Colors.white60, fontSize: 8, fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    activeRole == UserRole.office ? 'Suresh Kumar' : 'Ram Singh',
                                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                                  ),
                                  const SizedBox(height: 12),
                                  const Text(
                                    'DISPENSARY CODE',
                                    style: TextStyle(color: Colors.white60, fontSize: 8, fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 2),
                                  const Text(
                                    'DL-82 / Mayur Vihar',
                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                            // Right: High Contrast QR Mockup
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    width: 72,
                                    height: 72,
                                    color: Colors.black,
                                    child: GridView.builder(
                                      physics: const NeverScrollableScrollPhysics(),
                                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 6,
                                      ),
                                      itemCount: 36,
                                      itemBuilder: (context, idx) {
                                        final isDarkSquare = (idx * 7 + 13) % 3 == 0 || idx == 0 || idx == 5 || idx == 30 || idx == 35;
                                        return Container(
                                          color: isDarkSquare ? Colors.black : Colors.white,
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  const Text(
                                    'Scan at Hospital',
                                    style: TextStyle(color: Colors.black, fontSize: 7, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // 2. Health Insurance Coverage & Benefits Grid
                const Text(
                  'ESI HEALTH PLAN BENEFITS COVERED',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.0, color: Colors.grey),
                ),
                const SizedBox(height: 10),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.8,
                  children: [
                    _buildCoverageTile(context, 'Medical Care', 'Full free cashless treatment', Icons.healing_outlined, Colors.emerald, isDark),
                    _buildCoverageTile(context, 'Sickness Benefit', '70% wage payout on leave', Icons.sick_outlined, Colors.blue, isDark),
                    _buildCoverageTile(context, 'Maternity/Family', 'Full delivery cover', Icons.child_care_outlined, Colors.pink, isDark),
                    _buildCoverageTile(context, 'Disability Care', 'Continuous pension relief', Icons.wheelchair_pickup_outlined, Colors.purple, isDark),
                  ],
                ),
                const SizedBox(height: 24),

                // 3. Network Hospital Locator Simulator
                const Text(
                  'LOCAL TIE-UP HOSPITALS & CLINICS',
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Nearest ESIC dispensaries',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                          Text(
                            'GPS: Delhi NCR',
                            style: TextStyle(color: AppTheme.accentColor, fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _buildHospitalItem(
                        'Metro ESIC Hospital',
                        'Sector 12, Noida (Cashless Tie-up)',
                        '1.8 km away • Open 24 Hrs',
                        isDark,
                      ),
                      const Divider(),
                      _buildHospitalItem(
                        'ESIC Dispensary No. 4',
                        'Mayur Vihar Ph-1, Delhi (Primary Center)',
                        '3.2 km away • Closes 06:00 PM',
                        isDark,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // 4. Claims Status Tracker
                const Text(
                  'REIMBURSEMENT & CLAIM HISTORY',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.0, color: Colors.grey),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E293B) : Colors.white,
                    borderRadius: BorderRadius.circular(14),
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
                              color: Colors.emerald.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.check_circle_outline, color: Colors.emerald, size: 16),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Medical Reimbursement Claim',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Claim No: ESIC-MC-88214 (May 2026)',
                                style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '₹4,500',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.emerald),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Approved & Paid',
                            style: TextStyle(fontSize: 9, color: Colors.grey, fontWeight: FontWeight.bold),
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

  Widget _buildCoverageTile(BuildContext context, String title, String subtitle, IconData icon, Color color, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: isDark ? const Color(0xFF334155) : Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 9, color: Colors.grey.shade500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHospitalItem(String name, String location, String distance, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                const SizedBox(height: 2),
                Text(location, style: TextStyle(color: Colors.grey.shade500, fontSize: 10)),
              ],
            ),
          ),
          Text(
            distance,
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
