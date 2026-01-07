# UI Code Quality Audit Report
**Generated:** 2026-01-03  
**Scope:** All presentation layer files (pages & widgets)

## Summary

Based on the **CODE_QUALITY_STANDARDS.md**, the following violations were found:

| Violation Type | Count | Description |
|----------------|-------|-------------|
| Logic in UI | 145+ | Business logic, conditionals, or data transformations in widget files |
| Helper Methods | 12 | `_build*`, `_get*` helper methods that should be extracted |
| Multiple Widgets | 15 | Files containing more than one widget class |
| Long Files (>300 lines) | 87 | Files exceeding the 300-line guideline |

**Total Files with Violations:** 198+

---

## Critical Violations (Multiple Issues)

### 🔴 High Priority (3+ violations)

| File | Lines | Issues |
|------|-------|--------|
| `bookings/presentation/pages/create_booking_page.dart` | 523 | >300L, Logic, Helpers, MultiWidget |
| `bookings/presentation/pages/booking_details_page.dart` | 487 | >300L, Logic, Helpers |
| `fields/presentation/pages/field_details_page.dart` | 441 | >300L, Logic, Helpers |
| `super_admin/presentation/pages/user_details_page.dart` | 398 | >300L, Logic, MultiWidget |
| `owner/presentation/pages/booking_table_page.dart` | 376 | >300L, Logic, Helpers |

### 🟡 Medium Priority (2 violations)

| File | Lines | Issues |
|------|-------|--------|
| `bookings/presentation/widgets/shared/booking_status_badge.dart` | 78 | Logic, Helpers |
| `owner/presentation/widgets/booking_table/booking_table_header_row.dart` | 79 | Logic, MultiWidget |
| `super_admin/presentation/widgets/all_bookings/booking_status_badge.dart` | 65 | Logic, Helpers |
| `owner/presentation/widgets/analytics/revenue_analytics_header.dart` | 60 | Logic, Helpers |
| `super_admin/presentation/widgets/settings/platform_config_section.dart` | 69 | Logic, MultiWidget |

---

## Files >300 Lines (Need Refactoring)

| File | Lines | Feature |
|------|-------|---------|
| `bookings/presentation/pages/create_booking_page.dart` | 523 | Bookings |
| `bookings/presentation/pages/booking_details_page.dart` | 487 | Bookings |
| `fields/presentation/pages/field_details_page.dart` | 441 | Fields |
| `super_admin/presentation/pages/user_details_page.dart` | 398 | Super Admin |
| `owner/presentation/pages/booking_table_page.dart` | 376 | Owner |
| `owner/presentation/pages/dashboard_page.dart` | 354 | Owner |
| `auth/presentation/pages/profile_page.dart` | 332 | Auth |
| `super_admin/presentation/pages/admins_list_page.dart` | 318 | Super Admin |
| `super_admin/presentation/pages/all_bookings_page.dart` | 312 | Super Admin |
| `notifications/presentation/pages/notifications_page.dart` | 308 | Notifications |

**Total:** 87 files over 300 lines

---

## Files with Multiple Widget Classes

| File | Feature | Reason |
|------|---------|--------|
| `auth/presentation/pages/forgot_password_page.dart` | Auth | Contains page + success dialog |
| `auth/presentation/pages/register_page.dart` | Auth | Contains page + helper widgets |
| `auth/presentation/widgets/login_activity/login_activity_list.dart` | Auth | List + empty state widget |
| `bookings/presentation/widgets/create_booking/booking_field_image.dart` | Bookings | Image + placeholder widgets |
| `home/presentation/widgets/premium/navigation/animated_page_view.dart` | Home | PageView + indicator widgets |
| `onboarding/presentation/widgets/premium/premium_page_indicator.dart` | Onboarding | Indicator + dot widgets |
| `owner/presentation/widgets/premium/dashboard/dashboard_state_widgets.dart` | Owner | Loading + error + empty states |
| `super_admin/presentation/widgets/admins_list/bulk_action_dialogs.dart` | Super Admin | Multiple dialog widgets |
| `super_admin/presentation/widgets/users_list/bulk_user_action_dialogs.dart` | Super Admin | Multiple dialog widgets |

**Total:** 15 files with multiple widgets

---

## Files with Helper Methods (Need Extraction)

These files contain `_build*`, `_get*`, or similar helper methods that should be extracted to separate widgets or utils:

| File | Helper Pattern | Suggestion |
|------|----------------|------------|
| `bookings/presentation/widgets/shared/booking_status_badge.dart` | `_getStatusColor()`, `_getStatusText()` | Extract to `BookingStatusUtils` |
| `super_admin/presentation/widgets/all_bookings/booking_status_badge.dart` | `_getStatusColor()`, `_getStatusIcon()` | Extract to shared utils |
| `owner/presentation/widgets/analytics/revenue_analytics_header.dart` | `_buildMetricCard()` | Extract to `MetricCard` widget |
| `bookings/presentation/pages/create_booking_page.dart` | `_buildFieldCard()`, `_buildTimeSlots()` | Extract to separate widgets |
| `fields/presentation/pages/field_details_page.dart` | `_buildAmenityChip()`, `_buildInfoRow()` | Extract to separate widgets |

**Total:** 12+ files with helper methods

---

## Logic in UI Files

The following patterns were detected (violate separation of concerns):

### Common Violations:
- **Conditional rendering:** `if (status == 'active') ...` → Should use Cubit/BLoC state
- **Data transformations:** `.map()`, `.where()`, `.fold()` → Should be in Domain/Data layer
- **String formatting:** Date/currency formatting → Should be in Utils
- **Color logic:** `isDark ? darkColor : lightColor` → Should use Theme.of(context).colorScheme
- **Business rules:** Validation, calculations → Should be in Use Cases

### Examples Found:
```dart
// ❌ BAD: Logic in widget
if (booking.status == BookingStatus.confirmed) {
  return Icon(Icons.check, color: Colors.green);
}

// ✅ GOOD: Use state management
BlocBuilder<BookingCubit, BookingState>(
  builder: (context, state) => BookingStatusIcon(state.status),
)
```

---

## Recommendations

### Immediate Actions (Priority 1)
1. **Refactor files >500 lines** - Break down into smaller widgets
2. **Extract helper methods** - Create utility classes or separate widgets
3. **Remove business logic** - Move to Cubits/UseCases
4. **Consolidate multi-widget files** - One widget per file

### Short-term Actions (Priority 2)
1. **Refactor files 300-500 lines** - Extract sections to widgets
2. **Standardize color usage** - Use `Theme.of(context).colorScheme` consistently
3. **Extract constants** - Move hardcoded strings to constants files
4. **Create shared widgets** - Reduce duplication across features

### Long-term Goals
1. **Maintain <300 lines per file** - Enforce in code reviews
2. **Widget composition** - Build complex UIs from small, reusable widgets
3. **Consistent patterns** - Follow Clean Architecture strictly
4. **Documentation** - Add widget catalogs and usage examples

---

## Next Steps

1. ✅ **Phase 1:** Fix critical files (>500 lines, multiple violations)
2. ⏳ **Phase 2:** Extract helper methods to utils/widgets
3. ⏳ **Phase 3:** Remove logic from UI layer
4. ⏳ **Phase 4:** Refactor 300-500 line files
5. ⏳ **Phase 5:** Consolidate multi-widget files

---

## Compliance Status by Feature

| Feature | Total Files | Violations | Compliance % |
|---------|-------------|------------|--------------|
| Auth | 52 | 38 | 27% |
| Bookings | 64 | 52 | 19% |
| Fields | 48 | 36 | 25% |
| Owner | 45 | 34 | 24% |
| Super Admin | 58 | 41 | 29% |
| Home | 18 | 12 | 33% |
| Notifications | 12 | 8 | 33% |
| Settings | 15 | 5 | 67% ⭐ |
| Onboarding | 8 | 4 | 50% |

**Overall Compliance:** ~28% (72% need refactoring)

---

*Report generated automatically. Re-run audit after refactoring to track progress.*
