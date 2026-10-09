import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/localization/tr.dart';
import '../../../../core/shared_models/order_model.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../state/checkout_provider.dart';
import '../widgets/purchase_parts.dart';

/// Assigned to: DISSANAYAKE D. M. S. D.
/// Branch: feature/buyer-purchase
// I07 Order could not be placed (hi-fi HF10)
// no internet, or an item sold out
// returns true when the buyer wants to leave checkout
class OrderFailedScreen extends StatelessWidget {
  final PlaceFailure failure;
  final List<String> soldOut;
  final List<OrderItemModel> items;
  final bool fromCart;

  const OrderFailedScreen({
    super.key,
    required this.failure,
    required this.soldOut,
    required this.items,
    required this.fromCart,
  });

  @override
  Widget build(BuildContext context) {
    final stock = failure == PlaceFailure.stock;
    final total = items.fold(0.0, (sum, item) => sum + item.lineTotal);
    final leaveLabel =
        context.tr(fromCart ? 'pur_back_to_cart' : 'pur_back_to_product');

    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('pur_checkout_title')),
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: IconButton(
          tooltip: MaterialLocalizations.of(context).backButtonTooltip,
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(false),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                children: [
                  const Center(
                    child: StatusCircle(
                        icon: Icons.priority_high, color: AppColors.secondary),
                  ),
                  const SizedBox(height: 14),
                  Center(
                    child: SmallBadge(
                      text: context.tr('pur_not_placed_badge'),
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    context.tr('pur_failed_title'),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    stock
                        ? context.tr('pur_failed_stock', {'items': soldOut.join(', ')})
                        : context.tr('pur_failed_network'),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: AppColors.textSecondary, height: 1.4),
                  ),
                  if (fromCart) ...[
                    const SizedBox(height: 6),
                    Text(
                      context.tr('pur_cart_saved'),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          color: AppColors.accent, fontWeight: FontWeight.w600),
                    ),
                  ],
                  const SizedBox(height: 18),
                  PurchaseCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.inventory_2_outlined,
                                size: 18, color: AppColors.primary),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                context.tr(fromCart
                                    ? 'pur_cart_items_kept'
                                    : 'pur_your_item'),
                                style: const TextStyle(fontWeight: FontWeight.w700),
                              ),
                            ),
                            SmallBadge(
                              text: context.tr('pur_saved_badge'),
                              icon: Icons.check,
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        for (final item in items)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              children: [
                                ItemThumb(imageUrl: item.imageUrl, size: 44),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(item.title,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w600)),
                                      Text(
                                        context.tr('pur_qty',
                                            {'count': '${item.quantity}'}),
                                        style: const TextStyle(
                                            fontSize: 12,
                                            color: AppColors.textMuted),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(CurrencyFormatter.formatLKR(item.lineTotal),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),
                        const Divider(height: 12),
                        AmountRow(
                          label: context.tr('pur_items_total'),
                          value: CurrencyFormatter.formatLKR(total),
                          valueColor: AppColors.primary,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  PurchaseCard(
                    padding: EdgeInsets.zero,
                    child: Theme(
                      data: Theme.of(context)
                          .copyWith(dividerColor: Colors.transparent),
                      child: ExpansionTile(
                        leading: const Icon(Icons.help_outline,
                            color: AppColors.textSecondary),
                        title: Text(context.tr('pur_why_title'),
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w600)),
                        childrenPadding:
                            const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        children: [
                          Text(
                            context.tr(stock ? 'pur_why_stock' : 'pur_why_network'),
                            style: const TextStyle(
                                color: AppColors.textSecondary, height: 1.4),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Column(
                children: [
                  if (stock)
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: Text(leaveLabel),
                    )
                  else ...[
                    ElevatedButton.icon(
                      onPressed: () => Navigator.of(context).pop(false),
                      icon: const Icon(Icons.refresh, size: 18),
                      label: Text(context.tr('pur_try_again')),
                    ),
                    const SizedBox(height: 6),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: Text(leaveLabel),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
