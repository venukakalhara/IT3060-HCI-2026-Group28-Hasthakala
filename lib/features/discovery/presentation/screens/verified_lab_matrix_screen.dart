import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/constants/app_colors.dart';

/// High-Fidelity Verified Lab Matrix Screen matching Stitch Canvas specification
class VerifiedLabMatrixScreen extends StatelessWidget {
  const VerifiedLabMatrixScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Lab Report Preview',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon:
                const Icon(Icons.share_outlined, color: AppColors.textPrimary),
            onPressed: () async {
              await Clipboard.setData(const ClipboardData(
                  text:
                      'Hasthakala lab report preview. Sample data only; no product certificate is available.'));
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Preview note copied')),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
                'Sample report layout. These are not verified results for a selected product.',
                style: TextStyle(color: AppColors.textSecondary)),
            const SizedBox(height: 12),
            // Verified Header Banner
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF264E36), Color(0xFF1E3A29)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF264E36).withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.workspace_premium,
                          color: Color(0xFFC0EDCC),
                          size: 30,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'CERTIFICATE OF AUTHENTICITY',
                              style: TextStyle(
                                color: Color(0xFFC0EDCC),
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Hasthaka Heritage Lab Pass',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(color: Colors.white24, height: 24),
                  Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    spacing: 12,
                    runSpacing: 8,
                    children: const [
                      Text(
                        'Registry ID: #HK-2026-8841',
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                      Text(
                        'Verified Sep 2026',
                        style: TextStyle(
                          color: Color(0xFFC0EDCC),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Craft & Artisan Details Matrix
            const Text(
              'Provenance & Origin Verification',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                children: [
                  _buildMatrixRow(
                    icon: Icons.person_outline,
                    label: 'Master Artisan',
                    value: 'Sunil Kariyawasam',
                    badge: 'Verified Master',
                  ),
                  const Divider(height: 20),
                  _buildMatrixRow(
                    icon: Icons.location_on_outlined,
                    label: 'Geographical Origin',
                    value: 'Kelaniya Riverbank Pottery Shed',
                    badge: 'Kelaniya Guild',
                  ),
                  const Divider(height: 20),
                  _buildMatrixRow(
                    icon: Icons.category_outlined,
                    label: 'Material Composition',
                    value: '98.4% Natural Unrefined Terracotta',
                    badge: '100% Organic',
                  ),
                  const Divider(height: 20),
                  _buildMatrixRow(
                    icon: Icons.handyman_outlined,
                    label: 'Spin & Kiln Technique',
                    value: 'Traditional Pit-Loom / Kick Wheel',
                    badge: 'Zero Plastics',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Lab Spectroscopy Metrics
            const Text(
              'Laboratory Test Metrics',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),

            GridView.count(
              crossAxisCount: MediaQuery.sizeOf(context).width < 360 ? 1 : 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio:
                  MediaQuery.sizeOf(context).width < 360 ? 1.8 : 1.5,
              children: [
                _buildMetricCard(
                    'Thermal Retention', '94.2%', Icons.thermostat),
                _buildMetricCard(
                    'Lead & Cadmium Test', '0.00% (Pass)', Icons.sanitizer),
                _buildMetricCard(
                    'Earthen Water Filter', 'A+ Grade', Icons.water_drop),
                _buildMetricCard(
                    'Handmade Variation', 'Unique Pattern', Icons.fingerprint),
              ],
            ),
            const SizedBox(height: 24),

            // Verification Seal Actions
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF264E36),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                icon: const Icon(Icons.download, color: Colors.white),
                label: const Text(
                  'Certificate not available',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text(
                            'This is a sample report. No product certificate is available to download.')),
                  );
                },
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildMatrixRow({
    required IconData icon,
    required String label,
    required String value,
    required String badge,
  }) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: 22),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                    fontSize: 12, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: AppColors.secondary.withOpacity(0.12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            badge,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: AppColors.secondary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMetricCard(String title, String result, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: const Color(0xFF264E36), size: 22),
          const SizedBox(height: 8),
          Text(
            title,
            style:
                const TextStyle(fontSize: 11, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 2),
          Text(
            result,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
