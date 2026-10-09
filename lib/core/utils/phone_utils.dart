// SL Numbers
// Stored format: 10 digits starting with 0, e.g. 0771234567.
class PhoneUtils {
  // Converts "+94 77 123 4567", "94771234567" or "077-123 4567" to "0771234567".
  static String normalize(String input) {
    var digits = input.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.startsWith('94') && digits.length == 11) {
      digits = '0${digits.substring(2)}';
    }
    return digits;
  }

  // 0771234567 -> 077 123 4567 (for showing on screen)
  static String display(String phone) {
    final d = normalize(phone);
    if (d.length != 10) return phone;
    return '${d.substring(0, 3)} ${d.substring(3, 6)} ${d.substring(6)}';
  }

  static bool isValid(String input) =>
      RegExp(r'^0[0-9]{9}$').hasMatch(normalize(input));

  static String? validate(String? input) {
    if (input == null || input.trim().isEmpty) return 'Please enter a phone number';
    if (!isValid(input)) return 'Enter a valid number, e.g. 077 123 4567';
    return null;
  }
}
