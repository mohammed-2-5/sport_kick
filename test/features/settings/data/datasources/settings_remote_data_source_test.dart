import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:spo_kick/features/settings/data/datasources/settings_remote_data_source.dart';
import 'package:spo_kick/features/settings/data/models/user_preferences_model.dart';
import 'package:spo_kick/features/settings/domain/entities/user_preferences_entity.dart';

class MockSupabaseClient extends Mock implements SupabaseClient {}

void main() {
  late SettingsRemoteDataSourceImpl dataSource;
  late MockSupabaseClient mockSupabaseClient;

  const tUserId = 'user-123';

  const tPreferencesModel = UserPreferencesModel(
    userId: tUserId,
    themeMode: AppThemeMode.system,
    language: 'en',
    pushNotificationsEnabled: true,
    bookingConfirmationNotifications: true,
    bookingReminderNotifications: true,
    bookingStatusNotifications: true,
    fieldOwnerMessagesNotifications: true,
    showProfilePicture: true,
    showPhoneNumber: false,
    showEmail: false,
  );

  setUp(() {
    mockSupabaseClient = MockSupabaseClient();
    dataSource = SettingsRemoteDataSourceImpl(
      supabaseClient: mockSupabaseClient,
    );
  });

  group('SettingsRemoteDataSource', () {
    test('should create instance with required parameters', () {
      expect(dataSource, isA<SettingsRemoteDataSource>());
    });

    group('fromJson / toJson round-trip', () {
      test('UserPreferencesModel serializes and deserializes correctly', () {
        final json = tPreferencesModel.toJson();
        final restored = UserPreferencesModel.fromJson(json);

        expect(restored.userId, tPreferencesModel.userId);
        expect(restored.themeMode, tPreferencesModel.themeMode);
        expect(restored.language, tPreferencesModel.language);
        expect(
          restored.pushNotificationsEnabled,
          tPreferencesModel.pushNotificationsEnabled,
        );
        expect(
          restored.bookingConfirmationNotifications,
          tPreferencesModel.bookingConfirmationNotifications,
        );
        expect(
          restored.showProfilePicture,
          tPreferencesModel.showProfilePicture,
        );
        expect(restored.showPhoneNumber, tPreferencesModel.showPhoneNumber);
        expect(restored.showEmail, tPreferencesModel.showEmail);
      });

      test('fromJson handles missing fields with defaults', () {
        final minimalJson = {'user_id': tUserId};
        final model = UserPreferencesModel.fromJson(minimalJson);

        expect(model.userId, tUserId);
        expect(model.themeMode, AppThemeMode.system);
        expect(model.language, 'en');
        expect(model.pushNotificationsEnabled, true);
        expect(model.showPhoneNumber, false);
        expect(model.showEmail, false);
      });

      test('fromEntity creates model from entity correctly', () {
        const entity = UserPreferencesEntity(
          userId: tUserId,
          themeMode: AppThemeMode.dark,
          language: 'ar',
          showPhoneNumber: true,
        );

        final model = UserPreferencesModel.fromEntity(entity);

        expect(model.userId, entity.userId);
        expect(model.themeMode, entity.themeMode);
        expect(model.language, entity.language);
        expect(model.showPhoneNumber, entity.showPhoneNumber);
      });

      test('toJson includes all fields correctly', () {
        final json = tPreferencesModel.toJson();

        expect(json['user_id'], tUserId);
        expect(json['theme_mode'], 'system');
        expect(json['language'], 'en');
        expect(json['push_notifications_enabled'], true);
        expect(json['booking_confirmation_notifications'], true);
        expect(json['booking_reminder_notifications'], true);
        expect(json['booking_status_notifications'], true);
        expect(json['field_owner_messages_notifications'], true);
        expect(json['show_profile_picture'], true);
        expect(json['show_phone_number'], false);
        expect(json['show_email'], false);
      });

      test('theme mode conversion works for all values', () {
        final lightJson = {'user_id': tUserId, 'theme_mode': 'light'};
        final darkJson = {'user_id': tUserId, 'theme_mode': 'dark'};
        final systemJson = {'user_id': tUserId, 'theme_mode': 'system'};

        expect(
          UserPreferencesModel.fromJson(lightJson).themeMode,
          AppThemeMode.light,
        );
        expect(
          UserPreferencesModel.fromJson(darkJson).themeMode,
          AppThemeMode.dark,
        );
        expect(
          UserPreferencesModel.fromJson(systemJson).themeMode,
          AppThemeMode.system,
        );
      });
    });
  });
}
