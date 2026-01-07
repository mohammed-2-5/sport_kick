-- ============================================================================
-- MAINTENANCE & UTILITY QUERIES
-- Sport Kick Database
-- ============================================================================

-- ============================================================================
-- HEALTH CHECK QUERIES
-- ============================================================================

-- Check table sizes
SELECT
  tablename,
  pg_size_pretty(pg_total_relation_size(schemaname || '.' || tablename)) as total_size,
  pg_size_pretty(pg_relation_size(schemaname || '.' || tablename)) as table_size
FROM pg_tables
WHERE schemaname = 'public'
ORDER BY pg_total_relation_size(schemaname || '.' || tablename) DESC;

-- Check RLS policies
SELECT tablename, policyname, cmd, qual
FROM pg_policies
WHERE schemaname = 'public'
ORDER BY tablename, policyname;

-- Check triggers
SELECT
  tgname as trigger_name,
  tgrelid::regclass as table_name,
  proname as function_name
FROM pg_trigger t
JOIN pg_proc p ON t.tgfoid = p.oid
WHERE NOT tgisinternal
ORDER BY tgrelid::regclass, tgname;

-- Check indexes
SELECT
  tablename,
  indexname,
  indexdef
FROM pg_indexes
WHERE schemaname = 'public'
ORDER BY tablename, indexname;

-- Check foreign keys
SELECT
  tc.table_name,
  kcu.column_name,
  ccu.table_name AS foreign_table_name,
  ccu.column_name AS foreign_column_name
FROM information_schema.table_constraints AS tc
JOIN information_schema.key_column_usage AS kcu
  ON tc.constraint_name = kcu.constraint_name
JOIN information_schema.constraint_column_usage AS ccu
  ON ccu.constraint_name = tc.constraint_name
WHERE tc.constraint_type = 'FOREIGN KEY'
  AND tc.table_schema = 'public'
ORDER BY tc.table_name;

-- ============================================================================
-- DATA CLEANUP QUERIES
-- ============================================================================

-- Complete passed bookings (call this periodically)
SELECT complete_passed_bookings();

-- Check for orphaned records
SELECT 'Bookings without fields' as check_type, COUNT(*) as count
FROM bookings b WHERE NOT EXISTS (SELECT 1 FROM fields f WHERE f.id = b.field_id)
UNION ALL
SELECT 'Fields without owners', COUNT(*)
FROM fields f WHERE owner_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM profiles p WHERE p.id = f.owner_id)
UNION ALL
SELECT 'Reviews without bookings', COUNT(*)
FROM reviews r WHERE booking_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM bookings b WHERE b.id = r.booking_id);

-- Check and cancel missed recurring payments
SELECT check_and_cancel_missed_recurring_payments();

-- ============================================================================
-- STATISTICS QUERIES
-- ============================================================================

-- Booking statistics by status
SELECT
  status,
  COUNT(*) as count,
  SUM(total_price) as total_revenue
FROM bookings
GROUP BY status
ORDER BY count DESC;

-- Top fields by bookings
SELECT
  f.name,
  COUNT(b.id) as booking_count,
  SUM(b.total_price) as total_revenue,
  f.rating
FROM fields f
LEFT JOIN bookings b ON b.field_id = f.id AND b.status IN ('confirmed', 'completed')
GROUP BY f.id, f.name, f.rating
ORDER BY booking_count DESC
LIMIT 10;

-- User role distribution
SELECT
  role,
  COUNT(*) as count,
  COUNT(CASE WHEN is_active THEN 1 END) as active_count
FROM profiles
GROUP BY role;

-- City statistics
SELECT
  c.name,
  COUNT(DISTINCT f.id) as fields_count,
  COUNT(b.id) as bookings_count
FROM cities c
LEFT JOIN fields f ON f.city_id = c.id AND f.is_active = true
LEFT JOIN bookings b ON b.field_id = f.id
GROUP BY c.id, c.name
ORDER BY fields_count DESC;

-- ============================================================================
-- SCHEMA INSPECTION
-- ============================================================================

-- List all tables with row counts
SELECT
  schemaname,
  relname as tablename,
  n_live_tup as row_count
FROM pg_stat_user_tables
WHERE schemaname = 'public'
ORDER BY n_live_tup DESC;

-- List all functions
SELECT
  proname as function_name,
  pg_get_function_arguments(p.oid) as arguments,
  CASE WHEN prosecdef THEN 'SECURITY DEFINER' ELSE 'SECURITY INVOKER' END as security
FROM pg_proc p
JOIN pg_namespace n ON p.pronamespace = n.oid
WHERE n.nspname = 'public'
ORDER BY proname;

-- ============================================================================
-- BACKUP QUERIES
-- ============================================================================

-- Export important configuration
SELECT * FROM platform_settings;
SELECT * FROM sport_categories;
SELECT * FROM cities WHERE is_active = true;
