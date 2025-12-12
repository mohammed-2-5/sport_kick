# 📊 Database Deployment Guide - Business Hours & Reviews

**Date:** 2025-12-06
**Status:** Ready for Deployment
**Tables:** `business_hours`, `reviews`

---

## ✅ SCHEMAS ARE COMPLETE!

Both database schemas are **production-ready** and include:
- ✅ Table structures with proper constraints
- ✅ Indexes for performance optimization
- ✅ Row Level Security (RLS) policies
- ✅ Auto-update triggers
- ✅ Helper functions for common operations
- ✅ Validation functions
- ✅ Comprehensive comments and documentation

---

## 🚀 DEPLOYMENT STEPS

### Step 1: Open Supabase SQL Editor

1. Go to [https://supabase.com](https://supabase.com)
2. Select your **Sport Kick** project
3. Navigate to **SQL Editor** in the left sidebar
4. Click **New Query**

---

### Step 2: Deploy Business Hours Schema

**File:** `database_business_hours_schema.sql`

1. **Copy the entire contents** of `database_business_hours_schema.sql`
2. **Paste into Supabase SQL Editor**
3. **Click "Run"** (or press Ctrl+Enter)
4. **Verify success:**
   - You should see: "Success. No rows returned"
   - Or check the "Logs" tab for any errors

**What This Creates:**
- ✅ `business_hours` table
- ✅ 3 performance indexes
- ✅ Auto-update trigger for `updated_at`
- ✅ 3 RLS policies (view all, owners manage, admins full access)
- ✅ 5 helper functions:
  - `get_field_business_hours(field_id)` - Get hours for a field
  - `is_field_open_at(field_id, day, time)` - Check if open
  - `get_next_opening_time(field_id, timestamp)` - Find next opening
  - `initialize_default_business_hours(field_id)` - Set 24/7 hours
  - `validate_booking_time(field_id, timestamp)` - Validate booking

---

### Step 3: Deploy Reviews Schema

**File:** `database_reviews_schema.sql`

1. **Copy the entire contents** of `database_reviews_schema.sql`
2. **Paste into Supabase SQL Editor**
3. **Click "Run"** (or press Ctrl+Enter)
4. **Verify success:**
   - You should see: "Success. No rows returned"
   - Or check the "Logs" tab for any errors

**What This Creates:**
- ✅ `reviews` table
- ✅ 5 performance indexes
- ✅ Auto-update trigger for `updated_at`
- ✅ Auto-update triggers for field statistics (average_rating, total_reviews)
- ✅ 5 RLS policies (view all, users CRUD own reviews, admins full access)
- ✅ 3 helper functions:
  - `update_field_review_stats(field_id)` - Recalculate field ratings
  - `get_field_reviews(field_id, limit, offset)` - Get reviews with pagination
  - `can_user_review_field(user_id, field_id, booking_id)` - Check review eligibility
  - `get_user_field_review(user_id, field_id)` - Get user's review

---

### Step 4: Verify Tables Were Created

#### Using Supabase Dashboard:

1. Go to **Table Editor** in the left sidebar
2. You should see two new tables:
   - `business_hours`
   - `reviews`
3. Click on each table to inspect columns

#### Using SQL Query:

Run this query in SQL Editor:
```sql
-- Check if tables exist
SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'public'
AND table_name IN ('business_hours', 'reviews');
```

Expected output:
```
table_name
-----------------
business_hours
reviews
```

---

### Step 5: Verify RLS Policies

Run this query to check RLS policies:
```sql
-- Check RLS policies for business_hours
SELECT schemaname, tablename, policyname, permissive, roles, cmd, qual
FROM pg_policies
WHERE tablename = 'business_hours';

-- Check RLS policies for reviews
SELECT schemaname, tablename, policyname, permissive, roles, cmd, qual
FROM pg_policies
WHERE tablename = 'reviews';
```

**Expected for business_hours:**
- "Anyone can view business hours" (SELECT)
- "Field owners can manage their business hours" (ALL)
- "Super admins have full access to business hours" (ALL)

**Expected for reviews:**
- "Reviews are viewable by everyone" (SELECT)
- "Users can create reviews for their bookings" (INSERT)
- "Users can update their own reviews" (UPDATE)
- "Users can delete their own reviews" (DELETE)
- "Super admins have full access to reviews" (ALL)

---

### Step 6: Verify Functions Were Created

Run this query to check functions:
```sql
-- Check business_hours functions
SELECT routine_name, routine_type
FROM information_schema.routines
WHERE routine_schema = 'public'
AND routine_name LIKE '%business_hours%'
OR routine_name LIKE '%field_open%'
OR routine_name LIKE '%opening_time%';

-- Check reviews functions
SELECT routine_name, routine_type
FROM information_schema.routines
WHERE routine_schema = 'public'
AND routine_name LIKE '%review%';
```

---

### Step 7: Test the Setup

#### Test 1: Insert Business Hours for a Field

```sql
-- Get a field ID (replace with your actual field ID)
SELECT id, name FROM fields LIMIT 1;

-- Insert test business hours (9 AM - 10 PM, Monday-Friday)
INSERT INTO business_hours (field_id, day_of_week, is_open, opening_time, closing_time)
VALUES
  ('<your-field-id>', 1, true, '09:00:00', '22:00:00'), -- Monday
  ('<your-field-id>', 2, true, '09:00:00', '22:00:00'), -- Tuesday
  ('<your-field-id>', 3, true, '09:00:00', '22:00:00'), -- Wednesday
  ('<your-field-id>', 4, true, '09:00:00', '22:00:00'), -- Thursday
  ('<your-field-id>', 5, true, '09:00:00', '22:00:00'), -- Friday
  ('<your-field-id>', 6, false, NULL, NULL),             -- Saturday (closed)
  ('<your-field-id>', 0, false, NULL, NULL);             -- Sunday (closed)

-- Verify insert
SELECT * FROM business_hours WHERE field_id = '<your-field-id>';
```

#### Test 2: Test Business Hours Functions

```sql
-- Test is_field_open_at function
SELECT is_field_open_at(
  '<your-field-id>',  -- field_id
  1,                   -- Monday (1)
  '14:00:00'::TIME    -- 2 PM
);
-- Expected: true (field is open)

SELECT is_field_open_at(
  '<your-field-id>',  -- field_id
  6,                   -- Saturday (6)
  '14:00:00'::TIME    -- 2 PM
);
-- Expected: false (field is closed on Saturday)

-- Test get_field_business_hours function
SELECT * FROM get_field_business_hours('<your-field-id>');
```

#### Test 3: Insert a Test Review

```sql
-- Get required IDs
SELECT id FROM fields LIMIT 1;           -- Get a field_id
SELECT id FROM profiles LIMIT 1;         -- Get a user_id
SELECT id FROM bookings WHERE status = 'completed' LIMIT 1;  -- Get a booking_id

-- Insert test review
INSERT INTO reviews (field_id, user_id, booking_id, rating, comment)
VALUES (
  '<field-id>',
  '<user-id>',
  '<booking-id>',
  5,
  'Excellent field! Great experience.'
);

-- Verify the field statistics were auto-updated
SELECT id, name, average_rating, total_reviews
FROM fields
WHERE id = '<field-id>';
```

#### Test 4: Test Review Functions

```sql
-- Test get_field_reviews function
SELECT * FROM get_field_reviews('<your-field-id>', 10, 0);

-- Test can_user_review_field function
SELECT can_user_review_field(
  '<user-id>',
  '<field-id>',
  '<booking-id>'
);
```

---

## 📋 DATABASE SCHEMA DETAILS

### Business Hours Table Structure

```sql
business_hours
├─ id (UUID, PK)
├─ field_id (UUID, FK → fields.id, CASCADE DELETE)
├─ day_of_week (INTEGER, 0-6: 0=Sunday, 6=Saturday)
├─ is_open (BOOLEAN, default: true)
├─ opening_time (TIME, nullable)
├─ closing_time (TIME, nullable)
├─ created_at (TIMESTAMPTZ, auto)
└─ updated_at (TIMESTAMPTZ, auto-updated)

Constraints:
├─ UNIQUE (field_id, day_of_week)
└─ CHECK: If is_open=true, then times must be valid and opening < closing
```

### Reviews Table Structure

```sql
reviews
├─ id (UUID, PK)
├─ field_id (UUID, FK → fields.id, CASCADE DELETE)
├─ user_id (UUID, FK → profiles.id, CASCADE DELETE)
├─ booking_id (UUID, FK → bookings.id, SET NULL)
├─ rating (INTEGER, 1-5)
├─ comment (TEXT, nullable)
├─ created_at (TIMESTAMPTZ, auto)
└─ updated_at (TIMESTAMPTZ, auto-updated)

Constraints:
├─ UNIQUE (user_id, field_id, booking_id)
└─ CHECK: rating BETWEEN 1 AND 5
```

---

## 🔐 SECURITY (RLS Policies)

### Business Hours Policies:

| Policy | Users | Permissions | Condition |
|--------|-------|-------------|-----------|
| View | Everyone | SELECT | Always |
| Manage | Field Owners | INSERT, UPDATE, DELETE | Only their own fields |
| Full Access | Super Admins | ALL | Always |

### Reviews Policies:

| Policy | Users | Permissions | Condition |
|--------|-------|-------------|-----------|
| View | Authenticated | SELECT | Always |
| Create | Users | INSERT | Only for completed bookings |
| Update | Users | UPDATE | Only their own reviews |
| Delete | Users | DELETE | Only their own reviews |
| Full Access | Super Admins | ALL | Always |

---

## ⚙️ HELPER FUNCTIONS REFERENCE

### Business Hours Functions:

```sql
-- Get all business hours for a field
SELECT * FROM get_field_business_hours('<field-id>');

-- Check if field is open at specific time
SELECT is_field_open_at('<field-id>', 1, '15:00:00');  -- Monday 3 PM

-- Find next opening time
SELECT get_next_opening_time('<field-id>', NOW());

-- Initialize 24/7 hours for a new field
SELECT initialize_default_business_hours('<field-id>');

-- Validate a booking time
SELECT validate_booking_time('<field-id>', '2025-12-10 14:00:00');
```

### Review Functions:

```sql
-- Get reviews for a field (with pagination)
SELECT * FROM get_field_reviews('<field-id>', 10, 0);

-- Check if user can review
SELECT can_user_review_field('<user-id>', '<field-id>', '<booking-id>');

-- Get user's review for a field
SELECT * FROM get_user_field_review('<user-id>', '<field-id>');

-- Manually update field statistics (usually auto-updated)
SELECT update_field_review_stats('<field-id>');
```

---

## 🧪 TESTING CHECKLIST

After deployment, verify:

### Business Hours:
- [ ] Table exists in Supabase Table Editor
- [ ] Can insert hours for a field
- [ ] Can query hours using get_field_business_hours
- [ ] is_field_open_at function returns correct results
- [ ] RLS policies work (test as owner and regular user)
- [ ] Auto-update trigger works (updated_at changes on UPDATE)

### Reviews:
- [ ] Table exists in Supabase Table Editor
- [ ] Can insert a review
- [ ] Field statistics (average_rating, total_reviews) auto-update
- [ ] Can query reviews using get_field_reviews
- [ ] RLS policies work (can only update/delete own reviews)
- [ ] Auto-update triggers work

---

## 🚨 TROUBLESHOOTING

### Issue: "relation already exists"
**Solution:** Tables already exist. Either:
- Drop and recreate: `DROP TABLE business_hours CASCADE;` then re-run
- Or skip table creation, just run the functions/policies

### Issue: "column 'average_rating' does not exist in fields table"
**Solution:** Add missing columns to fields table:
```sql
ALTER TABLE fields
ADD COLUMN IF NOT EXISTS average_rating DECIMAL(3,2),
ADD COLUMN IF NOT EXISTS total_reviews INTEGER DEFAULT 0;
```

### Issue: RLS policies block all access
**Solution:** Check your auth context:
```sql
-- Check current user
SELECT auth.uid();

-- Temporarily disable RLS for testing (re-enable after!)
ALTER TABLE business_hours DISABLE ROW LEVEL SECURITY;
ALTER TABLE reviews DISABLE ROW LEVEL SECURITY;
```

### Issue: Functions not found
**Solution:** Verify functions were created:
```sql
\df+ get_field_business_hours
\df+ get_field_reviews
```

---

## 📊 MONITORING & MAINTENANCE

### Check table sizes:
```sql
SELECT
  schemaname,
  tablename,
  pg_size_pretty(pg_total_relation_size(schemaname||'.'||tablename)) AS size
FROM pg_tables
WHERE tablename IN ('business_hours', 'reviews')
ORDER BY pg_total_relation_size(schemaname||'.'||tablename) DESC;
```

### Check index usage:
```sql
SELECT
  schemaname,
  tablename,
  indexname,
  idx_scan,
  idx_tup_read,
  idx_tup_fetch
FROM pg_stat_user_indexes
WHERE tablename IN ('business_hours', 'reviews')
ORDER BY idx_scan DESC;
```

### Monitor review statistics accuracy:
```sql
-- Compare manual calculation with stored value
SELECT
  f.id,
  f.name,
  f.average_rating as stored_avg,
  ROUND(AVG(r.rating)::NUMERIC, 2) as calculated_avg,
  f.total_reviews as stored_count,
  COUNT(r.*) as calculated_count
FROM fields f
LEFT JOIN reviews r ON r.field_id = f.id
GROUP BY f.id, f.name, f.average_rating, f.total_reviews
HAVING f.average_rating != ROUND(AVG(r.rating)::NUMERIC, 2)
OR f.total_reviews != COUNT(r.*);
```

---

## ✅ POST-DEPLOYMENT CHECKLIST

- [ ] Both schemas deployed successfully
- [ ] Tables visible in Supabase Table Editor
- [ ] All RLS policies active
- [ ] All functions created and tested
- [ ] Test data inserted and verified
- [ ] Fields table has average_rating and total_reviews columns
- [ ] Flutter app can fetch business hours
- [ ] Flutter app can create/view reviews
- [ ] Field statistics auto-update when reviews added
- [ ] Business hours validation works in booking flow

---

## 📚 RELATED FILES

- **Business Hours Schema:** `database_business_hours_schema.sql`
- **Reviews Schema:** `database_reviews_schema.sql`
- **Integration Summary:** `BUSINESS_HOURS_REVIEWS_INTEGRATION_SUMMARY.md`
- **Project Status:** `PROJECT_STATUS.md`

---

**Deployment Status:** ✅ READY TO DEPLOY

**Last Updated:** 2025-12-06
**Next Step:** Deploy to Supabase following steps above
