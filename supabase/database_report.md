# Sport Kick Database Report

**Generated**: December 31, 2025
**Database**: Supabase PostgreSQL
**Schema Version**: 2.2 (includes all migrations through 20251231)

---

## Quick Reference

| Metric | Count |
|--------|:-----:|
| Tables | 15 |
| Views | 3 |
| Functions | 38 |
| Triggers | 19 |
| RLS Policies | 60+ |
| Indexes | 82+ |
| Storage Buckets | 1 (payment_proofs) |

---

## Tables Overview

| Table | Description | Rows (est.) | RLS |
|-------|-------------|:-----------:|:---:|
| `profiles` | User accounts (linked to auth.users) | - | Yes |
| `cities` | Supported cities/locations | - | Yes |
| `sport_categories` | Sport types (Football, Basketball, etc.) | - | Yes |
| `fields` | Sports venues/fields | - | Yes |
| `bookings` | Reservation records | - | Yes |
| `business_hours` | Field operating hours | - | Yes |
| `reviews` | User ratings & feedback | - | Yes |
| `admin_invitations` | Admin account creation tracking | - | Yes |
| `admin_field_assignments` | Admin-to-field links | - | Yes |
| `login_activity` | Security/audit tracking | - | Yes |
| `platform_settings` | App-wide configuration | - | Yes |
| `user_fcm_tokens` | Push notification tokens | - | Yes |
| `notifications` | Notification history | - | Yes |
| `recurring_bookings` | Weekly subscription bookings | - | Yes |
| `user_preferences` | User settings for appearance, notifications, privacy | - | Yes |

---

## Table Schemas

### 1. profiles
User accounts for all roles (super_admin, admin, user).

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| id | UUID | PK, FK(auth.users) | Links to Supabase auth |
| email | TEXT | UNIQUE, NOT NULL | User email |
| full_name | TEXT | - | Display name |
| phone | TEXT | - | Contact number |
| avatar_url | TEXT | - | Profile image URL |
| role | TEXT | CHECK(user/admin/super_admin) | User role |
| is_active | BOOLEAN | DEFAULT true | Account status |
| password_changed | BOOLEAN | DEFAULT false | Admin password change tracking |
| preferred_sports | TEXT[] | DEFAULT '{}' | User sport preferences |
| selected_city_id | UUID | FK(cities) | User's selected city |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | - |
| updated_at | TIMESTAMPTZ | DEFAULT NOW() | - |

**Indexes**: role, email, is_active, selected_city_id

---

### 2. cities
Supported cities where fields can be located.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| id | UUID | PK | - |
| name | TEXT | UNIQUE, NOT NULL | City name (English) |
| name_ar | TEXT | - | City name (Arabic) |
| is_active | BOOLEAN | DEFAULT true | City availability |
| fields_count | INTEGER | DEFAULT 0 | Cached count of fields |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | - |
| updated_at | TIMESTAMPTZ | DEFAULT NOW() | - |

**Indexes**: is_active, name

---

### 3. sport_categories
Types of sports supported.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| id | UUID | PK | - |
| name | TEXT | UNIQUE, NOT NULL | Category name |
| icon | TEXT | - | Icon name for UI |
| description | TEXT | - | Category description |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | - |

**Indexes**: name

---

### 4. fields
Football fields and sports facilities.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| id | UUID | PK | - |
| owner_id | UUID | FK(profiles) | Admin who manages field |
| name | TEXT | NOT NULL | Field name |
| description | TEXT | - | Field description |
| city_id | UUID | FK(cities), NOT NULL | Location city |
| address | TEXT | - | Street address |
| latitude | NUMERIC(10,8) | CHECK(-90 to 90) | GPS latitude |
| longitude | NUMERIC(11,8) | CHECK(-180 to 180) | GPS longitude |
| price_per_hour | NUMERIC(10,2) | NOT NULL, CHECK(>0) | Hourly rate |
| currency | TEXT | DEFAULT 'EGP' | Currency code |
| sport_category_id | UUID | FK(sport_categories) | Sport type |
| sport_type | TEXT | DEFAULT 'Football' | Legacy field |
| size | TEXT | - | e.g., "5-a-side", "7-a-side" |
| surface_type | TEXT | - | e.g., "Grass", "Artificial Turf" |
| images | TEXT[] | DEFAULT '{}' | Image URLs |
| amenities | TEXT[] | DEFAULT '{}' | e.g., ["Parking", "Lighting"] |
| is_active | BOOLEAN | DEFAULT true | Field availability |
| rating | NUMERIC(3,2) | DEFAULT 0.0, CHECK(0-5) | Average rating |
| total_bookings | INTEGER | DEFAULT 0 | Booking count |
| total_revenue | NUMERIC(12,2) | DEFAULT 0.0 | Revenue tracking |
| payment_phone | VARCHAR(20) | - | Mobile wallet number |
| payment_method | VARCHAR(50) | DEFAULT 'vodafone_cash' | Payment type |
| payment_instructions | TEXT | - | Custom payment instructions |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | - |
| updated_at | TIMESTAMPTZ | DEFAULT NOW() | - |

**Indexes**: owner_id, city_id, sport_category_id, is_active, rating, price, (city_id, is_active)

---

### 5. bookings
Field reservations (both user and manual/walk-in).

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| id | UUID | PK | - |
| field_id | UUID | FK(fields), NOT NULL | Booked field |
| user_id | UUID | FK(profiles), NOT NULL | Booking user |
| booking_date | DATE | NOT NULL | Reservation date |
| start_time | TIME | NOT NULL | Start time |
| end_time | TIME | NOT NULL | End time |
| duration_hours | INTEGER | DEFAULT 1 | 1 or 2 hours |
| status | TEXT | CHECK(pending/confirmed/canceled/completed) | Booking status |
| total_price | NUMERIC(10,2) | NOT NULL, CHECK(>0) | Total amount |
| currency | TEXT | DEFAULT 'EGP' | - |
| notes | TEXT | - | Additional notes |
| invoice_number | VARCHAR(50) | - | Format: INV-YYYYMMDD-XXXX |
| payment_status | VARCHAR(20) | DEFAULT 'pending' | pending/uploaded/verified/rejected |
| payment_proof_url | TEXT | - | Screenshot URL |
| payment_uploaded_at | TIMESTAMPTZ | - | Upload timestamp |
| payment_verified_at | TIMESTAMPTZ | - | Verification timestamp |
| payment_rejection_reason | TEXT | - | Rejection reason |
| confirmed_at | TIMESTAMPTZ | - | Confirmation timestamp |
| canceled_at | TIMESTAMPTZ | - | Cancellation timestamp |
| cancellation_reason | TEXT | - | Cancellation reason |
| is_manual | BOOLEAN | DEFAULT false | Walk-in booking flag |
| created_by | UUID | FK(profiles) | Admin for manual bookings |
| customer_name | TEXT | - | Walk-in customer name |
| customer_phone | TEXT | - | Walk-in customer phone |
| customer_email | TEXT | - | Walk-in customer email |
| recurring_booking_id | UUID | FK(recurring_bookings) | Link to subscription |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | - |
| updated_at | TIMESTAMPTZ | DEFAULT NOW() | - |

**Indexes**: field_id, user_id, status, booking_date, created_by, is_manual, payment_status, invoice_number, (field_id, booking_date), (field_id, status), recurring_booking_id

---

### 6. business_hours
Field operating hours per day of week.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| id | UUID | PK | - |
| field_id | UUID | FK(fields), NOT NULL | Associated field |
| day_of_week | INTEGER | CHECK(0-6), NOT NULL | 0=Sunday, 6=Saturday |
| is_open | BOOLEAN | DEFAULT true | Open on this day |
| opening_time | TIME | - | Opening time |
| closing_time | TIME | - | Closing time |
| closes_next_day | BOOLEAN | DEFAULT false | For cross-midnight hours |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | - |
| updated_at | TIMESTAMPTZ | DEFAULT NOW() | - |

**Constraints**: UNIQUE(field_id, day_of_week), valid_times CHECK
**Indexes**: field_id, day_of_week, is_open

---

### 7. reviews
User ratings and feedback for fields.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| id | UUID | PK | - |
| field_id | UUID | FK(fields), NOT NULL | Reviewed field |
| user_id | UUID | FK(profiles), NOT NULL | Reviewer |
| booking_id | UUID | FK(bookings) | Associated booking |
| rating | INTEGER | CHECK(1-5), NOT NULL | Star rating |
| comment | TEXT | - | Review text |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | - |
| updated_at | TIMESTAMPTZ | DEFAULT NOW() | - |

**Constraints**: UNIQUE(user_id, field_id, booking_id)
**Indexes**: field_id, user_id, booking_id, created_at, rating

---

### 8. admin_invitations
Tracking admin account creation by super admin.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| id | UUID | PK | - |
| email | TEXT | NOT NULL | Invited email |
| default_password | TEXT | NOT NULL | Initial password |
| full_name | TEXT | NOT NULL | Admin name |
| phone | TEXT | - | Contact number |
| created_by | UUID | FK(profiles), NOT NULL | Super admin who invited |
| admin_id | UUID | FK(profiles) | Created admin account |
| status | TEXT | CHECK(pending/accepted/expired) | Invitation status |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | - |
| accepted_at | TIMESTAMPTZ | - | Acceptance timestamp |

**Indexes**: email, status, created_by

---

### 9. admin_field_assignments
Audit trail for admin-to-field assignments.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| id | UUID | PK | - |
| admin_id | UUID | FK(profiles), NOT NULL | Assigned admin |
| field_id | UUID | FK(fields), NOT NULL | Assigned field |
| assigned_by | UUID | FK(profiles), NOT NULL | Super admin |
| notes | TEXT | - | Assignment notes |
| assigned_at | TIMESTAMPTZ | DEFAULT NOW() | - |

**Constraints**: UNIQUE(admin_id, field_id)
**Indexes**: admin_id, field_id, assigned_by

---

### 10. login_activity
Security and audit logging.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| id | UUID | PK | - |
| user_id | UUID | FK(auth.users) | Logging in user |
| timestamp | TIMESTAMPTZ | DEFAULT NOW() | Login time |
| ip_address | TEXT | - | Client IP |
| device_type | TEXT | - | mobile/web/desktop |
| device_name | TEXT | - | Device info |
| location | TEXT | - | City, Country |
| status | TEXT | DEFAULT 'success' | success/failed/blocked |
| user_agent | TEXT | - | Browser user agent |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | - |

**Indexes**: user_id, timestamp, status

---

### 11. platform_settings
App-wide configuration.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| id | UUID | PK | - |
| setting_key | TEXT | UNIQUE, NOT NULL | Setting identifier |
| setting_value | JSONB | NOT NULL | Setting data |
| description | TEXT | - | Setting description |
| updated_at | TIMESTAMPTZ | DEFAULT NOW() | - |
| updated_by | UUID | FK(auth.users) | Last modifier |

**Default Settings**:
- `default_operating_hours`: Default hours for new fields
- `enforce_operating_hours`: Whether to enforce operating hours

**Indexes**: setting_key

---

### 12. user_fcm_tokens
Firebase Cloud Messaging tokens for push notifications.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| id | UUID | PK | - |
| user_id | UUID | FK(auth.users), NOT NULL, UNIQUE | Token owner |
| fcm_token | TEXT | NOT NULL | Firebase token |
| user_role | TEXT | DEFAULT 'user' | Role for topic subscriptions |
| device_info | JSONB | - | Device metadata |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | - |
| updated_at | TIMESTAMPTZ | DEFAULT NOW() | - |

**Indexes**: user_id, user_role

---

### 13. notifications
Notification history for all users.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| id | UUID | PK | - |
| user_id | UUID | FK(auth.users), NOT NULL | Recipient |
| title | TEXT | NOT NULL | Notification title |
| body | TEXT | NOT NULL | Notification body |
| type | TEXT | DEFAULT 'booking' | booking/payment/system/review |
| reference_id | UUID | - | Related entity ID |
| reference_type | TEXT | - | booking/field/payment |
| is_read | BOOLEAN | DEFAULT false | Read status |
| is_sent | BOOLEAN | DEFAULT false | Push sent status |
| data | JSONB | DEFAULT '{}' | Additional metadata |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | - |
| read_at | TIMESTAMPTZ | - | Read timestamp |

**Indexes**: user_id, is_read, type, created_at

---

### 14. recurring_bookings
Weekly subscription bookings.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| id | UUID | PK | - |
| user_id | UUID | FK(profiles), NOT NULL | Subscriber |
| field_id | UUID | FK(fields), NOT NULL | Subscribed field |
| day_of_week | INTEGER | CHECK(0-6), NOT NULL | 0=Saturday (app convention) |
| start_time | TIME | NOT NULL | Weekly slot start |
| end_time | TIME | NOT NULL | Weekly slot end |
| duration_hours | INTEGER | CHECK(1 or 2), DEFAULT 1 | Duration |
| status | TEXT | CHECK(pending_approval/active/canceled/rejected) | Subscription status |
| started_at | DATE | - | Activation date |
| last_generated_date | DATE | - | Last booking generated |
| next_generation_date | DATE | - | Next booking to generate |
| approved_by | UUID | FK(profiles) | Approving admin |
| approved_at | TIMESTAMPTZ | - | Approval timestamp |
| rejection_reason | TEXT | - | Rejection reason |
| canceled_at | TIMESTAMPTZ | - | Cancellation timestamp |
| canceled_by | UUID | FK(profiles) | Canceling user/admin |
| cancellation_reason | TEXT | - | Cancellation reason |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | - |
| updated_at | TIMESTAMPTZ | DEFAULT NOW() | - |

**Constraints**: valid_time_range, UNIQUE(field_id, day_of_week, start_time) WHERE status IN (pending_approval, active)
**Indexes**: user_id, field_id, status, next_generation_date

---

### 15. user_preferences
User-specific settings for appearance, notifications, and privacy.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| user_id | UUID | PK, FK(auth.users) | Links to Supabase auth (CASCADE delete) |
| theme_mode | TEXT | CHECK(light/dark/system), DEFAULT 'system' | App theme preference |
| language | TEXT | CHECK(en/ar), DEFAULT 'en' | UI language |
| push_notifications_enabled | BOOLEAN | DEFAULT true | Master push toggle |
| booking_confirmation_notifications | BOOLEAN | DEFAULT true | Booking confirmed alerts |
| booking_reminder_notifications | BOOLEAN | DEFAULT true | Booking reminder alerts |
| booking_status_notifications | BOOLEAN | DEFAULT true | Status change alerts |
| field_owner_messages_notifications | BOOLEAN | DEFAULT true | Owner message alerts |
| show_profile_picture | BOOLEAN | DEFAULT true | Privacy: show avatar |
| show_phone_number | BOOLEAN | DEFAULT false | Privacy: show phone |
| show_email | BOOLEAN | DEFAULT false | Privacy: show email |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | - |
| updated_at | TIMESTAMPTZ | DEFAULT NOW() | - |

**Indexes**: theme_mode, language

---

## Views

### 1. user_bookings_with_details
Complete booking information with joins.

```sql
SELECT
  b.*,                           -- All booking columns
  b.payment_status, b.payment_proof_url, b.duration_hours,  -- Payment fields
  f.name AS field_name, f.images[1] AS field_image, f.address AS field_address,
  c.name AS field_city_name,
  p.full_name AS user_name, p.email AS user_email, p.phone AS user_phone,
  creator.full_name AS created_by_name, creator.email AS created_by_email
FROM bookings b
LEFT JOIN fields f, cities c, profiles p, profiles creator
```

### 2. admin_statistics
Statistics per admin/field owner.

```sql
SELECT
  admin_id, email, full_name, phone,
  fields_count, active_fields_count,
  total_bookings, pending_bookings, confirmed_bookings, canceled_bookings, completed_bookings,
  manual_bookings_count,
  total_revenue, completed_revenue,
  avg_field_rating
FROM profiles (role IN admin/super_admin) + fields + bookings
```

### 3. platform_statistics
Platform-wide statistics for super admin dashboard.

```sql
SELECT
  total_users, new_users_this_month,
  total_admins,
  active_fields, total_fields,
  cities_with_fields, active_cities,
  total_bookings, pending_bookings, confirmed_bookings, completed_bookings, manual_bookings,
  bookings_this_month,
  total_revenue, revenue_this_month
```

---

## Relationships (Foreign Keys)

```
auth.users
    └── profiles.id (CASCADE)
            ├── profiles.selected_city_id → cities.id (SET NULL)
            ├── fields.owner_id (SET NULL)
            ├── bookings.user_id (CASCADE)
            ├── bookings.created_by (SET NULL)
            ├── reviews.user_id (CASCADE)
            ├── admin_invitations.created_by (CASCADE)
            ├── admin_invitations.admin_id (SET NULL)
            ├── admin_field_assignments.admin_id (CASCADE)
            ├── admin_field_assignments.assigned_by (NO ACTION)
            ├── recurring_bookings.user_id (CASCADE)
            ├── recurring_bookings.approved_by (NO ACTION)
            ├── recurring_bookings.canceled_by (NO ACTION)
            └── user_preferences.user_id (CASCADE)

cities
    └── fields.city_id (RESTRICT)

sport_categories
    └── fields.sport_category_id (SET NULL)

fields
    ├── bookings.field_id (CASCADE)
    ├── reviews.field_id (CASCADE)
    ├── business_hours.field_id (CASCADE)
    ├── admin_field_assignments.field_id (CASCADE)
    └── recurring_bookings.field_id (CASCADE)

bookings
    ├── reviews.booking_id (SET NULL)
    └── recurring_bookings (via recurring_booking_id) (SET NULL)
```

---

## Functions Reference

### Authentication & Role Helpers
| Function | Returns | Description |
|----------|---------|-------------|
| `get_current_user_role()` | TEXT | Gets current user's role (SECURITY DEFINER) |
| `is_super_admin()` | BOOLEAN | Checks if current user is super admin |
| `is_admin()` | BOOLEAN | Checks if current user is admin or super_admin |
| `is_user()` | BOOLEAN | Checks if current user is regular user |

### Invoice & Booking
| Function | Returns | Description |
|----------|---------|-------------|
| `generate_invoice_number()` | TEXT | Generates INV-YYYYMMDD-XXXX format |
| `set_invoice_number()` | TRIGGER | Auto-sets invoice number on INSERT |
| `complete_passed_bookings()` | INTEGER | Marks passed confirmed bookings as completed |
| `validate_booking_date_on_insert()` | TRIGGER | Prevents bookings in the past |

### Business Hours
| Function | Returns | Description |
|----------|---------|-------------|
| `get_field_business_hours(field_id)` | TABLE | Gets all hours for a field |
| `is_field_open_at(field_id, day, time)` | BOOLEAN | Checks if field is open |
| `get_next_opening_time(field_id, from)` | TIMESTAMPTZ | Finds next opening time |
| `initialize_default_business_hours(field_id)` | VOID | Creates 24/7 default hours |
| `validate_booking_time(field_id, time)` | BOOLEAN | Validates against hours |
| `update_business_hours_updated_at()` | TRIGGER | Auto-updates timestamp |

### Reviews
| Function | Returns | Description |
|----------|---------|-------------|
| `update_field_review_stats(field_id)` | VOID | Recalculates field rating |
| `trigger_after_review_insert()` | TRIGGER | Updates stats on insert |
| `trigger_after_review_update()` | TRIGGER | Updates stats on update |
| `trigger_after_review_delete()` | TRIGGER | Updates stats on delete |
| `get_field_reviews(field_id, limit, offset)` | TABLE | Paginated reviews |
| `can_user_review_field(user_id, field_id, booking_id)` | BOOLEAN | Checks eligibility |
| `get_user_field_review(user_id, field_id)` | TABLE | Gets user's review |
| `update_reviews_updated_at()` | TRIGGER | Auto-updates timestamp |

### Notifications
| Function | Returns | Description |
|----------|---------|-------------|
| `notify_field_owner_on_booking()` | TRIGGER | Creates notification on new booking |
| `notify_owner_on_payment_upload()` | TRIGGER | Notifies on payment proof upload |
| `get_unread_notification_count(user_id)` | INTEGER | Counts unread notifications |
| `mark_notifications_read(ids[])` | VOID | Marks specific as read |
| `mark_all_notifications_read()` | VOID | Marks all as read for current user |

### FCM Tokens
| Function | Returns | Description |
|----------|---------|-------------|
| `update_user_fcm_tokens_updated_at()` | TRIGGER | Auto-updates timestamp |

### Recurring Bookings
| Function | Returns | Description |
|----------|---------|-------------|
| `create_recurring_booking_request(...)` | UUID | Creates subscription request |
| `cancel_recurring_booking(id, reason)` | BOOLEAN | User cancels subscription |
| `get_my_recurring_bookings()` | TABLE | User's subscriptions with stats |
| `approve_recurring_booking(id)` | BOOLEAN | Owner approves (generates 4 weeks) |
| `reject_recurring_booking(id, reason)` | BOOLEAN | Owner rejects |
| `get_pending_recurring_requests()` | TABLE | Pending requests for owner |
| `get_active_recurring_bookings_for_owner()` | TABLE | Active subscriptions for owner |
| `on_recurring_payment_verified()` | TRIGGER | Generates next booking on payment |
| `check_and_cancel_missed_recurring_payments()` | INTEGER | Auto-cancels missed payments |
| `is_slot_reserved_recurring(field, day, time)` | BOOLEAN | Checks if slot is reserved |
| `get_reserved_recurring_slots(field_id)` | TABLE | Gets all reserved slots |
| `update_recurring_updated_at()` | TRIGGER | Auto-updates timestamp |

### User Preferences
| Function | Returns | Description |
|----------|---------|-------------|
| `update_user_preferences_updated_at()` | TRIGGER | Auto-updates updated_at timestamp |
| `get_or_create_user_preferences(user_id)` | user_preferences | Gets prefs or creates defaults |
| `should_send_notification(user_id, type)` | BOOLEAN | Checks if notification should be sent |

---

## Triggers Reference

| Trigger | Table | Event | Function |
|---------|-------|-------|----------|
| `trigger_set_invoice_number` | bookings | BEFORE INSERT | `set_invoice_number()` |
| `validate_booking_date_trigger` | bookings | BEFORE INSERT | `validate_booking_date_on_insert()` |
| `trigger_notify_owner_new_booking` | bookings | AFTER INSERT | `notify_field_owner_on_booking()` |
| `trigger_notify_owner_payment_upload` | bookings | AFTER UPDATE | `notify_owner_on_payment_upload()` |
| `trigger_recurring_payment_verified` | bookings | AFTER UPDATE | `on_recurring_payment_verified()` |
| `trigger_update_business_hours_updated_at` | business_hours | BEFORE UPDATE | `update_business_hours_updated_at()` |
| `after_review_insert` | reviews | AFTER INSERT | `trigger_after_review_insert()` |
| `after_review_update` | reviews | AFTER UPDATE | `trigger_after_review_update()` |
| `after_review_delete` | reviews | AFTER DELETE | `trigger_after_review_delete()` |
| `trigger_update_reviews_updated_at` | reviews | BEFORE UPDATE | `update_reviews_updated_at()` |
| `trigger_user_fcm_tokens_updated_at` | user_fcm_tokens | BEFORE UPDATE | `update_user_fcm_tokens_updated_at()` |
| `set_recurring_updated_at` | recurring_bookings | BEFORE UPDATE | `update_recurring_updated_at()` |
| `trigger_update_user_preferences_updated_at` | user_preferences | BEFORE UPDATE | `update_user_preferences_updated_at()` |

---

## RLS Policies Summary

### By Role Access

| Table | User | Admin | Super Admin |
|-------|------|-------|-------------|
| profiles | Own only | Own only | All |
| cities | Active only | Active only | All |
| sport_categories | All | All | All |
| fields | Active only | Own fields | All |
| bookings | Own only | Own field bookings | All |
| business_hours | View all | Own fields | All |
| reviews | View all, create own | View all | All |
| admin_invitations | - | - | All |
| admin_field_assignments | - | Own only | All |
| login_activity | Own only | Own only | All |
| platform_settings | Read only | Read only | All |
| user_fcm_tokens | Own only | Own only | All |
| notifications | Own only | Own only | All |
| recurring_bookings | Own only | Own field requests | All |
| user_preferences | Own only | Own only | - |

---

## Storage Buckets

| Bucket | Public | Purpose |
|--------|:------:|---------|
| `payment_proofs` | No | Payment screenshot uploads |

**Policies**:
- Users can upload to their own folder
- Users can view their own uploads
- Owners can view proofs for their field bookings

---

## Day of Week Conventions

**PostgreSQL EXTRACT(DOW)**: 0=Sunday, 1=Monday, ..., 6=Saturday

**App Convention (recurring_bookings)**: 0=Saturday, 1=Sunday, 2=Monday, ..., 6=Friday

**Conversion**: `postgres_dow = (app_day + 1) % 7`

---

## Enums (Check Constraints)

| Table.Column | Values |
|--------------|--------|
| profiles.role | 'user', 'admin', 'super_admin' |
| bookings.status | 'pending', 'confirmed', 'canceled', 'completed' |
| bookings.payment_status | 'pending', 'uploaded', 'verified', 'rejected' |
| fields.payment_method | 'vodafone_cash', 'instapay' |
| admin_invitations.status | 'pending', 'accepted', 'expired' |
| login_activity.status | 'success', 'failed', 'blocked' |
| notifications.type | 'booking', 'payment', 'system', 'review' |
| recurring_bookings.status | 'pending_approval', 'active', 'canceled', 'rejected' |

---

## File Organization

```
supabase/
├── database_report.md                    # This comprehensive reference
├── README_DATABASE_SETUP.md              # Setup instructions
│
├── schema/                               # CONSOLIDATED SCHEMA (run in order for fresh install)
│   ├── 01_extensions.sql                 # uuid-ossp, pg_net
│   ├── 02_core_tables.sql                # profiles, cities, sport_categories, fields
│   ├── 03_booking_tables.sql             # bookings, business_hours, recurring_bookings
│   ├── 04_feature_tables.sql             # reviews, notifications
│   ├── 05_admin_tables.sql               # admin_invitations, admin_field_assignments, login_activity
│   ├── 06_system_tables.sql              # platform_settings, user_fcm_tokens, user_preferences, storage bucket
│   ├── 07_views.sql                      # user_bookings_with_details, admin_statistics, platform_statistics
│   ├── 08_functions.sql                  # All 38 functions
│   ├── 09_triggers.sql                   # All 19 triggers
│   └── 10_rls_policies.sql               # All RLS policies + grants
│
├── migrations/                           # HISTORICAL CHANGES (reference only)
│   ├── 20251212_*.sql                    # Payment, login activity, FCM, platform settings
│   ├── 20251213_*.sql                    # Notifications, webhooks, payment fixes
│   ├── 20251217_*.sql                    # Recurring bookings
│   ├── 20251219_*.sql                    # Day of week fix
│   └── 20251231_create_user_preferences.sql  # User preferences table
│
├── seeds/                                # INITIAL DATA
│   ├── 01_initial_data.sql               # Cities, categories, platform settings
│   └── 02_demo_data.sql                  # Optional test data (commented out)
│
├── utilities/                            # MAINTENANCE
│   └── maintenance.sql                   # Health checks, cleanup, statistics queries
│
├── functions/                            # EDGE FUNCTIONS
│   ├── send-fcm-notification/            # Push notification handler
│   └── complete-bookings/                # Auto-complete bookings
│
└── diagrams/                             # ERD diagrams
```

### Usage

**Fresh Installation:**
```bash
# Run schema files 01-10 in order
psql -f schema/01_extensions.sql
psql -f schema/02_core_tables.sql
# ... through 10_rls_policies.sql
psql -f seeds/01_initial_data.sql
```

**Adding New Features:**
1. Create migration: `migrations/YYYYMMDD_feature_name.sql`
2. Apply to production
3. Update corresponding schema file
4. Update this report

---

## Quick Reference Queries

### Check table sizes
```sql
SELECT tablename, pg_size_pretty(pg_total_relation_size(tablename::text))
FROM pg_tables WHERE schemaname = 'public';
```

### Check RLS policies
```sql
SELECT tablename, policyname, cmd, qual
FROM pg_policies WHERE schemaname = 'public';
```

### Check triggers
```sql
SELECT tgname, tgrelid::regclass, tgtype, proname
FROM pg_trigger t JOIN pg_proc p ON t.tgfoid = p.oid
WHERE NOT tgisinternal;
```

### Check indexes
```sql
SELECT tablename, indexname, indexdef
FROM pg_indexes WHERE schemaname = 'public';
```

---

*Last updated: December 31, 2025*
