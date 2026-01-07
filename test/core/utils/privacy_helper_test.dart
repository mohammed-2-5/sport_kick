import 'package:flutter_test/flutter_test.dart';
import 'package:spo_kick/core/utils/privacy_helper.dart';

void main() {
  group('PrivacyHelper', () {
    group('maskPhoneNumber', () {
      test('masks standard 11-digit phone number', () {
        const phone = '01012345678';
        final result = PrivacyHelper.maskPhoneNumber(phone);
        expect(result, '010****5678');
      });

      test('masks phone number with spaces', () {
        const phone = '010 1234 5678';
        final result = PrivacyHelper.maskPhoneNumber(phone);
        expect(result, '010****5678');
      });

      test('masks 10-digit phone number', () {
        const phone = '0123456789';
        final result = PrivacyHelper.maskPhoneNumber(phone);
        // 10 chars: middle = 10 - 7 = 3 asterisks
        expect(result, '012***6789');
      });

      test('returns unchanged if phone is too short', () {
        const phone = '123456';
        final result = PrivacyHelper.maskPhoneNumber(phone);
        expect(result, '123456');
      });

      test('handles exactly 7-digit phone number', () {
        const phone = '1234567';
        final result = PrivacyHelper.maskPhoneNumber(phone);
        // 7 chars: first 3 (123) + last 4 (4567) = no middle to mask
        expect(result, '1234567');
      });

      test('handles international format', () {
        const phone = '+201012345678';
        final result = PrivacyHelper.maskPhoneNumber(phone);
        // 13 chars: middle = 13 - 7 = 6 asterisks
        expect(result, '+20******5678');
      });
    });

    group('maskEmail', () {
      test('masks standard email address', () {
        const email = 'user@example.com';
        final result = PrivacyHelper.maskEmail(email);
        expect(result, 'u***@example.com');
      });

      test('masks email with long local part', () {
        const email = 'johndoe@domain.org';
        final result = PrivacyHelper.maskEmail(email);
        expect(result, 'j***@domain.org');
      });

      test('handles single character local part', () {
        const email = 'a@test.com';
        final result = PrivacyHelper.maskEmail(email);
        expect(result, 'a***@test.com');
      });

      test('returns unchanged if no @ symbol', () {
        const email = 'invalidemail';
        final result = PrivacyHelper.maskEmail(email);
        expect(result, 'invalidemail');
      });

      test('returns unchanged if @ is at start', () {
        const email = '@domain.com';
        final result = PrivacyHelper.maskEmail(email);
        expect(result, '@domain.com');
      });

      test('handles subdomain in domain', () {
        const email = 'test@mail.subdomain.com';
        final result = PrivacyHelper.maskEmail(email);
        expect(result, 't***@mail.subdomain.com');
      });
    });

    group('getPhoneDisplay', () {
      test('returns full phone when showPhone is true', () {
        const phone = '01012345678';
        final result = PrivacyHelper.getPhoneDisplay(
          phone: phone,
          showPhone: true,
        );
        expect(result, '01012345678');
      });

      test('returns masked phone when showPhone is false', () {
        const phone = '01012345678';
        final result = PrivacyHelper.getPhoneDisplay(
          phone: phone,
          showPhone: false,
        );
        expect(result, '010****5678');
      });
    });

    group('getEmailDisplay', () {
      test('returns full email when showEmail is true', () {
        const email = 'user@example.com';
        final result = PrivacyHelper.getEmailDisplay(
          email: email,
          showEmail: true,
        );
        expect(result, 'user@example.com');
      });

      test('returns masked email when showEmail is false', () {
        const email = 'user@example.com';
        final result = PrivacyHelper.getEmailDisplay(
          email: email,
          showEmail: false,
        );
        expect(result, 'u***@example.com');
      });
    });

    group('shouldShowProfilePicture', () {
      test('returns true when setting is enabled', () {
        final result = PrivacyHelper.shouldShowProfilePicture(
          showProfilePicture: true,
          isOwnProfile: false,
        );
        expect(result, true);
      });

      test('returns false when setting is disabled and not own profile', () {
        final result = PrivacyHelper.shouldShowProfilePicture(
          showProfilePicture: false,
          isOwnProfile: false,
        );
        expect(result, false);
      });

      test('returns true for own profile regardless of setting', () {
        final result = PrivacyHelper.shouldShowProfilePicture(
          showProfilePicture: false,
          isOwnProfile: true,
        );
        expect(result, true);
      });
    });

    group('shouldShowContactInfo', () {
      test('returns true when setting is enabled', () {
        final result = PrivacyHelper.shouldShowContactInfo(
          settingEnabled: true,
          isOwnProfile: false,
        );
        expect(result, true);
      });

      test('returns false when setting is disabled and not own profile', () {
        final result = PrivacyHelper.shouldShowContactInfo(
          settingEnabled: false,
          isOwnProfile: false,
        );
        expect(result, false);
      });

      test('returns true for own profile regardless of setting', () {
        final result = PrivacyHelper.shouldShowContactInfo(
          settingEnabled: false,
          isOwnProfile: true,
        );
        expect(result, true);
      });
    });
  });
}
