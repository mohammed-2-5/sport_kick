# GoRouter Migration Guide

## Overview
This document outlines the migration from the old `AppRouter` (using `Navigator.pushNamed`) to the new `GoRouter` configuration.

## Quick Reference: Navigation Method Changes

### Old Way (Navigator)
```dart
// Push a route
Navigator.pushNamed(context, AppRouter.fieldDetails, arguments: fieldId);

// Push with replacement
Navigator.pushReplacementNamed(context, AppRouter.home);

// Push and remove all previous routes
Navigator.pushNamedAndRemoveUntil(context, AppRouter.home, (route) => false);

// Pop
Navigator.pop(context);
Navigator.pop(context, result);
```

### New Way (GoRouter)
```dart
// Push a route (by name)
context.pushNamed('fieldDetails', pathParameters: {'fieldId': fieldId});

// Push a route (by path)
context.push('/fields/$fieldId');

// Go to route (replaces current)
context.goNamed('home');
context.go('/home');

// Pop
context.pop();
context.pop(result);

// Pass complex objects
context.pushNamed('createBooking', extra: fieldObject);
```

## Route Name Mapping

| Old Route Constant | New Route Name | Path | Notes |
|-------------------|----------------|------|-------|
| `AppRouter.splash` | `'splash'` | `/` | Initial route |
| `AppRouter.login` | `'login'` | `/login` | - |
| `AppRouter.register` | `'register'` | `/register` | - |
| `AppRouter.adminLogin` | `'adminLogin'` | `/admin-login` | - |
| `AppRouter.changePassword` | `'changePassword'` | `/change-password` | Query param: `?isFirstLogin=true` |
| `AppRouter.forgotPassword` | `'forgotPassword'` | `/forgot-password` | - |
| `AppRouter.citySelection` | `'citySelection'` | `/city-selection` | - |
| `AppRouter.home` | `'home'` | `/home` | - |
| `AppRouter.profile` | `'profile'` | `/profile` | - |
| `AppRouter.editProfile` | `'editProfile'` | `/edit-profile` | - |
| `AppRouter.settings` | `'settings'` | `/settings` | - |
| `AppRouter.privacyPolicy` | `'privacyPolicy'` | `/privacy-policy` | - |
| `AppRouter.termsOfService` | `'termsOfService'` | `/terms-of-service` | - |
| `AppRouter.fieldsList` | `'fieldsList'` | `/fields` | - |
| `AppRouter.fieldDetails` | `'fieldDetails'` | `/fields/:fieldId` | Path param: `fieldId` |
| `AppRouter.fieldsMap` | `'fieldsMap'` | `/fields-map` | - |
| `AppRouter.search` | `'search'` | `/search` | - |
| `AppRouter.favorites` | `'favorites'` | `/favorites` | - |
| `AppRouter.createBooking` | `'createBooking'` | `/create-booking` | Extra: `FieldEntity` |
| `AppRouter.myBookings` | `'myBookings'` | `/my-bookings` | - |
| `AppRouter.bookingDetails` | `'bookingDetails'` | `/bookings/:bookingId` | Path param: `bookingId` |
| `AppRouter.createReview` | `'createReview'` | `/create-review` | Extra: `Map<String, dynamic>` |
| `AppRouter.allReviews` | `'allReviews'` | `/all-reviews` | Extra: `Map<String, dynamic>` |
| `AppRouter.ownerDashboard` | `'ownerDashboard'` | `/owner/dashboard` | - |
| `AppRouter.ownerBookings` | `'ownerBookings'` | `/owner/bookings` | - |
| `AppRouter.ownerCreateManualBooking` | `'ownerCreateManualBooking'` | `/owner/bookings/manual` | - |
| `AppRouter.ownerFields` | `'ownerFields'` | `/owner/fields` | - |
| `AppRouter.ownerAddField` | `'ownerAddField'` | `/owner/fields/add` | - |
| `AppRouter.ownerEditField` | `'ownerEditField'` | `/owner/fields/edit` | Extra: `FieldEntity` |
| `AppRouter.ownerAnalytics` | `'ownerAnalytics'` | `/owner/analytics` | - |
| `AppRouter.ownerSettings` | `'ownerSettings'` | `/owner/settings` | - |
| `AppRouter.ownerProfile` | `'ownerProfile'` | `/owner/profile` | - |
| `AppRouter.superAdminDashboard` | `'superAdminDashboard'` | `/super-admin/dashboard` | - |
| `AppRouter.superAdminCreateAdmin` | `'superAdminCreateAdmin'` | `/super-admin/create-admin` | - |
| `AppRouter.superAdminCreateField` | `'superAdminCreateField'` | `/super-admin/create-field` | - |
| `AppRouter.superAdminAdmins` | `'superAdminAdmins'` | `/super-admin/admins` | - |
| `AppRouter.superAdminAdminDetails` | `'superAdminAdminDetails'` | `/super-admin/admin-details` | Extra: `UserEntity` |
| `AppRouter.superAdminUsers` | `'superAdminUsers'` | `/super-admin/users` | - |
| `AppRouter.superAdminUserDetails` | `'superAdminUserDetails'` | `/super-admin/user-details` | Extra: `UserEntity` |
| `AppRouter.superAdminCities` | `'superAdminCities'` | `/super-admin/cities` | - |
| `AppRouter.superAdminFields` | `'superAdminFields'` | `/super-admin/fields` | - |
| `AppRouter.superAdminBookings` | `'superAdminBookings'` | `/super-admin/bookings` | - |
| `AppRouter.superAdminAnalytics` | `'superAdminAnalytics'` | `/super-admin/analytics` | - |
| `AppRouter.superAdminSettings` | `'superAdminSettings'` | `/super-admin/settings` | - |

## Migration Examples

### Example 1: Simple Route Navigation
```dart
// OLD
Navigator.pushNamed(context, AppRouter.login);

// NEW
context.pushNamed('login');
// OR
context.push('/login');
```

### Example 2: Route with String Argument (fieldId)
```dart
// OLD
Navigator.pushNamed(context, AppRouter.fieldDetails, arguments: fieldId);

// NEW
context.pushNamed('fieldDetails', pathParameters: {'fieldId': fieldId});
// OR
context.push('/fields/$fieldId');
```

### Example 3: Route with Complex Object (FieldEntity)
```dart
// OLD
Navigator.pushNamed(context, AppRouter.createBooking, arguments: field);

// NEW
context.pushNamed('createBooking', extra: field);
```

### Example 4: Route with Map Arguments
```dart
// OLD
Navigator.pushNamed(context, AppRouter.createReview, arguments: {
  'fieldId': fieldId,
  'fieldName': fieldName,
});

// NEW
context.pushNamed('createReview', extra: {
  'fieldId': fieldId,
  'fieldName': fieldName,
});
```

### Example 5: Replace Current Route
```dart
// OLD
Navigator.pushReplacementNamed(context, AppRouter.home);

// NEW
context.goNamed('home');
// OR
context.go('/home');
```

### Example 6: Clear Stack and Navigate
```dart
// OLD
Navigator.pushNamedAndRemoveUntil(context, AppRouter.home, (route) => false);

// NEW
context.goNamed('home');
// OR
context.go('/home');
```

### Example 7: Navigate with Query Parameters
```dart
// OLD
Navigator.pushNamed(context, AppRouter.changePassword, arguments: true);

// NEW
context.pushNamed('changePassword', queryParameters: {'isFirstLogin': 'true'});
// OR
context.push('/change-password?isFirstLogin=true');
```

### Example 8: Pop with Result
```dart
// OLD
Navigator.pop(context, true);

// NEW
context.pop(true);
```

## Files That Need Updating

Total: ~32 files

### Critical Files (Auth & Core Navigation):
1. ✅ `lib/main.dart` - DONE
2. ✅ `lib/core/routes/go_router_config.dart` - DONE (new file)
3. ⏳ `lib/features/splash/splash_page.dart` - IN PROGRESS
4. ⏳ `lib/features/auth/presentation/pages/login_page.dart` - IN PROGRESS
5. ⏳ `lib/features/auth/presentation/pages/register_page.dart` - IN PROGRESS
6. ⏳ `lib/features/auth/presentation/pages/admin_login_page.dart` - IN PROGRESS
7. ⏳ `lib/features/city/presentation/pages/city_selection_page.dart` - IN PROGRESS
8. ⏳ `lib/features/home/presentation/pages/home_page.dart` - IN PROGRESS

### Other Files (32 total):
- All files listed in grep results above

## Testing Checklist

After migration, test:
- [ ] App launches (splash → city selection → home)
- [ ] Login flow
- [ ] Register flow
- [ ] Admin login flow
- [ ] Field navigation (list → details → booking)
- [ ] Bookings flow
- [ ] Reviews flow
- [ ] Owner dashboard navigation
- [ ] Super admin navigation
- [ ] Settings pages
- [ ] All back navigation works
- [ ] All deep links work (if applicable)

## Benefits of GoRouter

1. **Type-safe navigation** - Compile-time route checking
2. **Better URL management** - Deep linking support
3. **Cleaner API** - `context.go()` vs `Navigator.pushNamed()`
4. **Path parameters** - `/fields/:id` instead of passing arguments
5. **Query parameters** - Built-in support
6. **Declarative routing** - All routes defined in one place
7. **Better error handling** - Custom error pages
8. **Nested navigation** - Shell routes for tabs/drawers

## Notes

- GoRouter is now the official routing solution recommended by the Flutter team
- All BlocProvider injections are preserved in the new configuration
- Custom page transitions (slide) are maintained
- The old `app_router.dart` can be kept temporarily for reference, then deleted
