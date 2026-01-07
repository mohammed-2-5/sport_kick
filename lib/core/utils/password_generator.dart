import 'dart:math';

/// Utility class for generating secure passwords.
///
/// Provides methods for generating default passwords for admin accounts
/// and other secure password generation needs.
class PasswordGenerator {
  /// Generate a secure default password for new admins.
  ///
  /// Format: FieldAdmin{Year}@{RandomNumber}
  /// Example: FieldAdmin2025@743
  ///
  /// Returns a string password that meets security requirements.
  static String generateAdminPassword() {
    final year = DateTime.now().year;
    final random = Random().nextInt(900) + 100; // 3-digit random number
    return 'FieldAdmin$year@$random';
  }

  /// Generate a random numeric code.
  ///
  /// Used for OTP, verification codes, etc.
  ///
  /// [length] - Number of digits (default 6)
  static String generateNumericCode({int length = 6}) {
    final random = Random();
    final buffer = StringBuffer();

    for (int i = 0; i < length; i++) {
      buffer.write(random.nextInt(10));
    }

    return buffer.toString();
  }

  /// Generate a random alphanumeric code.
  ///
  /// Used for invitation codes, temporary tokens, etc.
  ///
  /// [length] - Number of characters (default 8)
  static String generateAlphanumericCode({int length = 8}) {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    final buffer = StringBuffer();

    for (int i = 0; i < length; i++) {
      buffer.write(chars[random.nextInt(chars.length)]);
    }

    return buffer.toString();
  }
}
