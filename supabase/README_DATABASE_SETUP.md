# 🗄️ Sport Kick Database Setup Guide

**Version:** 2.0 - Fresh Start
**Date:** November 24, 2025
**Status:** Ready to Deploy

---

## ⚠️ IMPORTANT WARNING

**This setup will DELETE ALL existing data in your Supabase database!**

Make sure you:
1. Have backed up any important data
2. Are ready for a fresh start
3. Understand this is IRREVERSIBLE

---

## 📋 Quick Overview

This database supports 3 distinct roles:

1. **Super Admin** (Platform Owner)
   - Email: `superadmin252001@sportkick.com`
   - Password: `My252001#`
   - Full platform control

2. **Admin** (Field Owner)
   - Created by super admin
   - Manages assigned fields
   - Creates manual bookings

3. **User** (Customer)
   - Selects city
   - Books fields
   - Manages bookings

---

## 🚀 Step-by-Step Setup

### Step 1: Safety Check (5 minutes)

**Open Supabase SQL Editor and run:**
```sql
-- File: 00_SAFETY_BACKUP.sql
```

**What it does:**
- Shows all existing tables
- Shows row counts
- Lists all policies
- Gives you a final warning

**Review the output carefully!** Make sure you're okay with deleting all this data.

---

### Step 2: Clean Slate (2 minutes)

**⚠️ POINT OF NO RETURN ⚠️**

**Run in Supabase SQL Editor:**
```sql
-- File: 01_CLEAN_DROP_ALL.sql
```

**What it does:**
- Drops all policies
- Drops all views
- Drops all tables
- Drops all functions
- Drops all triggers

**Expected output:**
```
✅ DATABASE COMPLETELY CLEAN!
✅ Ready to run 02_FRESH_SCHEMA.sql
```

**If you see any errors:** Stop and investigate before proceeding.

---

### Step 3: Create Fresh Schema (5 minutes)

**Run in Supabase SQL Editor:**
```sql
-- File: 02_FRESH_SCHEMA.sql
```

**What it does:**
- Creates 7 core tables:
  1. `profiles` - User accounts (all roles)
  2. `cities` - Supported cities (Minya, Mallawi, New Minya, Assiut)
  3. `sport_categories` - Sports types
  4. `fields` - Football fields
  5. `bookings` - Reservations (with manual booking support)
  6. `admin_invitations` - Admin creation tracking
  7. `admin_field_assignments` - Audit trail

- Creates 3 views:
  1. `user_bookings_with_details` - Complete booking info
  2. `admin_statistics` - Per-admin stats
  3. `platform_statistics` - Platform-wide stats

- Adds indexes for performance
- Adds constraints for data integrity

**Expected output:**
```
✅ FRESH SCHEMA CREATED SUCCESSFULLY!
📝 Next Step: Run 03_INITIALIZE_DATA.sql
```

---

### Step 4: Initialize Security & Data (5 minutes)

**Run in Supabase SQL Editor:**
```sql
-- File: 03_INITIALIZE_DATA.sql
```

**What it does:**
- Enables Row Level Security (RLS) on all tables
- Creates security policies for each role
- Inserts cities:
  - Minya
  - Mallawi
  - New Minya
  - Assiut
- Inserts sport categories:
  - Football
  - Basketball
  - Tennis
  - Volleyball
  - Padel

**Expected output:**
```
✅ INITIALIZATION COMPLETE!
✅ RLS enabled on all tables
✅ XX policies created
✅ 4 cities added
✅ 5 sport categories added
```

---

### Step 5: Create Super Admin Account (3 minutes)

**5.1: Create Auth User**

1. Go to **Supabase Dashboard** → **Authentication** → **Users**
2. Click **"Add User"**
3. Fill in:
   - **Email:** `superadmin252001@sportkick.com`
   - **Password:** `My252001#`
   - **Auto Confirm Email:** ✅ **YES** (IMPORTANT!)
4. Click **"Create User"**
5. **Copy the User ID** (UUID) - You'll need this!

**5.2: Create Profile Entry**

1. Open **Supabase SQL Editor**
2. Run this query (replace `YOUR-USER-ID-HERE` with the UUID from step 5.1):

```sql
INSERT INTO profiles (id, email, full_name, role, is_active, password_changed)
VALUES (
  'YOUR-USER-ID-HERE'::uuid, -- ← REPLACE THIS!
  'superadmin252001@sportkick.com',
  'Super Admin',
  'super_admin',
  true,
  true
)
ON CONFLICT (id) DO UPDATE SET
  role = 'super_admin',
  is_active = true;
```

**Example:**
```sql
INSERT INTO profiles (id, email, full_name, role, is_active, password_changed)
VALUES (
  '123e4567-e89b-12d3-a456-426614174000'::uuid,
  'superadmin252001@sportkick.com',
  'Super Admin',
  'super_admin',
  true,
  true
);
```

**Expected output:**
```
INSERT 0 1
```

---

### Step 6: Verify Setup (5 minutes)

**Run these verification queries:**

**6.1: Check Tables**
```sql
SELECT tablename FROM pg_tables WHERE schemaname = 'public' ORDER BY tablename;
```

**Expected:** 7 tables (profiles, cities, sport_categories, fields, bookings, admin_invitations, admin_field_assignments)

**6.2: Check Cities**
```sql
SELECT * FROM cities ORDER BY name;
```

**Expected:** 4 cities (Assiut, Mallawi, Minya, New Minya)

**6.3: Check Super Admin**
```sql
SELECT id, email, full_name, role, is_active FROM profiles WHERE role = 'super_admin';
```

**Expected:** 1 row with your super admin account

**6.4: Check Policies**
```sql
SELECT COUNT(*) as total_policies FROM pg_policies WHERE schemaname = 'public';
```

**Expected:** 20+ policies

**6.5: Test Platform Statistics**
```sql
SELECT * FROM platform_statistics;
```

**Expected:** Should return platform stats (all zeros for now since no data yet)

---

## ✅ Success Checklist

- [ ] Ran `00_SAFETY_BACKUP.sql` and reviewed output
- [ ] Ran `01_CLEAN_DROP_ALL.sql` and saw "DATABASE COMPLETELY CLEAN"
- [ ] Ran `02_FRESH_SCHEMA.sql` and saw "FRESH SCHEMA CREATED"
- [ ] Ran `03_INITIALIZE_DATA.sql` and saw "INITIALIZATION COMPLETE"
- [ ] Created super admin in Supabase Auth
- [ ] Inserted super admin profile with correct User ID
- [ ] Verified 7 tables exist
- [ ] Verified 4 cities exist
- [ ] Verified super admin profile exists
- [ ] Verified RLS policies exist

---

## 🧪 Test the Setup

### Test 1: Login as Super Admin

1. Run Flutter app: `flutter run`
2. On login screen:
   - Email: `superadmin252001@sportkick.com`
   - Password: `My252001#`
   - Click **Login**
3. **Expected:** Navigate to Super Admin Dashboard
4. **Expected:** See platform statistics (users, fields, bookings)

### Test 2: Platform Statistics

Should see:
- Total Users: 0
- Total Admins: 0
- Active Fields: 0
- Total Bookings: 0
- Active Cities: 4

### Test 3: Create Admin (Optional)

1. In super admin dashboard, click **"Create Admin"**
2. Fill in details
3. Should generate default password
4. Should see admin in admins list

---

## 🗂️ Database Schema Summary

### Tables

| Table | Purpose | Key Columns |
|-------|---------|-------------|
| **profiles** | All user accounts | id, email, role, selected_city_id |
| **cities** | Supported cities | id, name, fields_count |
| **sport_categories** | Sports types | id, name, icon |
| **fields** | Football fields | id, owner_id, city_id, price_per_hour |
| **bookings** | Reservations | id, field_id, user_id, is_manual, customer_name |
| **admin_invitations** | Admin creation log | id, email, created_by, status |
| **admin_field_assignments** | Field ownership audit | id, admin_id, field_id, assigned_by |

### Views

| View | Purpose | Users |
|------|---------|-------|
| **user_bookings_with_details** | Complete booking info | Users, Admins |
| **admin_statistics** | Per-admin metrics | Admins |
| **platform_statistics** | Platform-wide metrics | Super Admin |

---

## 🔐 Security (RLS Policies)

### Super Admin
- ✅ Can view/edit ALL data
- ✅ Can create admins
- ✅ Can assign fields
- ✅ Can override any booking

### Admin
- ✅ Can view/edit their assigned fields
- ✅ Can view bookings for their fields
- ✅ Can approve/reject bookings
- ✅ Can create manual bookings
- ❌ Cannot see other admins' data

### User
- ✅ Can view active fields in selected city
- ✅ Can create bookings
- ✅ Can view/cancel their own bookings
- ❌ Cannot see other users' data

---

## 🐛 Troubleshooting

### Error: "relation does not exist"

**Problem:** Table not created

**Solution:**
1. Check if `02_FRESH_SCHEMA.sql` ran successfully
2. Look for error messages in SQL output
3. Run schema script again

### Error: "permission denied"

**Problem:** RLS policy blocking access

**Solution:**
1. Check if `03_INITIALIZE_DATA.sql` ran successfully
2. Verify user role is correct:
   ```sql
   SELECT id, email, role FROM profiles WHERE email = 'your-email@example.com';
   ```
3. Check policies:
   ```sql
   SELECT * FROM pg_policies WHERE tablename = 'your_table_name';
   ```

### Error: "duplicate key value"

**Problem:** Trying to insert data that already exists

**Solution:**
- Check if initialization script was run multiple times
- This is usually safe to ignore

### Super Admin Can't Login

**Checklist:**
1. Auth user created? Check Supabase Dashboard → Auth
2. Profile entry created? Run:
   ```sql
   SELECT * FROM profiles WHERE email = 'superadmin252001@sportkick.com';
   ```
3. Role is 'super_admin'?
4. is_active is true?

---

## 📊 Data Examples

### Cities
```
Minya
Mallawi
New Minya
Assiut
```

### Sport Categories
```
Football (⚽)
Basketball (🏀)
Tennis (🎾)
Volleyball (🏐)
Padel (🎾)
```

---

## 🔄 If You Need to Start Over

1. Run `01_CLEAN_DROP_ALL.sql` again
2. Run `02_FRESH_SCHEMA.sql`
3. Run `03_INITIALIZE_DATA.sql`
4. Recreate super admin account

**Note:** You'll need to recreate the auth user in Supabase Dashboard each time.

---

## 📝 Next Steps After Setup

1. **Login as super admin** and explore dashboard
2. **Create first admin account** (field owner)
3. **Create first field** and assign to admin
4. **Create test user** and make a booking
5. **Test the entire flow**

---

## 🎯 Quick Reference

**Super Admin:**
- Email: `superadmin252001@sportkick.com`
- Password: `My252001#`

**Database Files (run in order):**
1. `00_SAFETY_BACKUP.sql` - Check before deletion
2. `01_CLEAN_DROP_ALL.sql` - Delete everything
3. `02_FRESH_SCHEMA.sql` - Create tables
4. `03_INITIALIZE_DATA.sql` - Add security & data

**Cities:**
- Minya, Mallawi, New Minya, Assiut

---

**Setup Time:** ~20-30 minutes
**Difficulty:** Medium
**Risk:** High (deletes all data)
**Reversible:** No (make backups!)

**Good luck! 🚀**
