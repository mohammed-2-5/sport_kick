# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**Sport Kick** is a football field booking platform for local cities with three distinct user roles: Super Admin, Field Owner/Admin, and Customer/User. The app replaces traditional phone-based booking with instant, real-time field reservations.

**Current Status:** Phase 11 Complete (100% MVP) - See `PROJECT_STATUS.md` for detailed roadmap and progress tracking.

**Architecture:**
- Clean Architecture with feature-based structure (Presentation → Domain → Data)
- State Management: Cubit/Bloc pattern with flutter_bloc
- Backend: Supabase (PostgreSQL + Auth + Storage + Realtime + Edge Functions)
- Dependency Injection: get_it service locator
- Routing: go_router with declarative navigation
- Testing: 360+ unit tests using bloc_test and mocktail

## Development Commands

### Running & Building
```bash
# Run app (hot reload enabled by default)
flutter run

# Run on specific device
flutter run -d <device_id>

# List available devices
flutter devices

# Build for production
flutter build apk              # Android APK
flutter build appbundle        # Android App Bundle
flutter build windows          # Windows desktop
flutter build web              # Web deployment
```

### Testing
```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/features/auth/presentation/cubit/auth_cubit_test.dart

# Run tests with coverage report
flutter test --coverage

# Run integration tests
flutter test integration_test/app_test.dart
flutter test integration_test/booking_flow_test.dart
```

### Code Quality
```bash
# Analyze code for issues
flutter analyze

# Format all Dart files
dart format .

# Format specific file
dart format lib/features/auth/presentation/cubit/auth_cubit.dart
```

### Dependencies
```bash
# Install dependencies
flutter pub get

# Upgrade dependencies
flutter pub upgrade

# Check outdated packages
flutter pub outdated
```

## Architecture Overview

### Clean Architecture Layers

The codebase follows strict Clean Architecture with three layers per feature:

**Presentation Layer** (`presentation/`)
- **Pages**: Full-screen routes/screens
- **Widgets**: Reusable UI components
- **Cubit**: State management (extends Cubit from bloc package)
  - Cubit files: `feature_cubit.dart`
  - State files: `feature_state.dart`
  - States must extend Equatable with Initial/Loading/Success/Error states

**Domain Layer** (`domain/`) - Pure Dart, no Flutter dependencies
- **Entities**: Business models (extend Equatable)
- **UseCases**: Single-responsibility business logic operations
- **Repositories**: Abstract interfaces (contracts)

**Data Layer** (`data/`)
- **Models**: DTOs with `fromJson`/`toJson` (extend entities)
- **DataSources**: Direct communication with Supabase/APIs
- **Repositories**: Concrete implementations of domain interfaces

### Dependency Injection Pattern

All dependencies are registered in `lib/core/di/injection_container.dart` using get_it:

```dart
// Registration order (bottom-up):
1. External (Supabase, Dio, SharedPreferences)
2. Core (NetworkInfo, Services)
3. Feature Data Sources (LazySingleton)
4. Feature Repositories (LazySingleton)
5. Feature UseCases (LazySingleton)
6. Feature Cubits (Factory)

// Usage:
final authCubit = sl<AuthCubit>();
```

**Important:** When adding new features:
1. Create data source implementations
2. Create repository implementations
3. Create use cases
4. Create cubits
5. Register all in `injection_container.dart` following the existing pattern
6. Use named instances for conflicting types (e.g., `instanceName: 'superAdminUpdateField'`)

### Data Source Architecture

Complex features use **Facade Pattern** for data sources:

**Example: Bookings**
- `BookingUserOperationsDataSource` - User booking operations
- `BookingTimeSlotDataSource` - Time slot queries
- `BookingOwnerOperationsDataSource` - Owner operations
- `BookingAdminOperationsDataSource` - Admin operations
- `BookingRemoteDataSourceFacade` - Unified interface combining all above

**Example: Super Admin**
- `SuperAdminStatisticsDataSource`
- `SuperAdminUserManagementDataSource`
- `SuperAdminFieldManagementDataSource`
- `SuperAdminCityManagementDataSource`
- `SuperAdminSportCategoryDatasource`
- `SuperAdminRemoteDataSourceFacade` - Unified interface

This pattern keeps data sources focused and maintainable.

### Routing Architecture

Centralized routing using `go_router` in `lib/core/routes/go_router_config.dart`:

- Declarative route definitions with path parameters
- Type-safe navigation using route names
- Custom page transitions (`_buildSlidePage` for slide animations)
- BlocProvider injection at route level when needed
- Error handling with `_ErrorPage`

**Route Structure:**
- Auth routes: `/login`, `/register`, `/admin-login`
- User routes: `/home`, `/fields`, `/my-bookings`
- Owner routes: `/owner/dashboard`, `/owner/bookings`, `/owner/fields`
- Super Admin routes: `/super-admin/dashboard`, `/super-admin/users`

## Key Architectural Patterns

### State Management (Cubit Pattern)

```dart
// State class must extend Equatable
sealed class FeatureState extends Equatable {
  const FeatureState();
  @override
  List<Object?> get props => [];
}

class FeatureInitial extends FeatureState {}
class FeatureLoading extends FeatureState {}
class FeatureSuccess extends FeatureState {
  final Data data;
  const FeatureSuccess(this.data);
  @override
  List<Object?> get props => [data];
}
class FeatureError extends FeatureState {
  final String message;
  const FeatureError(this.message);
  @override
  List<Object?> get props => [message];
}
```

**Critical Rules:**
- Business logic belongs in UseCases, not Cubits
- Cubits only orchestrate use case calls and emit states
- All entities and states must extend Equatable
- Use `sealed` classes for exhaustive state pattern matching

### Error Handling Pattern

Uses `dartz` package for functional error handling:

```dart
// Repository returns Either<Failure, Success>
Either<Failure, List<Field>> result = await repository.getFields();

result.fold(
  (failure) => emit(FeatureError(failure.message)),
  (data) => emit(FeatureSuccess(data)),
);
```

### Code Generation

When modifying entities/models that use code generation:

```bash
# Generate code for annotations (if applicable)
flutter pub run build_runner build --delete-conflicting-outputs
```

## Feature Structure

Each feature follows this structure:

```
lib/features/{feature_name}/
  presentation/
    pages/           # Full-screen widgets
    widgets/         # Reusable components
    cubit/
      {feature}_cubit.dart
      {feature}_state.dart
  domain/
    entities/        # Business models
    usecases/        # Business logic operations
    repositories/    # Abstract contracts
  data/
    models/          # DTOs (Data Transfer Objects)
    datasources/     # Supabase/API communication
    repositories/    # Repository implementations
```

## Backend (Supabase)

### Database Schema

Schema defined in `supabase/02_FRESH_SCHEMA.sql`:
- Core tables: users, fields, bookings, cities, sport_categories
- Support tables: reviews, business_hours, user_fcm_tokens, login_activity
- Views: fields_with_details_view, bookings_view
- Enums: user_role, booking_status, payment_status, payment_method

### Database Migrations

Located in `supabase/migrations/`:
- Versioned migration files: `YYYYMMDD_description.sql`
- Apply migrations in order
- Test migrations locally before production

### Edge Functions

Located in `supabase/functions/`:
- `send-fcm-notification/`: Push notification handler triggered by database webhooks
- Deployed using Supabase CLI

### Row Level Security (RLS)

All tables use RLS policies defined in schema files:
- Users can only access their own data
- Admins can manage their assigned fields
- Super admins have platform-wide access

## Testing Strategy

**Current Coverage:** 360+ unit tests

**Test Structure:**
```
test/
  features/{feature}/
    presentation/cubit/      # Cubit tests using bloc_test
    domain/usecases/         # UseCase tests
    data/repositories/       # Repository tests
  helpers/
    mock_dependencies.dart   # Shared mocks using mocktail
```

**Writing Cubit Tests:**
```dart
blocTest<FeatureCubit, FeatureState>(
  'emits [Loading, Success] when operation succeeds',
  build: () {
    when(() => mockUseCase.call(any()))
        .thenAnswer((_) async => Right(expectedData));
    return FeatureCubit(useCase: mockUseCase);
  },
  act: (cubit) => cubit.performOperation(),
  expect: () => [
    FeatureLoading(),
    FeatureSuccess(expectedData),
  ],
);
```

## Code Quality Standards

### Naming Conventions
- Cubits: `FeatureCubit` (e.g., `AuthCubit`, `BookingCubit`)
- States: `FeatureState` (e.g., `AuthState`, `BookingState`)
- Entities: `FeatureEntity` (e.g., `UserEntity`, `FieldEntity`)
- Models: `FeatureModel` (e.g., `UserModel`, `FieldModel`)
- UseCases: `VerbNounUseCase` (e.g., `GetAllFieldsUseCase`, `CreateBookingUseCase`)
- Repositories: `FeatureRepository` (e.g., `AuthRepository`, `BookingRepository`)

### Commit Convention
Follow conventional commits:
- `feat: Add feature description`
- `fix: Fix bug description`
- `refactor: Refactor description`
- `test: Add test description`
- `docs: Update documentation`

## Environment Configuration

**Required .env file** (root directory):
```env
SUPABASE_URL=your_supabase_url
SUPABASE_ANON_KEY=your_supabase_anon_key
SUPABASE_SERVICE_ROLE_KEY=your_service_role_key
```

Load using `flutter_dotenv` package.

## Key Configuration Files

- **pubspec.yaml**: Dependencies and assets
- **lib/main.dart**: App initialization (Firebase, Supabase, DI, Notifications)
- **lib/core/di/injection_container.dart**: Dependency injection setup
- **lib/core/routes/go_router_config.dart**: Navigation configuration
- **lib/core/constants/app_constants.dart**: App-wide constants
- **lib/core/constants/app_theme.dart**: Theme configuration
- **supabase/02_FRESH_SCHEMA.sql**: Database schema

## Common Development Tasks

### Adding a New Feature

1. Create feature folder structure in `lib/features/{feature_name}/`
2. Define entities in `domain/entities/`
3. Create repository interface in `domain/repositories/`
4. Create use cases in `domain/usecases/`
5. Create models (DTOs) in `data/models/`
6. Implement data source in `data/datasources/`
7. Implement repository in `data/repositories/`
8. Create cubit and states in `presentation/cubit/`
9. Create UI pages and widgets in `presentation/`
10. Register all dependencies in `injection_container.dart`
11. Add routes to `go_router_config.dart`
12. Write unit tests for all layers

### Modifying Supabase Schema

1. Create migration file in `supabase/migrations/YYYYMMDD_description.sql`
2. Test migration locally
3. Update `02_FRESH_SCHEMA.sql` to reflect changes
4. Update corresponding models and entities
5. Update data sources to use new schema
6. Update tests

### Adding New Routes

1. Add route in `lib/core/routes/go_router_config.dart`
2. Follow existing patterns for BlocProvider injection
3. Use named routes for type-safe navigation
4. Handle route parameters using `state.pathParameters` or `state.extra`

## Project-Specific Notes

### Three-Role System
- **User/Customer**: Browse fields, create bookings, write reviews
- **Admin/Field Owner**: Manage owned fields, approve bookings, track revenue
- **Super Admin**: Platform management, user/admin management, system analytics

### Booking Flow Enhancement
- Duration selection: 1 or 2 hours
- Payment methods: Vodafone Cash, InstaPay
- Payment proof upload with verification
- Cross-midnight booking support (e.g., 11 PM - 1 AM)
- Tomorrow is earliest booking date (not today)

### Push Notifications
- Firebase Cloud Messaging (FCM) for Android
- Database triggers → Supabase Edge Function → FCM
- Token management in `user_fcm_tokens` table
- Notifications for booking events and payment updates

### Map Integration
- Uses `flutter_map` with OpenStreetMap (no API key required)
- `NominatimGeocodingService` for free geocoding
- Location picker in Super Admin field creation

## Dart SDK & Flutter Version

- **Dart SDK**: ^3.10.0
- **Flutter**: 3.10+
- **Platforms**: Android, iOS, Web, Windows
