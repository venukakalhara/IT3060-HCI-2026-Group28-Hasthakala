import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

/// High-Fidelity Artisan Reviews & Proof Screen matching Stitch Canvas specification
class ArtisanReviewsScreen extends StatelessWidget {
  const ArtisanReviewsScreen({super.key});

  final List<Map<String, dynamic>> _reviews = const [
    {
      'name': 'Dilshan Ranasinghe',
      'rating': 5,
      'date': '2 days ago',
      'verifiedItem': 'Terracotta Water Jug (Kelaniya)',
      'comment':
          'Exceptional quality! The jug keeps water naturally cool during warm afternoons just like my grandmother’s traditional pot. Packed with biodegradable coir safety.',
      'location': 'Colombo 07',
    },
    {
      'name': 'Chathuri Wickramasinghe',
      'rating': 5,
      'date': '1 week ago',
      'verifiedItem': 'Gurulu Raksha Wooden Mask',
      'comment':
          'Master Sunil’s craftsmanship is astounding. The natural mineral pigments and Kaduru wood aroma prove 100% authenticity.',
      'location': 'Kandy',
    },
    {
      'name': 'Mahesh Pathirana',
      'rating': 4.8,
      'date': '2 weeks ago',
      'verifiedItem': 'Dumbara Weave Runner',
      'comment':
          'Direct support to local maker guilds is what makes Hasthaka special. The order arrived safely with provenance certificate included.',
      'location': 'Galle',
    },
  ];

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
          'Artisan Reviews & Proof',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Rating Summary Banner
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Column(
                    children: const [
                      Text(
                        '4.9',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                          height: 1.0,
                        ),
                      ),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.amber, size: 16),
                          Icon(Icons.star, color: Colors.amber, size: 16),
                          Icon(Icons.star, color: Colors.amber, size: 16),
                          Icon(Icons.star, color: Colors.amber, size: 16),
                          Icon(Icons.star, color: Colors.amber, size: 16),
                        ],
                      ),
                      SizedBox(height: 4),
                      Text(
                        '3 Sample Reviews',
                        style: TextStyle(
                            fontSize: 11, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                  const SizedBox(width: 20),
                  Container(width: 1, height: 60, color: Colors.grey.shade200),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Authenticity Rating',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Review preview',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF264E36),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Example feedback shown for this screen preview. Live artisan reviews are not connected yet.',
                          style: TextStyle(
                              fontSize: 11, color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Reviews Header
            const Text(
              'Sample Buyer Feedback',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _reviews.length,
              itemBuilder: (context, index) {
                final r = _reviews[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        alignment: WrapAlignment.spaceBetween,
                        spacing: 12,
                        runSpacing: 8,
                        children: [
                          Wrap(
                            spacing: 4,
                            runSpacing: 4,
                            children: [
                              CircleAvatar(
                                radius: 18,
                                backgroundColor:
                                    AppColors.primary.withOpacity(0.15),
                                child: Text(
                                  (r['name'] as String)[0],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    r['name'] as String,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(
                                    '${r['location']} • ${r['date']}',
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Wrap(
                            spacing: 4,
                            runSpacing: 4,
                            children: List.generate(
                              5,
                              (i) => const Icon(Icons.star,
                                  color: Colors.amber, size: 14),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.accent.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.verified,
                                size: 12, color: AppColors.accent),
                            const SizedBox(width: 4),
                            Text(
                              r['verifiedItem'] as String,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: AppColors.accent,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        r['comment'] as String,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textPrimary,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
