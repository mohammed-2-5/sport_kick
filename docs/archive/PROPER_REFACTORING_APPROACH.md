# Proper Refactoring Approach - Code Quality Standards

**Date**: 2025-12-04
**Status**: ✅ Approved Approach

## Overview

This document defines the CORRECT approach for refactoring presentation layer pages to meet code quality standards while maintaining proper separation of concerns.

## The Problem - What I Did Wrong Initially

### ❌ BAD: Initial Refactoring (create_field_page.dart v1)

```dart
// WRONG: Direct database calls in UI
Future<void> _loadCities() async {
  final response = await Supabase.instance.client
      .from('cities')
      .select('name')
      .eq('is_active', true);
  // ...
}

// WRONG: Business logic in UI
void _handleSubmit(BuildContext context) {
  if (_selectedAdmin == null) {
    ScaffoldMessenger.of(context).showSnackBar(...);
    return;
  }

  int capacity = _selectedSize == '5v5' ? 10 : _selectedSize == '7v7' ? 14 : 22;
  // ...
}

// WRONG: Hardcoded data in UI
final List<String> _sizes = ['5v5', '7v7', '11v11'];
final List<String> _surfaces = ['Natural Grass', 'Artificial Turf', 'Hybrid'];
```

**Issues:**
1. 🔴 Direct Supabase calls violate Clean Architecture
2. 🔴 Business logic mixed with UI code
3. 🔴 Hardcoded constants scattered in UI files
4. 🔴 Validation logic in page state
5. 🔴 Not testable in isolation

---

## ✅ CORRECT Approach - Proper Separation

### Layer Responsibilities

```
┌─────────────────────────────────────────────────────┐
│ PRESENTATION LAYER                                   │
├─────────────────────────────────────────────────────┤
│                                                      │
│  📄 Pages (.dart)                                   │
│  ├─ Scaffold, AppBar, routing                       │
│  ├─ BlocProvider, BlocConsumer                      │
│  ├─ Widget composition                              │
│  ├─ User interactions → call cubit methods         │
│  └─ Display data from cubit state                   │
│                                                      │
│  🧩 Widgets (.dart)                                 │
│  ├─ Reusable UI components                          │
│  ├─ Accept data via parameters                      │
│  ├─ Emit callbacks for interactions                 │
│  └─ NO business logic, NO state management          │
│                                                      │
│  📊 Cubit (.dart)                                   │
│  ├─ State management                                │
│  ├─ Call use cases                                  │
│  ├─ Emit states (Loading, Success, Error)           │
│  └─ NO direct database/API calls                    │
│                                                      │
│  📐 Constants (.dart)                               │
│  ├─ Static data (lists, defaults)                   │
│  ├─ Configuration values                            │
│  └─ Reusable across features                        │
│                                                      │
│  ✔️ Validators (.dart)                              │
│  ├─ Pure functions                                  │
│  ├─ Input validation logic                          │
│  └─ Return error messages or null                   │
│                                                      │
└─────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────┐
│ DOMAIN LAYER                                         │
├─────────────────────────────────────────────────────┤
│                                                      │
│  🎯 Use Cases (.dart)                               │
│  ├─ Single responsibility                           │
│  ├─ Call repository methods                         │
│  ├─ Return Either<Failure, Success>                 │
│  └─ Business rules enforcement                      │
│                                                      │
└─────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────┐
│ DATA LAYER                                           │
├─────────────────────────────────────────────────────┤
│                                                      │
│  💾 Repository Implementation (.dart)                │
│  ├─ Call data sources                               │
│  ├─ Handle errors → Failures                        │
│  └─ Map models to entities                          │
│                                                      │
│  🔌 Data Sources (.dart)                            │
│  ├─ Direct database/API calls                       │
│  ├─ Return models (DTOs)                            │
│  └─ Throw exceptions on error                       │
│                                                      │
└─────────────────────────────────────────────────────┘
```

---

## ✅ Correct Implementation Example

### 1. Constants File
**Location**: `lib/features/super_admin/presentation/constants/field_form_constants.dart`

```dart
/// Contains all static data for field creation form
class FieldFormConstants {
  const FieldFormConstants._();

  // ✅ Hardcoded lists belong here
  static const List<String> sizes = ['5v5', '7v7', '11v11'];
  static const List<String> surfaces = [
    'Natural Grass',
    'Artificial Turf',
    'Hybrid',
  ];
  static const List<String> facilities = [
    'Parking',
    'Changing Room',
    'Shower',
    'Cafeteria',
    'WiFi',
    'Lighting',
  ];

  // ✅ Default values
  static const String defaultSize = '5v5';
  static const String defaultSurface = 'Natural Grass';
  static const bool defaultIsIndoor = false;

  // ✅ Business logic helper (pure function)
  static int getSizeCapacity(String size) {
    switch (size) {
      case '5v5': return 10;
      case '7v7': return 14;
      case '11v11': return 22;
      default: return 10;
    }
  }
}
```

**Why?**
- ✅ Single source of truth
- ✅ Easy to update
- ✅ Reusable across features
- ✅ Testable independently

---

### 2. Validator File
**Location**: `lib/features/super_admin/presentation/validators/field_form_validator.dart`

```dart
/// Pure validation functions for field form
class FieldFormValidator {
  const FieldFormValidator._();

  // ✅ Each validator is a pure function
  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Field name is required';
    }
    return null;
  }

  static String? validatePrice(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Price is required';
    }
    final price = double.tryParse(value);
    if (price == null) {
      return 'Please enter a valid number';
    }
    if (price <= 0) {
      return 'Price must be greater than 0';
    }
    return null;
  }

  static String? validateAdmin(UserEntity? admin) {
    if (admin == null) {
      return 'Please select an admin to assign this field';
    }
    return null;
  }
}
```

**Why?**
- ✅ Separation of concerns
- ✅ Easy to test
- ✅ Reusable validators
- ✅ Clean page code

---

### 3. Cubit with Extensions
**Location**: `lib/features/super_admin/presentation/cubit/`

```dart
// Main cubit - only dependencies and constructor
class SuperAdminCubit extends Cubit<SuperAdminState> {
  final GetActiveCitiesUseCase getActiveCitiesUseCase;
  final CreateFieldUseCase createFieldUseCase;
  // ... other use cases

  SuperAdminCubit({
    required this.getActiveCitiesUseCase,
    required this.createFieldUseCase,
    // ...
  }) : super(const SuperAdminInitial());
}

// Extension - city operations
extension CityOperations on SuperAdminCubit {
  // ✅ Use case call, NO direct database access
  Future<void> loadCities() async {
    emit(const SuperAdminLoading(message: 'Loading cities...'));

    final result = await getActiveCitiesUseCase();

    result.fold(
      (failure) => emit(SuperAdminError(failure.message)),
      (cities) => emit(CitiesLoaded(cities)),
    );
  }
}

// Extension - field operations
extension FieldManagementOperations on SuperAdminCubit {
  // ✅ Use case call with proper parameters
  Future<void> createField({
    required String ownerId,
    required String sportCategoryId,
    required String name,
    // ... all parameters
  }) async {
    emit(const SuperAdminLoading(message: 'Creating field...'));

    final result = await createFieldUseCase(
      ownerId: ownerId,
      sportCategoryId: sportCategoryId,
      name: name,
      // ...
    );

    result.fold(
      (failure) => emit(SuperAdminError(failure.message)),
      (field) => emit(FieldCreated(field)),
    );
  }
}
```

**Why?**
- ✅ Clean Architecture respected
- ✅ Uses use cases (not direct DB calls)
- ✅ Organized by concern
- ✅ Testable with mocks

---

### 4. Page Implementation
**Location**: `lib/features/super_admin/presentation/pages/create_field_page.dart`

```dart
class _CreateFieldPageState extends State<CreateFieldPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  // ✅ Use constants for defaults
  String _selectedSize = FieldFormConstants.defaultSize;
  String _selectedSurface = FieldFormConstants.defaultSurface;
  bool _isIndoor = FieldFormConstants.defaultIsIndoor;

  void _handleSubmit(BuildContext context, Map<String, String> sportCategories) {
    // ✅ Use validator
    if (!_formKey.currentState!.validate()) return;

    // ✅ Use validator for non-form fields
    final adminError = FieldFormValidator.validateAdmin(_selectedAdmin);
    if (adminError != null) {
      _showError(context, adminError);
      return;
    }

    // ✅ Use constants helper
    final capacity = FieldFormValidator.getCapacityForSize(_selectedSize);

    // ✅ Call cubit method (not use case directly!)
    context.read<SuperAdminCubit>().createField(
      ownerId: _selectedAdmin!.id,
      sportCategoryId: sportCategories[_selectedSportCategory!] ?? '',
      name: _nameController.text.trim(),
      // ...
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // ✅ Load data via cubit methods
      create: (_) => sl<SuperAdminCubit>()
        ..loadAdmins()
        ..loadCities(),
      child: Scaffold(
        body: BlocConsumer<SuperAdminCubit, SuperAdminState>(
          listener: (context, state) {
            // ✅ Handle state changes
            if (state is FieldCreated) {
              showDialog(...);
            }
          },
          builder: (context, state) {
            // ✅ Extract data from state
            List<UserEntity> admins = [];
            if (state is AdminsListLoaded) {
              admins = state.admins;
            }

            // ✅ Pass to widget
            return CreateFieldFormBody(
              admins: admins,
              sizes: FieldFormConstants.sizes, // ✅ Use constants
              onSubmit: () => _handleSubmit(context, sportCategories),
              // ...
            );
          },
        ),
      ),
    );
  }
}
```

**Why?**
- ✅ UI-only code
- ✅ Calls cubit for data/actions
- ✅ Uses validators and constants
- ✅ Clean and readable

---

### 5. Widget Files
**Location**: `lib/features/super_admin/presentation/widgets/create_field/`

```dart
class CreateFieldFormBody extends StatelessWidget {
  final List<UserEntity> admins;
  final List<String> sizes;
  final VoidCallback onSubmit;
  // ... all parameters

  const CreateFieldFormBody({
    required this.admins,
    required this.sizes,
    required this.onSubmit,
    // ...
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // ✅ Pure UI - just displays data and emits callbacks
    return Form(
      child: ListView(
        children: [
          FieldFormDropdown<String>(
            label: 'Field Size',
            value: selectedSize,
            items: sizes.map((s) => DropdownMenuItem(...)).toList(),
            onChanged: onSizeChanged, // ✅ Emit callback
          ),
          // ...
          CustomButton(
            text: 'Create Field',
            onPressed: onSubmit, // ✅ Emit callback
          ),
        ],
      ),
    );
  }
}
```

**Why?**
- ✅ Reusable
- ✅ Testable in isolation
- ✅ No state management
- ✅ No business logic

---

## Checklist for Every Page Refactoring

### ❌ Remove from Pages/Widgets:
- [ ] Direct Supabase/database calls
- [ ] Direct API calls (use use cases)
- [ ] Business logic (use cubit/use cases)
- [ ] Hardcoded lists/constants (move to constants file)
- [ ] Complex validation logic (move to validators)
- [ ] Data transformation logic (use cubit/use cases)

### ✅ Pages Should Only Have:
- [ ] Scaffold, AppBar, routing setup
- [ ] BlocProvider, BlocConsumer setup
- [ ] Widget composition (layout)
- [ ] User interaction handlers (tap, submit) that call cubit
- [ ] Display data from cubit state
- [ ] Form keys and text controllers
- [ ] Local UI state (selected values, expanded/collapsed)

### ✅ Create Supporting Files:
- [ ] Constants file for static data
- [ ] Validator file for validation logic
- [ ] Widget files for reusable components
- [ ] Cubit extensions for new operations (if needed)

### ✅ Cubit Should:
- [ ] Use use cases (NOT direct DB calls)
- [ ] Emit states (Loading, Success, Error)
- [ ] Have no UI code
- [ ] Be organized with extensions

### ✅ Widgets Should:
- [ ] Accept data via parameters
- [ ] Emit callbacks for interactions
- [ ] Have NO business logic
- [ ] Be reusable

---

## File Size Targets

After refactoring, each file should be:

| File Type | Target Lines | Max Lines |
|-----------|-------------|-----------|
| Page | 150-250 | 300 |
| Widget | 50-150 | 200 |
| Cubit Extension | 50-150 | 200 |
| Constants | 20-100 | 150 |
| Validator | 50-150 | 200 |

---

## Example Refactoring Breakdown

### Before: create_field_page.dart (479 lines)

**Problems:**
- Direct Supabase calls
- Hardcoded lists
- Business logic
- Too large

### After: Properly Separated (201 lines + 4 support files)

1. **create_field_page.dart** (201 lines) ✅
   - UI-only code
   - Calls cubit methods
   - Uses constants and validators

2. **field_form_constants.dart** (52 lines) ✅
   - All hardcoded data
   - Default values
   - Helper functions

3. **field_form_validator.dart** (67 lines) ✅
   - All validation logic
   - Pure functions
   - Reusable

4. **create_field_form_body.dart** (237 lines) ✅
   - Main form widget
   - Reusable component
   - Parameter-driven

5. **field_creation_success_dialog.dart** (48 lines) ✅
   - Success dialog widget
   - Reusable

6. **field_indoor_switch.dart** (68 lines) ✅
   - Indoor toggle widget
   - Reusable

**Benefits:**
- ✅ Clean separation of concerns
- ✅ Each file under 300 lines
- ✅ Highly testable
- ✅ Reusable components
- ✅ Easy to maintain

---

## Testing Strategy

### What Becomes Easier to Test:

1. **Constants**: Direct imports and assertions
2. **Validators**: Pure function tests
3. **Widgets**: Widget tests with fixed data
4. **Cubit**: Mock use cases, test state emissions
5. **Pages**: Widget tests with mock cubit

### What Was Hard to Test Before:

- ❌ Pages with direct DB calls
- ❌ Mixed business logic
- ❌ Hardcoded values
- ❌ Coupled components

---

## Summary: The Golden Rules

### 🚫 NEVER in UI Files:
1. Direct database/API calls
2. Business logic
3. Hardcoded data lists
4. Complex validation
5. Data transformations

### ✅ ALWAYS:
1. Use cubit for data and actions
2. Extract constants to dedicated files
3. Extract validators to dedicated files
4. Create reusable widgets
5. Keep files under 300 lines
6. Follow Clean Architecture layers

---

## Next Steps

Apply this approach to remaining pages:
1. ✅ create_field_page.dart (DONE - 479 → 201 lines)
2. 🔄 admins_list_page.dart (388 lines)
3. ⏳ users_list_page.dart (376 lines)
4. ⏳ super_admin_dashboard_page.dart (370 lines)
5. ⏳ all_fields_page.dart (314 lines)
6. ⏳ all_bookings_page.dart (308 lines)

Each refactoring should follow this exact pattern for consistency.
