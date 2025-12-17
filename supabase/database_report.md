# Sport Kick Database Report

**Generated**: December 13, 2025  
**Database**: Supabase PostgreSQL  
**Environment**: Development

---

## 📊 Schema Overview

| Metric | Count |
|--------|:-----:|
| Tables | 12 |
| Views | 3 |
| Foreign Keys | 16 |
| Triggers | 15 |
| Functions | 23 |
| RLS Policies | 44 |
| Indexes | 65+ |

---

## 📋 Tables

| Table | Description | RLS |
|-------|-------------|:---:|
| `profiles` | User accounts (linked to auth.users) | ✅ |
| `fields` | Sports venues/fields | ✅ |
| `bookings` | Reservation records | ✅ |
| `reviews` | User ratings & feedback | ✅ |
| `business_hours` | Field operating hours | ✅ |
| `cities` | Location data | ✅ |
| `sport_categories` | Sport types | ✅ |
| `admin_field_assignments` | Admin-to-field links | ✅ |
| `admin_invitations` | Admin onboarding | ✅ |
| `login_activity` | Security tracking | ✅ |
| `platform_settings` | App configuration | ✅ |
| `user_fcm_tokens` | Push notification tokens | ✅ |

---

## 🔗 Relationships

```
profiles ──┬── fields (owner_id)
           ├── bookings (user_id)
           ├── reviews (user_id)
           └── admin_assignments (admin_id)

fields ────┬── bookings (field_id) [CASCADE]
           ├── reviews (field_id) [CASCADE]
           ├── business_hours (field_id) [CASCADE]
           └── admin_assignments (field_id)

cities ────┬── fields (city_id) [RESTRICT]
           └── profiles (selected_city_id) [SET NULL]

sport_categories ── fields (sport_category_id) [SET NULL]

bookings ── reviews (booking_id) [SET NULL]
```

---

## ⚙️ Triggers

| Trigger | Table | Event | Action |
|---------|-------|-------|--------|
| `trigger_set_invoice_number` | bookings | BEFORE INSERT | Auto-generate invoice |
| `trigger_update_field_booking_stats` | bookings | AFTER INSERT/UPDATE/DELETE | Update field stats |
| `trigger_update_city_fields_count` | fields | AFTER INSERT/UPDATE/DELETE | Update city count |
| `trigger_update_field_sport_type` | fields | BEFORE INSERT/UPDATE | Sync sport type |
| `after_review_insert` | reviews | AFTER INSERT | Update field rating |
| `after_review_update` | reviews | AFTER UPDATE | Recalculate rating |
| `after_review_delete` | reviews | AFTER DELETE | Recalculate rating |
| `trigger_update_*_updated_at` | various | BEFORE UPDATE | Auto-timestamp |

---

## 🔐 RLS Policies Summary

### User Role
- View active fields only
- Create/view own bookings (non-manual)
- Write reviews for completed bookings

### Admin Role
- View/update own fields
- View/update field bookings
- Create manual bookings

### Super Admin Role
- Full access to all tables
- Manage users, cities, categories
- Platform settings control

---

## 📈 Database Functions

| Function | Purpose |
|----------|---------|
| `handle_new_user()` | Create profile on signup |
| `generate_invoice_number()` | Create unique invoice IDs |
| `can_user_review_field()` | Validate review eligibility |
| `update_field_review_stats()` | Calculate average ratings |
| `get_field_business_hours()` | Fetch operating hours |
| `is_field_open_at()` | Check availability |
| `get_daily_revenue()` | Analytics query |
| `get_current_user_role()` | Auth helper |

---

## 📊 Current Data

| Table | Rows |
|-------|:----:|
| fields | 12 |
| bookings | 6 |
| business_hours | 7 |
| profiles | 4 |
| cities | 4 |
| sport_categories | 5 |
| login_activity | 5 |
| platform_settings | 2 |
| admin_invitations | 2 |
| reviews | 0 |
| user_fcm_tokens | 0 |
| admin_field_assignments | 0 |
