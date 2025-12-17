-- =====================================================
-- Update user_bookings_with_details View
-- =====================================================
-- Adds creator profile info (admin name/email) for manual bookings
-- Run this in Supabase SQL Editor
-- =====================================================

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
  p.phone as user_phone,
  -- Creator details (for manual bookings)
  creator.full_name as created_by_name,
  creator.email as created_by_email
FROM bookings b
LEFT JOIN fields f ON f.id = b.field_id
LEFT JOIN cities c ON c.id = f.city_id
LEFT JOIN profiles p ON p.id = b.user_id
LEFT JOIN profiles creator ON creator.id = b.created_by;

COMMENT ON VIEW user_bookings_with_details IS 'Complete booking information with field, user, payment, and creator details';

-- =====================================================
-- Verify the view works
-- =====================================================
-- SELECT * FROM user_bookings_with_details LIMIT 5;
