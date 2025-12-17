-- =====================================================
-- Fix: Complete Payment Integration
-- Date: 2025-12-13
-- Description: Ensures all payment fields exist and view is updated
-- Run this in Supabase SQL Editor
-- =====================================================

-- Step 1: Add payment columns to bookings table if missing
DO $$
BEGIN
    -- Add payment_status column
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'bookings' AND column_name = 'payment_status'
    ) THEN
        ALTER TABLE bookings ADD COLUMN payment_status VARCHAR(20) DEFAULT 'pending';
        RAISE NOTICE 'Added payment_status column';
    ELSE
        RAISE NOTICE 'payment_status column already exists';
    END IF;

    -- Add payment_proof_url column
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'bookings' AND column_name = 'payment_proof_url'
    ) THEN
        ALTER TABLE bookings ADD COLUMN payment_proof_url TEXT;
        RAISE NOTICE 'Added payment_proof_url column';
    ELSE
        RAISE NOTICE 'payment_proof_url column already exists';
    END IF;

    -- Add payment_uploaded_at column
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'bookings' AND column_name = 'payment_uploaded_at'
    ) THEN
        ALTER TABLE bookings ADD COLUMN payment_uploaded_at TIMESTAMP WITH TIME ZONE;
        RAISE NOTICE 'Added payment_uploaded_at column';
    ELSE
        RAISE NOTICE 'payment_uploaded_at column already exists';
    END IF;

    -- Add payment_verified_at column
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'bookings' AND column_name = 'payment_verified_at'
    ) THEN
        ALTER TABLE bookings ADD COLUMN payment_verified_at TIMESTAMP WITH TIME ZONE;
        RAISE NOTICE 'Added payment_verified_at column';
    ELSE
        RAISE NOTICE 'payment_verified_at column already exists';
    END IF;

    -- Add payment_rejection_reason column
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'bookings' AND column_name = 'payment_rejection_reason'
    ) THEN
        ALTER TABLE bookings ADD COLUMN payment_rejection_reason TEXT;
        RAISE NOTICE 'Added payment_rejection_reason column';
    ELSE
        RAISE NOTICE 'payment_rejection_reason column already exists';
    END IF;

    -- Add duration_hours column
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'bookings' AND column_name = 'duration_hours'
    ) THEN
        ALTER TABLE bookings ADD COLUMN duration_hours INTEGER DEFAULT 1;
        RAISE NOTICE 'Added duration_hours column';
    ELSE
        RAISE NOTICE 'duration_hours column already exists';
    END IF;

    -- Add invoice_number column
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'bookings' AND column_name = 'invoice_number'
    ) THEN
        ALTER TABLE bookings ADD COLUMN invoice_number TEXT;
        RAISE NOTICE 'Added invoice_number column';
    ELSE
        RAISE NOTICE 'invoice_number column already exists';
    END IF;
END $$;

-- Step 2: Add index for payment_status
CREATE INDEX IF NOT EXISTS idx_bookings_payment_status ON bookings(payment_status);

-- Step 3: Drop and recreate the view with all payment fields
DROP VIEW IF EXISTS user_bookings_with_details CASCADE;

CREATE VIEW user_bookings_with_details AS
SELECT
  b.id,
  b.field_id,
  b.user_id,
  b.booking_date,
  b.start_time,
  b.end_time,
  b.status,
  b.total_price,
  b.currency,
  b.notes,
  b.confirmed_at,
  b.canceled_at,
  b.cancellation_reason,
  b.is_manual,
  b.created_by,
  b.customer_name,
  b.customer_phone,
  b.customer_email,
  b.created_at,
  b.updated_at,
  -- Payment fields
  b.payment_status,
  b.payment_proof_url,
  b.payment_uploaded_at,
  b.payment_verified_at,
  b.payment_rejection_reason,
  b.invoice_number,
  -- Duration
  b.duration_hours,
  -- Field details
  f.name as field_name,
  f.images[1] as field_image,
  f.address as field_address,
  f.city_id as field_city_id,
  c.name as field_city_name,
  -- User details (for normal bookings)
  p.full_name as user_name,
  p.email as user_email,
  p.phone as user_phone
FROM bookings b
LEFT JOIN fields f ON f.id = b.field_id
LEFT JOIN cities c ON c.id = f.city_id
LEFT JOIN profiles p ON p.id = b.user_id;

COMMENT ON VIEW user_bookings_with_details IS 'Complete booking information with field, user, and payment details';

-- Step 4: Grant permissions
GRANT SELECT ON user_bookings_with_details TO authenticated;
GRANT SELECT ON user_bookings_with_details TO anon;

-- Step 5: Verify setup
DO $$
BEGIN
    RAISE NOTICE '========================================';
    RAISE NOTICE '✅ Payment Integration Complete!';
    RAISE NOTICE '========================================';
    RAISE NOTICE 'Columns added to bookings table:';
    RAISE NOTICE '  - payment_status (default: pending)';
    RAISE NOTICE '  - payment_proof_url';
    RAISE NOTICE '  - payment_uploaded_at';
    RAISE NOTICE '  - payment_verified_at';
    RAISE NOTICE '  - payment_rejection_reason';
    RAISE NOTICE '  - duration_hours (default: 1)';
    RAISE NOTICE '  - invoice_number';
    RAISE NOTICE '';
    RAISE NOTICE 'View recreated: user_bookings_with_details';
    RAISE NOTICE '';
    RAISE NOTICE 'NEXT STEPS:';
    RAISE NOTICE '1. Ensure storage bucket "payment_proofs" exists and is PUBLIC';
    RAISE NOTICE '2. Test the booking flow with payment upload';
    RAISE NOTICE '========================================';
END $$;
