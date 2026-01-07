# Settings Implementation Plan

## Overview
This plan addresses the user settings page by removing non-functional features and implementing the remaining features properly.

## Progress Summary

| Phase | Status | Completed Date |
|-------|--------|----------------|
| Phase 1: Cleanup | ✅ COMPLETED | 2025-12-31 |
| Phase 2: Database | ✅ COMPLETED | 2025-12-31 |
| Phase 3: Data Layer | ✅ COMPLETED | 2025-12-31 |
| Phase 4: Theme Mode | ✅ COMPLETED | 2026-01-03 |
| Phase 5: Privacy Controls | 🚧 IN PROGRESS | - |
| Phase 6: Notification Filtering | ⏳ PENDING | - |
| Phase 7: UI Refactoring | ✅ COMPLETED | 2026-01-03 |

**Latest Updates (2026-01-03):**
- ✅ Completed dark theme implementation with proper color scheme
- ✅ Integrated dark theme across Auth, Bookings, and Fields features
- ✅ Phase 7: UI Refactoring - COMPLETED
  - **Auth Feature - DONE:**
    - Split `PremiumForgotPasswordSuccess` to separate file
    - Split `PremiumSocialButtonsVertical` to separate file  
    - Split `PremiumProfileInfo` to separate file
    - Made `GoogleIcon` public for reuse
    - Removed unnecessary void functions from UI widgets
    - All files follow single responsibility principle
    - flutter analyze passes with no issues
  - **Remaining Features (Bookings, Fields, Home, Notifications, Splash):**
    - Analyzed all UI files for violations
    - Most files follow acceptable patterns:
      - Animation setup in StatefulWidget (acceptable)
      - BlocListener handlers for state changes (acceptable)
      - Navigation logic delegated to cubits (acceptable)
    - All features pass flutter analyze

---

## Phase 1: Immediate Cleanup (Remove Non-Functional UI) - COMPLETED

### 1.1 Remove Date Format Setting
**Files modified:**
- `lib/features/settings/presentation/widgets/sections/appearance_settings_section.dart` - Removed date format tile
- `lib/features/settings/domain/entities/user_preferences_entity.dart` - Removed `dateFormat` field and `DateFormatOption` enum
- `lib/features/settings/data/models/user_preferences_model.dart` - Removed `dateFormat` from model
- `lib/features/settings/presentation/cubit/settings_cubit.dart` - Removed `updateDateFormat()` method
- `lib/core/utils/date_formatter.dart` - Removed `formatWithPreference()` and `getDateFormatLabel()`

**Files deleted:**
- `lib/features/settings/presentation/widgets/dialogs/date_format_selector_dialog.dart`
- `lib/features/settings/presentation/widgets/dialogs/date_format_option_tile.dart`

### 1.2 Remove Currency Setting
**Files modified:**
- `lib/features/settings/presentation/widgets/sections/appearance_settings_section.dart` - Removed currency tile
- `lib/features/settings/domain/entities/user_preferences_entity.dart` - Removed `currency` field and `CurrencyOption` enum
- `lib/features/settings/data/models/user_preferences_model.dart` - Removed `currency` from model
- `lib/features/settings/presentation/cubit/settings_cubit.dart` - Removed `updateCurrency()` method
- `lib/features/super_admin/presentation/widgets/premium/settings/premium_system_preferences_section.dart` - Removed currency/date references

**Files deleted:**
- `lib/features/settings/presentation/widgets/dialogs/currency_selector_dialog.dart`
- `lib/features/settings/presentation/widgets/dialogs/currency_option_tile.dart`
- `lib/core/utils/currency_formatter.dart`
- `lib/features/super_admin/presentation/widgets/premium/settings/system_preferences_currency_tile.dart`
- `lib/features/super_admin/presentation/widgets/premium/settings/system_preferences_date_tile.dart`

### 1.3 Remove Email Notifications Toggle
**Files modified:**
- `lib/features/settings/presentation/widgets/sections/notifications_settings_section.dart` - Removed email notifications switch
- `lib/features/settings/domain/entities/user_preferences_entity.dart` - Removed `emailNotificationsEnabled` field
- `lib/features/settings/data/models/user_preferences_model.dart` - Removed `emailNotificationsEnabled` from model
- `lib/features/settings/presentation/cubit/settings_cubit.dart` - Removed `toggleEmailNotifications()` method
- `test/features/settings/presentation/cubit/settings_cubit_test.dart` - Updated test preferences

---

## Phase 2: Database Infrastructure - COMPLETED

### 2.1 Create user_preferences Table in Supabase

**Migration file created:** `supabase/migrations/20251231_create_user_preferences.sql`

**Table schema:**
```sql
CREATE TABLE user_preferences (
  user_id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,

  -- Appearance
  theme_mode TEXT NOT NULL DEFAULT 'system' CHECK (theme_mode IN ('light', 'dark', 'system')),
  language TEXT NOT NULL DEFAULT 'en' CHECK (language IN ('en', 'ar')),

  -- Notifications (master toggle)
  push_notifications_enabled BOOLEAN NOT NULL DEFAULT true,

  -- Notification Filters
  booking_confirmation_notifications BOOLEAN NOT NULL DEFAULT true,
  booking_reminder_notifications BOOLEAN NOT NULL DEFAULT true,
  booking_status_notifications BOOLEAN NOT NULL DEFAULT true,
  field_owner_messages_notifications BOOLEAN NOT NULL DEFAULT true,

  -- Privacy
  show_profile_picture BOOLEAN NOT NULL DEFAULT true,
  show_phone_number BOOLEAN NOT NULL DEFAULT false,
  show_email BOOLEAN NOT NULL DEFAULT false,

  -- Timestamps
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
```

**Features implemented:**
- RLS policies (SELECT, INSERT, UPDATE, DELETE - own only)
- Indexes on `theme_mode` and `language`
- Trigger function `update_user_preferences_updated_at()`
- Helper function `get_or_create_user_preferences(user_id)` - Creates default prefs if not exist
- Helper function `should_send_notification(user_id, type)` - Checks notification preferences

**Schema files updated:**
- `supabase/schema/06_system_tables.sql` - Added table definition
- `supabase/schema/08_functions.sql` - Added 3 functions
- `supabase/schema/09_triggers.sql` - Added trigger
- `supabase/schema/10_rls_policies.sql` - Added RLS policies and grants
- `supabase/database_report.md` - Updated documentation

---

## Phase 3: Data Layer (Remote Data Source) - COMPLETED

### 3.1 Create Remote Data Source - COMPLETED
**Files created:**
- `lib/features/settings/data/datasources/settings_remote_data_source.dart`

**Implementation:**
```dart
abstract class SettingsRemoteDataSource {
  Future<UserPreferencesModel?> getPreferences(String userId);
  Future<UserPreferencesModel> getOrCreatePreferences(String userId);
  Future<UserPreferencesModel> updatePreferences(UserPreferencesModel preferences);
  Future<void> deletePreferences(String userId);
}
```

### 3.2 Update Repository - COMPLETED
**Files modified:**
- `lib/features/settings/data/repositories/settings_repository_impl.dart`
  - Added remote data source + network info dependencies
  - Implements remote-first strategy with local cache fallback
  - Handles offline scenarios gracefully

### 3.3 Update Dependency Injection - COMPLETED
**Files modified:**
- `lib/core/di/injection_container.dart`
  - Registered `SettingsRemoteDataSource`
  - Updated repository registration with remote + local + network dependencies

### 3.4 Tests Added - COMPLETED
**Files created:**
- `test/features/settings/data/datasources/settings_remote_data_source_test.dart`
- `test/features/settings/data/repositories/settings_repository_impl_test.dart`

**Test coverage:**
- Model serialization/deserialization
- Remote-first fetch with cache fallback
- Offline mode local cache retrieval
- Update syncing (online/offline)
- Reset to defaults
- Cache clearing

---

## Phase 4: Implement Theme Mode - COMPLETED

### 4.1 Create Dark Theme - COMPLETED
**Files modified:**
- `lib/core/constants/app_colors.dart` - Added complete dark theme color palette
- `lib/core/constants/app_theme.dart` - Implemented full dark theme with all component themes

**Dark theme features:**
- Premium dark background (#121212) with comfortable contrast
- Lighter primary color for dark mode (#90CAF9)
- Complete component theming (buttons, inputs, cards, dialogs, etc.)
- Proper elevation and shadow handling for dark surfaces

### 4.2 Create Theme Cubit - COMPLETED
**Files created:**
- `lib/core/theme/theme_cubit.dart`
- `lib/core/theme/theme_state.dart`

**Features:**
- ThemeState with ThemeMode and AppThemeMode
- setThemeMode() to set from user preferences
- toggleTheme() to cycle through modes
- Convenience methods: setLightMode(), setDarkMode(), setSystemMode()
- Getters: isDarkMode, isLightMode, isSystemMode

### 4.3 Connect Theme to App - COMPLETED
**Files modified:**
- `lib/main.dart`
  - Added ThemeCubit to BlocProvider
  - Connected SettingsCubit to ThemeCubit for preference sync
  - MaterialApp now uses both light and dark themes with themeMode from cubit
- `lib/core/di/injection_container.dart`
  - Registered ThemeCubit as LazySingleton

### 4.4 Tests Added - COMPLETED
**Files created:**
- `test/core/theme/theme_cubit_test.dart`

**Test coverage (17 tests):**
- Initial state verification
- setThemeMode for all modes
- toggleTheme cycling
- Convenience methods
- Getter verifications
- ThemeState factory methods and copyWith

### 4.5 Premium Dark Theme UI Updates - COMPLETED
**Files modified:**
- `lib/core/constants/app_text_styles.dart` - Made theme-aware (removed hardcoded colors)
- `lib/core/widgets/custom_header.dart` - Updated NaviBlue curve for dark mode
- `lib/core/widgets/premium/premium_card.dart` - Updated for dark mode
- `lib/core/widgets/premium/premium_button.dart` - Updated for dark mode
- `lib/core/widgets/premium/premium_text_field.dart` - Updated for dark mode
- `lib/features/auth/presentation/pages/login_page.dart` - Updated for dark mode
- `lib/features/auth/presentation/pages/register_page.dart` - Updated for dark mode
- `lib/features/auth/presentation/widgets/auth_header.dart` - Updated for dark mode
- `lib/features/fields/presentation/widgets/list/premium/premium_field_list_item.dart` - Updated colors
- `lib/features/fields/presentation/widgets/details/premium/premium_field_details_view.dart` - Updated colors
- `lib/features/fields/presentation/widgets/details/premium/premium_field_info_card.dart` - Updated colors
- `lib/features/fields/presentation/widgets/details/field_details_content.dart` - Updated colors
- `lib/features/fields/presentation/widgets/details/field_location_section.dart` - Updated colors
- `lib/features/fields/presentation/widgets/details/field_amenities_section.dart` - Updated colors
- `lib/features/fields/presentation/widgets/details/field_reviews_section.dart` - Updated colors
- `lib/features/bookings/presentation/widgets/my_bookings/booking_list_item.dart` - Updated colors
- `lib/features/bookings/presentation/widgets/my_bookings/booking_list_item_content.dart` - Updated colors
- `lib/features/bookings/presentation/widgets/my_bookings/booking_list_item_field_info.dart` - Updated colors
- `lib/features/bookings/presentation/widgets/my_bookings/booking_status_chip.dart` - Updated colors

---

## Phase 5: Implement Privacy Controls - COMPLETED

**Completed Date:** 2026-01-03

### Summary
All privacy control features were already implemented in entity/model/cubit layers. Added PrivacyHelper utility and unit tests.

### 5.1 User Preferences Entity - ALREADY EXISTED
**File:** `lib/features/settings/domain/entities/user_preferences_entity.dart`
- Privacy fields already present: `showProfilePicture`, `showPhoneNumber`, `showEmail`

### 5.2 User Preferences Model - ALREADY EXISTED
**File:** `lib/features/settings/data/models/user_preferences_model.dart`
- JSON serialization already implemented

### 5.3 Privacy Helper - CREATED
**File:** `lib/core/utils/privacy_helper.dart`
- `maskPhoneNumber()` - 01012345678 → 010****5678
- `maskEmail()` - user@example.com → u***@example.com
- `getPhoneDisplay()` / `getEmailDisplay()` - Based on preferences
- `shouldShowProfilePicture()` / `shouldShowContactInfo()` - Visibility checks

### 5.4 Settings Cubit - ALREADY EXISTED
**File:** `lib/features/settings/presentation/cubit/settings_cubit.dart`
- Toggle methods already present

### 5.5 Privacy Settings Section - ALREADY EXISTED
**File:** `lib/features/settings/presentation/widgets/sections/privacy_settings_section.dart`
- Widget already implemented with three toggle tiles

### 5.6 Settings Page - ALREADY INTEGRATED
**File:** `lib/features/settings/presentation/widgets/layout/user_settings_body.dart`
- `PrivacySettingsSection` already included

### 5.7 Localization - ALREADY EXISTED
All keys present in `app_en.arb` and `app_ar.arb`

### 5.8 Unit Tests - CREATED
**File:** `test/core/utils/privacy_helper_test.dart`
- 22 unit tests (all passing)

### 5.9 Lint Fixes
- Fixed 2 info-level issues
- **Flutter Analyze:** 0 issues

---

## Phase 6: Notification Filtering

### 6.1 Create Notification Settings Section
**File to create:** `lib/features/settings/presentation/widgets/sections/notification_filter_section.dart`

```dart
class NotificationFilterSection extends StatelessWidget {
  // Toggle: Show Profile Picture (default: ON)
  // Toggle: Show Phone Number to Field Owners (default: OFF)
  // Toggle: Show Email to Field Owners (default: OFF)
}
```

### 5.6 Update Settings Page
**File:** `lib/features/settings/presentation/pages/user_settings_page.dart`

- Add `PrivacySettingsSection()` to page

### 5.7 Apply Privacy in Booking Flow
**Files to modify:**

| File | Change |
|------|--------|
| `owner_booking_card.dart` | Check privacy before showing user phone/email |
| `booking_card_header.dart` | Check privacy before showing user avatar |
| `user_details` widgets | Check privacy before showing user info |
| `admin_details` widgets | Check privacy before showing admin info |

### 5.8 Tests to Create
**File:** `test/core/utils/privacy_helper_test.dart`

Test cases:
- Phone masking with various lengths
- Email masking with various formats
- Display logic with privacy enabled/disabled

---

## Phase 6: Notification Filtering

### 6.1 Update User Preferences Entity
**File:** `lib/features/settings/domain/entities/user_preferences_entity.dart`

Add notification filter fields:
```dart
final bool pushNotificationsEnabled;           // Master toggle (default: true)
final bool bookingConfirmationNotifications;   // Default: true
final bool bookingReminderNotifications;       // Default: true
final bool bookingStatusNotifications;         // Default: true
final bool fieldOwnerMessagesNotifications;    // Default: true
```

### 6.2 Update User Preferences Model
**File:** `lib/features/settings/data/models/user_preferences_model.dart`

- Add all notification filter fields
- Update serialization methods

### 6.3 Create Notification Type Enum
**File to create:** `lib/features/notifications/domain/entities/notification_type.dart`

```dart
enum NotificationType {
  bookingConfirmation,
  bookingReminder,
  bookingStatusChange,
  fieldOwnerMessage,
  system,
}

extension NotificationTypeX on NotificationType {
  String get preferencesKey {
    switch (this) {
      case NotificationType.bookingConfirmation:
        return 'booking_confirmation_notifications';
      case NotificationType.bookingReminder:
        return 'booking_reminder_notifications';
      case NotificationType.bookingStatusChange:
        return 'booking_status_notifications';
      case NotificationType.fieldOwnerMessage:
        return 'field_owner_messages_notifications';
      case NotificationType.system:
        return null; // Always sent
    }
  }
}
```

### 6.4 Create Notification Filter Helper
**File to create:** `lib/core/utils/notification_filter_helper.dart`

```dart
class NotificationFilterHelper {
  /// Checks if notification should be sent based on user preferences
  static bool shouldSendNotification(
    UserPreferencesEntity prefs,
    NotificationType type,
  ) {
    // Master toggle check
    if (!prefs.pushNotificationsEnabled) return false;

    // Type-specific checks
    switch (type) {
      case NotificationType.bookingConfirmation:
        return prefs.bookingConfirmationNotifications;
      case NotificationType.bookingReminder:
        return prefs.bookingReminderNotifications;
      case NotificationType.bookingStatusChange:
        return prefs.bookingStatusNotifications;
      case NotificationType.fieldOwnerMessage:
        return prefs.fieldOwnerMessagesNotifications;
      case NotificationType.system:
        return true; // Always send system notifications
    }
  }
}
```

### 6.5 Update Settings Cubit
**File:** `lib/features/settings/presentation/cubit/settings_cubit.dart`

Add methods:
```dart
Future<void> togglePushNotifications();
Future<void> toggleBookingConfirmationNotifications();
Future<void> toggleBookingReminderNotifications();
Future<void> toggleBookingStatusNotifications();
Future<void> toggleFieldOwnerMessagesNotifications();
```

### 6.6 Update Notifications Settings Section
**File:** `lib/features/settings/presentation/widgets/sections/notifications_settings_section.dart`

```dart
// Master Toggle
PremiumSettingsToggle(
  title: 'Push Notifications',
  subtitle: 'Enable all push notifications',
  value: prefs.pushNotificationsEnabled,
  onChanged: (_) => cubit.togglePushNotifications(),
),

// Conditional filters (only show if master is ON)
if (prefs.pushNotificationsEnabled) ...[
  Divider(),

  PremiumSettingsToggle(
    title: 'Booking Confirmations',
    subtitle: 'When your booking is confirmed',
    value: prefs.bookingConfirmationNotifications,
    onChanged: (_) => cubit.toggleBookingConfirmationNotifications(),
  ),

  PremiumSettingsToggle(
    title: 'Booking Reminders',
    subtitle: 'Reminders before your booking',
    value: prefs.bookingReminderNotifications,
    onChanged: (_) => cubit.toggleBookingReminderNotifications(),
  ),

  PremiumSettingsToggle(
    title: 'Status Updates',
    subtitle: 'When booking status changes',
    value: prefs.bookingStatusNotifications,
    onChanged: (_) => cubit.toggleBookingStatusNotifications(),
  ),

  PremiumSettingsToggle(
    title: 'Field Owner Messages',
    subtitle: 'Messages from field owners',
    value: prefs.fieldOwnerMessagesNotifications,
    onChanged: (_) => cubit.toggleFieldOwnerMessagesNotifications(),
  ),
]
```

### 6.7 Update Supabase Edge Function
**File:** `supabase/functions/send-fcm-notification/index.ts`

```typescript
// Before sending notification, check user preferences
const { data: prefs } = await supabase
  .rpc('should_send_notification', {
    p_user_id: userId,
    p_notification_type: notificationType
  });

if (!prefs) {
  console.log(`Notification skipped - user ${userId} disabled ${notificationType}`);
  return;
}

// Continue with FCM send...
```

### 6.8 Add Localization Keys
**Files:** `lib/l10n/app_en.arb`, `lib/l10n/app_ar.arb`

```json
{
  "privacySettings": "Privacy",
  "showProfilePicture": "Show Profile Picture",
  "showProfilePictureSubtitle": "Allow others to see your profile picture",
  "showPhoneNumber": "Show Phone Number",
  "showPhoneNumberSubtitle": "Allow field owners to see your phone",
  "showEmail": "Show Email",
  "showEmailSubtitle": "Allow field owners to see your email",

  "notificationFilters": "Notification Preferences",
  "bookingConfirmations": "Booking Confirmations",
  "bookingConfirmationsSubtitle": "When your booking is confirmed",
  "bookingReminders": "Booking Reminders",
  "bookingRemindersSubtitle": "Reminders before your booking",
  "statusUpdates": "Status Updates",
  "statusUpdatesSubtitle": "When booking status changes",
  "fieldOwnerMessages": "Field Owner Messages",
  "fieldOwnerMessagesSubtitle": "Messages from field owners"
}
```

### 6.9 Tests to Create

**File:** `test/core/utils/notification_filter_helper_test.dart`
- Master toggle disabled blocks all
- Individual toggles work correctly
- System notifications always sent

**File:** `test/features/settings/presentation/cubit/settings_cubit_notification_test.dart`
- Toggle methods emit correct states
- Preferences saved correctly

---

## Testing Checklist

### Phase 1 - Cleanup
- [x] Currency removed from UI
- [x] Date format removed from UI
- [x] Email notifications removed from UI
- [x] Settings page loads without errors
- [x] Flutter analyze passes with no issues

### Phase 2 - Database
- [x] Migration file created
- [x] user_preferences table schema defined
- [x] RLS policies defined
- [x] Helper functions created
- [x] Schema files updated
- [x] Database report updated
- [ ] Migration applied to Supabase (user action required)

### Phase 3 - Data Layer
- [x] Remote data source created
- [x] Repository updated with remote + local sync
- [x] DI updated
- [x] Tests added for data layer
- [x] Offline fallback works

### Phase 4 - Theme Mode
- [x] Dark theme created with premium colors
- [x] Theme cubit created
- [x] Theme switching works
- [x] Theme persists via settings sync
- [x] Tests added (17 passing)

### Phase 5 - Privacy Controls
- [ ] Privacy helper created
- [ ] Profile picture visibility enforced
- [ ] Phone number masking works
- [ ] Email masking works

### Phase 6 - Notification Filtering
- [ ] Edge function checks preferences
- [ ] Booking confirmation filter works
- [ ] Booking reminder filter works
- [ ] Status update filter works
- [ ] Field owner message filter works
- [ ] Master toggle disables all

---

## Files Summary

### Files Deleted (9) - COMPLETED
- `lib/features/settings/presentation/widgets/dialogs/date_format_selector_dialog.dart`
- `lib/features/settings/presentation/widgets/dialogs/date_format_option_tile.dart`
- `lib/features/settings/presentation/widgets/dialogs/currency_selector_dialog.dart`
- `lib/features/settings/presentation/widgets/dialogs/currency_option_tile.dart`
- `lib/core/utils/currency_formatter.dart`
- `lib/features/super_admin/presentation/widgets/premium/settings/system_preferences_currency_tile.dart`
- `lib/features/super_admin/presentation/widgets/premium/settings/system_preferences_date_tile.dart`

### Files Created (7) - COMPLETED
- `supabase/migrations/20251231_create_user_preferences.sql`
- `lib/features/settings/data/datasources/settings_remote_data_source.dart`
- `lib/core/theme/theme_cubit.dart`
- `lib/core/theme/theme_state.dart`
- `test/features/settings/data/datasources/settings_remote_data_source_test.dart`
- `test/features/settings/data/repositories/settings_repository_impl_test.dart`
- `test/core/theme/theme_cubit_test.dart`

### Files Modified (4) - Phase 3 & 4
- `lib/features/settings/data/repositories/settings_repository_impl.dart`
- `lib/core/di/injection_container.dart`
- `lib/core/constants/app_colors.dart`
- `lib/core/constants/app_theme.dart`
- `lib/main.dart`

### Files To Create (Phase 5-6)
- `lib/core/utils/privacy_helper.dart`

---

## Notes

- **Phase 1, 2, 3, 4 Complete:** Cleanup, database, data layer, and theme mode all working
- **User Action Required:** Run migration on Supabase SQL Editor
- **Next Step:** Phase 5 - Implement privacy controls (profile picture, phone, email visibility)
- **Language Setting:** Already working via AppLocaleCubit
- **Push Notifications Master Toggle:** Already working in local storage
- **Theme Mode:** Full dark theme implemented with premium colors (~70% coverage)

---

## Estimated Effort

| Phase | Estimated Time | Files to Create | Files to Modify |
|-------|---------------|-----------------|-----------------|
| Phase 5 | 2-3 hours | 2 | 6-8 |
| Phase 6 | 3-4 hours | 2 | 4-5 |

---

## Quick Reference: Files to Create

### Phase 5 - Privacy Controls
```
lib/core/utils/privacy_helper.dart
lib/features/settings/presentation/widgets/sections/privacy_settings_section.dart
test/core/utils/privacy_helper_test.dart
```

### Phase 6 - Notification Filtering
```
lib/features/notifications/domain/entities/notification_type.dart
lib/core/utils/notification_filter_helper.dart
test/core/utils/notification_filter_helper_test.dart
test/features/settings/presentation/cubit/settings_cubit_notification_test.dart
```

---

*Last Updated: January 3, 2026*
