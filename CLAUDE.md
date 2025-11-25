# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**Sport Kick** is a football field booking application for local cities. The app allows users to browse available football fields, view time slots, and make bookings instantly, replacing the traditional phone call/WhatsApp booking process. Field owners manage bookings through a dashboard.

**Current Status:** Phase 3 (Super Admin Enhancements) - 40% Complete. See `PROJECT_STATUS.md` for detailed progress tracking and roadmap.

**Master Plan:** `NEW_ROLE_ARCHITECTURE_PLAN.md` - Comprehensive role-based architecture with three distinct roles (Super Admin, Admin/Field Owner, User/Customer).

**Target Architecture:**
- Clean Architecture with feature-based folder structure
- State Management: Cubit/Bloc (flutter_bloc)
- Backend: Supabase (PostgreSQL, Auth, Storage, Realtime)
- Three-layer architecture: Presentation → Domain → Data
- Dependency Injection: get_it

## Development Commands

### Running the Application
```bash
# Run the app in development mode
flutter run

# Run on specific device
flutter run -d <device_id>

# Run with hot reload enabled (default)
flutter run --hot
```

### Testing
```bash
# Run all tests
flutter test

# Run a specific test file
flutter test test/widget_test.dart

# Run tests with coverage
flutter test --coverage
```

### Building
```bash
# Build for Android
flutter build apk
flutter build appbundle

# Build for iOS (requires macOS)
flutter build ios

# Build for web
flutter build web

# Build for Windows
flutter build windows
```

### Code Quality
```bash
# Run the analyzer to check for issues
flutter analyze

# Format all Dart files
dart format .

# Format specific file
dart format lib/main.dart
```

### Dependencies
```bash
# Get dependencies
flutter pub get

# Upgrade dependencies
flutter pub upgrade

# Check for outdated packages
flutter pub outdated
```

## Project Structure

- **lib/main.dart**: Entry point of the application. Contains MyApp (root widget) and MyHomePage (stateful counter demo widget)
- **test/**: Widget and unit tests
- **android/**: Android platform-specific code
- **ios/**: iOS platform-specific code
- **web/**: Web platform-specific code
- **windows/**: Windows platform-specific code

## Architecture & Implementation Progress

For complete implementation status, roadmap, and next steps, see `PROJECT_STATUS.md`.

### Folder Structure (Already Created)
```
lib/
  core/
    errors/           # Custom error classes and failures
    constants/        # App constants, strings, colors
    utils/            # Helper functions and utilities
    network/          # Network configuration and interceptors
    di/               # Dependency injection setup (get_it)
  features/
    auth/             # Authentication feature
      presentation/
        pages/        # Login, register screens
        widgets/      # Reusable auth widgets
        cubit/        # Auth state management (Cubit)
      domain/
        entities/     # User entity
        usecases/     # Login, register, logout use cases
        repositories/ # Auth repository interface
      data/
        models/       # User model (DTO)
        datasources/  # Supabase auth data source
        repositories/ # Auth repository implementation
    fields/           # Football fields feature
      presentation/
        pages/        # Field list, field details screens
        widgets/      # Field card, rating widget
        cubit/        # Fields state management
      domain/
        entities/     # Field entity
        usecases/     # Get fields, get field details
        repositories/ # Field repository interface
      data/
        models/       # Field model (DTO)
        datasources/  # Supabase fields data source
        repositories/ # Field repository implementation
    bookings/         # Bookings feature
      presentation/
        pages/        # Create booking, my bookings screens
        widgets/      # Booking card, time slot picker
        cubit/        # Bookings state management
      domain/
        entities/     # Booking entity
        usecases/     # Create booking, get bookings, cancel
        repositories/ # Booking repository interface
      data/
        models/       # Booking model (DTO)
        datasources/  # Supabase bookings data source
        repositories/ # Booking repository implementation
```

### Key Features (MVP - Phase 1)
**User Side:**
- Browse football fields
- View field details (photos, price, location map)
- Select date and available time slots
- Book slots (pending confirmation)
- View "My Bookings"

**Owner Side:**
- Login system
- View all bookings (Pending/Confirmed/Canceled)
- Dashboard to manage bookings

### Technology Stack
- **State Management:** Cubit/Bloc (flutter_bloc ^9.1.1, bloc ^9.1.0)
- **Backend:** Supabase (supabase_flutter ^2.10.3)
- **Dependency Injection:** get_it ^9.1.0
- **Functional Programming:** dartz ^0.10.1 (for Either type)
- **Network:** dio ^5.9.0, connectivity_plus ^7.0.0
- **Local Storage:** shared_preferences ^2.5.3, hive ^2.2.3
- **Maps & Location:** google_maps_flutter ^2.14.0, geolocator ^14.0.2
- **Images:** cached_network_image ^3.4.1, image_picker ^1.2.1
- **UI:** Material Design, flutter_svg ^2.2.2
- **Utilities:** intl ^0.20.2, uuid ^4.5.2, url_launcher ^6.3.2
- **Testing:** bloc_test ^10.0.0, mocktail ^1.0.4
- **Code Generation:** build_runner ^2.10.4
- **Platforms:** Android, iOS (primary), Web (owner dashboard)

### Code Quality Standards
- Clear naming conventions (e.g., `FieldRepository`, `BookingCubit`, `FieldEntity`)
- Separation of concerns (UI, Business Logic, Domain, Data layers)
- Reusable widgets and centralized theming
- Proper error handling with meaningful messages using Either from dartz
- Git conventional commits (`feat:`, `fix:`, `refactor:`)
- Use Equatable for state and entity comparisons
- All states should extend Equatable
- All entities should extend Equatable

### Cubit/Bloc Pattern
- **Cubit Files:** Named as `feature_cubit.dart` (e.g., `auth_cubit.dart`)
- **State Files:** Named as `feature_state.dart` (e.g., `auth_state.dart`)
- States should have: Initial, Loading, Success, and Error states
- Use BlocProvider to inject cubits at appropriate widget levels
- Use BlocBuilder or BlocConsumer to listen to state changes
- Business logic stays in UseCases, Cubits only orchestrate

## Key Configuration

- **Dart SDK**: ^3.10.0
- **Flutter Lints**: Uses `package:flutter_lints/flutter.yaml` for static analysis
- **Material Design**: Theme uses ColorScheme.fromSeed with deep purple as seed color
