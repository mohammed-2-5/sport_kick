# 🚀 Admin Login Setup Guide

## Complete step-by-step guide to set up and test admin login functionality

---

## 📋 Overview

This guide will help you:
1. ✅ Set up the database with 3 user roles
2. ✅ Create test admin accounts
3. ✅ Test the admin login flow
4. ✅ Access the owner dashboard

---

## 🎯 User Roles

The app now supports 3 roles:

| Role | Description | Access |
|------|-------------|--------|
| `user` | Regular customer who books fields | User app + My Bookings |
| `admin` | Field owner who manages bookings | Owner Dashboard (full access) |
| `super_admin` | Platform administrator | Owner Dashboard + All data |

---

## 🔧 Step 1: Database Setup

### 1.1 Run the SQL Setup Script

Navigate to Supabase SQL Editor and run this file:

```
supabase/SETUP_ADMIN_ROLES.sql
```

**What it does:**
- ✅ Adds `role` column to `users` table with CHECK constraint
- ✅ Adds `owner_id` to `fields` table
- ✅ Creates test users with different roles
- ✅ Creates test bookings
- ✅ Sets up Row Level Security (RLS) policies
- ✅ Creates indexes for performance

### 1.2 Create Auth Accounts

In Supabase Dashboard → Authentication → Users:

**Create these test accounts:**

1. **Admin Account**
   - Email: `admin@spokick.com`
   - Password: `Admin123!` (or your choice)
   - Confirm email: ✅ Yes

2. **Super Admin Account** (optional)
   - Email: `superadmin@spokick.com`
   - Password: `SuperAdmin123!`
   - Confirm email: ✅ Yes

3. **Regular User Account**
   - Email: `user@spokick.com`
   - Password: `User123!`
   - Confirm email: ✅ Yes

### 1.3 Link Auth to Database

After creating auth accounts, the SQL script should automatically update their roles. If not, run:

```sql
-- Set admin role
UPDATE users
SET role = 'admin', full_name = 'Admin User'
WHERE email = 'admin@spokick.com';

-- Set super_admin role
UPDATE users
SET role = 'super_admin', full_name = 'Super Admin'
WHERE email = 'superadmin@spokick.com';

-- Set user role
UPDATE users
SET role = 'user', full_name = 'Regular User'
WHERE email = 'user@spokick.com';
```

### 1.4 Verify Setup

Run this query to check everything:

```sql
SELECT
  email,
  full_name,
  role,
  created_at
FROM users
ORDER BY role;
```

Expected output:
```
email                    | full_name    | role         | created_at
-------------------------|--------------|--------------|-------------------
admin@spokick.com        | Admin User   | admin        | 2025-11-24...
superadmin@spokick.com   | Super Admin  | super_admin  | 2025-11-24...
user@spokick.com         | Regular User | user         | 2025-11-24...
```

---

## 📱 Step 2: Test the Login Flow

### 2.1 Launch the App

```bash
flutter run
```

### 2.2 Test Admin Login

1. **On the login screen**, you'll see two buttons:
   - 🟢 **Login as User** (default, green)
   - 🟠 **Login as Admin** (admin mode, orange)

2. **Click "Login as Admin"** button (it should highlight in green gradient)

3. **Enter admin credentials:**
   - Email: `admin@spokick.com`
   - Password: `Admin123!`

4. **Click "Login"**

5. **Expected Result:**
   - ✅ You should be redirected to **Owner Dashboard** (`/owner/dashboard`)
   - ✅ You should see statistics (Total Bookings, Pending, Fields, Revenue)
   - ✅ You should see quick action buttons
   - ✅ You should see recent bookings list

### 2.3 Test Regular User Login

1. **Logout** (if logged in)

2. **On login screen**, select **"Login as User"** button

3. **Enter user credentials:**
   - Email: `user@spokick.com`
   - Password: `User123!`

4. **Click "Login"**

5. **Expected Result:**
   - ✅ You should be redirected to **Home Page** (`/home`)
   - ✅ You should see fields list
   - ✅ You should NOT see owner dashboard

### 2.4 Test Invalid Admin Access

1. **On login screen**, select **"Login as Admin"**

2. **Enter regular user credentials:**
   - Email: `user@spokick.com`
   - Password: `User123!`

3. **Click "Login"**

4. **Expected Result:**
   - ❌ You should see an error message: "Access Denied: You don't have admin privileges"
   - ✅ You'll be redirected to Home Page (not owner dashboard)

---

## 🎨 Step 3: Explore Owner Dashboard

Once logged in as admin, you can:

### 3.1 Dashboard Overview
- View total bookings count
- View pending bookings count
- View total fields count
- View total revenue

### 3.2 Manage Bookings
Click **"Manage Bookings"** → you'll see:
- **ALL** tab - All bookings
- **PENDING** tab - Awaiting approval
- **CONFIRMED** tab - Approved bookings
- **CANCELED** tab - Rejected bookings

**Actions on Pending Bookings:**
- ✅ **Approve** - Changes status to `confirmed`, sets `confirmed_at` timestamp
- ❌ **Reject** - Changes status to `canceled`

### 3.3 Manage Fields
Click **"Manage Fields"** → you'll see:
- List of all fields owned by the admin
- ➕ **Add Field** button (floating action button)
- ✏️ **Edit** button on each field
- 🗑️ **Delete** button (not yet implemented)

### 3.4 Analytics
Click **"Analytics"** → you'll see:
- Revenue overview
- Booking statistics
- Performance metrics
- Top performing fields

---

## 🧪 Step 4: Test Booking Approval Flow

### 4.1 Create a Test Booking (as regular user)

1. **Login as regular user**
2. **Browse fields**
3. **Select a field**
4. **Book a time slot**
5. **Confirm booking** (status will be `pending`)

### 4.2 Approve the Booking (as admin)

1. **Logout and login as admin**
2. **Navigate to Owner Dashboard**
3. **Click "Manage Bookings"**
4. **Go to PENDING tab**
5. **Find the booking you created**
6. **Click "Approve" button**
7. **Confirm in dialog**

**Expected Result:**
- ✅ Booking status changes to `confirmed`
- ✅ `confirmed_at` timestamp is set
- ✅ Booking moves to CONFIRMED tab
- ✅ Success message appears

### 4.3 Verify as User

1. **Logout and login as regular user**
2. **Navigate to "My Bookings"**
3. **Check the booking status** - should show "Confirmed" badge in green

---

## 🔐 Security Features

### Row Level Security (RLS)

The SQL script sets up these policies:

1. **Admins can view bookings for their fields:**
   ```sql
   -- Only returns bookings where field.owner_id = current_user_id
   ```

2. **Admins can update booking status:**
   ```sql
   -- Only allows updates if user owns the field
   ```

3. **Super admins can see/update everything:**
   ```sql
   -- Super admin bypass for all operations
   ```

4. **Users can create bookings:**
   ```sql
   -- Any authenticated user can create bookings
   ```

---

## 📊 Database Schema

### Users Table
```sql
users (
  id UUID PRIMARY KEY,
  email TEXT UNIQUE NOT NULL,
  full_name TEXT,
  phone TEXT,
  role TEXT DEFAULT 'user' CHECK (role IN ('user', 'admin', 'super_admin')),
  avatar_url TEXT,
  preferred_sports TEXT[],
  created_at TIMESTAMP,
  updated_at TIMESTAMP
)
```

### Fields Table
```sql
fields (
  id UUID PRIMARY KEY,
  owner_id UUID REFERENCES users(id),  -- NEW
  name TEXT NOT NULL,
  address TEXT,
  city TEXT,
  price_per_hour NUMERIC,
  currency TEXT DEFAULT 'EGP',
  images TEXT[],
  -- other fields...
)
```

### Bookings Table
```sql
bookings (
  id UUID PRIMARY KEY,
  field_id UUID REFERENCES fields(id),
  user_id UUID REFERENCES users(id),
  booking_date DATE,
  start_time TIME,
  end_time TIME,
  status TEXT CHECK (status IN ('pending', 'confirmed', 'canceled', 'completed')),
  total_price NUMERIC,
  currency TEXT,
  confirmed_at TIMESTAMP,
  canceled_at TIMESTAMP,
  cancellation_reason TEXT,
  notes TEXT,
  created_at TIMESTAMP
)
```

---

## 🎯 Login Logic Flow

```
User clicks "Login as Admin"
       ↓
User enters email + password
       ↓
System authenticates via Supabase Auth
       ↓
System fetches user role from database
       ↓
Check: selectedMode == 'admin' AND user.role IN ('admin', 'super_admin')?
       ↓
   YES → Navigate to /owner/dashboard
       ↓
   NO → Show error + Navigate to /home
```

---

## 🚨 Troubleshooting

### Issue 1: "Access Denied" even with admin email

**Solution:**
```sql
-- Verify user role
SELECT email, role FROM users WHERE email = 'admin@spokick.com';

-- If role is 'user', update it:
UPDATE users SET role = 'admin' WHERE email = 'admin@spokick.com';
```

### Issue 2: No bookings showing in owner dashboard

**Solution:**
```sql
-- Check if fields have owner_id
SELECT id, name, owner_id FROM fields;

-- Assign fields to admin
UPDATE fields
SET owner_id = (SELECT id FROM users WHERE email = 'admin@spokick.com')
WHERE owner_id IS NULL;

-- Verify bookings exist
SELECT * FROM bookings WHERE field_id IN (
  SELECT id FROM fields WHERE owner_id = (
    SELECT id FROM users WHERE email = 'admin@spokick.com'
  )
);
```

### Issue 3: Login mode selector not showing

**Solution:**
- Clear app cache: `flutter clean && flutter pub get`
- Hot restart: `r` in terminal or `R` for hot reload
- Check if you're on the latest code

### Issue 4: Database permissions error

**Solution:**
- Check RLS policies are enabled
- Verify user is authenticated
- Check Supabase logs for details

---

## 📝 Quick Test Checklist

- [ ] SQL script executed successfully
- [ ] Test accounts created in Supabase Auth
- [ ] User roles set in database
- [ ] Fields assigned to admin
- [ ] Test bookings created
- [ ] App runs without errors
- [ ] Login screen shows mode selector
- [ ] Admin login redirects to owner dashboard
- [ ] User login redirects to home
- [ ] Booking approval works
- [ ] Dashboard shows correct statistics

---

## 🎓 Advanced Usage

### Make Existing User an Admin

```sql
UPDATE users
SET role = 'admin'
WHERE email = 'existing.user@example.com';
```

### Assign Multiple Fields to Admin

```sql
UPDATE fields
SET owner_id = (SELECT id FROM users WHERE email = 'admin@spokick.com')
WHERE id IN ('field-uuid-1', 'field-uuid-2', 'field-uuid-3');
```

### Create Bulk Test Bookings

```sql
DO $$
DECLARE
  admin_field UUID;
  test_user UUID;
BEGIN
  SELECT id INTO admin_field FROM fields WHERE owner_id = (
    SELECT id FROM users WHERE email = 'admin@spokick.com'
  ) LIMIT 1;

  SELECT id INTO test_user FROM users WHERE role = 'user' LIMIT 1;

  FOR i IN 1..10 LOOP
    INSERT INTO bookings (field_id, user_id, booking_date, start_time, end_time, status, total_price, currency)
    VALUES (
      admin_field,
      test_user,
      CURRENT_DATE + (i % 7),
      (10 + (i % 10))::TEXT || ':00:00',
      (11 + (i % 10))::TEXT || ':00:00',
      CASE WHEN i % 3 = 0 THEN 'pending' WHEN i % 3 = 1 THEN 'confirmed' ELSE 'canceled' END,
      200.0,
      'EGP'
    );
  END LOOP;
END $$;
```

---

## 📞 Support

If you encounter issues:
1. Check this guide first
2. Review `UPDATED_PLAN.md` for project status
3. Check Supabase logs for database errors
4. Run `flutter analyze` to check for code issues

---

## 🎉 Next Steps

After successful setup:
1. ✅ Test all owner dashboard features
2. ✅ Create real fields for your business
3. ✅ Customize analytics calculations
4. ✅ Add email notifications for bookings
5. ✅ Implement field CRUD operations
6. ✅ Add image upload for fields

---

**Last Updated:** November 24, 2025
**Version:** 1.0.0
**Status:** ✅ Complete & Ready to Use
