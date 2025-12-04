# Database Setup Guide

This guide explains how to set up required database functions in Supabase for the Sport Kick application.

## Issue: Missing Database Functions

If you see this error when opening the Super Admin Analytics page:

```
Could not find the function public.get_daily_revenue(days_back) in the schema cache
```

It means the required database function hasn't been created yet.

## Solution: Create Database Functions

### Step 1: Open Supabase SQL Editor

1. Go to your Supabase project dashboard: https://supabase.com/dashboard
2. Select your project
3. Click on **SQL Editor** in the left sidebar

### Step 2: Run the SQL Script

1. Click **New Query** button
2. Copy the entire contents of `DATABASE_FUNCTIONS.sql`
3. Paste it into the SQL editor
4. Click **Run** (or press Ctrl+Enter / Cmd+Enter)

### Step 3: Verify the Function

After running the SQL, verify it works by running this query:

```sql
SELECT * FROM get_daily_revenue(7);
```

This should return daily revenue data for the last 7 days (or empty results if you don't have any bookings yet).

## What This Function Does

The `get_daily_revenue` function:
- Calculates total revenue per day from confirmed/completed bookings
- Takes a parameter `days_back` (default: 7) to specify how many days to include
- Returns a list of `{booking_date, daily_revenue}` records
- Used by the Super Admin Analytics page to show revenue trends

## Current Status

✅ **App is working**: The app gracefully handles the missing function by showing zeros in the chart.
⚠️ **Database setup needed**: To see actual revenue data, you need to run the SQL script.

## Troubleshooting

### Error: "relation 'bookings' does not exist"

If you get this error, it means your bookings table hasn't been created yet. Make sure you've:
1. Created all the required database tables
2. Run any migration scripts for your database schema

### Error: "permission denied"

Make sure you're running the SQL as a superuser in Supabase SQL Editor. The SQL Editor typically runs with the correct permissions.

### Function created but still seeing errors

1. Refresh your Supabase schema cache by restarting your app
2. Check that the function has the correct permissions:
   ```sql
   GRANT EXECUTE ON FUNCTION get_daily_revenue(INTEGER) TO authenticated;
   ```

## Need Help?

If you continue to have issues:
1. Check the Supabase logs for detailed error messages
2. Verify your database schema matches the expected structure
3. Ensure RLS (Row Level Security) policies are set up correctly
