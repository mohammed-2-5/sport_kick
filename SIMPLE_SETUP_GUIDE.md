# 🚀 Simple Setup Guide (3 Easy Steps)

## Your Database Status

✅ You already have these tables:
- `profiles` table exists
- `fields` table exists
- `bookings` table exists
- `user_bookings_with_details` view exists

**We just need to:**
1. Add `role` column to profiles
2. Add `owner_id` column to fields
3. Set admin roles

---

## Step 1: Run This SQL (In Supabase SQL Editor)

```sql
-- Copy and paste this entire script:
```

**Run:** `supabase/01_CREATE_TABLES_FIXED.sql`

**What it does:**
- ✅ Adds `role` column to profiles (if missing)
- ✅ Adds `owner_id` column to fields (if missing)
- ✅ Recreates the view (fixes the error)
- ✅ Adds indexes for performance
- ✅ Shows success message

**Expected output:**
```
✅ profiles table has role column
✅ fields table has owner_id column
========================================
TABLES SETUP COMPLETE!
========================================
```

---

## Step 2: Create Auth Accounts

**Go to:** Supabase Dashboard → Authentication → Users

**Click:** "Add User" button

**Create these 2 accounts:**

### Account 1: Admin
- Email: `admin@spokick.com`
- Password: `Admin123!`
- Auto Confirm Email: ✅ **Check this box**
- Click: **Create User**

### Account 2: Regular User
- Email: `user@spokick.com`
- Password: `User123!`
- Auto Confirm Email: ✅ **Check this box**
- Click: **Create User**

---

## Step 3: Login Once to Create Profiles

**Important:** Each user needs to login once to create their profile in the database.

```bash
flutter run
```

1. **Login with admin account:**
   - Email: `admin@spokick.com`
   - Password: `Admin123!`
   - Click Login
   - Then **Logout**

2. **Login with user account:**
   - Email: `user@spokick.com`
   - Password: `User123!`
   - Click Login
   - Then **Logout**

This creates profile entries in the database.

---

## Step 4: Set Admin Role (Run SQL)

Now run this SQL to make admin@spokick.com an admin:

```sql
-- Set admin role
UPDATE profiles
SET role = 'admin', full_name = 'Admin User'
WHERE email = 'admin@spokick.com';

-- Set user role
UPDATE profiles
SET role = 'user', full_name = 'Regular User'
WHERE email = 'user@spokick.com';

-- Assign all fields to admin
UPDATE fields
SET owner_id = (SELECT id FROM profiles WHERE email = 'admin@spokick.com')
WHERE owner_id IS NULL;

-- Verify
SELECT email, full_name, role FROM profiles;
```

**Expected output:**
```
email                  | full_name      | role
-----------------------|----------------|-------
admin@spokick.com      | Admin User     | admin
user@spokick.com       | Regular User   | user
```

---

## Step 5: Setup Security (Run SQL)

**Run:** `supabase/02_SETUP_RLS.sql`

This creates security policies so users can only see their own data.

---

## ✅ You're Done! Test It

```bash
flutter run
```

1. **On login screen:**
   - Click **"Login as Admin"** button (it turns green)

2. **Enter admin credentials:**
   - Email: `admin@spokick.com`
   - Password: `Admin123!`

3. **Click Login**

4. **Expected Result:**
   - ✅ You see **Owner Dashboard**
   - ✅ You see statistics
   - ✅ You see bookings (if any)
   - ✅ You can manage bookings

---

## 🎯 Quick Test

After setup, verify everything works:

### Test 1: Admin Login
- Select "Login as Admin"
- Use `admin@spokick.com`
- Should see: Owner Dashboard ✅

### Test 2: User Login
- Select "Login as User"
- Use `user@spokick.com`
- Should see: Home Page ✅

### Test 3: Wrong Permission
- Select "Login as Admin"
- Use `user@spokick.com` (not an admin!)
- Should see: Error message + redirected to Home ❌

---

## 🚨 Common Issues

### Issue: "relation 'profiles' does not exist"
You skipped Step 1. Run `01_CREATE_TABLES_FIXED.sql`

### Issue: "cannot drop columns from view"
The old script had this bug. Use `01_CREATE_TABLES_FIXED.sql` instead.

### Issue: "User not found" when setting role
You didn't login once with that email. Go to Step 3.

### Issue: No bookings showing
Run this to assign fields to admin:
```sql
UPDATE fields
SET owner_id = (SELECT id FROM profiles WHERE email = 'admin@spokick.com');
```

### Issue: "Access Denied" when logging as admin
Check the role:
```sql
SELECT email, role FROM profiles WHERE email = 'admin@spokick.com';
```
If role is not 'admin', run:
```sql
UPDATE profiles SET role = 'admin' WHERE email = 'admin@spokick.com';
```

---

## 📝 Summary

**5 Simple Steps:**
1. ✅ Run `01_CREATE_TABLES_FIXED.sql` - Adds columns
2. ✅ Create auth accounts in Supabase Dashboard
3. ✅ Login once with each account (creates profiles)
4. ✅ Run SQL to set admin role
5. ✅ Run `02_SETUP_RLS.sql` - Setup security

**Test Accounts:**
- Admin: `admin@spokick.com` / `Admin123!`
- User: `user@spokick.com` / `User123!`

**That's it!** 🎉

---

## ⚡ Even Simpler (If You're Brave)

Run ALL of this in one go (after creating auth accounts and logging in once):

```sql
-- 1. Add columns (from 01_CREATE_TABLES_FIXED.sql)
-- [Copy entire content of that file]

-- 2. Set roles
UPDATE profiles SET role = 'admin' WHERE email = 'admin@spokick.com';
UPDATE profiles SET role = 'user' WHERE email = 'user@spokick.com';
UPDATE fields SET owner_id = (SELECT id FROM profiles WHERE email = 'admin@spokick.com');

-- 3. Setup security (from 02_SETUP_RLS.sql)
-- [Copy entire content of that file]

-- 4. Verify
SELECT email, role FROM profiles;
```

Done! 🚀
