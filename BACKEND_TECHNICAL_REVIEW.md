# Spo Kick Backend Technical Review

This report highlights key backend behaviors in the current Supabase-based
implementation, focusing on authentication, notifications, booking flow,
complex queries, file uploads, RPC usage, SQL functions/triggers, and any
background jobs. It is written to help plan a migration to a custom API.

## A) Authentication & Sessions

File: `lib/features/auth/data/datasources/auth_remote_datasource.dart`

Key behaviors:
- Sign in: `supabase.auth.signInWithPassword` then fetches `profiles` row.
- Sign up: `supabase.auth.signUp` then updates `profiles` with name/phone.
- Role handling: roles are stored in `profiles.role`. The client fetches the
  profile and relies on RLS policies in Supabase for access control.
- Session checks: uses `supabase.auth.currentSession` and token expiry.
- Password change: re-authenticate with password then `auth.updateUser`.
- Profile updates: writes to `profiles` and re-fetches data.

Notes:
- Role enforcement is primarily in database RLS policies, not in the client.
- A trigger is assumed to create a `profiles` row after sign-up.

## B) Realtime & Notifications

Folder: `lib/features/notifications/data/datasources/`
File: `notification_remote_datasource.dart`

Key behaviors:
- Fetch notifications by user ID with pagination.
- Unread count:
  - Preferred: `rpc('get_unread_notification_count')`
  - Fallback: direct query of `notifications` table.
- Mark as read:
  - Single: update `notifications` row
  - Bulk: `rpc('mark_notifications_read')` with fallback
  - All: `rpc('mark_all_notifications_read')` with fallback
- Realtime:
  - Uses Supabase Realtime channel
  - Subscribes to `PostgresChangeEvent.insert` on `notifications`
  - Emits updates via a Dart stream

Conclusion:
- Realtime subscriptions are used; polling is not the primary mechanism.

## C) Booking Flow

Folder: `lib/features/bookings/data/datasources/`

File: `booking_remote_datasource.dart`
- Create booking: inserts into `bookings`, joins `fields` to enrich response.
- Availability:
  - `getAvailableTimeSlots` queries `bookings` directly for a date and
    builds availability in memory.
  - `is_time_slot_available` RPC is also used in a separate time slot data
    source for O(1) availability checks.

File: `booking_user_operations_datasource.dart`
- Payment proof upload:
  - Uploads to Supabase Storage bucket `payment_proofs`
  - Updates `bookings.payment_proof_url` and `payment_status`

File: `booking_time_slot_datasource.dart`
- Availability checks using RPC:
  - `is_time_slot_available`
- Consecutive slot checks:
  - Queries `bookings` table directly by date/start time/status

## D) Complex Queries & Analytics

Statistics / analytics:
- `lib/features/super_admin/data/datasources/super_admin_statistics_datasource.dart`
  - Reads from `platform_statistics` view
  - Calls `get_daily_revenue` RPC for 7-day trend chart
- `lib/features/super_admin/data/datasources/super_admin_remote_datasource.dart`
  - Also uses `platform_statistics` and daily revenue logic

Other complex logic:
- Reviews: `rpc('can_user_review_field')` for eligibility checks
- Business hours: RPC functions for validation and next opening time
- Recurring bookings: multiple RPC functions for approval workflows and slot
  reservation checks

## E) File Uploads

File: `lib/features/bookings/data/datasources/booking_user_operations_datasource.dart`
- Uploads payment proof images to Supabase Storage
- Bucket: `payment_proofs`
- Path: `payment_proofs/<userId>/<timestamp>_<filename>`
- Uses `storage.uploadBinary` and `storage.getPublicUrl`

## F) RPC Calls (Supabase)

RPC functions used by the Flutter app:
- `get_daily_revenue`
- `validate_booking_time`
- `is_field_open_at`
- `get_next_opening_time`
- `is_time_slot_available`
- `complete_passed_bookings`
- `can_user_review_field`
- `get_unread_notification_count`
- `mark_notifications_read`
- `mark_all_notifications_read`
- `create_recurring_booking_request`
- `cancel_recurring_booking`
- `get_my_recurring_bookings`
- `approve_recurring_booking`
- `reject_recurring_booking`
- `get_pending_recurring_requests`
- `get_active_recurring_bookings_for_owner`
- `is_slot_reserved_recurring`
- `get_reserved_recurring_slots`

## SQL Functions and Triggers

Files and highlights:

- `DATABASE_FUNCTIONS.sql`
  - `get_daily_revenue(days_back)`

- `supabase/auto_complete_bookings.sql`
  - Trigger: `validate_booking_date_trigger` on INSERT
  - Function: `validate_booking_date_on_insert`
  - Function: `complete_passed_bookings` (RPC)

- `supabase/migrations/20251213_booking_notification_trigger.sql`
  - Function: `notify_field_owner_on_booking` (trigger on booking INSERT)
  - Function: `notify_owner_on_payment_upload` (trigger on booking UPDATE)
  - Trigger: `trigger_notify_owner_new_booking`
  - Trigger: `trigger_notify_owner_payment_upload`
  - Functions: `get_unread_notification_count`,
    `mark_notifications_read`, `mark_all_notifications_read`

- `database_business_hours_schema.sql`
  - Trigger: `trigger_update_business_hours_updated_at`
  - Function: `update_business_hours_updated_at`
  - Functions: `get_field_business_hours`,
    `is_field_open_at`, `get_next_opening_time`

- `database_reviews_schema.sql`
  - Trigger: `trigger_update_reviews_updated_at`
  - Function: `update_reviews_updated_at`
  - Function: `update_field_review_stats`
  - Triggers: `after_review_insert`, `after_review_update`,
    `after_review_delete`

- `supabase/migrations/20251217_recurring_bookings.sql`
  - Trigger: `set_recurring_updated_at`
  - Function: `update_recurring_updated_at`
  - Recurring booking RPC functions (see RPC list above)

## Background Jobs and Scheduled Tasks

Current state:
- No cron scheduler is defined in the repo.
- The app calls `complete_passed_bookings` via RPC from
  `booking_admin_operations_datasource.dart`. This is manual and not scheduled.

Implications:
- If you move to a custom API, you will need a job runner (Cron, Celery, Hangfire,
  BullMQ, etc.) for:
  - Auto-completing bookings after end time
  - Recurring booking generation (if needed)
  - Notification dispatch (if you want push/email schedules)

Email notifications:
- No email jobs are defined in the repo.
- Notification system currently relies on DB inserts + realtime streams.
