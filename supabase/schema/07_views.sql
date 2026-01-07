-- ============================================================================
-- VIEWS
-- Sport Kick Database - Schema Part 7
-- ============================================================================

-- ============================================================================
-- VIEW: user_bookings_with_details
-- ============================================================================
CREATE OR REPLACE VIEW user_bookings_with_details AS
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
  b.duration_hours,
  b.recurring_booking_id,
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

GRANT SELECT ON user_bookings_with_details TO authenticated;
GRANT SELECT ON user_bookings_with_details TO anon;

-- ============================================================================
-- VIEW: admin_statistics
-- ============================================================================
CREATE OR REPLACE VIEW admin_statistics AS
SELECT
  p.id as admin_id,
  p.email,
  p.full_name,
  p.phone,
  p.created_at as admin_since,
  -- Field counts
  COUNT(DISTINCT f.id) as fields_count,
  COUNT(DISTINCT CASE WHEN f.is_active THEN f.id END) as active_fields_count,
  -- Booking counts
  COUNT(DISTINCT b.id) as total_bookings,
  COUNT(DISTINCT CASE WHEN b.status = 'pending' THEN b.id END) as pending_bookings,
  COUNT(DISTINCT CASE WHEN b.status = 'confirmed' THEN b.id END) as confirmed_bookings,
  COUNT(DISTINCT CASE WHEN b.status = 'canceled' THEN b.id END) as canceled_bookings,
  COUNT(DISTINCT CASE WHEN b.status = 'completed' THEN b.id END) as completed_bookings,
  COUNT(DISTINCT CASE WHEN b.is_manual THEN b.id END) as manual_bookings_count,
  -- Revenue
  COALESCE(SUM(b.total_price), 0) as total_revenue,
  COALESCE(SUM(CASE WHEN b.status = 'completed' THEN b.total_price ELSE 0 END), 0) as completed_revenue,
  -- Rating
  ROUND(AVG(f.rating)::numeric, 2) as avg_field_rating
FROM profiles p
LEFT JOIN fields f ON f.owner_id = p.id
LEFT JOIN bookings b ON b.field_id = f.id
WHERE p.role IN ('admin', 'super_admin')
GROUP BY p.id, p.email, p.full_name, p.phone, p.created_at;

COMMENT ON VIEW admin_statistics IS 'Statistics per admin/field owner';

-- ============================================================================
-- VIEW: platform_statistics
-- ============================================================================
CREATE OR REPLACE VIEW platform_statistics AS
SELECT
  -- User counts
  (SELECT COUNT(*) FROM profiles WHERE role = 'user') as total_users,
  (SELECT COUNT(*) FROM profiles WHERE role = 'user' AND created_at >= DATE_TRUNC('month', CURRENT_DATE)) as new_users_this_month,
  (SELECT COUNT(*) FROM profiles WHERE role = 'admin') as total_admins,
  -- Field counts
  (SELECT COUNT(*) FROM fields WHERE is_active = true) as active_fields,
  (SELECT COUNT(*) FROM fields) as total_fields,
  -- City counts
  (SELECT COUNT(DISTINCT city_id) FROM fields WHERE is_active = true) as cities_with_fields,
  (SELECT COUNT(*) FROM cities WHERE is_active = true) as active_cities,
  -- Booking counts
  (SELECT COUNT(*) FROM bookings) as total_bookings,
  (SELECT COUNT(*) FROM bookings WHERE status = 'pending') as pending_bookings,
  (SELECT COUNT(*) FROM bookings WHERE status = 'confirmed') as confirmed_bookings,
  (SELECT COUNT(*) FROM bookings WHERE status = 'completed') as completed_bookings,
  (SELECT COUNT(*) FROM bookings WHERE is_manual = true) as manual_bookings,
  (SELECT COUNT(*) FROM bookings WHERE created_at >= DATE_TRUNC('month', CURRENT_DATE)) as bookings_this_month,
  -- Revenue
  (SELECT COALESCE(SUM(total_price), 0) FROM bookings WHERE status IN ('confirmed', 'completed')) as total_revenue,
  (SELECT COALESCE(SUM(total_price), 0) FROM bookings WHERE status IN ('confirmed', 'completed') AND created_at >= DATE_TRUNC('month', CURRENT_DATE)) as revenue_this_month;

COMMENT ON VIEW platform_statistics IS 'Platform-wide statistics for super admin dashboard';
