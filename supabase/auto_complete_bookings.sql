-- =====================================================
-- Auto-Complete Expired Bookings - PROPER SOLUTION
-- =====================================================
-- This is the best approach because:
-- 1. Prevents creating bookings in the past (INSERT only)
-- 2. Allows updating old booking statuses (UPDATE allowed)
-- 3. Uses a trigger instead of a broken CHECK constraint
-- =====================================================

-- ===================== STEP 1: FIX THE CONSTRAINT =====================

-- Drop the problematic CHECK constraint
ALTER TABLE bookings DROP CONSTRAINT IF EXISTS bookings_date_check;

-- Create a function that validates booking date on INSERT only
CREATE OR REPLACE FUNCTION validate_booking_date_on_insert()
RETURNS TRIGGER AS $$
BEGIN
  -- Only validate on INSERT, not UPDATE
  -- Allow bookings from yesterday (in case of timezone differences)
  IF NEW.booking_date < CURRENT_DATE - INTERVAL '1 day' THEN
    RAISE EXCEPTION 'Booking date cannot be more than 1 day in the past. Date: %, Today: %', 
      NEW.booking_date, CURRENT_DATE;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Drop old trigger if exists
DROP TRIGGER IF EXISTS validate_booking_date_trigger ON bookings;

-- Create trigger ONLY for INSERT (not UPDATE)
CREATE TRIGGER validate_booking_date_trigger
  BEFORE INSERT ON bookings
  FOR EACH ROW
  EXECUTE FUNCTION validate_booking_date_on_insert();

-- ===================== STEP 2: CREATE AUTO-COMPLETE FUNCTION =====================

-- Drop existing function if exists
DROP FUNCTION IF EXISTS complete_passed_bookings();

-- Create the function to complete passed bookings
CREATE OR REPLACE FUNCTION complete_passed_bookings()
RETURNS INTEGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    updated_count INTEGER;
BEGIN
    -- Update all 'confirmed' bookings where the booking_date + end_time has passed
    UPDATE bookings
    SET 
        status = 'completed',
        updated_at = NOW()
    WHERE 
        status = 'confirmed'
        AND (booking_date + end_time::time) < NOW();
    
    -- Get the count of updated rows
    GET DIAGNOSTICS updated_count = ROW_COUNT;
    
    RETURN updated_count;
END;
$$;

-- Grant RPC access so it can be called from the app
GRANT EXECUTE ON FUNCTION complete_passed_bookings() TO authenticated;
GRANT EXECUTE ON FUNCTION complete_passed_bookings() TO anon;
GRANT EXECUTE ON FUNCTION complete_passed_bookings() TO service_role;

-- ===================== TEST =====================
-- Run this to test:
-- SELECT complete_passed_bookings();
-- 
-- It should return the number of bookings that were marked as completed.

-- ===================== VERIFY =====================
-- Check that the trigger exists:
-- SELECT tgname FROM pg_trigger WHERE tgname = 'validate_booking_date_trigger';
--
-- Check that old bookings can now be updated:
-- UPDATE bookings SET updated_at = NOW() WHERE id = 'some-old-booking-id';
