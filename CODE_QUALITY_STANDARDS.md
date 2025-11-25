Code Quality Standards

This document defines the code quality standards for the Sport Kick application.
ALL code must follow these standards.

1. Clean Code Principles
   1.1 Single Responsibility Principle

Each class/function does ONE thing well.

Widget classes should be focused and composable.

Business logic stays in UseCases / Repositories / Cubits, never in UI widgets.

Good Example:

// ✅ Single responsibility – only displays a field card
class FieldCard extends StatelessWidget {
final FieldEntity field;
final VoidCallback onTap;

const FieldCard({
required this.field,
required this.onTap,
super.key,
});
// ...
}


Bad Example:

// ❌ Multiple responsibilities – fetches data AND displays it
class FieldScreen extends StatefulWidget {
// Contains API calls, state management, AND UI
}

1.2 DRY (Don't Repeat Yourself)

Extract repeated code into reusable widgets/functions.

Use constants for repeated values.

Create utility functions for common operations.

Shared lists (e.g., dropdown options, status lists) must be defined once in a proper layer (e.g. core/constants, feature_name/domain/values) and not duplicated inside screens.

Good Example:

// ✅ Reusable component
class PriceTag extends StatelessWidget {
final double price;
const PriceTag({required this.price, super.key});

@override
Widget build(BuildContext context) {
return Text('${price.toStringAsFixed(0)} EGP/hour');
}
}

1.3 Meaningful Naming

Use descriptive names that explain intent.

Avoid abbreviations unless widely known.

Boolean variables start with is, has, should.

Functions use verb phrases.

Examples:

// ✅ Good naming
final bool isFieldActive;
final int userBookingCount;
void fetchAvailableFields();

// ❌ Bad naming
final bool active;
final int count;
void get();

1.4 Small, Focused Functions

Functions should ideally be < 20 lines.

Long functions must be split into smaller private helpers.

Each function does one job (fetch, map, validate, build part of UI…).

1.5 No Magic Numbers/Strings

Use named constants for all hard-coded values.

Create constant classes for app-wide values.

Good Example:

// ✅ Named constants
class AppPadding {
static const double small = 8.0;
static const double medium = 16.0;
static const double large = 24.0;
}

Widget build(BuildContext context) {
return Padding(
padding: const EdgeInsets.all(AppPadding.medium),
child: ...
);
}

2. Code Quality Standards
   2.1 Flutter/Dart Style Guide

Follow official Dart Style Guide
.

Run flutter format . before committing.

Follow linter rules in analysis_options.yaml.

2.2 Const Constructors

Use const constructors wherever possible.

Improves performance by reusing widget instances.

// ✅ Use const
const SizedBox(height: 16);
const Text('Hello');

// ❌ Avoid non-const when possible
SizedBox(height: 16); // Missing const

2.3 Null Safety

Use proper null safety (?, !, ??, ?.).

Avoid using ! (force unwrap) unless absolutely guaranteed non-null.

Prefer null-coalescing operators and safe access.

// ✅ Safe null handling
final name = user?.name ?? 'Guest';
if (user?.email != null) { ... }

// ❌ Unsafe null handling
final name = user!.name; // Crashes if user is null

2.4 Equatable for Value Equality

All entities and data models extend Equatable.

All Bloc/Cubit states extend Equatable.

Override props with all properties.

class FieldEntity extends Equatable {
final String id;
final String name;

const FieldEntity({required this.id, required this.name});

@override
List<Object?> get props => [id, name];
}

2.5 Error Handling

Use Either<Failure, Success> pattern from dartz.

Always handle errors gracefully in Cubits/UseCases.

Show user-friendly error messages.

Log errors with enough context for debugging.

result.fold(
(failure) {
debugPrint('Error fetching fields: ${failure.message}');
emit(FieldsError(failure.message));
},
(fields) => emit(FieldsLoaded(fields)),
);

2.6 Documentation

Add doc comments to public APIs, UseCases, repositories, Cubits.

Explain complex logic with inline comments.

Document function parameters and return values.

/// Fetches all active fields from the repository.
///
/// Returns a list of [FieldEntity].
/// Throws [ServerFailure] if the request fails.
Future<Either<Failure, List<FieldEntity>>> getAllFields();

2.7 File Size & Structure Limits

File size guideline:

A Dart file should ideally not exceed 300 lines.

If a file approaches 300 lines, split it into smaller files (widgets, helpers, extensions, etc.).

Function size:

Aim for < 20 lines per function where possible.

Any function > 30 lines should be a red flag and considered for refactor.

3. Readability & Organization
   3.1 Consistent Formatting

Use 2-space indentation (Flutter default).

Max line length: 80 characters (can go up to 100 if needed for readability).

Group related code with blank lines.

Use trailing commas for better diffs and auto-formatting.

Widget build(BuildContext context) {
return Column(
children: [
const Text('Title'),
const SizedBox(height: 16),
const Text('Description'),
], // Trailing comma
);
}

3.2 Logical Organization (Inside File)

Order inside a Dart file:

Imports (Dart → Flutter → Packages → Local).

Class-level documentation.

Fields/properties.

Constructor.

Lifecycle methods.

Public methods.

Private methods.

Private helper widgets (if allowed).

Import order:

// 1. Dart imports
import 'dart:async';

// 2. Flutter imports
import 'package:flutter/material.dart';

// 3. Package imports
import 'package:equatable/equatable.dart';

// 4. Local imports
import 'package:spo_kick/core/...';
import 'package:spo_kick/features/...';

3.3 File & Folder Naming Conventions

Features structure (Clean Architecture):

lib/
core/
constants/
errors/
widgets/
utils/
features/
super_admin/
domain/
entities/
usecases/
repositories/
data/
models/
datasources/
repositories/
presentation/
cubit/
pages/
widgets/


File naming:

Snake case: super_admin_cubit.dart, create_admin_account_usecase.dart.

UI files:

Screens/pages: super_admin_dashboard_page.dart

Widgets: admin_card.dart, booking_list_item.dart.

3.4 Class & Widget per File

Each public class / widget must live in its own file.

Example:

super_admin_dashboard_page.dart → contains only SuperAdminDashboardPage.

admin_card.dart → contains only AdminCard.

Do NOT put multiple main widgets/screens in one file.

Avoid defining new classes in the same file as the screen.

For big screens:

Extract sections into separate widgets & files:

_StatsSection → super_admin_stats_section.dart

_BookingsSection → super_admin_bookings_section.dart

Tiny private helper widgets inside a screen are allowed only if very small, but the default rule is:

“If it has a name, it usually deserves its own file.”

3.5 Clear Variable Names

Use descriptive names over short ones.

Context should make the purpose obvious.

// ✅ Clear names
final List<FieldEntity> availableFields;
final bool isLoadingFields;
final String fieldsErrorMessage;

// ❌ Unclear names
final List<FieldEntity> fields;  // Which fields?
final bool loading;              // What is loading?
final String error;              // Error of what?

4. Architecture & Separation of Concerns
   4.1 Clean Architecture Boundaries

Domain layer:

Contains Entities, UseCases, and Repository interfaces.

No dependencies on Flutter, Supabase, or UI.

Data layer:

Contains Models, RemoteDataSource, LocalDataSource, and repository implementations.

Knows about Supabase, APIs, databases.

Presentation layer:

Contains Cubits/Blocs, States, Pages, Widgets.

No direct access to supabaseClient or data sources.

Rules:

Presentation → talks to UseCases, not DataSources directly.

Domain → knows nothing about Flutter or Supabase.

Data → implements the Repository interfaces defined in Domain.

4.2 UI vs Logic Separation

UI files (pages/widgets):

Should be StatelessWidget wherever possible.

Should only handle:

Layout

Rendering state

Calling Cubit/UseCase methods via events.

Must not contain:

API calls

Database logic

Business rules

All business logic:

Goes to UseCases, Cubits, Repositories, or helper services.

Any list of values used in UI (statuses, roles, menu items) should live:

In core/constants or feature_name/domain/values, not inside the widget file.

5. Git & Workflow Standards
   5.1 Branching

Use feature branches:

feature/super-admin-create

fix/booking-timezone-bug

Keep main / master always stable.

5.2 Commit Messages

Use descriptive, structured messages (e.g. Conventional Commits style):

feat: add super admin create admin flow

fix: handle null phone in admin invitations

refactor: extract booking stats widget

chore: update dependencies

test: add tests for super admin cubit

Avoid vague commits like:

update

fix

misc

6. Logging & Error Reporting
   6.1 Logging Conventions

Use debugPrint or a logging library with tags:

debugPrint('[SuperAdminCubit] Loading admins...');
debugPrint('[AuthRepository] Login failed: ${failure.message}');


Do not log sensitive data:

Passwords

Tokens

Full credit card numbers

6.2 User-Facing Errors vs Internal Logs

Distinguish between:

Internal log message (technical, detailed)

User-facing message (simple, friendly, localized)

Example:

debugPrint('[SuperAdminRepository] Failed to create admin: ${e.toString()}');
emit(SuperAdminError('Failed to create admin. Please try again later.'));

7. Environment & Configuration
   7.1 Environments

Support multiple environments:

dev, staging, prod

Config must not be hard-coded:

Supabase URL

Supabase anon key

API endpoints

Use one of:

--dart-define

flutter_dotenv

Flavors (main_dev.dart, main_prod.dart)

7.2 Sensitive Keys

Never commit service keys (especially service_role keys) in the Flutter project.

Any secret keys must be stored in:

Supabase secrets (for Edge Functions)

Secure backend config

.env files excluded from git for local dev.

8. API & Data Contracts
   8.1 DTOs and Entities

All API responses map to Models/DTOs.

Models convert to Domain Entity classes.

UI never consumes raw JSON.

8.2 Null & Missing Fields

fromJson must handle:

Missing fields

Null values

Should never throw by default for absent optional fields; use sensible defaults where appropriate.

9. TODO & Deprecation Policy
   9.1 TODO Comments

Must include owner + date:

// TODO(ty, 2025-11-25): Handle offline caching for bookings.

9.2 Deprecation

Use @Deprecated() to mark deprecated APIs:

@Deprecated('Use NewBookingCard instead')
class OldBookingCard extends StatelessWidget { ... }

10. Flutter Updates (Nov 2025 - Latest)
    10.1 Modern Color API
    // ✅ Use withValues() (Flutter 3.27+)
    color.withValues(alpha: 0.5);

// ❌ Deprecated withOpacity()
color.withOpacity(0.5);

10.2 Material 3 Components

Use Material 3 design system.

Use ColorScheme.fromSeed().

Use modern button styles (FilledButton, ElevatedButton, OutlinedButton).

// ✅ Material 3
FilledButton(
onPressed: () {},
child: const Text('Submit'),
);

10.3 Modern Navigation
// ✅ Use PopScope (Flutter 3.12+)
PopScope(
canPop: false,
onPopInvokedWithResult: (didPop, result) { ... },
child: const Scaffold(...),
);

11. Widget Best Practices
    11.1 Stateless Preferred

Prefer StatelessWidget whenever possible.

Use StatefulWidget only when:

Local UI state is required (animations, controllers, etc.).

Any business state should live in Cubits/Blocs, not in StatefulWidgets.

11.2 Extract Widgets

If a widget tree is > 3 levels deep, extract sections into methods or separate widgets.

Large sections of UI must be extracted into their own widget classes and files.

class SuperAdminDashboardPage extends StatelessWidget {
const SuperAdminDashboardPage({super.key});

@override
Widget build(BuildContext context) {
return Column(
children: [
const _DashboardHeader(), // ideally in its own file
const _StatsSection(),
const _BookingsSection(),
],
);
}
}


Rule: For maintainability, every meaningful widget/class gets its own file.

12. Performance
    12.1 Use Const

const widgets are not rebuilt unnecessarily.

Helps with scroll performance and rebuild-heavy screens.

12.2 Avoid Unnecessary Rebuilds

Use const constructors where possible.

Use ListView.builder / GridView.builder for lists.

Lift heavy computations out of build() methods into:

UseCases

Cubits

Precomputed values.

12.3 Image Optimization

Use CachedNetworkImage for network images.

Specify image dimensions.

Use appropriate formats (WebP where possible).

13. Testing Considerations
    13.1 Testable Code

Use dependency injection (GetIt, etc.).

Prefer pure functions in UseCases.

Avoid static/global mutable state.

13.2 Test Types

Unit tests for:

UseCases

Repositories

Bloc/Cubit tests:

With bloc_test.

Widget tests:

For critical screens and widgets (booking flow, payment confirmation, etc.).

13.3 Widget Keys

Add keys for important interactive widgets to support testing:

TextField(
key: const Key('login_email_field'),
...
);

14. Security
    14.1 Input Validation

Validate all user inputs.

Sanitize and validate before API calls.

14.2 Sensitive Data

Do not log:

Passwords

Tokens

Cards

Always use HTTPS.

15. Accessibility
    15.1 Semantic Labels
    IconButton(
    icon: const Icon(Icons.settings),
    onPressed: () {},
    tooltip: 'Settings', // ✅ Accessible
    );

15.2 Color Contrast

Ensure sufficient color contrast (WCAG AA).

Do not rely only on color to convey information.

16. Code Review Checklist

Before submitting code, verify:

No compilation errors or warnings.

Follows Clean Architecture (Domain → Data → Presentation).

Each file is reasonably small (preferably ≤ 300 lines).

Functions are small and focused (< 20 lines when possible).

Each main class/widget has its own file.

UI files are Stateless when possible and contain no business logic.

No deprecated APIs.

Proper null safety (no unnecessary !).

Meaningful variable/function/class names.

No magic numbers/strings (use constants).

Proper error handling with user-friendly messages.

Doc comments on public APIs.

No duplicated code.

Uses theme and design system (no raw Colors).

Tests added or updated when needed.

flutter analyze passes.

flutter format . has been run.


17. Responsive Design Standards

The Sport Kick application must deliver a consistent and optimized experience across all screen sizes, platforms, and device orientations.
All UI must follow the following responsive design rules.

17.1 General Principles
17.1.1 One UI Layout Must Work Everywhere

All screens must adapt correctly to:

Small phones (≤ 360 width)

Standard phones (360–420 width)

Large phones / small tablets (≥ 500 width)

Tablets (≥ 720 width)

Web & desktop (≥ 1024 width)

17.1.2 No Hardcoded Dimensions

Avoid fixed width/height values unless necessary.

❌ Bad:

Container(width: 300, height: 200)


✅ Good:

Container(
width: MediaQuery.of(context).size.width * 0.8,
)


Or use responsive layout breakpoints.

17.1.3 Use Flexible Widgets

Prefer:

Expanded

Flexible

Spacer

FittedBox

Wrap

LayoutBuilder

These prevent overflow and layout crashes.

17.2 Breakpoint Standards

We use 4 standard breakpoints:

Type	Width
Small (Phones)	< 400
Medium (Phones/Large Phones)	400–600
Large (Tablets)	600–900
Extra Large (Web/Desktop)	> 900

Example:

final width = MediaQuery.of(context).size.width;

if (width < 400) return _SmallLayout();
if (width < 600) return _MediumLayout();
if (width < 900) return _TabletLayout();
return _DesktopLayout();

17.3 Responsive Text & Padding
17.3.1 Scalable Text

Use:

Theme.of(context).textTheme.titleLarge


Instead of:

TextStyle(fontSize: 18)

17.3.2 Responsive Padding

Use constants or scale them:

EdgeInsets.symmetric(
horizontal: width * 0.05,
vertical: 16,
);

17.4 Responsive Layout Tools
17.4.1 LayoutBuilder

For conditional branching:

LayoutBuilder(
builder: (context, constraints) {
if (constraints.maxWidth < 400) {
return _SmallCard();
} else {
return _LargeCard();
}
},
);

17.4.2 MediaQuery

For device info:

final height = MediaQuery.of(context).size.height;
final width  = MediaQuery.of(context).size.width;

17.4.3 OrientationBuilder
OrientationBuilder(
builder: (_, orientation) {
return orientation == Orientation.portrait
? _PortraitLayout()
: _LandscapeLayout();
},
);

17.5 Lists, Grids, and Cards
17.5.1 Responsive Grid Count
SliverGridDelegateWithFixedCrossAxisCount(
crossAxisCount: width > 700 ? 3 : 2,
);

17.5.2 Avoid Overflow

Never assume a card width—use flexible cards:

Expanded(
child: BookingCard(booking: booking),
);

17.6 Responsive Buttons & Inputs

Buttons must stretch horizontally by default (minWidth = 100%).

Input fields must expand to available width.

Avoid fixed heights unless using Material3 standards.

Example:

SizedBox(
width: double.infinity,
child: FilledButton(onPressed: () {}, child: Text('Continue')),
);

17.7 Web/Desktop Responsiveness

When adapting for web/desktop:

Increase max width:

Center(
child: ConstrainedBox(
constraints: BoxConstraints(maxWidth: 600),
child: content,
),
);


Add hover/fluent spacing if needed.

Use scrollable column instead of fixed height containers.

17.8 Testing Responsiveness

Before pushing UI changes:

Test on small width (Pixel 4a)

Test on large width (Tablet)

Test on landscape mode

Test on web (desktop browser)

Test long text overflow

Test with system font scaling (Accessibility)

A screen failing responsive layout = PR rejected.

17.9 Anti-Patterns (❌ Forbidden)

❌ Hardcoded pixel sizes
❌ Containers with fixed width for full screens
❌ Using Positioned for core layout
❌ Using SizedBox for layout arrangement instead of space-flex
❌ Relying only on Expanded inside nested scrollables
❌ Overflow errors like "A RenderFlex overflowed…"
❌ Text cut off because of fixed height

17.10 Quick Checklist

Before merging UI code, verify:

Does this screen scale on all screen sizes?

Does the layout adjust based on width breakpoints?

Are text, padding, and widgets responsive?

No fixed pixel values unless necessary.

No layout overflow in any device.

Works on web, tablet, and landscape mode.

Enforcement

Run flutter analyze before committing (must show 0 errors).

Run flutter format . on changed files.

All code reviews must check against these standards.

No exceptions unless explicitly documented and approved.

Last Updated: November 2025
Flutter Version: 3.38.2+ (Material 3)
Dart Version: 3.0+