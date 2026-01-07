# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**Sport Kick** is a football field booking platform with three user roles: Super Admin, Field Owner/Admin, and Customer/User. MVP is 100% complete.

**Tech Stack:**
- Flutter 3.10+ / Dart ^3.10.0
- Clean Architecture (Presentation → Domain → Data)
- State Management: Cubit/Bloc (flutter_bloc)
- Backend: Supabase (PostgreSQL + Auth + Storage + Realtime + Edge Functions)
- DI: get_it | Routing: go_router | Error Handling: dartz (Either type)
- Testing: bloc_test + mocktail (360+ tests)

## Development Commands

```bash
# Run & Build
flutter run                    # Run with hot reload
flutter run -d <device_id>     # Run on specific device
flutter devices                # List devices
flutter build apk              # Android APK
flutter build appbundle        # Android App Bundle

# Testing
flutter test                                           # All tests
flutter test test/features/auth/presentation/cubit/    # Specific folder
flutter test --coverage                                # With coverage

# Code Quality
flutter analyze                # Lint check
dart format .                  # Format all files

# Dependencies
flutter pub get                # Install
flutter pub upgrade            # Upgrade
```

## Architecture

### Feature Structure
```
lib/features/{feature}/
  presentation/
    pages/        # Full-screen routes
    widgets/      # UI components
    cubit/        # {feature}_cubit.dart + {feature}_state.dart
  domain/
    entities/     # Business models (extend Equatable)
    usecases/     # Single-responsibility operations
    repositories/ # Abstract interfaces
  data/
    models/       # DTOs with fromJson/toJson (extend entities)
    datasources/  # Supabase/API communication
    repositories/ # Concrete implementations
```

### Current Features
`auth`, `bookings`, `business_hours`, `city`, `favorites`, `fields`, `home`, `notifications`, `onboarding`, `owner`, `recurring_bookings`, `reviews`, `settings`, `splash`, `super_admin`

### Core Modules
`constants`, `di`, `errors`, `localization`, `models`, `network`, `observers`, `routes`, `services`, `utils`, `widgets`

## Key Patterns

### Dependency Injection (`lib/core/di/injection_container.dart`)

Registration order: External → Core → DataSources → Repositories → UseCases → Cubits

```dart
// Factory for Cubits (new instance each time)
sl.registerFactory(() => AuthCubit(loginUseCase: sl()));

// LazySingleton for UseCases/Repositories (reused)
sl.registerLazySingleton(() => LoginUseCase(sl()));

// Named instances for type conflicts (Super Admin vs Owner versions)
sl.registerLazySingleton(
  () => superadmin.UpdateFieldUseCase(sl<SuperAdminRepository>()),
  instanceName: 'superAdminUpdateField',
);

// Factory with runtime parameters
sl.registerFactoryParam<CreateRecurringCubit, FieldEntity, void>(
  (field, _) => CreateRecurringCubit(field: field, ...),
);
// Usage: sl<CreateRecurringCubit>(param1: fieldEntity)
```

### State Pattern (sealed classes)

```dart
sealed class FeatureState extends Equatable {
  const FeatureState();
  @override
  List<Object?> get props => [];
}
class FeatureInitial extends FeatureState {}
class FeatureLoading extends FeatureState {}
class FeatureSuccess extends FeatureState { final Data data; ... }
class FeatureError extends FeatureState { final String message; ... }
```

### Error Handling (dartz Either)

```dart
Either<Failure, List<Field>> result = await repository.getFields();
result.fold(
  (failure) => emit(FeatureError(failure.message)),
  (data) => emit(FeatureSuccess(data)),
);
```

### Data Source Facade Pattern

Complex features split data sources by concern, unified via facade:
- Bookings: `BookingUserOperationsDataSource`, `BookingTimeSlotDataSource`, `BookingOwnerOperationsDataSource` → `BookingRemoteDataSourceFacade`
- Super Admin: `SuperAdminStatisticsDataSource`, `SuperAdminUserManagementDataSource`, etc. → `SuperAdminRemoteDataSourceFacade`

## Routing (`lib/core/routes/go_router_config.dart`)

```dart
// Path parameters
'/fields/:fieldId'  // state.pathParameters['fieldId']

// Query parameters
'/change-password?isFirstLogin=true'  // state.uri.queryParameters

// Complex objects via extra
state.extra as FieldEntity
state.extra as Map<String, dynamic>
```

**Route Prefixes:**
- Auth: `/login`, `/register`, `/admin-login`, `/change-password`
- User: `/home`, `/fields`, `/my-bookings`, `/myRecurringBookings`
- Owner: `/owner/dashboard`, `/owner/bookings`, `/owner/fields`
- Super Admin: `/super-admin/dashboard`, `/super-admin/users`, `/super-admin/fields`

## Internationalization

Supports Arabic & English with RTL support.

```dart
// Access translations
final l10n = AppLocalizations.of(context)!;
Text(l10n.appName);

// Switch locale
context.read<AppLocaleCubit>().changeLocale(Locale('ar'));
```

**Files:** `lib/l10n/app_en.arb`, `lib/l10n/app_ar.arb`

**Adding translations:** Add to both ARB files → `flutter pub get` → Use via `l10n.yourKey`

## Testing

```dart
blocTest<FeatureCubit, FeatureState>(
  'emits [Loading, Success] when operation succeeds',
  build: () {
    when(() => mockUseCase.call(any()))
        .thenAnswer((_) async => Right(expectedData));
    return FeatureCubit(useCase: mockUseCase);
  },
  act: (cubit) => cubit.performOperation(),
  expect: () => [FeatureLoading(), FeatureSuccess(expectedData)],
);
```

Test structure mirrors feature paths: `test/features/{feature}/presentation/cubit/`

## Backend (Supabase)

**Schema:** `supabase/02_FRESH_SCHEMA.sql`
- Tables: users, fields, bookings, cities, sport_categories, reviews, business_hours, user_fcm_tokens, login_activity
- Views: fields_with_details_view, bookings_view
- Enums: user_role, booking_status, payment_status, payment_method

**Migrations:** `supabase/migrations/YYYYMMDD_description.sql`

**Edge Functions:** `supabase/functions/send-fcm-notification/`

## Environment

Required `.env` file:
```env
SUPABASE_URL=your_supabase_url
SUPABASE_ANON_KEY=your_supabase_anon_key
SUPABASE_SERVICE_ROLE_KEY=your_service_role_key
```

## Theme & Dark Mode

The app uses Material 3 with comprehensive dark mode support.

**Core Pattern:**
```dart
// Access theme-aware colors via BuildContext extension
final colorScheme = Theme.of(context).colorScheme;
final isDark = Theme.of(context).brightness == Brightness.dark;

// Shortcuts via extension
context.colors.primary
context.colors.surface
context.cardShadow  // Auto-adapts (empty in dark, shadow in light)

// Semantic colors (success/error/warning) adapt to theme
final successColor = isDark ? AppColors.darkSuccess : AppColors.success;
```

**Theme Management:** `ThemeCubit` stores preference in SharedPreferences

**Key Files:**
- `lib/core/theme/theme_cubit.dart` - State management
- `lib/core/constants/app_theme.dart` - Light/Dark ThemeData
- `lib/core/constants/app_colors.dart` - Color palette
- `lib/core/theme/theme_extensions.dart` - Context extensions

## Premium UI Components

Reusable premium widgets in `lib/core/widgets/premium/`:

**Animations** (`animations/micro_interactions.dart`):
- `TapScaleAnimation` - Scale-down with haptic feedback
- `BounceAnimation` - Spring-like bounce effect
- `ShakeAnimation` - Horizontal shake for errors
- `PulseAnimation` - Continuous pulsing
- `SlideInAnimation` - Slide and fade entrance

**Skeletons** (`skeletons/`): Shimmer loading states for all major screens
**Transitions** (`transitions/`): Premium page transitions with hero animations
**Cards/Buttons** (`premium_card.dart`, `premium_button.dart`): Theme-aware variants

## Multi-Step Flows

Complex features use dedicated flow cubits (separate from general CRUD):
- `BookingFlowCubit` - Create booking wizard (date → time → confirm → success)
- `CreateRecurringCubit` - Recurring booking setup

**Pattern:**
```dart
// Flow cubit manages steps
enum BookingFlowStep { selectDate, selectTime, confirm, success }

// State tracks current step + accumulated data
class BookingFlowActive {
  final BookingFlowStep currentStep;
  final DateTime selectedDate;
  final TimeSlotEntity? selectedSlot;
  // ...
}
```

## Cubit Organization Patterns

**Simple features:** Single cubit per feature (AuthCubit, FieldsCubit)

**Complex features with sub-concerns:** Nested cubit folders
```
super_admin/presentation/cubit/
  super_admin_cubit.dart              # Main cubit
  admin_details/admin_details_cubit.dart
  users_list/super_admin_users_list_cubit.dart
  dashboard/super_admin_dashboard_cubit.dart
```

## Naming Conventions

- Cubits: `FeatureCubit` (AuthCubit, BookingCubit)
- States: `FeatureState` (AuthState, BookingState)
- Entities: `FeatureEntity` (UserEntity, FieldEntity)
- Models: `FeatureModel` (UserModel, FieldModel)
- UseCases: `VerbNounUseCase` (GetAllFieldsUseCase, CreateBookingUseCase)
- Files: snake_case (user_settings_page.dart)
- Private helper methods: `_buildSectionName` or `_handleAction`

## Key Rules

- Business logic belongs in UseCases, not Cubits
- All entities and states must extend Equatable
- Use `sealed` classes for exhaustive state matching
- Cubits are Factory (new instance), UseCases/Repositories are LazySingleton
- Complex objects passed between routes via `state.extra`
- Use named instances when same UseCase type exists for different roles
- NEVER hardcode colors - always use Theme.of(context).colorScheme or AppColors with theme detection
- Avoid magic numbers/strings - use named constants
- Widget files should focus on UI only - no business logic, no direct API calls
- Extract reusable widgets to avoid duplication
- Use `context.colors`, `context.textTheme`, `context.cardShadow` extensions

## Code Quality Standards

See `docs/CODE_QUALITY_STANDARDS.md` for full details. Key principles:
- Single Responsibility Principle - one widget/class does one thing
- DRY - extract repeated code into reusables
- Functions < 20 lines ideally
- Meaningful names (booleans: `isActive`, `hasError`; functions: verb phrases)
- No duplicate constants - define once in `core/constants` or feature domain layer

## Commit Convention

```
feat: Add feature description
fix: Fix bug description
refactor: Refactor description
test: Add test description
docs: Update documentation
```
