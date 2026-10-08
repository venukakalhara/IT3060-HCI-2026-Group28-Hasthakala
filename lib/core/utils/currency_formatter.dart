import 'package:intl/intl.dart';

class CurrencyFormatter {
  static final NumberFormat _lkrFormat = NumberFormat.currency(
    locale: 'en_LK',
    symbol: 'Rs. ',
    decimalDigits: 2,
  );

  static final NumberFormat _compactFormat = NumberFormat.compactCurrency(
    locale: 'en_LK',
    symbol: 'Rs. ',
  );

  static String formatLKR(double amount) {
    return _lkrFormat.format(amount);
  }

  static String formatCompact(double amount) {
    return _compactFormat.format(amount);
  }
}
