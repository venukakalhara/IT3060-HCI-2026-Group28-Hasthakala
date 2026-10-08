import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../../../../core/localization/tr.dart';
import '../../../../core/shared_models/order_model.dart';

// Small text helpers shared by the purchase screens.
class OrderText {
  // Firestore ids are long, so buyers see the first 6 characters.
  static String ref(String orderId) {
    final short = orderId.length > 6 ? orderId.substring(0, 6) : orderId;
    return '#${short.toUpperCase()}';
  }

  static String status(BuildContext context, OrderStatus status) =>
      context.tr('pur_status_${status.name}');

  static String payment(BuildContext context, String method) => context
      .tr(method == PaymentMethods.bankTransfer ? 'pur_pay_bank' : 'pur_pay_cod');

  static bool isActive(OrderStatus status) =>
      status != OrderStatus.delivered && status != OrderStatus.cancelled;

  static String date(BuildContext context, DateTime value,
      [String pattern = 'd MMM yyyy']) {
    try {
      return DateFormat(pattern, Localizations.localeOf(context).languageCode)
          .format(value);
    } catch (_) {
      return DateFormat(pattern).format(value);
    }
  }

  static String dateTime(BuildContext context, DateTime value) =>
      date(context, value, 'd MMM, h:mm a');

  // Not stored anywhere - most parcels arrive 5 to 7 days after ordering.
  static String estimate(BuildContext context, DateTime placed) {
    final from = date(context, placed.add(const Duration(days: 5)), 'd MMM');
    final to = date(context, placed.add(const Duration(days: 7)), 'd MMM');
    return '$from - $to';
  }

  // "Coconut Bowl" or "Coconut Bowl + 2 more"
  static String itemsTitle(BuildContext context, List<OrderItemModel> items) {
    if (items.isEmpty) return '';
    if (items.length == 1) return items.first.title;
    return '${items.first.title} ${context.tr('pur_and_more', {
          'count': '${items.length - 1}'
        })}';
  }
}
