class PhoneUtils {
  static String formatPhone(String input) {
    final digits = input.replaceAll(RegExp(r'[^0-9]'), '');

    // If 10 digits → assume India
    if (digits.length == 10) {
      return '+91$digits';
    }

    // If already has country code
    if (digits.length > 10) {
      return '+$digits';
    }

    throw Exception('Invalid phone number');
  }
}