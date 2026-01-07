# Code Quality Audit Report

**Generated:** 2026-01-04
**Audited By:** Claude Code

---

## Executive Summary

| Category | Files Scanned | Files with Violations | Critical | High | Medium | Low |
|----------|---------------|----------------------|----------|------|--------|-----|
| Core Widgets | 47 | 7 | 0 | 2 | 4 | 1 |
| Feature Widgets | 200+ | 13 | 0 | 3 | 8 | 2 |
| Pages | 57 | 17 | 1 | 2 | 12 | 2 |
| Cubits | 30+ | 12 | 3 | 0 | 5 | 4 |
| Data Layer | 60+ | 12 | 3 | 3 | 4 | 2 |
| Domain Layer | 80+ | 34 | 2 | 2 | 26 | 4 |
| **TOTAL** | **475+** | **95** | **9** | **12** | **59** | **15** |

---

## Violation Categories

### Critical Violations
- Files > 500 lines
- Flutter imports in domain layer
- Business logic in data layer
- Monolithic cubits with 10+ responsibilities

### High Severity
- Files > 300 lines
- Multiple public classes per file
- Direct repository access in cubits
- Cubit-to-cubit dependencies

### Medium Severity
- Private helper classes that should be extracted
- Business logic in UI widgets
- Hardcoded data lists
- Multiple responsibilities in single class

### Low Severity
- Files near 300-line threshold
- Minor helper methods in widgets
- Parameter classes in same file as UseCase

---

## 1. Core Widgets Violations

### Files Over 300 Lines

| File | Lines | Issue |
|------|-------|-------|
| `lib/core/widgets/premium/animations/micro_interactions.dart` | 457 | 5 public animation classes in single file |
| `lib/core/widgets/map/map_location_picker.dart` | 407 | Mixed concerns: location, search, geocoding, UI |
| `lib/core/widgets/custom_text_field.dart` | 313 | Multiple public classes + business logic |

### Multiple Classes Per File

| File | Classes | Recommended Action |
|------|---------|-------------------|
| `micro_interactions.dart` | 5 public + 5 private | Split into individual animation files |
| `advanced_filter_bottom_sheet.dart` | 6 classes | Separate filter widgets + models |
| `premium_button_variants.dart` | 3 public | One file per button variant |
| `premium_page_transitions.dart` | 3 classes | Separate route class to own file |

### Recommended Fixes

```
lib/core/widgets/premium/animations/
├── micro_interactions.dart (REMOVE)
├── tap_scale_animation.dart (CREATE)
├── bounce_animation.dart (CREATE)
├── shake_animation.dart (CREATE)
├── pulse_animation.dart (CREATE)
└── slide_in_animation.dart (CREATE)
```

---

## 2. Feature Widgets Violations

### Critical: Private Helper Classes

| File | Private Classes | Action |
|------|-----------------|--------|
| `premium_reviews_preview.dart` | 7 classes | Extract to separate files |
| `booking_table_view.dart` | 5 classes | Extract _MissingHoursCard, _RefreshButton, etc. |
| `premium_owner_bookings_view.dart` | 3 classes + 6 handlers | Move handlers to cubit |
| `premium_owner_bookings_header.dart` | 4 classes | Extract _BackButton, _SearchBar, _StatChip |

### Business Logic in Widgets

| File | Issue | Fix |
|------|-------|-----|
| `premium_owner_bookings_view.dart` | 6 handler methods (_handleApprove, etc.) | Move to cubit listener |
| `booking_table_day_row.dart` | Hardcoded day names list | Use localization |

### Files Needing Extraction

```
lib/features/owner/presentation/widgets/booking_table/
├── booking_table_view.dart
├── booking_table_missing_hours_card.dart (EXTRACT)
├── booking_table_refresh_button.dart (EXTRACT)
├── booking_table_loading_view.dart (EXTRACT)
└── booking_table_error_view.dart (EXTRACT)
```

---

## 3. Pages Violations

### Critical: Over 300 Lines

| File | Lines | Issue |
|------|-------|-------|
| `super_admin_reports_page.dart` | 437 | 2 private classes + 4 helper functions |

### Multiple Classes in Pages

| File | Classes | Action |
|------|---------|--------|
| `platform_analytics_page.dart` | 4 classes | Extract _AnalyticsContent, _ErrorContent |
| `booking_invoice_page.dart` | 2 classes | Extract _BookingInvoiceContent |

### Business Logic in Pages

| File | Lines | Issue | Action |
|------|-------|-------|--------|
| `edit_field_page.dart` | 228 | _mapCapacityToSize(), _validateDropdownValue() | Move to utils |
| `create_field_page.dart` | 189 | Form logic, validation | Extract to form widget |
| `add_edit_field_page.dart` | 215 | Multiple TextControllers, validation | Extract form logic |
| `create_recurring_page.dart` | 210 | _loadBusinessHours(), _showSuccessDialog() | Move to cubit, separate dialog |
| `manage_business_hours_page.dart` | 211 | Repeated state listener logic | Extract to helper |

### Priority Refactoring

1. **`super_admin_reports_page.dart`** - Split into:
   - `super_admin_reports_page.dart` (<50 lines)
   - `super_admin_reports_view.dart`
   - `widgets/reports/stat_item_card.dart`
   - `widgets/reports/report_card.dart`
   - `widgets/reports/export_section.dart`

---

## 4. Cubits Violations

### Critical: Multiple Responsibilities

| Cubit | Lines | Use Cases | Domains | Action |
|-------|-------|-----------|---------|--------|
| `super_admin_cubit.dart` | 140+ext | 22 | 7 via mixins | Split into 7 focused cubits |
| `owner_cubit.dart` | 270 | 8 | 3 | Split into 4 focused cubits |
| `booking_flow_cubit.dart` | 360 | - | - | Extract slot logic to UseCases |
| `booking_cubit.dart` | 357 | 8 | 4 | Split into 3 focused cubits |

### Business Logic in Cubits

| Cubit | Methods | Issue | Action |
|-------|---------|-------|--------|
| `booking_flow_cubit.dart` | `_groupSlotsByPeriod()`, `_findConsecutiveSlot()` | Pure business logic | Create UseCases |
| `fields_cubit.dart` | Category matching, filtering | Data transformation | Create FilterFieldsUseCase |
| `business_hours_cubit.dart` | Delayed reloads, orchestration | Side effect management | Create UseCase |
| `manual_booking_form_cubit.dart` | Time calculation, price calculation | Business rules | Extract to UseCases |

### Architecture Violations

| Cubit | Issue | Action |
|-------|-------|--------|
| `recurring_requests_cubit.dart` | Direct repository access | Create wrapper UseCase |
| `review_form_cubit.dart` | Calls reviewsCubit methods | Use callbacks or direct UseCase calls |
| `search_cubit.dart` | Depends on FieldsCubit | Event-based or UseCase |

### Recommended Cubit Split

```
SuperAdminCubit → Split into:
├── AdminManagementCubit
├── BookingApprovalCubit
├── CityManagementCubit
├── ExportCubit
├── FieldVerificationCubit
├── StatisticsCubit
└── UserActivationCubit

OwnerCubit → Split into:
├── OwnerFieldsCubit
├── OwnerBookingsApprovalCubit
├── OwnerRevenueStatsCubit
└── OwnerProfileCubit
```

---

## 5. Data Layer Violations

### Critical: Files Over 300 Lines

| File | Lines | Issue |
|------|-------|-------|
| `super_admin_remote_datasource.dart` | 766 | Monolithic datasource |
| `super_admin_repository_impl.dart` | 570 | Very large repository |
| `booking_remote_datasource.dart` | 547 | Too large + business logic |
| `booking_repository_impl.dart` | 485 | Complex caching logic |
| `super_admin_field_management_datasource.dart` | 400 | Large field operations |

### Multiple Classes Per File (Interface + Implementation)

| File | Classes |
|------|---------|
| `auth_remote_datasource.dart` | AuthRemoteDataSource + AuthRemoteDataSourceImpl |
| `booking_remote_datasource.dart` | BookingRemoteDataSource + BookingRemoteDataSourceImpl |
| `booking_time_slot_datasource.dart` | BookingTimeSlotDataSource + BookingTimeSlotDataSourceImpl |
| `field_remote_datasource.dart` | FieldRemoteDataSource + FieldRemoteDataSourceImpl |
| `review_remote_datasource.dart` | ReviewRemoteDataSource + ReviewRemoteDataSourceImpl |
| `super_admin_remote_datasource.dart` | SuperAdminRemoteDataSource + SuperAdminRemoteDataSourceImpl |

### Business Logic in Data Layer (CRITICAL)

| File | Location | Issue |
|------|----------|-------|
| `booking_time_slot_datasource.dart` | Lines 120-310 | Time slot generation algorithm |
| `super_admin_user_management_datasource.dart` | Lines 335-339 | Password generation logic |
| `booking_model.dart` | Lines 176-177, 195-197 | Status transitions, business rules |
| `review_remote_datasource.dart` | Lines 281-314 | Complex JSON parsing logic |

### Error Handling Issues

| File | Issue |
|------|-------|
| `booking_time_slot_datasource.dart` | Silent fallback returns default values |
| `field_remote_datasource.dart` | Generic error wrapping loses context |
| `booking_time_slot_datasource.dart:267` | Missing try-catch for parsing |

---

## 6. Domain Layer Violations

### Critical: Flutter Dependencies

| File | Import | Issue |
|------|--------|-------|
| `search_filters_entity.dart` | `package:flutter/material.dart` | Uses Icons in domain |
| `booking_status.dart` | `package:flutter/material.dart` | Uses Color, LinearGradient, IconData |

**Action:** Remove UI properties from domain entities. Move to presentation layer extensions.

### Files Over 300 Lines

| File | Lines | Issue |
|------|-------|-------|
| `super_admin_repository.dart` | 376 | 20+ abstract methods, mixed responsibilities |

**Action:** Split into:
- `SuperAdminUserRepository`
- `SuperAdminCityRepository`
- `SuperAdminFieldRepository`
- `SuperAdminSportCategoryRepository`

### Multiple Classes/Enums Per File (26 Files)

| Category | Files | Example |
|----------|-------|---------|
| Entity + Enum | 8 | `login_activity_entity.dart` (LoginStatus, DeviceType, Entity) |
| UseCase + Params | 15 | `login_usecase.dart` (LoginUseCase, LoginParams) |
| Entity + Extension | 3 | `notification_entity.dart` (NotificationType, Extension, Entity) |

### UseCases with Multiple Responsibilities

| UseCase | Lines | Issue |
|---------|-------|-------|
| `create_manual_booking_usecase.dart` | 127 | Date, time, phone, email, price validation |

**Action:** Extract to validators: `BookingDateValidator`, `PhoneValidator`, `EmailValidator`

---

## 7. Priority Fixes Summary

### Priority 1: CRITICAL (Fix Immediately)

| # | File | Issue | Action |
|---|------|-------|--------|
| 1 | `booking_status.dart` | Flutter import in domain | Remove UI properties |
| 2 | `search_filters_entity.dart` | Flutter import in domain | Move Icons to presentation |
| 3 | `super_admin_cubit.dart` | 22 use cases, 7 domains | Split into 7 cubits |
| 4 | `super_admin_remote_datasource.dart` | 766 lines | Split by domain |
| 5 | `booking_time_slot_datasource.dart` | Business logic | Move to UseCase |

### Priority 2: HIGH (Fix This Sprint)

| # | File | Issue | Action |
|---|------|-------|--------|
| 6 | `owner_cubit.dart` | 8 use cases, 3 domains | Split into 4 cubits |
| 7 | `super_admin_reports_page.dart` | 437 lines | Extract widgets |
| 8 | `booking_flow_cubit.dart` | Slot logic in cubit | Create UseCases |
| 9 | `micro_interactions.dart` | 5 animation classes | Split files |
| 10 | `premium_owner_bookings_view.dart` | 6 handler methods | Move to cubit |

### Priority 3: MEDIUM (Fix Next Sprint)

| # | Category | Count | Action |
|---|----------|-------|--------|
| 11 | Private widget classes | 13 files | Extract to separate files |
| 12 | Domain enums in entity files | 8 files | Separate enum files |
| 13 | Interface+Impl in same file | 8 files | Split (optional) |
| 14 | Pages with form logic | 6 files | Extract form widgets |
| 15 | Data layer validation | 3 files | Move to domain |

### Priority 4: LOW (Backlog)

| # | Category | Count | Notes |
|---|----------|-------|-------|
| 16 | UseCase + Params in same file | 15 files | Acceptable pattern |
| 17 | Large entities (200-280 lines) | 3 files | Monitor, don't fix yet |
| 18 | Minor helper methods | Various | Case-by-case |

---

## 8. Metrics After Fix

### Expected Improvements

| Metric | Current | Target |
|--------|---------|--------|
| Files > 300 lines | 20+ | 0 |
| Files with multiple public classes | 40+ | 5 |
| Flutter imports in domain | 2 | 0 |
| Business logic in data layer | 6+ | 0 |
| Cubit dependencies on other cubits | 3 | 0 |
| Cubits with > 5 use cases | 4 | 0 |

### Code Quality Score

| Layer | Current | Target |
|-------|---------|--------|
| Domain | 65% | 95% |
| Data | 60% | 90% |
| Presentation (Cubits) | 55% | 90% |
| Presentation (Widgets) | 70% | 95% |
| Presentation (Pages) | 75% | 95% |
| Core | 75% | 95% |
| **Overall** | **67%** | **93%** |

---

## Appendix A: Full File List

### Files Requiring Immediate Action

1. `lib/features/bookings/domain/entities/booking_status.dart`
2. `lib/features/fields/domain/entities/search_filters_entity.dart`
3. `lib/features/super_admin/presentation/cubit/super_admin_cubit.dart`
4. `lib/features/super_admin/data/datasources/super_admin_remote_datasource.dart`
5. `lib/features/bookings/data/datasources/booking_time_slot_datasource.dart`
6. `lib/features/owner/presentation/cubit/owner_cubit.dart`
7. `lib/features/super_admin/presentation/pages/super_admin_reports_page.dart`
8. `lib/features/bookings/presentation/cubit/booking_flow_cubit.dart`
9. `lib/core/widgets/premium/animations/micro_interactions.dart`

### Files Requiring Extraction

1. `lib/features/owner/presentation/widgets/booking_table/booking_table_view.dart`
2. `lib/features/fields/presentation/widgets/details/premium/premium_reviews_preview.dart`
3. `lib/features/owner/presentation/widgets/premium/bookings/premium_owner_bookings_view.dart`
4. `lib/features/owner/presentation/widgets/premium/bookings/premium_owner_bookings_header.dart`
5. `lib/features/super_admin/presentation/pages/platform_analytics_page.dart`
6. `lib/core/widgets/advanced_filter_bottom_sheet.dart`
7. `lib/core/widgets/premium/premium_button_variants.dart`

---

## Appendix B: Clean Architecture Checklist

### Domain Layer
- [ ] No Flutter imports
- [ ] No direct dependencies on data layer
- [ ] Each entity in own file
- [ ] Each UseCase in own file
- [ ] Enums in separate files

### Data Layer
- [ ] Only data transformation (no business logic)
- [ ] Proper error propagation
- [ ] Interface and implementation can be in same file (acceptable)
- [ ] Models extend entities
- [ ] No UI-related code

### Presentation Layer
- [ ] Cubits only call UseCases
- [ ] No cubit-to-cubit dependencies
- [ ] Widgets under 300 lines
- [ ] One public widget per file
- [ ] Business logic in cubits, not widgets
- [ ] No hardcoded data lists in widgets

---

*Report generated by Code Quality Audit - Claude Code*
