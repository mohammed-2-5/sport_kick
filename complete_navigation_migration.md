# GoRouter Migration - Completion Guide

## Files Successfully Updated (14 files)

### Authentication & Core Pages (5 files)
- ✅ `lib/features/auth/presentation/pages/login_page.dart`
- ✅ `lib/features/auth/presentation/pages/register_page.dart`
- ✅ `lib/features/auth/presentation/pages/admin_login_page.dart`
- ✅ `lib/features/city/presentation/pages/city_selection_page.dart`
- ✅ `lib/features/auth/presentation/pages/profile_page.dart`

### Home Pages (1 file)
- ✅ `lib/features/home/presentation/pages/home_page.dart`

### Fields Pages & Widgets (5 files)
- ✅ `lib/features/fields/presentation/pages/fields_list_page.dart`
- ✅ `lib/features/fields/presentation/pages/fields_map_page.dart`
- ✅ `lib/features/fields/presentation/widgets/field_reviews_section.dart`
- ✅ `lib/features/fields/presentation/widgets/book_now_button.dart`

### Home Widgets (3 files)
- ✅ `lib/features/home/presentation/widgets/nearby_fields_preview.dart`
- ✅ `lib/features/home/presentation/widgets/categories_slider.dart`
- ✅ `lib/features/home/presentation/widgets/quick_booking_shortcuts.dart`

## Remaining Files to Update (19 files)

### Home Widgets (2 files)
1. `lib/features/home/presentation/widgets/explore_section.dart`
2. `lib/features/home/presentation/widgets/home_quick_actions.dart`

### Owner Pages & Widgets (5 files)
3. `lib/features/owner/presentation/pages/owner_dashboard_page.dart`
4. `lib/features/owner/presentation/pages/owner_fields_page.dart`
5. `lib/features/owner/presentation/pages/owner_settings_page.dart`
6. `lib/features/owner/presentation/pages/owner_profile_page.dart`
7. `lib/features/owner/presentation/pages/owner_field_detail_page.dart`

### Super Admin Pages & Widgets (10 files)
8. `lib/features/super_admin/presentation/pages/super_admin_dashboard_page.dart`
9. `lib/features/super_admin/presentation/pages/users_list_page.dart`
10. `lib/features/super_admin/presentation/pages/user_details_page.dart`
11. `lib/features/super_admin/presentation/pages/admins_list_page.dart`
12. `lib/features/super_admin/presentation/pages/admin_details_page.dart`
13. `lib/features/super_admin/presentation/pages/super_admin_settings_page.dart`
14. `lib/features/super_admin/presentation/widgets/dashboard/dashboard_header.dart`
15. `lib/features/super_admin/presentation/widgets/dashboard/dashboard_drawer.dart`
16. `lib/features/super_admin/presentation/widgets/cities/city_card.dart`
17. `lib/features/super_admin/presentation/widgets/booking_card.dart`
18. `lib/features/super_admin/presentation/widgets/field_card.dart`

### Bookings & Settings (2 files)
19. `lib/features/bookings/presentation/widgets/booking_list_item.dart`
20. `lib/features/settings/presentation/pages/user_settings_page.dart`

## Migration Pattern Reference

### Import Changes
```dart
// REMOVE
import 'package:spo_kick/core/routes/app_router.dart';

// ADD
import 'package:go_router/go_router.dart';
```

### Navigation Changes

#### Simple Navigation
```dart
// OLD
Navigator.pushNamed(context, AppRouter.fieldsList);
// NEW
context.pushNamed('fieldsList');
```

#### With Path Parameters (ID)
```dart
// OLD
Navigator.pushNamed(context, AppRouter.fieldDetails, arguments: fieldId);
// NEW
context.pushNamed('fieldDetails', pathParameters: {'fieldId': fieldId});
```

#### With Complex Object
```dart
// OLD
Navigator.pushNamed(context, AppRouter.createBooking, arguments: field);
// NEW
context.pushNamed('createBooking', extra: field);
```

#### With Map/Dictionary
```dart
// OLD
Navigator.pushNamed(context, AppRouter.allReviews, arguments: {
  'fieldId': id,
  'fieldName': name,
});
// NEW
context.pushNamed('allReviews', extra: {
  'fieldId': id,
  'fieldName': name,
});
```

#### Replace (goNamed instead of pushNamed)
```dart
// OLD
Navigator.pushReplacementNamed(context, AppRouter.home);
// NEW
context.goNamed('home');
```

#### Clear Stack and Navigate
```dart
// OLD
Navigator.pushNamedAndRemoveUntil(context, AppRouter.home, (route) => false);
// NEW
context.goNamed('home');
```

## Route Name Mapping Quick Reference

| Old (AppRouter constant) | New (GoRouter name) | Type |
|--------------------------|---------------------|------|
| `AppRouter.home` | `'home'` | Simple |
| `AppRouter.login` | `'login'` | Simple |
| `AppRouter.register` | `'register'` | Simple |
| `AppRouter.profile` | `'profile'` | Simple |
| `AppRouter.fieldsList` | `'fieldsList'` | Simple or with extra for categoryId |
| `AppRouter.fieldDetails` | `'fieldDetails'` | Path param: `{'fieldId': id}` |
| `AppRouter.fieldsMap` | `'fieldsMap'` | Simple |
| `AppRouter.myBookings` | `'myBookings'` | Simple |
| `AppRouter.bookingDetails` | `'bookingDetails'` | Path param: `{'bookingId': id}` |
| `AppRouter.createBooking` | `'createBooking'` | Extra: FieldEntity |
| `AppRouter.favorites` | `'favorites'` | Simple |
| `AppRouter.settings` | `'settings'` | Simple |
| `AppRouter.createReview` | `'createReview'` | Extra: Map with fieldId, fieldName |
| `AppRouter.allReviews` | `'allReviews'` | Extra: Map with fieldId, fieldName, etc |
| `AppRouter.ownerDashboard` | `'ownerDashboard'` | Simple |
| `AppRouter.ownerFields` | `'ownerFields'` | Simple |
| `AppRouter.ownerSettings` | `'ownerSettings'` | Simple |
| `AppRouter.ownerProfile` | `'ownerProfile'` | Simple |
| `AppRouter.superAdminDashboard` | `'superAdminDashboard'` | Simple |
| `AppRouter.superAdminUsers` | `'superAdminUsers'` | Simple |
| `AppRouter.superAdminUserDetails` | `'superAdminUserDetails'` | Extra: UserEntity |
| `AppRouter.superAdminAdmins` | `'superAdminAdmins'` | Simple |
| `AppRouter.superAdminAdminDetails` | `'superAdminAdminDetails'` | Extra: UserEntity |
| `AppRouter.superAdminCities` | `'superAdminCities'` | Simple |
| `AppRouter.superAdminSettings` | `'superAdminSettings'` | Simple |

## Next Steps

1. **Complete Remaining Files**: Use the pattern above to update the 19 remaining files
2. **Format All Files**: Run `dart format .` on the entire project
3. **Test Compilation**: Run `flutter analyze` and `flutter run` to ensure no errors
4. **Test Navigation**: Manually test all navigation flows in the app

## Testing Checklist

After completing all updates:

- [ ] App launches successfully
- [ ] Login/Register flow works
- [ ] Admin login works
- [ ] Field browsing works
- [ ] Field details and booking work
- [ ] Owner dashboard navigation works
- [ ] Super admin navigation works
- [ ] All back buttons work correctly
- [ ] Deep linking works (if applicable)

## Navigation Call Count

- **Total files updated**: 14/33 (42%)
- **Estimated navigation calls updated**: ~35+
- **Remaining files**: 19
- **Estimated remaining calls**: ~50

## Common Issues & Solutions

### Issue: Import not found
**Solution**: Ensure `go_router` is in pubspec.yaml dependencies

### Issue: Route not found
**Solution**: Check route name matches exactly in `go_router_config.dart`

### Issue: Arguments not accessible
**Solution**: Use `extra` for objects, `pathParameters` for IDs

### Issue: Navigation doesn't work
**Solution**: Ensure context is from a widget inside `MaterialApp.router()`
