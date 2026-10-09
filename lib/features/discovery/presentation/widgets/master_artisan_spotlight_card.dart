import '../discovery_labels.dart';
import '../../../../core/localization/tr.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/shared_models/product_model.dart';

class MasterArtisanSpotlightCard extends StatelessWidget {
  const MasterArtisanSpotlightCard(
      {super.key,
      required this.product,
      required this.onViewWorkshop,
      required this.onFeaturedProductTap});
  final ProductModel product;
  final VoidCallback onViewWorkshop;
  final VoidCallback onFeaturedProductTap;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.border)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(context.tr('discovery_spotlight'),
              style: TextStyle(
                  color: AppColors.accent, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Text(
              product.artisanName.isEmpty
                  ? context.tr('discovery_meet_maker')
                  : product.artisanName,
              style:
                  const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          if (product.district.isNotEmpty)
            Text(discoveryOriginLabel(context, product.district)),
          const SizedBox(height: 8),
          Text(product.title,
              style: const TextStyle(color: AppColors.textSecondary)),
          const SizedBox(height: 16),
          Wrap(spacing: 8, runSpacing: 8, children: [
            OutlinedButton(
                onPressed: product.artisanId.isEmpty ? null : onViewWorkshop,
                child: Text(context.tr('discovery_workshop'))),
            ElevatedButton(
                onPressed: onFeaturedProductTap,
                child: Text(context.tr('discovery_view_craft'))),
          ]),
        ]),
      );
}
