# 🎯 Incomplete Features - Phased Implementation Plan

**Date:** 2025-12-06
**Approach:** Complete each phase fully before moving to next
**Rule:** NO hiding "coming soon" or TODOs - implement or remove them properly

---

## 📊 CURRENT STATUS VERIFICATION

### ✅ MAP VIEW - **100% COMPLETE!**
**Checked:** Map view is fully implemented and working!
- ✅ `FieldsMapPage` - Complete with interactive map
- ✅ `MapCubit` - State management complete
- ✅ `MapContent` - Map rendering complete
- ✅ Location services - Complete
- ✅ Map filters - Complete
- ✅ Route configured: `/fields-map` (name: 'fieldsMap')
- ✅ User location tracking
- ✅ Field markers
- ✅ Filter functionality

**No work needed!** ✨

---

## 📋 ALL INCOMPLETE ITEMS ORGANIZED BY PHASE

---

## 🔴 PHASE 0: CRITICAL BLOCKERS (1 hour)
**Must complete before ANY production launch**
**Status:** ⏳ Not Started
**Dependencies:** None

### Task 0.1: Deploy Database Schemas (30 minutes)
**Priority:** 🔴 CRITICAL - BLOCKING
**Files:**
- `database_business_hours_schema.sql`
- `database_reviews_schema.sql`

**Steps:**
1. Open Supabase SQL Editor
2. Copy & run `database_business_hours_schema.sql`
3. Copy & run `database_reviews_schema.sql`
4. Verify tables created
5. Run test queries to confirm

**Acceptance Criteria:**
- [ ] `business_hours` table exists in Supabase
- [ ] `reviews` table exists in Supabase
- [ ] RLS policies active
- [ ] Helper functions created
- [ ] Test data can be inserted

**Documentation:** See `DATABASE_DEPLOYMENT_GUIDE.md`

---

### Task 0.2: Fix Placeholder URLs (30 minutes)
**Priority:** 🔴 CRITICAL - BLOCKING
**Files:**
- `lib/features/settings/presentation/constants/settings_constants.dart`

**Current State:**
```dart
static const String privacyPolicyUrl = 'https://example.com/privacy-policy';
static const String termsOfServiceUrl = 'https://example.com/terms-of-service';
static const String helpCenterUrl = 'https://example.com/help';
```

**Implementation Options:**

**Option A: Use Email Links (5 minutes - RECOMMENDED)**
```dart
static const String privacyPolicyUrl = 'mailto:legal@yourapp.com?subject=Privacy Policy Request';
static const String termsOfServiceUrl = 'mailto:legal@yourapp.com?subject=Terms of Service Request';
static const String helpCenterUrl = 'mailto:support@yourapp.com';
```

**Option B: Host Real Documents (4+ hours)**
1. Write privacy policy document
2. Write terms of service document
3. Host on website
4. Update URLs

**Option C: Use In-App Pages (2 hours)**
1. Populate `lib/features/settings/presentation/pages/privacy_policy_page.dart`
2. Populate `lib/features/settings/presentation/pages/terms_of_service_page.dart`
3. Update navigation to use routes instead of URLs

**Decision:** Choose Option A, B, or C

**Acceptance Criteria:**
- [ ] All URLs point to real, accessible resources
- [ ] Privacy policy accessible from settings
- [ ] Terms of service accessible from settings
- [ ] Help center accessible from settings
- [ ] No broken links

---

## 🟡 PHASE 1: QUICK WINS (1 hour)
**Remove "coming soon" messages by implementing already-built features**
**Status:** ⏳ Not Started
**Dependencies:** Phase 0 complete

### Task 1.1: Wire Favorites Feature (5 minutes)
**Priority:** 🟡 HIGH - Easy win
**Files:**
- `lib/features/home/presentation/widgets/home_quick_actions.dart`

**Current Code (lines 99-106):**
```dart
onTap: () {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text(HomeConstants.favoritesComingSoonMessage),
      behavior: SnackBarBehavior.floating,
    ),
  );
},
```

**New Code:**
```dart
onTap: () => context.pushNamed('favorites'),
```

**Verification:**
- Favorites feature is 100% complete (verified in DI container)
- Route exists: `/favorites`
- Page exists: `lib/features/favorites/presentation/pages/favorites_page.dart`

**Acceptance Criteria:**
- [ ] Clicking "Favorites" on home opens favorites page
- [ ] No "coming soon" message shown
- [ ] User can view their favorite fields
- [ ] User can remove favorites

---

### Task 1.2: Implement Support Feature (10 minutes)
**Priority:** 🟡 HIGH - User satisfaction
**Files:**
- `lib/features/bookings/presentation/widgets/booking_details_actions.dart`

**Current Code (line 50):**
```dart
'Support feature coming soon!',
```

**Implementation:**
```dart
// Add this function to the widget:
Future<void> _contactSupport(BuildContext context, String bookingId) async {
  final Uri emailUri = Uri(
    scheme: 'mailto',
    path: 'support@yourapp.com',
    queryParameters: {
      'subject': 'Booking Support - $bookingId',
      'body': 'Please describe your issue:\n\n',
    },
  );

  if (await canLaunchUrl(emailUri)) {
    await launchUrl(emailUri);
  } else {
    if (context.mounted) {
      SnackbarHelper.showError(context, 'Could not open email client');
    }
  }
}

// Replace "coming soon" with:
onPressed: () => _contactSupport(context, booking.id),
```

**Dependencies:**
- `url_launcher` package (already installed: `^6.3.2`)

**Acceptance Criteria:**
- [ ] "Contact Support" button opens email client
- [ ] Email pre-filled with booking ID
- [ ] No "coming soon" message
- [ ] Error handling if email client unavailable

---

### Task 1.3: Update "Coming Soon" Home Card (15 minutes)
**Priority:** 🟡 MEDIUM - Accuracy
**Files:**
- `lib/features/home/presentation/widgets/home_upcoming_features.dart`
- `lib/features/home/presentation/constants/home_constants.dart`

**Current State:**
Shows as "coming soon":
- ✅ Browse and search sports fields (DONE!)
- ✅ Book time slots instantly (DONE!)
- ❌ Secure online payments (NOT DONE)
- ✅ Review and rate fields (DONE!)

**Implementation Options:**

**Option A: Remove the entire card** (5 minutes)
```dart
// In the parent widget, comment out or remove:
// const HomeUpcomingFeatures(),
```

**Option B: Update to show only Payment** (15 minutes)
```dart
// Update home_upcoming_features.dart to show only:
const _FeatureItem(
  icon: Icons.payment,
  text: 'Secure online payments - Coming in Phase 7',
),
```

**Decision:** Choose Option A or B

**Acceptance Criteria:**
- [ ] No misleading "coming soon" for completed features
- [ ] Users see accurate information
- [ ] Home page still looks good

---

### Task 1.4: Update Documentation Comments (5 minutes)
**Priority:** 🟢 LOW - Code accuracy
**Files:**
- `lib/features/fields/presentation/pages/field_details_page.dart`

**Current (line 20):**
```dart
/// - Reviews (coming soon)
```

**Update to:**
```dart
/// - Reviews and ratings
```

**Additional Updates:**
- Remove any other outdated "coming soon" comments
- Update feature lists to reflect current state

**Acceptance Criteria:**
- [ ] All code comments accurate
- [ ] No misleading documentation

---

## 🟠 PHASE 2: ERROR LOGGING & MONITORING (6 hours)
**Set up production error tracking**
**Status:** ⏳ Not Started
**Dependencies:** Phase 0-1 complete

### Task 2.1: Setup Firebase Crashlytics (4 hours)
**Priority:** 🟡 HIGH - Production monitoring
**Files:**
- `lib/core/services/error_logging_service.dart`
- `lib/main.dart`
- `pubspec.yaml`
- `android/app/build.gradle`
- `ios/Runner/GoogleService-Info.plist`

**Current TODOs:**
- Line 158: `// TODO: Implement Firebase Crashlytics for production error tracking`
- Line 220: `// TODO: Implement local logging to file or database`
- Line 234: `// TODO: Implement log cleanup for local storage`
- Line 240: `// TODO: Implement retrieval of recent logs from local storage`

**Implementation Steps:**

1. **Add Firebase to project** (1 hour)
   ```bash
   # Install FlutterFire CLI
   dart pub global activate flutterfire_cli

   # Configure Firebase for your project
   flutterfire configure
   ```

2. **Add dependencies** (10 minutes)
   ```yaml
   # pubspec.yaml
   dependencies:
     firebase_core: ^2.24.2
     firebase_crashlytics: ^3.4.9
   ```

3. **Initialize Firebase** (30 minutes)
   ```dart
   // lib/main.dart
   import 'package:firebase_core/firebase_core.dart';
   import 'package:firebase_crashlytics/firebase_crashlytics.dart';
   import 'firebase_options.dart';

   void main() async {
     WidgetsFlutterBinding.ensureInitialized();

     // Initialize Firebase
     await Firebase.initializeApp(
       options: DefaultFirebaseOptions.currentPlatform,
     );

     // Pass all uncaught errors to Crashlytics
     FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

     // Pass all uncaught asynchronous errors
     PlatformDispatcher.instance.onError = (error, stack) {
       FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
       return true;
     };

     await initDependencies();
     runApp(const MyApp());
   }
   ```

4. **Implement Crashlytics in ErrorLoggingService** (2 hours)
   ```dart
   // lib/core/services/error_logging_service.dart

   import 'package:firebase_crashlytics/firebase_crashlytics.dart';

   Future<void> _logToRemoteService(
     String error,
     StackTrace? stackTrace,
     Map<String, dynamic>? context,
   ) async {
     try {
       // Set custom keys for context
       if (context != null) {
         context.forEach((key, value) {
           FirebaseCrashlytics.instance.setCustomKey(key, value.toString());
         });
       }

       // Record error
       await FirebaseCrashlytics.instance.recordError(
         error,
         stackTrace,
         reason: context?['reason'],
         fatal: context?['fatal'] ?? false,
       );
     } catch (e) {
       debugPrint('[Crashlytics Error] Failed to log: $e');
     }
   }

   // Implement local logging
   Future<void> _logToLocalStorage(...) async {
     // Use shared_preferences or hive
     final prefs = await SharedPreferences.getInstance();
     final logs = prefs.getStringList('error_logs') ?? [];
     logs.add(jsonEncode({
       'error': error,
       'timestamp': DateTime.now().toIso8601String(),
       'context': context,
     }));

     // Keep only last 100 logs
     if (logs.length > 100) {
       logs.removeRange(0, logs.length - 100);
     }

     await prefs.setStringList('error_logs', logs);
   }
   ```

**Acceptance Criteria:**
- [ ] Firebase configured for Android
- [ ] Firebase configured for iOS
- [ ] Crashlytics recording errors
- [ ] Test crash reported successfully
- [ ] Custom context logged with errors
- [ ] Local logs stored
- [ ] Can retrieve recent logs
- [ ] Old logs cleaned up automatically

---

### Task 2.2: Test Error Logging (1 hour)
**Priority:** 🟡 HIGH
**Steps:**
1. Force a test crash
2. Verify it appears in Firebase Console
3. Test non-fatal error logging
4. Verify context data logged
5. Test local log storage
6. Test log retrieval

**Acceptance Criteria:**
- [ ] Crashes appear in Firebase Console within 5 minutes
- [ ] Non-fatal errors logged
- [ ] Context data visible in Crashlytics
- [ ] Local logs accessible
- [ ] No performance impact

---

### Task 2.3: Remove TODO Comments (30 minutes)
**Priority:** 🟢 LOW
**Files:**
- `lib/core/services/error_logging_service.dart`

**Action:**
Remove all 4 TODO comments after implementing features

**Acceptance Criteria:**
- [ ] No TODOs in error_logging_service.dart

---

## 🟢 PHASE 3: DARK THEME (10 hours)
**Implement dark mode throughout app**
**Status:** ⏳ Not Started
**Dependencies:** Phase 0-2 complete

### Task 3.1: Define Dark Color Scheme (2 hours)
**Priority:** 🟡 MEDIUM
**Files:**
- `lib/core/constants/app_colors.dart`
- `lib/core/constants/app_theme.dart`

**Current TODO:**
- `main.dart:115`: `// TODO: Add dark theme when ready`
- `app_theme.dart:114`: `// TODO: Implement dark theme when needed`

**Implementation:**

```dart
// lib/core/constants/app_colors.dart

class AppColors {
  // ... existing colors ...

  // Dark Theme Colors
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkCard = Color(0xFF2C2C2C);
  static const Color darkPrimary = Color(0xFF7C3AED);  // Lighter purple for dark mode
  static const Color darkSecondary = Color(0xFF10B981);
  static const Color darkTextPrimary = Color(0xFFE5E5E5);
  static const Color darkTextSecondary = Color(0xFFB3B3B3);
  static const Color darkBorder = Color(0xFF3F3F3F);
  static const Color darkError = Color(0xFFEF4444);
  static const Color darkSuccess = Color(0xFF10B981);
  static const Color darkWarning = Color(0xFFF59E0B);
  static const Color darkInfo = Color(0xFF3B82F6);
}
```

```dart
// lib/core/constants/app_theme.dart

class AppTheme {
  // ... existing light theme ...

  /// Dark theme configuration
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,

    colorScheme: ColorScheme.dark(
      primary: AppColors.darkPrimary,
      secondary: AppColors.darkSecondary,
      surface: AppColors.darkSurface,
      background: AppColors.darkBackground,
      error: AppColors.darkError,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: AppColors.darkTextPrimary,
      onBackground: AppColors.darkTextPrimary,
      onError: Colors.white,
    ),

    scaffoldBackgroundColor: AppColors.darkBackground,

    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.darkSurface,
      foregroundColor: AppColors.darkTextPrimary,
      elevation: 0,
    ),

    cardTheme: CardTheme(
      color: AppColors.darkCard,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),

    // ... rest of theme configuration ...
  );
}
```

**Acceptance Criteria:**
- [ ] Dark colors defined
- [ ] Dark theme created
- [ ] All color contrasts meet WCAG AA standards
- [ ] Dark theme looks good visually

---

### Task 3.2: Implement Theme Toggle (3 hours)
**Priority:** 🟡 MEDIUM
**Files:**
- `lib/main.dart`
- `lib/features/settings/domain/entities/user_preferences.dart`
- `lib/features/settings/presentation/pages/user_settings_page.dart`

**Implementation:**

1. **Add theme mode to user preferences** (1 hour)
   ```dart
   // user_preferences.dart
   class UserPreferences extends Equatable {
     final bool emailNotifications;
     final bool pushNotifications;
     final bool bookingReminders;
     final ThemeMode themeMode; // ADD THIS

     const UserPreferences({
       this.emailNotifications = true,
       this.pushNotifications = true,
       this.bookingReminders = true,
       this.themeMode = ThemeMode.system, // Default to system
     });
   }
   ```

2. **Update settings page with theme toggle** (1 hour)
   ```dart
   // Add to user_settings_page.dart
   ListTile(
     leading: Icon(Icons.dark_mode),
     title: Text('Theme'),
     subtitle: Text('Choose your preferred theme'),
     trailing: SegmentedButton<ThemeMode>(
       segments: [
         ButtonSegment(value: ThemeMode.light, label: Text('Light')),
         ButtonSegment(value: ThemeMode.system, label: Text('Auto')),
         ButtonSegment(value: ThemeMode.dark, label: Text('Dark')),
       ],
       selected: {currentTheme},
       onSelectionChanged: (Set<ThemeMode> newSelection) {
         // Update theme
       },
     ),
   );
   ```

3. **Wire theme to MaterialApp** (1 hour)
   ```dart
   // lib/main.dart
   class MyApp extends StatelessWidget {
     @override
     Widget build(BuildContext context) {
       return BlocBuilder<SettingsCubit, SettingsState>(
         builder: (context, state) {
           final themeMode = state is SettingsLoaded
             ? state.preferences.themeMode
             : ThemeMode.system;

           return MaterialApp.router(
             theme: AppTheme.lightTheme,
             darkTheme: AppTheme.darkTheme, // ADD THIS
             themeMode: themeMode, // ADD THIS
             // ... rest of config
           );
         },
       );
     }
   }
   ```

**Acceptance Criteria:**
- [ ] Theme toggle appears in settings
- [ ] Can switch between Light/Auto/Dark
- [ ] Theme persists after app restart
- [ ] System theme option works correctly

---

### Task 3.3: Test All Screens in Dark Mode (4 hours)
**Priority:** 🟡 MEDIUM
**Action:** Test every screen, fix any contrast/visibility issues

**Screens to Test:**
- [ ] Home page
- [ ] Field list
- [ ] Field details
- [ ] Search page
- [ ] Bookings
- [ ] Reviews
- [ ] Owner dashboard
- [ ] Super admin dashboard
- [ ] Settings pages
- [ ] Login/Register

**Common Issues to Fix:**
- Text contrast too low
- Images don't look good on dark background
- Borders not visible
- Buttons hard to see

**Acceptance Criteria:**
- [ ] All screens tested in dark mode
- [ ] No contrast issues
- [ ] All text readable
- [ ] All interactive elements visible
- [ ] Images/icons look good

---

### Task 3.4: Remove TODO Comments (10 minutes)
**Priority:** 🟢 LOW
**Files:**
- `lib/main.dart`
- `lib/core/constants/app_theme.dart`

**Action:**
Remove TODO comments about dark theme

**Acceptance Criteria:**
- [ ] No TODOs about dark theme

---

## 🔵 PHASE 4: HIVE LOCAL STORAGE (3 hours)
**Set up offline caching**
**Status:** ⏳ Not Started
**Dependencies:** Phase 0-3 complete

### Task 4.1: Initialize Hive (2 hours)
**Priority:** 🟢 MEDIUM
**Files:**
- `lib/main.dart`
- Create: `lib/core/storage/hive_boxes.dart`

**Current TODO:**
- `main.dart:47`: `// TODO: Open Hive boxes when needed`

**Implementation:**

```dart
// lib/core/storage/hive_boxes.dart
class HiveBoxes {
  static const String cachedFields = 'cached_fields';
  static const String cachedBookings = 'cached_bookings';
  static const String userPreferences = 'user_preferences';
  static const String errorLogs = 'error_logs';

  static Future<void> init() async {
    await Hive.initFlutter();

    // Open boxes
    await Hive.openBox(cachedFields);
    await Hive.openBox(cachedBookings);
    await Hive.openBox(userPreferences);
    await Hive.openBox(errorLogs);
  }

  static Future<void> close() async {
    await Hive.close();
  }
}
```

```dart
// lib/main.dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await HiveBoxes.init();

  // Initialize Firebase
  await Firebase.initializeApp(...);

  // Initialize dependencies
  await initDependencies();

  runApp(const MyApp());
}
```

**Use Cases:**
1. Cache field data for offline viewing
2. Store error logs locally
3. Cache user preferences
4. Store booking data for offline access

**Acceptance Criteria:**
- [ ] Hive initialized successfully
- [ ] All boxes opened
- [ ] Can read/write to boxes
- [ ] Data persists across app restarts

---

### Task 4.2: Implement Offline Field Caching (1 hour)
**Priority:** 🟢 LOW
**Files:**
- `lib/features/fields/data/datasources/field_local_datasource.dart` (create)
- `lib/features/fields/data/repositories/field_repository_impl.dart`

**Implementation:**
```dart
// When fetching fields:
// 1. Return cached data immediately
// 2. Fetch from network in background
// 3. Update cache with new data
```

**Acceptance Criteria:**
- [ ] Fields cached locally
- [ ] Offline viewing works
- [ ] Cache updates when online

---

### Task 4.3: Remove TODO Comment (5 minutes)
**Priority:** 🟢 LOW
**Files:**
- `lib/main.dart`

**Action:**
Remove TODO about Hive boxes

**Acceptance Criteria:**
- [ ] No TODO about Hive

---

## 🟣 PHASE 5: DYNAMIC SPORT CATEGORIES (3 hours)
**Load sport categories from database instead of hard-coding**
**Status:** ⏳ Not Started
**Dependencies:** Phase 0-4 complete

### Task 5.1: Create Sport Categories Table (30 minutes)
**Priority:** 🟢 LOW
**Files:**
- Create: `supabase/sport_categories_schema.sql`

**Implementation:**
```sql
CREATE TABLE sport_categories (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL UNIQUE,
  icon TEXT,
  display_order INTEGER DEFAULT 0,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Insert default categories
INSERT INTO sport_categories (name, icon, display_order) VALUES
  ('Football', 'sports_soccer', 1),
  ('Basketball', 'sports_basketball', 2),
  ('Tennis', 'sports_tennis', 3),
  ('Volleyball', 'sports_volleyball', 4),
  ('Padel', 'sports_tennis', 5);
```

**Acceptance Criteria:**
- [ ] Table created in Supabase
- [ ] Default categories inserted
- [ ] Can query categories

---

### Task 5.2: Fetch Categories Dynamically (2 hours)
**Priority:** 🟢 LOW
**Files:**
- `lib/features/super_admin/presentation/pages/create_field_page.dart`
- `lib/features/fields/presentation/cubit/fields_cubit.dart`

**Current TODO:**
- Line 110: `// TODO: Load sport categories from fields feature`

**Implementation:**
1. Fetch categories from `sport_categories` table
2. Replace hard-coded list
3. Display in dropdown

**Acceptance Criteria:**
- [ ] Categories fetched from database
- [ ] Dropdown shows dynamic list
- [ ] Can add new categories via Super Admin
- [ ] Categories cached for performance

---

### Task 5.3: Remove TODO Comment (5 minutes)
**Priority:** 🟢 LOW
**Files:**
- `lib/features/super_admin/presentation/pages/create_field_page.dart`

**Action:**
Remove TODO about loading categories

**Acceptance Criteria:**
- [ ] No TODO about sport categories

---

## 🟤 PHASE 6: ADMIN MANAGEMENT FEATURES (4 hours)
**Complete admin activate/deactivate functionality**
**Status:** ⏳ Not Started
**Dependencies:** Phase 0-5 complete

### Task 6.1: Implement Admin Activate/Deactivate (3 hours)
**Priority:** 🟢 LOW
**Files:**
- `lib/features/super_admin/presentation/widgets/admin_details/admin_details_view.dart`
- `lib/features/super_admin/domain/usecases/activate_admin_usecase.dart` (create)
- `lib/features/super_admin/domain/usecases/deactivate_admin_usecase.dart` (create)

**Current:**
Shows "Activate/Deactivate feature coming soon"

**Implementation:**
Similar to user activate/deactivate, but for admin accounts

**Acceptance Criteria:**
- [ ] Can activate admin accounts
- [ ] Can deactivate admin accounts
- [ ] Confirmation dialog shown
- [ ] Updates reflect immediately
- [ ] No "coming soon" message

---

### Task 6.2: Implement Maintenance Mode (1 hour)
**Priority:** 🟢 LOW
**Files:**
- `lib/features/super_admin/presentation/widgets/settings/platform_config_section.dart`
- Create backend flag/RLS policy

**Current:**
Shows "Maintenance mode feature coming soon"

**Implementation:**
1. Add `maintenance_mode` flag to settings table
2. Create use case to toggle
3. Check flag before allowing user actions
4. Show maintenance page if enabled

**Acceptance Criteria:**
- [ ] Can enable/disable maintenance mode
- [ ] When enabled, regular users see maintenance page
- [ ] Super admins can still access
- [ ] No "coming soon" message

---

## 📊 PHASE SUMMARY TABLE

| Phase | Tasks | Effort | Priority | Blocks Launch? |
|-------|-------|--------|----------|----------------|
| **Phase 0: Blockers** | 2 | 1h | 🔴 Critical | YES |
| **Phase 1: Quick Wins** | 4 | 1h | 🟡 High | No |
| **Phase 2: Error Logging** | 3 | 6h | 🟡 High | No |
| **Phase 3: Dark Theme** | 4 | 10h | 🟡 Medium | No |
| **Phase 4: Hive Storage** | 3 | 3h | 🟢 Medium | No |
| **Phase 5: Sport Categories** | 3 | 3h | 🟢 Low | No |
| **Phase 6: Admin Features** | 2 | 4h | 🟢 Low | No |

**Total Effort:** ~28 hours
**Critical Path:** Phase 0 (1 hour) - then can launch!

---

## 🎯 EXECUTION STRATEGY

### Week 1: Launch Preparation
**Goal:** Remove blockers, launch MVP

**Day 1-2 (2 hours):**
- ✅ Phase 0: Critical blockers
- ✅ Phase 1: Quick wins

**Result:** Can launch! 🚀

---

### Week 2-3: Production Hardening
**Goal:** Error monitoring, polish

**Time Investment: 10 hours**
- ✅ Phase 2: Error logging (6h)
- ✅ Phase 3: Start dark theme (4h)

**Result:** Production-ready, monitored app

---

### Month 2: Polish & Features
**Goal:** Complete dark theme, add nice-to-haves

**Time Investment: 17 hours**
- ✅ Phase 3: Complete dark theme (6h remaining)
- ✅ Phase 4: Hive storage (3h)
- ✅ Phase 5: Sport categories (3h)
- ✅ Phase 6: Admin features (4h)
- Testing & bug fixes (varies)

**Result:** Polished, feature-complete app

---

## ✅ PROGRESS TRACKING

### Phase 0: Critical Blockers
- [ ] Task 0.1: Deploy DB schemas
- [ ] Task 0.2: Fix placeholder URLs

### Phase 1: Quick Wins
- [ ] Task 1.1: Wire Favorites
- [ ] Task 1.2: Support feature
- [ ] Task 1.3: Update home card
- [ ] Task 1.4: Update comments

### Phase 2: Error Logging
- [ ] Task 2.1: Firebase Crashlytics
- [ ] Task 2.2: Test logging
- [ ] Task 2.3: Remove TODOs

### Phase 3: Dark Theme
- [ ] Task 3.1: Define colors
- [ ] Task 3.2: Theme toggle
- [ ] Task 3.3: Test all screens
- [ ] Task 3.4: Remove TODOs

### Phase 4: Hive Storage
- [ ] Task 4.1: Initialize Hive
- [ ] Task 4.2: Field caching
- [ ] Task 4.3: Remove TODOs

### Phase 5: Sport Categories
- [ ] Task 5.1: Create table
- [ ] Task 5.2: Fetch dynamically
- [ ] Task 5.3: Remove TODOs

### Phase 6: Admin Features
- [ ] Task 6.1: Admin activate/deactivate
- [ ] Task 6.2: Maintenance mode

---

## 🔄 INTEGRATION WITH MAIN PLAN

After completing all phases here, return to main roadmap:

**From `REMAINING_FEATURES_REPORT.md`:**

### Already Complete:
- ✅ Phase 0-6 (this document)

### Next Phases:
- ⏳ **Phase 7: Advanced Features** (120-160 hours)
  - Payment integration
  - Promotions & discounts
  - Multi-language support
  - Social features
  - Tournament system

- ⏳ **Phase 8: Production Polish** (Ongoing)
  - Performance optimization
  - Additional unit tests
  - User feedback iterations
  - App store optimization

---

## 📝 NOTES

### Important Rules:
1. ✅ **Complete each phase fully before moving to next**
2. ✅ **NO hiding "coming soon" or TODOs - implement or remove properly**
3. ✅ **Test thoroughly after each phase**
4. ✅ **Update documentation as you go**
5. ✅ **Commit after each task completion**

### Map View Status:
- ✅ **100% COMPLETE** - No work needed!
- Route: `/fields-map`
- Features: Interactive map, markers, filters, user location

### Features Already Complete (Don't Need Phase):
- ✅ Business Hours
- ✅ Reviews & Ratings
- ✅ Map View
- ✅ Favorites (just needs 5-min button fix in Phase 1)
- ✅ All core booking features
- ✅ All admin features

---

**Last Updated:** 2025-12-06
**Current Phase:** Phase 0 (Not Started)
**Estimated Completion:** 2-4 weeks (if working part-time)

---

## 🎯 RECOMMENDED START

**Start NOW with Phase 0 (1 hour):**
1. Deploy database schemas (30 min)
2. Fix placeholder URLs (30 min)

**Then Phase 1 (1 hour):**
1. Wire Favorites (5 min)
2. Implement Support (10 min)
3. Update home card (15 min)
4. Update comments (5 min)

**Total: 2 hours to launch-ready MVP!** 🚀
