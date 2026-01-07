# Spo Kick Backend Review and Migration Notes

This report summarizes the app domain, current Supabase usage, and what changes
are required to move to a custom API backend. It also compares backend
frameworks with a focus on performance, ease of learning, maintainability, and
deployment.

## App Overview (from codebase and SQL schema)

Spo Kick is a multi-role sports facility booking platform with three roles:
- Super admin: platform owner with full control
- Admin: field owner/manager
- User: customer who browses and books fields

Core features present in the schema and data layer:
- User accounts with roles, profiles, activation status, and selected city
- Cities and sport categories
- Fields/facilities with location, pricing, media, amenities, and surface details
- Bookings with status, manual bookings, payment proof, and verification flows
- Business hours and availability checks
- Recurring booking requests and approval workflow
- Reviews with user data enrichment and rating aggregation
- Notifications, unread counters, and realtime updates
- Platform statistics and revenue reporting
- Admin invitations and field assignment audit trail
- FCM token storage for push notifications

## Feature Areas and Workflows

- Auth and profiles: sign in/up, profile updates, password changes, role checks
- City selection: users choose a city to filter available fields
- Field discovery: search and filters by city, sport, price, amenities, rating
- Field management: owners/super admins create and update field data
- Booking flow: create, confirm, cancel, and complete bookings
- Manual bookings: owners can create walk-in bookings for their fields
- Payment proof: upload, verify, reject with reason
- Business hours: open/close times, day-based availability
- Recurring bookings: request, approve/reject, cancel, reserved slots
- Reviews: only after completed bookings, update field rating stats
- Notifications: insert, read, bulk read, realtime updates
- Analytics: admin and platform dashboards, daily revenue trends
- Platform settings: update global settings from super admin
- Audit logs: login activity and admin actions

## Data Model Highlights

Primary tables and views implied by SQL and data sources:
- profiles, cities, sport_categories, fields, bookings
- admin_invitations, admin_field_assignments
- business_hours, recurring_bookings, reviews, notifications
- user_fcm_tokens, platform_settings, login_activity
- Views: user_bookings_with_details, admin_statistics, platform_statistics

Important data constraints:
- Role and status checks in profiles and bookings
- Unique constraints for recurring slots and business hours per day
- Rating and time range validation at the DB level
- Trigger-based updates for review stats and timestamps

## Current Backend: Supabase + Postgres

The app uses Supabase directly from Flutter:
- Supabase Auth for sign-in/sign-up, sessions, and roles
- Postgres tables for core data (profiles, fields, bookings, cities, etc.)
- Row Level Security (RLS) for access control
- RPC functions for complex logic (availability checks, recurring bookings)
- Views for optimized reads (user bookings with details, platform statistics)
- Storage for payment proof uploads
- Realtime channels for notifications

Key SQL assets:
- `supabase/02_FRESH_SCHEMA.sql` (tables, constraints, views)
- `supabase/03_INITIALIZE_DATA.sql` (RLS policies, seed data)
- `supabase/migrations/*.sql` (recurring bookings, payment updates, triggers)
- `DATABASE_FUNCTIONS.sql` (daily revenue function)
- `supabase/auto_complete_bookings.sql`, `supabase/update_bookings_view.sql`

## Migration Impact (Supabase -> Custom API)

### What must be re-implemented in the API
- Auth and role-based access (replaces Supabase Auth + RLS)
- SQL view outputs or equivalent endpoints:
  - `user_bookings_with_details`
  - `platform_statistics`
- RPC logic used by the app:
  - Booking availability checks
  - Business hours validations
  - Recurring booking workflows
  - Notifications bulk updates and counters
  - Review eligibility checks
  - Daily revenue analytics
- Storage layer for payment proofs (S3/GCS/etc.)
- Background jobs (auto-complete bookings, notifications)

### Data Sources to replace (Supabase SDK calls)
All remote data sources under `lib/features/**/data/datasources/` that call
`SupabaseClient` must be swapped to use an API client. This includes:
- Auth, bookings, fields, cities, reviews, business hours
- Recurring bookings and notification flows
- Super admin management and platform settings

### Repositories
Repository implementations mostly remain, but error mapping must change from
PostgREST errors to HTTP/API error codes.

## Backend Framework Comparison (Focus on your app)

Below is a comparison between the two best fits we discussed.

### NestJS (Node/TypeScript)
Pros:
- Strong architecture for large domains
- Clean role-based guards and DI
- Good performance and websocket support
Cons:
- Requires learning DI/decorator patterns
- Slightly longer initial setup
Fit:
- Excellent for a medium to complex mobile backend
- Great long-term maintainability with TypeScript

### Django + DRF (Python)
Pros:
- Fastest to build
- Best built-in admin panel
- Mature ORM and permissions
Cons:
- Heavier stack, less raw performance under high concurrency
Fit:
- Excellent if you want rapid delivery and a strong admin UI

## Quick Decision Guide

If your priority is:
- Fastest delivery + admin panel: Django + DRF
- Strong structure + TypeScript safety + realtime: NestJS

Both are stable and scalable for this system. NestJS usually wins for long-term
maintainability in large codebases, while Django wins for speed to production.

## Notes on Deployment

Both stacks are easy to deploy with Docker:
- API service
- Database (Postgres)
- Background worker (Celery for Django, BullMQ for NestJS)
- Object storage for uploads (S3-compatible)

Free or low-cost hosting options include Render, Railway, Fly.io, and Oracle
Cloud Always Free.

## Recommendation

If you want the fastest path to a working backend with minimal effort, choose
**Django + DRF**. If you want a highly structured and scalable API that aligns
with your Flutter + strong-typing workflow, choose **NestJS**.
