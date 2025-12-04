-- =====================================================
-- DATABASE FUNCTIONS FOR SPO KICK APP
-- =====================================================
-- This file contains SQL functions required for the app
-- Run these in your Supabase SQL Editor
-- =====================================================

-- =====================================================
-- FUNCTION: get_daily_revenue
-- Description: Returns daily revenue for the last N days
-- Parameters: days_back (integer) - number of days to look back
-- Returns: List of {booking_date, daily_revenue}
-- =====================================================

CREATE OR REPLACE FUNCTION get_daily_revenue(days_back INTEGER DEFAULT 7)
RETURNS TABLE (
  booking_date DATE,
  daily_revenue NUMERIC
)
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  RETURN QUERY
  SELECT
    b.booking_date::DATE as booking_date,
    COALESCE(SUM(b.total_price), 0) as daily_revenue
  FROM bookings b
  WHERE
    b.booking_date >= CURRENT_DATE - days_back
    AND b.status IN ('confirmed', 'completed')
  GROUP BY b.booking_date::DATE
  ORDER BY b.booking_date::DATE ASC;
END;
$$;

-- Grant execute permission to authenticated users
GRANT EXECUTE ON FUNCTION get_daily_revenue(INTEGER) TO authenticated;

-- =====================================================
-- NOTES:
-- 1. This function calculates revenue from confirmed/completed bookings
-- 2. It groups by booking_date (not created_at)
-- 3. Returns revenue in the original currency (not divided by 1000)
--    The division by 1000 is done in the Flutter app for display
-- 4. Only includes bookings from the last N days
-- 5. SECURITY DEFINER allows the function to run with elevated privileges
-- =====================================================

-- =====================================================
-- VERIFICATION QUERY (Optional - run this to test)
-- =====================================================
-- SELECT * FROM get_daily_revenue(7);
-- This should return daily revenue for the last 7 days
-- =====================================================
