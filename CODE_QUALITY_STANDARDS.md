# Code Quality Standards

This document defines the code quality standards for the Sport Kick application.
**ALL code must follow these standards.**

---

## 1. Clean Code Principles

### 1.1 Single Responsibility Principle
- Each class/function does ONE thing well
- Widget classes should be focused and composable
- Business logic stays in UseCases, not in Cubits or Widgets

**Good Example**:
```dart
// ✅ Single responsibility - only displays a field card
class FieldCard extends StatelessWidget {
  final FieldEntity field;
  final VoidCallback onTap;

  const FieldCard({required this.field, required this.onTap});
  // ...
}
```

**Bad Example**:
```dart
// ❌ Multiple responsibilities - fetches data AND displays it
class FieldCard extends StatefulWidget {
  // Contains API calls, state management, AND UI
}
```

### 1.2 DRY (Don't Repeat Yourself)
- Extract repeated code into reusable widgets/functions
- Use constants for repeated values
- Create utility functions for common operations

**Good Example**:
```dart
// ✅ Reusable component
class PriceTag extends StatelessWidget {
  final double price;
  const PriceTag({required this.price});

  @override
  Widget build(BuildContext context) {
    return Text('${price.toStringAsFixed(0)} EGP/hour');
  }
}
```

### 1.3 Meaningful Naming
- Use descriptive names that explain intent
- Avoid abbreviations unless widely known
- Boolean variables start with `is`, `has`, `should`
- Functions use verb phrases

**Examples**:
```dart
// ✅ Good naming
final bool isFieldActive;
final int userBookingCount;
void fetchAvailableFields();

// ❌ Bad naming
final bool active;
final int count;
void get();
```

### 1.4 Small, Focused Functions
- Functions should be < 20 lines when possible
- If function is too long, extract helper functions
- Each function does ONE thing

### 1.5 No Magic Numbers/Strings
- Use named constants for all hard-coded values
- Create constant classes for app-wide values

**Good Example**:
```dart
// ✅ Named constants
class AppPadding {
  static const double small = 8.0;
  static const double medium = 16.0;
  static const double large = 24.0;
}

Widget build(BuildContext context) {
  return Padding(
    padding: EdgeInsets.all(AppPadding.medium),
    child: ...
  );
}
```

---

## 2. Code Quality Standards

### 2.1 Flutter/Dart Style Guide
- Follow official [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- Use `flutter format .` before committing
- Follow linter rules in `analysis_options.yaml`

### 2.2 Const Constructors
- Use `const` constructors wherever possible
- Improves performance by reusing widget instances

```dart
// ✅ Use const
const SizedBox(height: 16)
const Text('Hello')

// ❌ Avoid non-const when possible
SizedBox(height: 16) // Missing const
```

### 2.3 Null Safety
- Use proper null safety annotations (`?`, `!`, `??`, `?.`)
- Avoid using `!` (force unwrap) unless absolutely certain
- Prefer null-coalescing operators

```dart
// ✅ Safe null handling
final name = user?.name ?? 'Guest';
if (user?.email != null) { ... }

// ❌ Unsafe null handling
final name = user!.name; // Crashes if user is null
```

### 2.4 Equatable for Value Equality
- All entities and models extend Equatable
- All states extend Equatable
- Override `props` getter with all properties

```dart
class FieldEntity extends Equatable {
  final String id;
  final String name;

  @override
  List<Object?> get props => [id, name];
}
```

### 2.5 Error Handling
- Use Either<Failure, Success> pattern from dartz
- Always handle errors gracefully
- Show user-friendly error messages
- Log errors for debugging

```dart
// ✅ Proper error handling
result.fold(
  (failure) {
    print('Error: ${failure.message}');
    emit(FieldsError(failure.message));
  },
  (fields) => emit(FieldsLoaded(fields)),
);
```

### 2.6 Documentation
- Add doc comments to public APIs
- Explain complex logic with inline comments
- Document function parameters and return values

```dart
/// Fetches all active fields from the repository.
///
/// Returns a list of [FieldEntity] objects.
/// Throws [ServerFailure] if the request fails.
Future<Either<Failure, List<FieldEntity>>> getAllFields();
```

---

## 3. Readability Standards

### 3.1 Consistent Formatting
- Use 2-space indentation (Flutter default)
- Max line length: 80 characters (can extend to 100 for readability)
- Group related code with blank lines
- Use trailing commas for better diffs

```dart
// ✅ Good formatting
Widget build(BuildContext context) {
  return Column(
    children: [
      Text('Title'),
      const SizedBox(height: 16),
      Text('Description'),
    ], // Trailing comma
  );
}
```

### 3.2 Logical Organization
**File Structure**:
1. Imports (dart, flutter, packages, local)
2. Class documentation
3. Fields/properties
4. Constructor
5. Lifecycle methods
6. Public methods
7. Private methods
8. Helper widgets (if any)

**Import Order**:
```dart
// 1. Dart imports
import 'dart:async';

// 2. Flutter imports
import 'package:flutter/material.dart';

// 3. Package imports
import 'package:equatable/equatable.dart';

// 4. Local imports
import 'package:spo_kick/core/...';
```

### 3.3 Clear Variable Names
- Use descriptive names over short ones
- Context should make the purpose obvious

```dart
// ✅ Clear names
final List<FieldEntity> availableFields;
final bool isLoadingFields;
final String errorMessage;

// ❌ Unclear names
final List<FieldEntity> fields; // Available? All? Filtered?
final bool loading; // Loading what?
final String error; // What kind of error?
```

---

## 4. Flutter Updates (Nov 2025 - Latest)

### 4.1 Use Modern Color API
```dart
// ✅ Use withValues() (Flutter 3.27+)
color.withValues(alpha: 0.5)

// ❌ Deprecated withOpacity()
color.withOpacity(0.5)
```

### 4.2 Material 3 Components
- Use Material 3 design system
- Use ColorScheme.fromSeed()
- Use modern button styles (FilledButton, OutlinedButton)

```dart
// ✅ Material 3
FilledButton(
  onPressed: () {},
  child: Text('Submit'),
)

// ❌ Old Material 2
RaisedButton( // Deprecated
  onPressed: () {},
  child: Text('Submit'),
)
```

### 4.3 Modern Navigation
```dart
// ✅ Use PopScope (Flutter 3.12+)
PopScope(
  canPop: false,
  onPopInvokedWithResult: (didPop, result) { ... },
  child: Scaffold(...),
)

// ❌ Deprecated WillPopScope
WillPopScope( // Deprecated
  onWillPop: () async { ... },
  child: Scaffold(...),
)
```

### 4.4 Modern Widget Patterns
```dart
// ✅ Use switch expressions (Dart 3.0+)
final color = switch (status) {
  Status.pending => Colors.orange,
  Status.confirmed => Colors.green,
  Status.cancelled => Colors.red,
};

// ✅ Use records for multiple returns (Dart 3.0+)
(String, int) getUserInfo() => ('John', 25);
```

### 4.5 Avoid Deprecated APIs
**Deprecated → Modern Replacement**:
- `withOpacity()` → `withValues(alpha: ...)`
- `WillPopScope` → `PopScope`
- `RaisedButton` → `FilledButton` or `ElevatedButton`
- `FlatButton` → `TextButton`
- `OutlineButton` → `OutlinedButton`
- `buttonColor` → `backgroundColor` in ButtonStyle

---

## 5. Widget Best Practices

### 5.1 Const Widgets
```dart
// ✅ Use const for static widgets
const Text('Hello')
const SizedBox(height: 16)
const Icon(Icons.home)
```

### 5.2 Extract Widgets
- If widget tree is > 3 levels deep, extract to a method or class
- Prefer StatelessWidget over StatefulWidget when possible

```dart
// ✅ Extracted widget
class _UserInfoSection extends StatelessWidget {
  final UserEntity user;
  const _UserInfoSection({required this.user});

  @override
  Widget build(BuildContext context) => Column(...);
}
```

### 5.3 Builder Pattern
- Use builder functions for complex conditional UI
- Keeps build method clean

```dart
Widget build(BuildContext context) {
  return Column(
    children: [
      _buildHeader(),
      _buildContent(),
      _buildActions(),
    ],
  );
}
```

---

## 6. Performance

### 6.1 Use Const
- const widgets are not rebuilt
- Significant performance improvement

### 6.2 Avoid Rebuilds
- Use `const` constructors
- Use `ListView.builder()` for long lists
- Use `RepaintBoundary` for complex widgets
- Avoid expensive operations in build()

### 6.3 Image Optimization
- Use `CachedNetworkImage` for network images
- Specify image dimensions
- Use appropriate image formats (WebP for modern devices)

---

## 7. Testing Considerations

### 7.1 Testable Code
- Dependency injection (GetIt)
- Pure functions
- Avoid static/global state
- Mock external dependencies

### 7.2 Widget Keys
- Add keys to important widgets for testing
```dart
TextField(
  key: const Key('email_field'),
  ...
)
```

---

## 8. Security

### 8.1 Input Validation
- Validate all user inputs
- Sanitize data before API calls
- Use validators for forms

### 8.2 Sensitive Data
- Never hardcode API keys (use environment variables)
- Don't log sensitive information
- Use HTTPS for all network calls

---

## 9. Accessibility

### 9.1 Semantic Labels
```dart
IconButton(
  icon: Icon(Icons.settings),
  onPressed: () {},
  tooltip: 'Settings', // ✅ Accessibility
)
```

### 9.2 Color Contrast
- Ensure sufficient color contrast (WCAG AA)
- Don't rely solely on color to convey information

---

## 10. Code Review Checklist

Before submitting code, verify:

- [ ] No compilation errors or warnings
- [ ] Follows Clean Architecture (Domain → Data → Presentation)
- [ ] All widgets use const where possible
- [ ] No deprecated APIs
- [ ] Proper null safety
- [ ] Meaningful variable/function names
- [ ] No magic numbers/strings
- [ ] Proper error handling
- [ ] Doc comments on public APIs
- [ ] No code duplication
- [ ] Follows file organization standards
- [ ] Uses latest Flutter widgets/APIs
- [ ] Testable code structure

---

## Enforcement

- Run `flutter analyze` before committing (must show 0 errors)
- Run `flutter format .` to format code
- All code reviews must check against these standards
- No exceptions unless explicitly documented

---

**Last Updated**: November 2025
**Flutter Version**: 3.38.2+ (Material 3)
**Dart Version**: 3.0+
