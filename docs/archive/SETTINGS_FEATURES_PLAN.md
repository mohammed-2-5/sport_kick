# Settings Features Implementation Plan

## Overview
This plan covers the implementation of 5 settings features for the Sport Kick app.

---

## Feature 2: Date Format Settings

### Current State
- Not implemented
- No `dateFormat` field in `UserPreferencesEntity`

### Implementation Steps

#### Step 2.1: Update Entity
**File:** `lib/features/settings/domain/entities/user_preferences_entity.dart`
- Add `dateFormat` field (String: 'DD/MM/YYYY', 'MM/DD/YYYY', 'YYYY-MM-DD')
- Default: 'DD/MM/YYYY'

#### Step 2.2: Update Model
**File:** `lib/features/settings/data/models/user_preferences_model.dart`
- Add `dateFormat` to model
- Add to JSON serialization

#### Step 2.3: Update Cubit
**File:** `lib/features/settings/presentation/cubit/settings_cubit.dart`
- Add `updateDateFormat()` method

#### Step 2.4: Create Date Format Selector Dialog
**File:** `lib/features/settings/presentation/widgets/dialogs/date_format_selector_dialog.dart`
- Radio options for date formats
- Preview of current date in selected format

#### Step 2.5: Update UI
**File:** `lib/features/super_admin/presentation/widgets/settings/system_preferences_section.dart`
- Replace "Coming Soon" with dialog trigger

#### Step 2.6: Create Date Formatter Utility
**File:** `lib/core/utils/date_formatter.dart`
- Global formatter that uses stored preference
- Use throughout app for consistent date display

---

## Feature 3: Currency Settings

### Current State
- Not implemented
- No `currency` field in `UserPreferencesEntity`

### Implementation Steps

#### Step 3.1: Update Entity
**File:** `lib/features/settings/domain/entities/user_preferences_entity.dart`
- Add `currency` field (String: 'EGP', 'USD', 'EUR', 'SAR')
- Default: 'EGP'

#### Step 3.2: Update Model
**File:** `lib/features/settings/data/models/user_preferences_model.dart`
- Add `currency` to model
- Add to JSON serialization

#### Step 3.3: Update Cubit
**File:** `lib/features/settings/presentation/cubit/settings_cubit.dart`
- Add `updateCurrency()` method

#### Step 3.4: Create Currency Selector Dialog
**File:** `lib/features/settings/presentation/widgets/dialogs/currency_selector_dialog.dart`
- Radio options with currency symbols
- Options: EGP (E£), USD ($), EUR (€), SAR (﷼)

#### Step 3.5: Update UI
**File:** `lib/features/super_admin/presentation/widgets/settings/system_preferences_section.dart`
- Replace "Coming Soon" with dialog trigger

#### Step 3.6: Create Currency Formatter Utility
**File:** `lib/core/utils/currency_formatter.dart`
- Format prices using stored currency preference
- Use throughout app for price display

---

## Feature 4: Notification Settings

### Current State
- Entity already has notification fields
- Cubit already has toggle methods
- UI needs to connect to existing infrastructure

### Implementation Steps

#### Step 4.1: Create Notification Settings Page
**File:** `lib/features/super_admin/presentation/pages/notification_settings_page.dart`
- Full page with all notification toggles
- Uses existing SettingsCubit

#### Step 4.2: Update UI - System Preferences
**File:** `lib/features/super_admin/presentation/widgets/settings/system_preferences_section.dart`
- Replace "Coming Soon" with navigation to notification settings page

#### Step 4.3: Add Route
**File:** `lib/core/routes/go_router_config.dart`
- Add route for `notificationSettings`

#### Notification Options (Already in Entity):
- Push Notifications (master toggle)
- Email Notifications (master toggle)
- Booking Confirmation Notifications
- Booking Reminder Notifications
- Booking Status Notifications
- Field Owner Messages Notifications

---

## Feature 6: Login Activity

### Current State
- Not implemented
- No login activity tracking

### Implementation Steps

#### Step 6.1: Create Login Activity Entity
**File:** `lib/features/auth/domain/entities/login_activity_entity.dart`
```dart
class LoginActivityEntity {
  final String id;
  final String userId;
  final DateTime timestamp;
  final String ipAddress;
  final String deviceType; // 'mobile', 'web', 'desktop'
  final String deviceName;
  final String location; // City, Country (from IP)
  final bool isCurrentSession;
  final LoginStatus status; // success, failed, blocked
}
```

#### Step 6.2: Create Supabase Table
**Table:** `login_activity`
```sql
CREATE TABLE login_activity (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES auth.users(id),
  timestamp TIMESTAMPTZ DEFAULT NOW(),
  ip_address TEXT,
  device_type TEXT,
  device_name TEXT,
  location TEXT,
  status TEXT DEFAULT 'success',
  created_at TIMESTAMPTZ DEFAULT NOW()
);
```

#### Step 6.3: Create Data Source
**File:** `lib/features/auth/data/datasources/login_activity_datasource.dart`
- Log login events
- Get login history for user

#### Step 6.4: Update Auth Flow
**File:** `lib/features/auth/presentation/cubit/auth_cubit.dart`
- Log successful logins
- Log failed login attempts

#### Step 6.5: Create Login Activity Page
**File:** `lib/features/super_admin/presentation/pages/login_activity_page.dart`
- List of recent login events
- Device icons, timestamps, locations
- Option to logout other sessions

#### Step 6.6: Update UI
**File:** `lib/features/super_admin/presentation/widgets/settings/security_section.dart`
- Replace "Coming Soon" with navigation to login activity page

#### Step 6.7: Add Route
**File:** `lib/core/routes/go_router_config.dart`
- Add route for `loginActivity`

---

## Feature 7: Operating Hours (Platform-wide)

### Current State
- Per-field business hours exist
- Platform-wide default hours do not exist

### Implementation Steps

#### Step 7.1: Create Platform Settings Entity
**File:** `lib/features/super_admin/domain/entities/platform_settings_entity.dart`
```dart
class PlatformSettingsEntity {
  final String id;
  final Map<String, DayHours> defaultOperatingHours;
  final bool enforceOperatingHours;
  final DateTime updatedAt;
}

class DayHours {
  final bool isOpen;
  final String openTime; // "08:00"
  final String closeTime; // "22:00"
}
```

#### Step 7.2: Create Supabase Table
**Table:** `platform_settings`
```sql
CREATE TABLE platform_settings (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  setting_key TEXT UNIQUE NOT NULL,
  setting_value JSONB,
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  updated_by UUID REFERENCES auth.users(id)
);
```

#### Step 7.3: Create Data Source
**File:** `lib/features/super_admin/data/datasources/platform_settings_datasource.dart`
- Get/update platform settings

#### Step 7.4: Create Operating Hours Page
**File:** `lib/features/super_admin/presentation/pages/platform_operating_hours_page.dart`
- Week view with day toggles
- Time pickers for open/close
- "Apply to all new fields" option

#### Step 7.5: Update UI
**File:** `lib/features/super_admin/presentation/widgets/settings/platform_config_section.dart`
- Replace "Coming Soon" with navigation to operating hours page

#### Step 7.6: Add Route
**File:** `lib/core/routes/go_router_config.dart`
- Add route for `platformOperatingHours`

---

## Files to Hide (Features Not Being Implemented Now)

### Features to Remove from UI:
1. **Language Selection** - Remove from system_preferences_section.dart
2. **2FA Settings** - Remove from security_section.dart
3. **Payment Settings** - Remove from platform_config_section.dart
4. **Email Templates** - Remove from platform_config_section.dart
5. **Maintenance Mode** - Remove from platform_config_section.dart

---

## Implementation Order

### Phase 1: Quick Wins (Date Format & Currency)
1. Update UserPreferencesEntity with dateFormat and currency
2. Update model
3. Create selector dialogs
4. Create formatter utilities
5. Connect UI

### Phase 2: Notification Settings
1. Create notification settings page
2. Add route
3. Connect to existing cubit

### Phase 3: Login Activity
1. Create database table
2. Create entities and data sources
3. Update auth flow to log events
4. Create login activity page
5. Add route

### Phase 4: Platform Operating Hours
1. Create database table
2. Create entities and data sources
3. Create operating hours editor page
4. Add route

---

## Estimated Complexity

| Feature | Files to Create/Modify | Complexity |
|---------|----------------------|------------|
| Date Format | 6 files | Low |
| Currency | 6 files | Low |
| Notification Settings | 3 files | Low |
| Login Activity | 8 files + DB | Medium |
| Operating Hours | 6 files + DB | Medium |

---

## Notes

- All features use existing design system (Premium widgets)
- Settings stored in SharedPreferences (local) and Supabase (remote sync)
- Login Activity requires new Supabase table
- Operating Hours requires new Supabase table
