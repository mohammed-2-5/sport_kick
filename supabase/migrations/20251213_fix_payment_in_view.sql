-- =====================================================
-- Fix: Add payment fields to user_bookings_with_details view
-- Date: 2025-12-13
-- Description: Add payment_proof_url, payment_status, payment_uploaded_at,
--              payment_rejection_reason, and duration_hours to the view
-- =====================================================

-- Drop and recreate the view with payment fields
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
  b.payment_rejection_reason,
  -- Duration calculation
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

-- Grant permissions
GRANT SELECT ON user_bookings_with_details TO authenticated;
GRANT SELECT ON user_bookings_with_details TO anon;
