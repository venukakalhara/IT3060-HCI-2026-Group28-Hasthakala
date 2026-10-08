class InputValidators {
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email address is required';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Enter a valid email address';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required';
    }
    // Sri Lankan standard phone validation (e.g. 07XXXXXXXX or +947XXXXXXXX)
    final phoneRegex = RegExp(r'^(?:0|\+94)?[7][0-9]{8}$');
    if (!phoneRegex.hasMatch(value.replaceAll(' ', ''))) {
      return 'Enter a valid Sri Lankan mobile number (e.g. 0712345678)';
    }
    return null;
  }

  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  static String? validatePositiveNumber(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    final number = double.tryParse(value);
    if (number == null || number <= 0) {
      return '$fieldName must be greater than 0';
    }
    return null;
  }
}
