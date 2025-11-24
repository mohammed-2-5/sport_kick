# Sport Kick ⚽🎾🏀

**Multi-sport field booking application** - Book your sports field instantly!

A modern Flutter mobile application that allows users to browse available sports fields (Football, Tennis, Basketball, Volleyball, Padel, Squash), view time slots, and make bookings instantly - replacing traditional phone call/WhatsApp booking processes.

---

## 🎯 Features

- 🏟️ **Browse Multi-Sport Fields** - View all available sports fields in your city
  - ⚽ Football (11v11, 7v7, 5v5)
  - 🎾 Tennis & Padel Courts
  - 🏀 Basketball Courts
  - 🏐 Volleyball Courts
  - 🎾 Squash Courts
- 📅 **Book Instantly** - Select sport, date and time, book in seconds
- 🎯 **Smart Filtering** - Filter by sport type, amenities, price, location
- 👤 **User Accounts** - Manage your profile and bookings
- ⭐ **Reviews & Ratings** - Rate and review fields with detailed categories
- 👨‍💼 **Owner Dashboard** - Field owners can manage bookings across all sports
- 🔔 **Notifications** - Get notified about booking updates

---

## 🏗️ Project Status

**Current Phase:** Phase 2 Complete (Supabase Backend Setup)
**MVP Progress:** ~25% Complete

### Completed:
- ✅ Phase 0: Foundation (Core infrastructure)
- ✅ Phase 1: UI Components & Routing
- ✅ Phase 2: Supabase Backend Setup

### Next:
- ⏳ Phase 3: Authentication Feature
- ⏳ Phase 4: Fields Feature
- ⏳ Phase 5: Bookings Feature
- ⏳ Phase 6: MVP Polish & Testing

---

## 🛠️ Tech Stack

- **Framework:** Flutter 3.10+
- **State Management:** Cubit/Bloc
- **Backend:** Supabase (PostgreSQL, Auth, Storage, Realtime)
- **Architecture:** Clean Architecture
- **Dependency Injection:** get_it
- **HTTP Client:** Dio
- **Local Storage:** Hive & Shared Preferences

---

## 📱 Getting Started

### Prerequisites
- Flutter SDK 3.10 or higher
- Dart SDK
- Android Studio / VS Code
- Supabase account (for backend)

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd spo_kick
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Set up Supabase**
   - Follow instructions in `supabase/README.md`
   - Run SQL scripts in order:
     1. `01_schema_v2.sql` (Multi-sport database)
     2. `02_rls_policies_v2.sql` (Security policies)
     3. `03_initial_data_v2.sql` (Sample data - optional)

4. **Run the app**
   ```bash
   flutter run
   ```

---

## 📂 Project Structure

```
lib/
├── main.dart                    # App entry point
├── core/
│   ├── constants/              # App constants, colors, strings
│   ├── widgets/                # Reusable UI components
│   ├── routes/                 # Navigation & routing
│   ├── di/                     # Dependency injection
│   ├── network/                # API client & network utils
│   ├── utils/                  # Validators & helpers
│   └── errors/                 # Error handling
└── features/
    ├── splash/                 # Splash screen
    ├── auth/                   # Authentication (WIP)
    ├── fields/                 # Football fields (WIP)
    └── bookings/               # Booking management (WIP)
```

---

## 🗄️ Database Schema (Multi-Sport)

### Tables:
1. **sport_categories** - Sport types (Football, Tennis, Basketball, etc.)
2. **profiles** - User accounts and information
3. **fields** - Universal sports fields (supports all sports)
4. **amenities** - Facilities catalog (Parking, Showers, AC, etc.)
5. **field_amenities** - Field to amenity mapping
6. **bookings** - Reservation records (all sports)
7. **time_slots** - Available time slots
8. **reviews** - User reviews with detailed ratings

### Key Features:
- ✅ Flexible multi-sport support via `sport_categories` table
- ✅ Sport-specific properties stored as JSONB (infinitely extensible)
- ✅ Structured amenities system with sport associations
- ✅ Easy to add new sports without schema changes

See `supabase/01_schema_v2.sql` for complete schema.
See `supabase/SCHEMA_GUIDE_V2.md` for usage guide and examples.

---

## 📚 Documentation

- **Setup Guide:** `supabase/README.md`
- **Implementation Plan:** `IMPLEMENTATION_PLAN.md`
- **Architecture Guide:** `CLAUDE.md`
- **Phase Summaries:**
  - `PHASE_1_SUMMARY.md`
  - `PHASE_2_COMPLETE.md`

---

## 🚀 Development Commands

```bash
# Run the app
flutter run

# Run with hot reload
flutter run --hot

# Build for Android
flutter build apk

# Run tests
flutter test

# Analyze code
flutter analyze

# Format code
dart format .
```

---

## 🤝 Contributing

This is a learning/portfolio project. Feel free to fork and experiment!

---

## 📄 License

This project is open source and available for educational purposes.

---

## 📧 Contact

For questions or support, please refer to the documentation or create an issue.

---

*Built with Flutter & Supabase* 💙
