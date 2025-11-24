# 🎯 New Role-Based Architecture Plan

**Project:** Sport Kick - Football Field Booking System
**Date:** November 24, 2025
**Status:** Planning Phase

---

## 📋 Table of Contents

1. [Overview](#overview)
2. [Role Definitions](#role-definitions)
3. [Database Schema Updates](#database-schema-updates)
4. [Feature Matrix](#feature-matrix)
5. [UI/UX Design](#uiux-design)
6. [Implementation Roadmap](#implementation-roadmap)
7. [Security & Permissions](#security--permissions)

---

## 🎭 Overview

### Current vs New Architecture

| Aspect | Current | New |
|--------|---------|-----|
| Roles | Basic 3 roles | Fully separated 3 roles |
| Super Admin | Limited | Full platform control |
| Admin | Basic dashboard | Complete field management |
| User | Basic booking | City-based field selection |
| Admin Creation | Manual | Super admin creates |
| Manual Bookings | ❌ | ✅ Admin can create |
| City Filtering | ❌ | ✅ Users select city |

---

## 👥 Role Definitions

### 1️⃣ Super Admin (Platform Owner)

**Purpose:** Manages the entire platform

**Key Capabilities:**
- ✅ View platform-wide statistics
  - Total users count
  - Total bookings count
  - Total revenue
  - Active fields count
  - City-wise breakdown
- ✅ User Management
  - View all users (list, search, filter)
  - View user details and booking history
  - Activate/deactivate users
- ✅ Admin Management
  - Create new admin accounts
  - Generate email and default password
  - Assign multiple fields to admin
  - Remove admin access
  - Reset admin passwords
- ✅ Field Management
  - View all fields in system
  - Create fields and assign to admins
  - Edit/deactivate any field
- ✅ Booking Management
  - View all bookings across all fields
  - Filter by field, date, status, city
  - Override booking status
- ✅ Analytics
  - Revenue trends
  - Booking trends
  - Popular fields/cities
  - User growth metrics

**Dashboard Sections:**
1. Overview (statistics cards)
2. Users Management
3. Admins Management
4. Fields Management
5. All Bookings
6. Analytics & Reports
7. System Settings

---

### 2️⃣ Admin (Field Owner)

**Purpose:** Manages assigned football fields

**Key Capabilities:**
- ✅ View Field-Specific Statistics
  - Total bookings for their fields
  - Revenue from their fields
  - Booking trends
  - Popular time slots
- ✅ Booking Management
  - View all bookings for their fields
  - Approve pending bookings
  - Reject bookings with reason
  - View customer details (name, email, phone)
- ✅ Manual Booking Creation (Walk-ins)
  - Select their field
  - Choose date and time slot
  - Enter customer data manually:
    - Name
    - Phone number
    - Email (optional)
    - Notes
  - Create booking as "confirmed" directly
- ✅ Field Management
  - Edit their field information
  - Update photos
  - Set pricing
  - Manage amenities
  - Set availability schedule
- ✅ Customer Management
  - View all customers who booked their fields
  - View customer booking history
  - Customer contact information

**Dashboard Sections:**
1. Overview (field statistics)
2. Bookings Management
3. Create Manual Booking
4. My Fields
5. Customers
6. Analytics

**First Login:**
- Must change default password
- Setup profile (phone, etc.)

---

### 3️⃣ User (Customer)

**Purpose:** Book football fields for play

**Key Capabilities:**
- ✅ City Selection
  - Select from supported cities
  - Browse fields in selected city
- ✅ Field Discovery
  - View all fields in city
  - Filter by:
    - Sport type
    - Price range
    - Rating
    - Amenities
  - Search by name/location
- ✅ Field Details
  - View photos
  - See pricing
  - Read reviews
  - Check location on map
  - View amenities
- ✅ Booking Flow
  - Select date
  - View available time slots
  - Select time slot
  - Confirm booking (status: pending)
  - Add notes
- ✅ My Bookings
  - View all bookings
  - Filter by status
  - View booking details
  - Cancel booking
- ✅ Profile Management
  - Update personal info
  - Change password
  - View booking history

**Navigation Flow:**
```
Login → City Selection → Fields List → Field Details → Book → My Bookings
```

---

## 🗄️ Database Schema Updates

### 1. Existing Tables (Keep)

#### `profiles` table
```sql
- id (UUID, PK)
- email (TEXT)
- full_name (TEXT)
- phone (TEXT)
- avatar_url (TEXT)
- role (TEXT) -- 'user', 'admin', 'super_admin'
- preferred_sports (TEXT[])
- created_at (TIMESTAMP)
- updated_at (TIMESTAMP)
- is_active (BOOLEAN) -- NEW: for user activation
- password_changed (BOOLEAN) -- NEW: track first login password change
```

#### `fields` table
```sql
- id (UUID, PK)
- owner_id (UUID, FK → profiles) -- admin who owns this field
- name (TEXT)
- description (TEXT)
- address (TEXT)
- city (TEXT) -- IMPORTANT: for city filtering
- latitude (NUMERIC)
- longitude (NUMERIC)
- price_per_hour (NUMERIC)
- currency (TEXT)
- sport_type (TEXT)
- size (TEXT)
- surface_type (TEXT)
- images (TEXT[])
- amenities (TEXT[])
- is_active (BOOLEAN)
- rating (NUMERIC)
- total_bookings (INTEGER)
- created_at (TIMESTAMP)
- updated_at (TIMESTAMP)
```

#### `bookings` table
```sql
- id (UUID, PK)
- field_id (UUID, FK → fields)
- user_id (UUID, FK → profiles)
- booking_date (DATE)
- start_time (TIME)
- end_time (TIME)
- status (TEXT) -- 'pending', 'confirmed', 'canceled', 'completed'
- total_price (NUMERIC)
- currency (TEXT)
- notes (TEXT)
- confirmed_at (TIMESTAMP)
- canceled_at (TIMESTAMP)
- cancellation_reason (TEXT)
- created_at (TIMESTAMP)
- updated_at (TIMESTAMP)
- is_manual (BOOLEAN) -- NEW: track if created by admin
- created_by (UUID, FK → profiles) -- NEW: admin who created manual booking
- customer_name (TEXT) -- NEW: for manual bookings (walk-ins)
- customer_phone (TEXT) -- NEW: for manual bookings
- customer_email (TEXT) -- NEW: for manual bookings (optional)
```

### 2. New Tables

#### `cities` table
```sql
CREATE TABLE cities (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name TEXT NOT NULL UNIQUE,
  name_ar TEXT, -- Arabic name (optional for future)
  is_active BOOLEAN DEFAULT true,
  fields_count INTEGER DEFAULT 0, -- cached count
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Indexes
CREATE INDEX idx_cities_is_active ON cities(is_active);
CREATE INDEX idx_cities_name ON cities(name);

-- Initial cities
INSERT INTO cities (name, is_active) VALUES
  ('Cairo', true),
  ('Alexandria', true),
  ('Giza', true),
  ('Mansoura', true),
  ('Tanta', true);
```

#### `admin_field_assignments` table
```sql
-- Track which admin manages which fields (for audit trail)
CREATE TABLE admin_field_assignments (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  admin_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  field_id UUID NOT NULL REFERENCES fields(id) ON DELETE CASCADE,
  assigned_by UUID NOT NULL REFERENCES profiles(id), -- super admin
  assigned_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  notes TEXT,

  UNIQUE(admin_id, field_id)
);

-- Indexes
CREATE INDEX idx_admin_field_admin ON admin_field_assignments(admin_id);
CREATE INDEX idx_admin_field_field ON admin_field_assignments(field_id);
```

#### `admin_invitations` table
```sql
-- Track admin account creation
CREATE TABLE admin_invitations (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  email TEXT NOT NULL,
  default_password TEXT NOT NULL, -- hashed
  created_by UUID NOT NULL REFERENCES profiles(id), -- super admin
  admin_id UUID REFERENCES profiles(id), -- set after admin accepts
  status TEXT DEFAULT 'pending', -- 'pending', 'accepted'
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  accepted_at TIMESTAMP WITH TIME ZONE,

  CHECK (status IN ('pending', 'accepted'))
);

-- Indexes
CREATE INDEX idx_admin_invitations_email ON admin_invitations(email);
CREATE INDEX idx_admin_invitations_status ON admin_invitations(status);
```

### 3. Updated Views

#### `admin_statistics` view
```sql
CREATE VIEW admin_statistics AS
SELECT
  p.id as admin_id,
  p.email,
  p.full_name,
  COUNT(DISTINCT f.id) as fields_count,
  COUNT(DISTINCT b.id) as total_bookings,
  SUM(CASE WHEN b.status = 'pending' THEN 1 ELSE 0 END) as pending_bookings,
  SUM(CASE WHEN b.status = 'confirmed' THEN 1 ELSE 0 END) as confirmed_bookings,
  SUM(b.total_price) as total_revenue
FROM profiles p
LEFT JOIN fields f ON f.owner_id = p.id
LEFT JOIN bookings b ON b.field_id = f.id
WHERE p.role IN ('admin', 'super_admin')
GROUP BY p.id, p.email, p.full_name;
```

#### `platform_statistics` view (for super admin)
```sql
CREATE VIEW platform_statistics AS
SELECT
  (SELECT COUNT(*) FROM profiles WHERE role = 'user') as total_users,
  (SELECT COUNT(*) FROM profiles WHERE role = 'admin') as total_admins,
  (SELECT COUNT(*) FROM fields WHERE is_active = true) as active_fields,
  (SELECT COUNT(*) FROM bookings) as total_bookings,
  (SELECT COUNT(*) FROM bookings WHERE status = 'pending') as pending_bookings,
  (SELECT SUM(total_price) FROM bookings WHERE status = 'confirmed') as total_revenue,
  (SELECT COUNT(DISTINCT city) FROM fields) as cities_count;
```

---

## 🎨 Feature Matrix

| Feature | Super Admin | Admin | User |
|---------|-------------|-------|------|
| View platform statistics | ✅ | ❌ | ❌ |
| Manage all users | ✅ | ❌ | ❌ |
| Create admin accounts | ✅ | ❌ | ❌ |
| Assign fields to admins | ✅ | ❌ | ❌ |
| View all fields | ✅ | Own only | By city |
| View all bookings | ✅ | Own fields | Own only |
| Create manual bookings | ✅ | ✅ | ❌ |
| Approve/reject bookings | ✅ | ✅ | ❌ |
| Edit any field | ✅ | Own only | ❌ |
| Select city | ❌ | ❌ | ✅ |
| Browse fields | ✅ | Own only | ✅ |
| Book time slots | ❌ | ❌ | ✅ |
| View analytics | ✅ | Own fields | ❌ |

---

## 🎨 UI/UX Design

### Super Admin Dashboard

```
┌─────────────────────────────────────────────────────┐
│  🏆 Super Admin Dashboard                            │
├─────────────────────────────────────────────────────┤
│                                                      │
│  📊 Platform Overview                                │
│  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌─────────┐│
│  │  👥      │ │  ⚽      │ │  📅     │ │  💰    ││
│  │  Users   │ │  Fields  │ │ Bookings│ │ Revenue││
│  │  1,234   │ │   45     │ │  2,567  │ │ 50,000 ││
│  └──────────┘ └──────────┘ └──────────┘ └─────────┘│
│                                                      │
│  🔥 Quick Actions                                    │
│  [➕ Create Admin] [➕ Add Field] [📊 View Reports]  │
│                                                      │
│  📋 Recent Activity                                  │
│  • New user registered: user@example.com             │
│  • Booking confirmed: Field A - Tomorrow 10:00      │
│  • New admin created: admin@field.com               │
│                                                      │
│  Navigation:                                         │
│  [📊 Dashboard] [👥 Users] [🔧 Admins] [⚽ Fields]   │
│  [📅 Bookings] [📈 Analytics] [⚙️ Settings]          │
└─────────────────────────────────────────────────────┘
```

#### Super Admin - Create Admin Flow
```
Step 1: Admin Details
┌────────────────────────────────┐
│ Create New Admin               │
├────────────────────────────────┤
│ Email: [____________]          │
│ Full Name: [____________]      │
│ Phone: [____________]          │
│                                │
│ Default Password (auto):       │
│ FieldAdmin2024@123             │
│ [🔄 Generate New]              │
│                                │
│ [Next: Assign Fields →]        │
└────────────────────────────────┘

Step 2: Assign Fields
┌────────────────────────────────┐
│ Assign Fields to Admin         │
├────────────────────────────────┤
│ Select fields to manage:       │
│                                │
│ □ Stadium 1 - Cairo            │
│ □ Green Field - Giza           │
│ ☑ Champions Field - Cairo      │
│ ☑ Victory Arena - Cairo        │
│                                │
│ [← Back]  [Create Admin ✓]    │
└────────────────────────────────┘
```

### Admin (Field Owner) Dashboard

```
┌─────────────────────────────────────────────────────┐
│  ⚽ Field Owner Dashboard                            │
├─────────────────────────────────────────────────────┤
│                                                      │
│  📊 My Fields Performance                            │
│  ┌──────────┐ ┌──────────┐ ┌──────────┐            │
│  │  📅      │ │  ✅      │ │  💰     │            │
│  │ Bookings │ │ Approved │ │ Revenue │            │
│  │   45     │ │   38     │ │ 8,500   │            │
│  └──────────┘ └──────────┘ └──────────┘            │
│                                                      │
│  🔔 Pending Approvals (7)                            │
│  ┌──────────────────────────────────────────────┐  │
│  │ Ahmed Mohamed - Champions Field               │  │
│  │ Tomorrow 10:00 - 11:00 | 200 EGP             │  │
│  │ [✅ Approve] [❌ Reject]                      │  │
│  ├──────────────────────────────────────────────┤  │
│  │ Sara Ali - Victory Arena                     │  │
│  │ Today 14:00 - 15:00 | 250 EGP                │  │
│  │ [✅ Approve] [❌ Reject]                      │  │
│  └──────────────────────────────────────────────┘  │
│                                                      │
│  🔥 Quick Actions                                    │
│  [➕ Create Manual Booking] [📊 View Analytics]     │
│                                                      │
│  Navigation:                                         │
│  [📊 Dashboard] [📅 Bookings] [➕ Manual Booking]   │
│  [⚽ My Fields] [👥 Customers] [📈 Analytics]        │
└─────────────────────────────────────────────────────┘
```

#### Admin - Manual Booking Flow
```
Step 1: Select Field & Time
┌────────────────────────────────┐
│ Create Manual Booking          │
├────────────────────────────────┤
│ Field:                         │
│ ◉ Champions Field              │
│ ○ Victory Arena                │
│                                │
│ Date: [📅 Tomorrow]            │
│                                │
│ Available Times:               │
│ [08:00] [09:00] [10:00]        │
│ [11:00] [14:00] [15:00]        │
│                                │
│ [Next: Customer Info →]        │
└────────────────────────────────┘

Step 2: Customer Information
┌────────────────────────────────┐
│ Customer Details               │
├────────────────────────────────┤
│ Name: [____________]           │
│ Phone: [____________]          │
│ Email: [____________](optional)│
│                                │
│ Notes:                         │
│ [________________________]     │
│ [________________________]     │
│                                │
│ Total Price: 200 EGP           │
│                                │
│ [← Back]  [Confirm Booking ✓] │
└────────────────────────────────┘
```

### User App

```
Step 1: City Selection (First Time)
┌────────────────────────────────┐
│ Select Your City               │
├────────────────────────────────┤
│ Where do you want to play?     │
│                                │
│ 📍 Cairo (15 fields)           │
│ 📍 Alexandria (8 fields)       │
│ 📍 Giza (12 fields)            │
│ 📍 Mansoura (5 fields)         │
│                                │
│ [Select City]                  │
└────────────────────────────────┘

Step 2: Fields List (City: Cairo)
┌────────────────────────────────┐
│ Football Fields in Cairo       │
│ [Change City ▼]                │
├────────────────────────────────┤
│ 🔍 Search fields...            │
│ [Filters] [Sort: Rating ▼]    │
│                                │
│ ┌──────────────────────────┐  │
│ │ 🏟️ Champions Field       │  │
│ │ ⭐ 4.8 | 200 EGP/hr      │  │
│ │ 📍 Nasr City, Cairo      │  │
│ └──────────────────────────┘  │
│                                │
│ ┌──────────────────────────┐  │
│ │ 🏟️ Victory Arena         │  │
│ │ ⭐ 4.5 | 250 EGP/hr      │  │
│ │ 📍 Maadi, Cairo          │  │
│ └──────────────────────────┘  │
│                                │
│ Navigation: [🏠 Home] [📅 My]  │
└────────────────────────────────┘
```

---

## 🛣️ Implementation Roadmap

### Phase 1: Database & Backend (Week 1)
**Priority:** HIGH

#### Tasks:
1. **Database Schema Updates**
   - [ ] Create `cities` table
   - [ ] Create `admin_field_assignments` table
   - [ ] Create `admin_invitations` table
   - [ ] Add new columns to `bookings` table:
     - `is_manual`, `created_by`, `customer_name`, `customer_phone`, `customer_email`
   - [ ] Add new columns to `profiles` table:
     - `is_active`, `password_changed`
   - [ ] Create views: `admin_statistics`, `platform_statistics`

2. **RLS Policies Update**
   - [ ] Super admin can access all data
   - [ ] Admin can only access their assigned fields
   - [ ] Users can only access their bookings
   - [ ] City-based field filtering

3. **Database Functions**
   - [ ] `create_admin_account(email, password, full_name, phone)`
   - [ ] `assign_field_to_admin(admin_id, field_id)`
   - [ ] `get_platform_statistics()`
   - [ ] `get_admin_statistics(admin_id)`

**SQL Script:** `supabase/04_ROLE_ARCHITECTURE_UPDATE.sql`

---

### Phase 2: Domain Layer (Week 1-2)
**Priority:** HIGH

#### New Entities:
1. **City Entity**
```dart
class CityEntity extends Equatable {
  final String id;
  final String name;
  final String? nameAr;
  final bool isActive;
  final int fieldsCount;

  const CityEntity({...});
}
```

2. **Admin Invitation Entity**
```dart
class AdminInvitationEntity extends Equatable {
  final String id;
  final String email;
  final String defaultPassword;
  final String createdById;
  final String status;
  final DateTime createdAt;

  const AdminInvitationEntity({...});
}
```

3. **Manual Booking Entity** (extend BookingEntity)
```dart
class ManualBookingEntity extends BookingEntity {
  final bool isManual;
  final String? createdBy;
  final String? customerName;
  final String? customerPhone;
  final String? customerEmail;

  const ManualBookingEntity({...});
}
```

4. **Platform Statistics Entity**
```dart
class PlatformStatisticsEntity extends Equatable {
  final int totalUsers;
  final int totalAdmins;
  final int activeFields;
  final int totalBookings;
  final int pendingBookings;
  final double totalRevenue;
  final int citiesCount;

  const PlatformStatisticsEntity({...});
}
```

#### New Use Cases:

**Super Admin:**
- `GetPlatformStatisticsUseCase`
- `GetAllUsersUseCase`
- `GetAllAdminsUseCase`
- `CreateAdminAccountUseCase`
- `AssignFieldToAdminUseCase`
- `GetAllFieldsUseCase`
- `GetAllBookingsUseCase`

**Admin:**
- `GetAdminStatisticsUseCase`
- `CreateManualBookingUseCase`
- `GetMyCustomersUseCase`
- `GetMyFieldsUseCase`

**User:**
- `GetCitiesUseCase`
- `GetFieldsByCityUseCase`
- `SelectCityUseCase`

---

### Phase 3: Data Layer (Week 2)
**Priority:** HIGH

#### New Data Sources:
1. **City Remote Data Source**
```dart
abstract class CityRemoteDataSource {
  Future<List<CityModel>> getCities();
  Future<CityModel> getCityById(String id);
}
```

2. **Super Admin Remote Data Source**
```dart
abstract class SuperAdminRemoteDataSource {
  Future<PlatformStatisticsModel> getPlatformStatistics();
  Future<List<UserModel>> getAllUsers();
  Future<List<AdminModel>> getAllAdmins();
  Future<AdminModel> createAdminAccount({...});
  Future<void> assignFieldToAdmin(String adminId, String fieldId);
}
```

3. **Manual Booking Remote Data Source**
```dart
abstract class ManualBookingRemoteDataSource {
  Future<ManualBookingModel> createManualBooking({
    required String fieldId,
    required DateTime date,
    required String startTime,
    required String endTime,
    required String customerName,
    required String customerPhone,
    String? customerEmail,
    String? notes,
  });
}
```

#### Repositories:
- `CityRepository`
- `SuperAdminRepository`
- `ManualBookingRepository`

---

### Phase 4: Presentation Layer - Super Admin (Week 3)
**Priority:** MEDIUM

#### Pages:
1. **Super Admin Dashboard** (`super_admin_dashboard_page.dart`)
   - Platform statistics cards
   - Quick actions
   - Recent activity feed

2. **Users Management** (`users_management_page.dart`)
   - Users list with search/filter
   - User details dialog
   - Activate/deactivate user

3. **Admins Management** (`admins_management_page.dart`)
   - Admins list
   - Create admin flow
   - Assign fields dialog
   - Reset password

4. **All Fields Management** (`all_fields_management_page.dart`)
   - All fields list
   - Create field
   - Assign to admin

5. **All Bookings** (`all_bookings_page.dart`)
   - All bookings across platform
   - Advanced filters

6. **Analytics** (`platform_analytics_page.dart`)
   - Charts and graphs
   - Revenue trends
   - Booking trends

#### Cubits:
- `SuperAdminCubit`
- `UserManagementCubit`
- `AdminManagementCubit`

---

### Phase 5: Presentation Layer - Admin Updates (Week 3-4)
**Priority:** MEDIUM

#### Updated Pages:
1. **Admin Dashboard** (update existing)
   - Field-specific statistics
   - Pending approvals section
   - Quick access to manual booking

2. **Manual Booking Page** (`create_manual_booking_page.dart`)
   - Select field
   - Select date/time
   - Enter customer info
   - Confirm booking

3. **Customers Page** (`customers_page.dart`)
   - List of customers who booked
   - Customer details
   - Booking history per customer

#### Updated Cubits:
- `BookingCubit` (add manual booking methods)
- `CustomerCubit` (new)

---

### Phase 6: Presentation Layer - User Updates (Week 4)
**Priority:** MEDIUM

#### Updated Pages:
1. **City Selection** (`city_selection_page.dart`)
   - First-time city selection
   - Can change later in settings

2. **Home Page** (update existing)
   - Show selected city
   - Fields filtered by city
   - Change city button

3. **Fields List** (update existing)
   - Add city filter
   - Show city in field cards

#### Updated Cubits:
- `CityCubit` (new)
- `FieldsCubit` (update to filter by city)

---

### Phase 7: Navigation & Routing (Week 4)
**Priority:** HIGH

#### Update App Router:
```dart
// Super Admin Routes
static const String superAdminDashboard = '/super-admin/dashboard';
static const String usersManagement = '/super-admin/users';
static const String adminsManagement = '/super-admin/admins';
static const String allFields = '/super-admin/fields';
static const String allBookings = '/super-admin/bookings';
static const String platformAnalytics = '/super-admin/analytics';

// Admin Routes (keep existing, add new)
static const String createManualBooking = '/owner/bookings/manual';
static const String customers = '/owner/customers';

// User Routes (keep existing, add new)
static const String citySelection = '/city-selection';
```

#### Update Splash Logic:
```dart
if (role == 'super_admin') {
  navigate to superAdminDashboard
} else if (role == 'admin') {
  if (!passwordChanged) {
    navigate to changePassword
  } else {
    navigate to ownerDashboard
  }
} else { // user
  if (!hasSelectedCity) {
    navigate to citySelection
  } else {
    navigate to home
  }
}
```

---

### Phase 8: Testing & Refinement (Week 5)
**Priority:** HIGH

#### Testing Tasks:
- [ ] Super admin can create admin
- [ ] Super admin can assign fields
- [ ] Admin receives login credentials
- [ ] Admin must change password on first login
- [ ] Admin can create manual bookings
- [ ] Manual bookings appear in statistics
- [ ] Users can select city
- [ ] Fields filtered by city correctly
- [ ] RLS policies work correctly for each role
- [ ] All statistics calculate correctly

---

## 🔒 Security & Permissions

### Row Level Security (RLS) Policies

#### Profiles Table
```sql
-- Super admin can see all profiles
CREATE POLICY "Super admins can view all profiles"
ON profiles FOR SELECT
TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM profiles
    WHERE id = auth.uid() AND role = 'super_admin'
  )
  OR id = auth.uid() -- Users can see their own
);
```

#### Fields Table
```sql
-- Super admin can see all fields
-- Admin can see assigned fields
-- Users can see active fields in their selected city
CREATE POLICY "Field visibility by role"
ON fields FOR SELECT
TO authenticated
USING (
  -- Super admin sees all
  EXISTS (
    SELECT 1 FROM profiles
    WHERE id = auth.uid() AND role = 'super_admin'
  )
  OR
  -- Admin sees their fields
  (owner_id = auth.uid() AND EXISTS (
    SELECT 1 FROM profiles
    WHERE id = auth.uid() AND role = 'admin'
  ))
  OR
  -- Users see active fields
  (is_active = true AND EXISTS (
    SELECT 1 FROM profiles
    WHERE id = auth.uid() AND role = 'user'
  ))
);
```

#### Bookings Table
```sql
-- Super admin sees all
-- Admin sees bookings for their fields
-- User sees their bookings
CREATE POLICY "Booking visibility by role"
ON bookings FOR SELECT
TO authenticated
USING (
  -- Super admin sees all
  EXISTS (
    SELECT 1 FROM profiles
    WHERE id = auth.uid() AND role = 'super_admin'
  )
  OR
  -- Admin sees bookings for their fields
  EXISTS (
    SELECT 1 FROM fields f
    WHERE f.id = bookings.field_id
    AND f.owner_id = auth.uid()
    AND EXISTS (
      SELECT 1 FROM profiles
      WHERE id = auth.uid() AND role IN ('admin', 'super_admin')
    )
  )
  OR
  -- Users see their own bookings
  (user_id = auth.uid() AND EXISTS (
    SELECT 1 FROM profiles
    WHERE id = auth.uid() AND role = 'user'
  ))
);
```

---

## 📊 Success Metrics

### Key Performance Indicators (KPIs)

**Super Admin Metrics:**
- Time to create new admin: < 2 minutes
- Platform statistics accuracy: 100%
- System response time: < 1 second

**Admin Metrics:**
- Manual booking creation time: < 1 minute
- Booking approval time: < 30 seconds
- Field statistics refresh: Real-time

**User Metrics:**
- City selection time: < 10 seconds
- Field discovery time: < 30 seconds
- Booking completion time: < 2 minutes

---

## 🎯 Priority Summary

### Must Have (Phase 1-3) - 2 Weeks
- Database schema updates
- Super admin: Create admin accounts
- Admin: Manual booking creation
- User: City selection

### Should Have (Phase 4-6) - 2 Weeks
- Super admin dashboard
- Admin dashboard updates
- Customer management
- Platform analytics

### Nice to Have (Phase 7-8) - 1 Week
- Advanced analytics
- Email notifications
- Password reset flow
- Mobile app optimization

---

## 📝 Notes & Considerations

### Technical Debt to Address:
- [ ] Add password hashing for default passwords
- [ ] Implement email service for admin invitations
- [ ] Add phone verification
- [ ] Implement real-time notifications
- [ ] Add caching for statistics
- [ ] Optimize database queries with proper indexes

### Future Enhancements:
- Multi-language support (Arabic/English)
- SMS notifications
- Payment integration
- Review and rating system
- Field availability calendar
- Recurring bookings
- Loyalty program

---

**Document Version:** 1.0
**Last Updated:** November 24, 2025
**Author:** Claude Code
**Status:** ✅ Ready for Review
