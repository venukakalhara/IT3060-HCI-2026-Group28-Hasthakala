import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/localization/tr.dart';
import '../../../../core/shared_models/artisan_profile_model.dart';
import '../../../../core/shared_models/order_model.dart';
import '../../data/artisan_info_cache.dart';
import 'order_text.dart';

// Pieces reused across the cart, checkout, orders and chat screens.

// white card with the soft border used on every purchase screen
class PurchaseCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? color;

  const PurchaseCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: color ?? AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: child,
    );
  }
}

// small rounded label, e.g. "Islandwide" or a status
class SmallBadge extends StatelessWidget {
  final String text;
  final Color color;
  final IconData? icon;

  const SmallBadge({
    super.key,
    required this.text,
    this.color = AppColors.accent,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: color),
            const SizedBox(width: 3),
          ],
          // capped width: badges often sit in rows with no width limit
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 200),
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: 11, fontWeight: FontWeight.w700, color: color),
            ),
          ),
        ],
      ),
    );
  }
}

// label on the left, amount on the right
class AmountRow extends StatelessWidget {
  final String label;
  final String value;
  final bool bold;
  final Color? valueColor;
  final Widget? badge;

  const AmountRow({
    super.key,
    required this.label,
    required this.value,
    this.bold = false,
    this.valueColor,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Flexible(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: bold ? 17 : 14,
                      fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
                      color: bold ? AppColors.textPrimary : AppColors.textSecondary,
                    ),
                  ),
                ),
                if (badge != null) ...[const SizedBox(width: 6), badge!],
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: bold ? 19 : 14,
              fontWeight: bold ? FontWeight.w700 : FontWeight.w600,
              color: valueColor ??
                  (bold ? AppColors.primary : AppColors.textPrimary),
            ),
          ),
        ],
      ),
    );
  }
}

// tinted note with an icon, e.g. "Handmade by Sri Lankan artisans"
class InfoNote extends StatelessWidget {
  final IconData icon;
  final String title;
  final String text;
  final Color color;

  const InfoNote({
    super.key,
    required this.icon,
    required this.title,
    required this.text,
    this.color = AppColors.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: color.withValues(alpha: 0.14),
            child: Icon(icon, size: 18, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 14)),
                const SizedBox(height: 3),
                Text(text,
                    style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12.5,
                        height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// product photo with a craft icon when there is no picture
class ItemThumb extends StatelessWidget {
  final String? imageUrl;
  final double size;

  const ItemThumb({super.key, this.imageUrl, this.size = 64});

  @override
  Widget build(BuildContext context) {
    final placeholder = Icon(Icons.brush_outlined,
        color: AppColors.secondary, size: size * 0.4);
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: size,
        height: size,
        color: AppColors.background,
        child: (imageUrl == null || imageUrl!.isEmpty)
            ? placeholder
            : Image.network(
                imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => placeholder,
              ),
      ),
    );
  }
}

// artisan name (+ verified tick) and, if asked, their place below it
class ArtisanLine extends StatelessWidget {
  final String artisanId;
  final String fallbackName;
  final bool showPlace;

  const ArtisanLine({
    super.key,
    required this.artisanId,
    this.fallbackName = '',
    this.showPlace = false,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ArtisanProfileModel?>(
      future: ArtisanInfoCache.get(artisanId),
      builder: (context, snapshot) {
        final profile = snapshot.data;
        final name = profile?.displayName.isNotEmpty == true
            ? profile!.displayName
            : fallbackName;
        final place = profile?.location ?? '';
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Flexible(
                  child: Text(
                    name.isEmpty ? context.tr('pur_artisan') : name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 12.5, color: AppColors.textSecondary),
                  ),
                ),
                if (profile?.verified == true) ...[
                  const SizedBox(width: 4),
                  Tooltip(
                    message: context.tr('pur_verified_artisan'),
                    child: const Icon(Icons.verified,
                        size: 14, color: AppColors.accent),
                  ),
                ],
              ],
            ),
            if (showPlace && place.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Row(
                  children: [
                    const Icon(Icons.place_outlined,
                        size: 12, color: AppColors.textMuted),
                    const SizedBox(width: 2),
                    Flexible(
                      child: Text(place,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 11.5, color: AppColors.textMuted)),
                    ),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }
}

// coloured label for an order status
class OrderStatusChip extends StatelessWidget {
  final OrderStatus status;

  const OrderStatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final color = switch (status) {
      OrderStatus.delivered => AppColors.accent,
      OrderStatus.cancelled => AppColors.error,
      _ => AppColors.secondaryDark,
    };
    return SmallBadge(text: OrderText.status(context, status), color: color);
  }
}

// Review - Delivery - Payment - Confirm (step is 0 to 3)
class CheckoutStepper extends StatelessWidget {
  final int step;

  const CheckoutStepper({super.key, required this.step});

  static const _labels = [
    'pur_step_review',
    'pur_step_delivery',
    'pur_step_payment',
    'pur_step_confirm',
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < _labels.length; i++)
          Expanded(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 2,
                        color: i == 0
                            ? Colors.transparent
                            : (i <= step ? AppColors.accent : AppColors.border),
                      ),
                    ),
                    _dot(i),
                    Expanded(
                      child: Container(
                        height: 2,
                        color: i == _labels.length - 1
                            ? Colors.transparent
                            : (i < step ? AppColors.accent : AppColors.border),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  context.tr(_labels[i]),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: i == step ? FontWeight.w700 : FontWeight.w500,
                    color: i == step ? AppColors.primary : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _dot(int i) {
    final done = i < step;
    final current = i == step;
    return Container(
      width: 28,
      height: 28,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: done
            ? AppColors.accent
            : (current ? AppColors.primary : AppColors.surface),
        border: Border.all(
          color: done || current ? Colors.transparent : AppColors.border,
        ),
      ),
      child: done
          ? const Icon(Icons.check, size: 16, color: AppColors.onPrimary)
          : Text(
              '${i + 1}',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: current ? AppColors.onPrimary : AppColors.textSecondary,
              ),
            ),
    );
  }
}

// round icon at the top of the placed / failed screens
class StatusCircle extends StatelessWidget {
  final IconData icon;
  final Color color;

  const StatusCircle({super.key, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withValues(alpha: 0.12),
      ),
      child: CircleAvatar(
        radius: 40,
        backgroundColor: color,
        child: Icon(icon, size: 42, color: AppColors.onPrimary),
      ),
    );
  }
}

// icon in a soft circle, a small label and a value below it
class IconInfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const IconInfoRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: AppColors.primary.withValues(alpha: 0.08),
            child: Icon(icon, size: 18, color: AppColors.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.textMuted)),
                const SizedBox(height: 2),
                Text(value,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
