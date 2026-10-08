import 'package:intl/intl.dart';

class DateTimeUtils {
  static String formatOrderDate(DateTime dateTime) {
    return DateFormat('dd MMM yyyy, hh:mm a').format(dateTime);
  }

  static String formatChatTimestamp(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays == 0) {
      return DateFormat('hh:mm a').format(dateTime);
    } else if (difference.inDays < 7) {
      return DateFormat('E, hh:mm a').format(dateTime);
    } else {
      return DateFormat('dd/MM/yyyy').format(dateTime);
    }
  }
}
