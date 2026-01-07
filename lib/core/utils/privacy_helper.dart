/// Privacy utility class for masking and displaying user data.
///
/// Provides methods to:
/// - Mask phone numbers (e.g., 01012345678 → 010****5678)
/// - Mask emails (e.g., user@example.com → u***@example.com)
/// - Get display values based on privacy preferences
class PrivacyHelper {
  const PrivacyHelper._();

  /// Masks a phone number, showing only first 3 and last 4 digits.
  ///
  /// Example: 01012345678 → 010****5678
  ///
  /// Returns [phone] unchanged if it's too short to mask (< 7 chars).
  static String maskPhoneNumber(String phone) {
    final cleaned = phone.replaceAll(RegExp(r'\s+'), '');
    if (cleaned.length < 7) return phone;

    final visiblePrefix = cleaned.substring(0, 3);
    final visibleSuffix = cleaned.substring(cleaned.length - 4);
    final maskedLength = cleaned.length - 7; // chars between prefix and suffix
    final masked = '*' * (maskedLength > 0 ? maskedLength : 0);

    return '$visiblePrefix$masked$visibleSuffix';
  }

  /// Masks an email address, showing only first char and domain.
  ///
  /// Example: user@example.com → u***@example.com
  ///
  /// Returns [email] unchanged if it doesn't contain '@'.
  static String maskEmail(String email) {
    final atIndex = email.indexOf('@');
    if (atIndex < 1) return email;

    final localPart = email.substring(0, atIndex);
    final domain = email.substring(atIndex);

    if (localPart.length <= 1) {
      return '$localPart***$domain';
    }

    return '${localPart[0]}***$domain';
  }

  /// Returns the phone number display based on privacy setting.
  ///
  /// If [showPhone] is true, returns the full [phone].
  /// Otherwise, returns the masked version.
  static String getPhoneDisplay({
    required String phone,
    required bool showPhone,
  }) {
    if (showPhone) return phone;
    return maskPhoneNumber(phone);
  }

  /// Returns the email display based on privacy setting.
  ///
  /// If [showEmail] is true, returns the full [email].
  /// Otherwise, returns the masked version.
  static String getEmailDisplay({
    required String email,
    required bool showEmail,
  }) {
    if (showEmail) return email;
    return maskEmail(email);
  }

  /// Determines if profile picture should be shown.
  ///
  /// Returns true if [showProfilePicture] preference is enabled,
  /// or if viewing own profile ([isOwnProfile] is true).
  static bool shouldShowProfilePicture({
    required bool showProfilePicture,
    bool isOwnProfile = false,
  }) {
    return isOwnProfile || showProfilePicture;
  }

  /// Determines if contact info should be visible.
  ///
  /// Returns true if the specific setting is enabled,
  /// or if viewing own profile ([isOwnProfile] is true).
  static bool shouldShowContactInfo({
    required bool settingEnabled,
    bool isOwnProfile = false,
  }) {
    return isOwnProfile || settingEnabled;
  }
}
