# Code Quality Standards

**Last Updated:** January 2026
**Flutter Version:** 3.38.2+ (Material 3)
**Dart Version:** 3.0+

This document defines the **mandatory** code quality standards for the Sport Kick application based on our completed refactoring work (Phases 1-17). ALL code must follow these standards without exception.

---

## Table of Contents

1. [Clean Architecture Principles](#1-clean-architecture-principles)
2. [File Size & Organization](#2-file-size--organization)
3. [Presentation Layer Standards](#3-presentation-layer-standards)
4. [Domain Layer Standards](#4-domain-layer-standards)
5. [Data Layer Standards](#5-data-layer-standards)
6. [State Management (Cubit/Bloc)](#6-state-management-cubitbloc)
7. [Widget & UI Standards](#7-widget--ui-standards)
8. [Code Quality & Best Practices](#8-code-quality--best-practices)
9. [Testing Standards](#9-testing-standards)
10. [Responsive Design](#10-responsive-design)

---

## 1. Clean Architecture Principles

### 1.1 Layer Boundaries (CRITICAL)

**Domain Layer** (Pure Dart - Zero Flutter Dependencies)
- ✅ Contains: Entities, UseCases, Repository interfaces
- ❌ NO Flutter imports (`dart:ui`, `package:flutter`)
- ❌ NO UI properties (Color, IconData, LinearGradient)
- ✅ Use extensions in presentation layer for UI properties

**Data Layer** (Infrastructure)
- ✅ Contains: Models, DataSources, Repository implementations
- ✅ Knows about: Supabase, APIs, databases
- ❌ NO business logic (validation, calculations, transformations)
- ✅ Use utilities/mappers for complex transformations

**Presentation Layer** (UI)
- ✅ Contains: Cubits, States, Pages, Widgets
- ✅ Talks to: UseCases only (never DataSources directly)
- ❌ NO direct access to `supabaseClient`
- ❌ NO business logic in pages/widgets

### 1.2 Dependency Flow

```
Presentation → Domain ← Data
     ↓           ↓
  Cubits    UseCases
     ↓           ↓
  Widgets   Repositories → DataSources → Supabase
```

**Rules:**
- Presentation depends on Domain (UseCases)
- Data depends on Domain (Repository interfaces)
- Domain depends on NOTHING (pure Dart)

---

## 2. File Size & Organization

### 2.1 File Size Limits (MANDATORY)

| File Type | Max Lines | Action if Exceeded |
|-----------|-----------|-------------------|
| Any Dart file | 300 lines | Split into multiple files |
| Cubit | 150 lines | Split into focused cubits |
| Page | 50 lines | Extract to widgets |
| Widget | 200 lines | Extract sections |
| DataSource | 300 lines | Use facade pattern |
| UseCase | 100 lines | Extract validators/helpers |

### 2.2 File Structure

**Feature Organization:**
```
lib/features/{feature}/
├── domain/
│   ├── entities/          # Business models (extend Equatable)
│   ├── usecases/          # Single-responsibility operations
│   ├── repositories/      # Abstract interfaces
│   └── utils/             # Business logic utilities
├── data/
│   ├── models/            # DTOs with fromJson/toJson
│   ├── datasources/       # Supabase/API communication
│   │   ├── {feature}_creation_datasource.dart
│   │   ├── {feature}_operations_datasource.dart
│   │   └── {feature}_remote_datasource.dart  # Facade
│   ├── repositories/      # Concrete implementations
│   └── mappers/           # Complex JSON parsing
└── presentation/
    ├── cubit/
    │   ├── {concern_1}/   # e.g., field_management/
    │   │   ├── {concern}_cubit.dart
    │   │   └── {concern}_state.dart
    │   └── {concern_2}/
    ├── pages/             # Routing shells only (< 50 lines)
    └── widgets/
        ├── {page_name}/   # Page-specific widgets
        └── shared/        # Reusable widgets
```

### 2.3 Naming Conventions

| Type | Pattern | Example |
|------|---------|---------|
| Files | snake_case | `field_management_cubit.dart` |
| Classes | PascalCase | `FieldManagementCubit` |
| Variables | camelCase | `isFieldActive` |
| Constants | camelCase | `AppPadding.medium` |
| Booleans | is/has/should prefix | `isLoading`, `hasError` |
| Functions | verbNoun | `fetchAvailableFields()` |
| UseCases | VerbNounUseCase | `GetAllFieldsUseCase` |
| Pages | {Name}Page | `FieldDetailsPage` |
| Widgets | {Name}Widget | `FieldCard` |

### 2.4 One Class Per File (MANDATORY)

✅ **Good:**
```
lib/features/fields/presentation/widgets/
├── field_card.dart              # Only FieldCard
├── field_card_image.dart        # Only FieldCardImage
└── field_card_rating.dart       # Only FieldCardRating
```

❌ **Bad:**
```dart
// field_widgets.dart - MULTIPLE CLASSES (FORBIDDEN)
class FieldCard extends StatelessWidget { }
class FieldCardImage extends StatelessWidget { }
class FieldCardRating extends StatelessWidget { }
```

**Exception:** Tiny private helper widgets (< 10 lines) can stay in the same file, but default rule is: **"If it has a name, it gets its own file."**

---

## 3. Presentation Layer Standards

### 3.1 Cubit Splitting Rules

**When to Split a Cubit:**
- ❌ Cubit handles > 3 different concerns
- ❌ Cubit has > 5 use cases
- ❌ Cubit exceeds 150 lines
- ❌ Cubit manages multiple domains (users + fields + bookings)

**Example from Phase 3 (SuperAdmin):**

❌ **Before:** `super_admin_cubit.dart` (140 lines + 7 mixins, 22 use cases)

✅ **After:** Split into 7 focused cubits:
```
lib/features/super_admin/presentation/cubit/
├── admin_management/
│   ├── admin_management_cubit.dart
│   └── admin_management_state.dart
├── booking_management/
│   ├── booking_management_cubit.dart
│   └── booking_management_state.dart
├── city_management/
├── export/
├── field_management/
├── statistics/
└── user_management/
```

### 3.2 State Pattern (Sealed Classes)

✅ **Mandatory Pattern:**
```dart
sealed class FeatureState extends Equatable {
  const FeatureState();
  @override
  List<Object?> get props => [];
}

class FeatureInitial extends FeatureState {}

class FeatureLoading extends FeatureState {
  final String? message;
  const FeatureLoading({this.message});
  @override
  List<Object?> get props => [message];
}

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

**Rules:**
- ✅ Use `sealed class` for exhaustive pattern matching
- ✅ All states extend `Equatable`
- ✅ Override `props` with ALL properties
- ✅ Use const constructors
- ❌ NO mutable state properties

### 3.3 Page Organization (Phase 12, 14)

**Pages Must Be Routing Shells Only (< 50 lines)**

✅ **Good Page Structure:**
```dart
/// Field Details Page - Displays detailed information about a field
class FieldDetailsPage extends StatelessWidget {
  final String fieldId;

  const FieldDetailsPage({super.key, required this.fieldId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<FieldDetailsCubit>()..loadFieldDetails(fieldId),
      child: const FieldDetailsView(),  // All UI in separate widget
    );
  }
}
```

**What Pages Should NOT Contain:**
- ❌ Form initialization logic → Move to Cubit
- ❌ Business logic → Move to UseCase
- ❌ Helper functions → Move to utils or cubit
- ❌ Multiple widget classes → Extract to separate files
- ❌ TextEditingController logic → Cubit handles form state

**Example from Phase 14:**

❌ **Before:** `edit_field_page.dart` (225 lines with form logic)
```dart
class _EditFieldPageState extends State<EditFieldPage> {
  void _initializeFormWithFieldData() {
    // Business logic: mapping capacity to size
    _selectedSize = _mapCapacityToSize(field.capacity);  // ❌ Business logic
  }

  String _mapCapacityToSize(int capacity) {  // ❌ Helper function
    if (capacity <= 10) return '5-a-side';
    if (capacity <= 14) return '7-a-side';
    return '11-a-side';
  }
}
```

✅ **After:** `edit_field_page.dart` (260 lines, business logic in cubit)
```dart
@override
void initState() {
  super.initState();
  // Request form initialization from cubit
  WidgetsBinding.instance.addPostFrameCallback((_) {
    context.read<FieldManagementCubit>().initializeFieldForm(widget.field);
  });
}

// Page only syncs UI state from cubit
void _populateFormFromData(FieldFormData formData) {
  _nameController.text = formData.name;
  _selectedSize = formData.size;  // ✅ Already computed by cubit
}
```

**Cubit handles business logic:**
```dart
// field_management_cubit.dart
void initializeFieldForm(FieldEntity field) {
  final formData = FieldFormData(
    size: FieldFormUtils.mapCapacityToSize(field.capacity),  // ✅ Business logic in utils
    // ...
  );
  emit(FieldFormInitialized(formData));
}
```

### 3.4 Architecture Violations (Phase 7)

**FORBIDDEN Patterns:**

❌ **1. Cubit-to-Cubit Dependencies**
```dart
class ReviewFormCubit extends Cubit {
  final ReviewsCubit reviewsCubit;  // ❌ FORBIDDEN

  void submit() {
    await reviewsCubit.createReview();  // ❌ Coupling cubits
  }
}
```

✅ **Fix:** Use UseCases directly
```dart
class ReviewFormCubit extends Cubit {
  final CreateReviewUseCase createReviewUseCase;  // ✅ Use UseCases

  void submit() {
    final result = await createReviewUseCase(params);
    result.fold(
      (failure) => emit(ReviewFormError(failure.message)),
      (review) => emit(ReviewFormSuccess(review)),
    );
  }
}
```

❌ **2. Direct Repository Access in Cubit**
```dart
class BookingCubit extends Cubit {
  final BookingRepository repository;  // ❌ FORBIDDEN

  void loadBookings() {
    final result = await repository.getBookings();  // ❌ Skip UseCase layer
  }
}
```

✅ **Fix:** Always use UseCases
```dart
class BookingCubit extends Cubit {
  final GetUserBookingsUseCase getUserBookingsUseCase;  // ✅ Use UseCases

  void loadBookings() {
    final result = await getUserBookingsUseCase();
  }
}
```

---

## 4. Domain Layer Standards

### 4.1 Pure Dart Rule (CRITICAL)

**Domain layer MUST have ZERO Flutter dependencies**

❌ **Before (Phase 1):**
```dart
// booking_status.dart (Domain Layer)
import 'package:flutter/material.dart';  // ❌ FORBIDDEN

enum BookingStatus {
  pending,
  confirmed;

  Color get color {  // ❌ UI logic in domain
    switch (this) {
      case BookingStatus.pending: return Colors.orange;
      case BookingStatus.confirmed: return Colors.green;
    }
  }
}
```

✅ **After:**
```dart
// booking_status.dart (Domain Layer)
enum BookingStatus {
  pending,
  confirmed,
}

// booking_status_ui_extension.dart (Presentation Layer)
import 'package:flutter/material.dart';

extension BookingStatusUI on BookingStatus {
  Color get color {  // ✅ UI logic in presentation
    switch (this) {
      case BookingStatus.pending: return Colors.orange;
      case BookingStatus.confirmed: return Colors.green;
    }
  }
}
```

### 4.2 UseCase Standards (Phase 6)

**Single Responsibility:**
- ✅ One UseCase = One operation
- ✅ Business logic in UseCase, not Cubit
- ✅ Keep UseCases < 100 lines

**Example from Phase 6:**

❌ **Before:** Business logic in Cubit
```dart
// booking_flow_cubit.dart
Map<String, List<TimeSlotEntity>> _groupSlotsByPeriod(List<TimeSlotEntity> slots) {
  // 31 lines of grouping logic  // ❌ Business logic in cubit
}
```

✅ **After:** Extracted to UseCase
```dart
// group_time_slots_by_period_usecase.dart
class GroupTimeSlotsByPeriodUseCase {
  Either<Failure, Map<String, List<TimeSlotEntity>>> call(
    List<TimeSlotEntity> timeSlots,
  ) {
    // Grouping logic  // ✅ Business logic in UseCase
  }
}

// booking_flow_cubit.dart
final result = await _groupTimeSlotsByPeriodUseCase(timeSlots);  // ✅ Cubit orchestrates
```

### 4.3 Entity Standards

```dart
/// Field entity representing a football field
class FieldEntity extends Equatable {
  final String id;
  final String name;
  final double pricePerHour;

  const FieldEntity({
    required this.id,
    required this.name,
    required this.pricePerHour,
  });

  @override
  List<Object?> get props => [id, name, pricePerHour];
}
```

**Rules:**
- ✅ Extend `Equatable`
- ✅ Use const constructors
- ✅ Immutable properties (final)
- ✅ Override `props` with ALL properties
- ❌ NO Flutter dependencies
- ❌ NO UI properties

---

## 5. Data Layer Standards

### 5.1 Facade Pattern for Large DataSources (Phase 15)

**When DataSource Exceeds 300 Lines → Split with Facade**

❌ **Before:** Monolithic DataSource (400 lines)
```dart
// super_admin_field_management_datasource.dart (400 lines)
class SuperAdminFieldManagementDataSourceImpl {
  Future<FieldModel> createField() { }      // 80 lines
  Future<FieldModel> updateField() { }      // 70 lines
  Future<void> deleteField() { }            // 50 lines
  Future<void> verifyField() { }            // 40 lines
  Future<void> assignFieldToAdmin() { }     // 60 lines
  // ... more methods
}
```

✅ **After:** Split into focused DataSources + Facade
```
lib/features/super_admin/data/datasources/
├── super_admin_field_creation_datasource.dart       (190 lines)
├── super_admin_field_operations_datasource.dart     (184 lines)
├── super_admin_field_assignment_datasource.dart     (85 lines)
└── super_admin_field_management_datasource.dart     (211 lines - FACADE)
```

**Facade Pattern:**
```dart
// super_admin_field_management_datasource.dart (Facade)
class SuperAdminFieldManagementDataSourceImpl
    implements SuperAdminFieldManagementDataSource {

  final SuperAdminFieldCreationDataSource _creationDataSource;
  final SuperAdminFieldOperationsDataSource _operationsDataSource;
  final SuperAdminFieldAssignmentDataSource _assignmentDataSource;

  SuperAdminFieldManagementDataSourceImpl({
    required SuperAdminFieldCreationDataSource creationDataSource,
    required SuperAdminFieldOperationsDataSource operationsDataSource,
    required SuperAdminFieldAssignmentDataSource assignmentDataSource,
  }) : _creationDataSource = creationDataSource,
       _operationsDataSource = operationsDataSource,
       _assignmentDataSource = assignmentDataSource;

  @override
  Future<FieldModel> createField({...}) =>
      _creationDataSource.createField(...);

  @override
  Future<FieldModel> updateField({...}) =>
      _operationsDataSource.updateField(...);

  @override
  Future<void> assignFieldToAdmin({...}) =>
      _assignmentDataSource.assignFieldToAdmin(...);
}
```

**Benefits:**
- ✅ Each datasource < 300 lines
- ✅ Single responsibility per datasource
- ✅ Backward compatibility via facade
- ✅ Easy testing (mock individual datasources)

### 5.2 Business Logic Extraction (Phase 2)

**NO Business Logic in Data Layer**

❌ **Before:** Business logic in DataSource
```dart
// booking_time_slot_datasource.dart
List<TimeSlotEntity> generateTimeSlots(...) {
  // 190 lines of time slot generation algorithm  // ❌ Business logic
}

String _generateDefaultPassword() {
  // Password generation logic  // ❌ Business logic
}
```

✅ **After:** Extracted to utilities
```dart
// lib/features/bookings/data/utils/time_slot_generator.dart
class TimeSlotGenerator {
  static List<TimeSlotEntity> generateTimeSlots(...) {
    // Time slot generation  // ✅ Utility class
  }
}

// lib/core/utils/password_generator.dart
class PasswordGenerator {
  static String generateAdminPassword() {
    // Password generation  // ✅ Utility class
  }
}
```

### 5.3 Complex JSON Parsing (Phase 2)

**Extract Complex Parsing to Mappers**

❌ **Before:** Complex parsing in DataSource
```dart
// review_remote_datasource.dart
ReviewModel _parseReviewResponse(Map<String, dynamic> json) {
  // 34 lines of complex nested JSON parsing  // ❌ Too complex
}
```

✅ **After:** Extracted to Mapper
```dart
// lib/features/reviews/data/mappers/review_response_mapper.dart
class ReviewResponseMapper {
  static ReviewModel fromSupabaseResponse(Map<String, dynamic> json) {
    // Complex parsing logic  // ✅ Dedicated mapper
  }
}
```

---

## 6. State Management (Cubit/Bloc)

### 6.1 Dependency Injection (get_it)

**Registration Patterns:**

```dart
// lib/core/di/injection_container.dart

// 1. Factory for Cubits (new instance each time)
sl.registerFactory(() => AuthCubit(loginUseCase: sl()));

// 2. LazySingleton for UseCases/Repositories (reused)
sl.registerLazySingleton(() => LoginUseCase(sl()));

// 3. Named instances for conflicts
sl.registerLazySingleton(
  () => UpdateFieldUseCase(sl<SuperAdminRepository>()),
  instanceName: 'superAdminUpdateField',
);

// Usage:
sl.get<UpdateFieldUseCase>(instanceName: 'superAdminUpdateField')

// 4. Factory with runtime parameters
sl.registerFactoryParam<CreateBookingCubit, FieldEntity, void>(
  (field, _) => CreateBookingCubit(field: field, createUseCase: sl()),
);

// Usage:
sl<CreateBookingCubit>(param1: fieldEntity)
```

**Rules:**
- ✅ Cubits: `registerFactory` (new instance per page)
- ✅ UseCases: `registerLazySingleton` (reused)
- ✅ Repositories: `registerLazySingleton`
- ✅ DataSources: `registerLazySingleton`
- ✅ External: `registerSingleton` (e.g., SupabaseClient)

### 6.2 Error Handling

**Use Either<Failure, Success> Pattern:**

```dart
// In UseCase
Future<Either<Failure, List<FieldEntity>>> call() async {
  try {
    final fields = await repository.getAllFields();
    return Right(fields);
  } catch (e) {
    return Left(ServerFailure('Failed to fetch fields'));
  }
}

// In Cubit
Future<void> loadFields() async {
  emit(FieldsLoading());

  final result = await getAllFieldsUseCase();

  result.fold(
    (failure) {
      debugPrint('[FieldsCubit] Error: ${failure.message}');
      emit(FieldsError(failure.message));
    },
    (fields) => emit(FieldsLoaded(fields)),
  );
}
```

### 6.3 Logging Standards

```dart
// ✅ Tag-based logging
debugPrint('[FieldManagementCubit] Loading fields...');
debugPrint('[AuthRepository] Login failed: ${failure.message}');

// ❌ Never log sensitive data
debugPrint('Password: $password');  // FORBIDDEN
debugPrint('Token: $authToken');    // FORBIDDEN
```

---

## 7. Widget & UI Standards

### 7.1 Page Widget Extraction (Phase 8, 11)

**Large Pages Must Be Split into Widgets**

❌ **Before:** All UI in one file (437 lines)
```dart
// super_admin_reports_page.dart (437 lines)
class SuperAdminReportsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // 100 lines of stats overview
          // 120 lines of report cards
          // 95 lines of export section
        ],
      ),
    );
  }
}
```

✅ **After:** Split into focused widgets (27 lines page + 5 widget files)
```
lib/features/super_admin/presentation/
├── pages/
│   └── super_admin_reports_page.dart (27 lines) ✓
└── widgets/
    └── reports/
        ├── super_admin_reports_view.dart (177 lines)
        ├── stats_overview_section.dart (83 lines)
        ├── stat_item_card.dart (53 lines)
        ├── report_card.dart (123 lines)
        └── export_section.dart (95 lines)
```

**Page becomes routing shell only:**
```dart
// super_admin_reports_page.dart (27 lines)
class SuperAdminReportsPage extends StatelessWidget {
  const SuperAdminReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<StatisticsCubit>()..loadPlatformStatistics(),
      child: const SuperAdminReportsView(),  // All UI extracted
    );
  }
}
```

### 7.2 Widget Best Practices

**Prefer StatelessWidget:**
```dart
// ✅ Stateless when possible
class FieldCard extends StatelessWidget {
  final FieldEntity field;
  final VoidCallback onTap;

  const FieldCard({
    super.key,
    required this.field,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(field.name),
        onTap: onTap,
      ),
    );
  }
}
```

**Use StatefulWidget only for:**
- Local UI state (AnimationController, TabController, TextEditingController)
- ❌ NOT for business state (use Cubit instead)

**Const Constructors:**
```dart
// ✅ Use const for performance
const SizedBox(height: 16);
const Text('Hello');

// ❌ Missing const
SizedBox(height: 16);
```

---

## 8. Code Quality & Best Practices

### 8.1 DRY (Don't Repeat Yourself)

**Extract Repeated Code:**

❌ **Before:**
```dart
// In 5 different files
Container(
  padding: const EdgeInsets.all(16),
  decoration: BoxDecoration(
    gradient: LinearGradient(
      colors: [Color(0xFF1A237E), Color(0xFF3949AB)],
    ),
  ),
)
```

✅ **After:**
```dart
// lib/core/constants/app_gradients.dart
class AppGradients {
  static const primaryGradient = LinearGradient(
    colors: [Color(0xFF1A237E), Color(0xFF3949AB)],
  );
}

// Usage
Container(
  padding: const EdgeInsets.all(AppPadding.medium),
  decoration: const BoxDecoration(gradient: AppGradients.primaryGradient),
)
```

### 8.2 No Magic Numbers/Strings

```dart
// ✅ Named constants
class AppPadding {
  static const double small = 8.0;
  static const double medium = 16.0;
  static const double large = 24.0;
}

class AppDurations {
  static const animationShort = Duration(milliseconds: 200);
  static const animationMedium = Duration(milliseconds: 300);
}

// Usage
Padding(
  padding: const EdgeInsets.all(AppPadding.medium),
  child: AnimatedOpacity(
    duration: AppDurations.animationShort,
    opacity: isVisible ? 1.0 : 0.0,
  ),
)
```

### 8.3 Null Safety

```dart
// ✅ Safe null handling
final name = user?.name ?? 'Guest';
if (user?.email != null) { ... }

// ❌ Unsafe null handling
final name = user!.name;  // Crashes if user is null
```

### 8.4 Documentation

**Required for:**
- All public classes
- All UseCases
- All Cubits
- All complex functions

```dart
/// Fetches all active fields from the repository.
///
/// Returns [Right<List<FieldEntity>>] on success.
/// Returns [Left<Failure>] on error.
///
/// Throws [ServerException] if network request fails.
Future<Either<Failure, List<FieldEntity>>> getAllFields();
```

### 8.5 Import Organization

```dart
// 1. Dart imports
import 'dart:async';

// 2. Flutter imports
import 'package:flutter/material.dart';

// 3. Package imports
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// 4. Local imports
import 'package:spo_kick/core/constants/app_colors.dart';
import 'package:spo_kick/features/fields/domain/entities/field_entity.dart';
```

---

## 9. Testing Standards

### 9.1 Test Coverage Requirements

| Component | Required Tests | Example |
|-----------|----------------|---------|
| UseCases | Unit tests | `get_all_fields_usecase_test.dart` |
| Cubits | Bloc tests | `field_management_cubit_test.dart` |
| Repositories | Mock tests | `field_repository_impl_test.dart` |
| Critical UI | Widget tests | `booking_flow_test.dart` |

### 9.2 Cubit Testing Pattern

```dart
blocTest<FieldsCubit, FieldsState>(
  'emits [Loading, Success] when fields are fetched successfully',
  build: () {
    when(() => mockGetAllFieldsUseCase.call())
        .thenAnswer((_) async => Right(mockFields));
    return FieldsCubit(getAllFieldsUseCase: mockGetAllFieldsUseCase);
  },
  act: (cubit) => cubit.loadFields(),
  expect: () => [
    FieldsLoading(),
    FieldsLoaded(mockFields),
  ],
  verify: (_) {
    verify(() => mockGetAllFieldsUseCase.call()).called(1);
  },
);
```

### 9.3 Test Organization

```
test/
├── features/
│   └── fields/
│       ├── domain/
│       │   └── usecases/
│       │       └── get_all_fields_usecase_test.dart
│       └── presentation/
│           └── cubit/
│               └── fields_cubit_test.dart
└── core/
    └── utils/
        └── validators_test.dart
```

---

## 10. Responsive Design

### 10.1 Breakpoints

```dart
enum ScreenSize {
  small,    // < 400 (Phones)
  medium,   // 400-600 (Large Phones)
  large,    // 600-900 (Tablets)
  xlarge,   // > 900 (Web/Desktop)
}

ScreenSize getScreenSize(BuildContext context) {
  final width = MediaQuery.of(context).size.width;
  if (width < 400) return ScreenSize.small;
  if (width < 600) return ScreenSize.medium;
  if (width < 900) return ScreenSize.large;
  return ScreenSize.xlarge;
}
```

### 10.2 Responsive Layout

```dart
// ✅ Use LayoutBuilder
LayoutBuilder(
  builder: (context, constraints) {
    if (constraints.maxWidth < 400) {
      return const _SmallCard();
    } else {
      return const _LargeCard();
    }
  },
);

// ✅ Flexible widgets
Expanded(
  child: BookingCard(booking: booking),
)

// ❌ Hardcoded dimensions
Container(width: 300, height: 200)  // FORBIDDEN
```

### 10.3 Responsive Testing Checklist

Before merging UI code:
- [ ] Test on small width (Pixel 4a)
- [ ] Test on large width (Tablet)
- [ ] Test landscape mode
- [ ] Test web (desktop browser)
- [ ] Test long text overflow
- [ ] Test with system font scaling

---

## Code Review Checklist

Before submitting code, verify:

### Architecture
- [ ] Follows Clean Architecture (Domain → Data → Presentation)
- [ ] Domain layer has ZERO Flutter dependencies
- [ ] No business logic in pages/widgets
- [ ] No cubit-to-cubit dependencies
- [ ] All data access through UseCases

### File Organization
- [ ] Each file ≤ 300 lines
- [ ] Pages ≤ 50 lines (routing shells only)
- [ ] One class per file
- [ ] Proper folder structure (domain/data/presentation)

### Code Quality
- [ ] `flutter analyze` passes with 0 issues
- [ ] `flutter test` all tests passing
- [ ] `flutter format .` has been run
- [ ] No magic numbers/strings
- [ ] Meaningful variable/function names
- [ ] Proper null safety (minimal use of `!`)
- [ ] Documentation on public APIs

### State Management
- [ ] States use sealed classes
- [ ] States extend Equatable
- [ ] Cubits registered in DI properly
- [ ] Error handling with Either pattern

### UI
- [ ] Responsive layout (tested on multiple sizes)
- [ ] No hardcoded dimensions
- [ ] Uses theme/design system
- [ ] Const constructors where possible
- [ ] StatelessWidget preferred

### Performance
- [ ] No unnecessary rebuilds
- [ ] ListView.builder for lists
- [ ] CachedNetworkImage for network images
- [ ] Heavy computations in UseCases/Cubits

---

## Summary: Golden Rules

1. **Domain layer = Pure Dart** (zero Flutter imports)
2. **Files ≤ 300 lines** (split with facade pattern if needed)
3. **Pages ≤ 50 lines** (routing shells only)
4. **One class per file** (if it has a name, it gets a file)
5. **Business logic in UseCases** (not in Cubits or Pages)
6. **Split large cubits** (max 150 lines, single responsibility)
7. **No cubit-to-cubit dependencies** (use UseCases)
8. **Sealed classes for states** (with Equatable)
9. **Document public APIs** (100% coverage required)
10. **Test everything** (UseCases, Cubits, critical UI)

---

**These standards are based on 15 completed refactoring phases across 100+ files. They are proven to work and MUST be followed for all new code.**

*Last Refactoring: January 2026 - Phases 1-17 Complete*
