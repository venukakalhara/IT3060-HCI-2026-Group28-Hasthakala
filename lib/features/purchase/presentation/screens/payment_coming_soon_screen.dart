import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/localization/tr.dart';
import '../widgets/purchase_parts.dart';

/// Assigned to: DISSANAYAKE D. M. S. D.
/// Branch: feature/buyer-purchase
// I07 payment step - opens when Card or Koko / Mintpay is tapped (hi-fi HF6)
// we have no payment gateway yet, so this page just says it is coming soon
// returns true when the buyer picks "Pay with Cash on Delivery"
class PaymentComingSoonScreen extends StatelessWidget {
  // true for Koko / Mintpay, false for card
  final bool koko;

  const PaymentComingSoonScreen({super.key, required this.koko});

  @override
  Widget build(BuildContext context) {
    final name = context.tr(koko ? 'pur_pay_koko' : 'pur_pay_card');

    return Scaffold(
      appBar: AppBar(
        title: Text(name),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      'assets/images/payment_coming_soon.png',
                      height: 220,
                      fit: BoxFit.cover,
                      semanticLabel: context.tr('pur_soon_image'),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: SmallBadge(
                      text: context.tr('pur_coming_soon').toUpperCase(),
                      color: AppColors.secondaryDark,
                      icon: Icons.schedule,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    context.tr('pur_soon_title', {'method': name}),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    context.tr('pur_soon_text'),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 14.5,
                        color: AppColors.textSecondary,
                        height: 1.4),
                  ),
                  const SizedBox(height: 20),
                  InfoNote(
                    icon: Icons.lock_outline,
                    title: context.tr('pur_soon_why_title'),
                    text: context.tr('pur_soon_why_text'),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => Navigator.of(context).pop(true),
                    icon: const Icon(Icons.payments_outlined, size: 18),
                    label: Text(context.tr('pur_soon_use_cod')),
                  ),
                  const SizedBox(height: 6),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text(context.tr('pur_soon_other')),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
