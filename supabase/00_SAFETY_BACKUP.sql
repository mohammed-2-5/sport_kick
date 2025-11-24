-- ============================================================================
-- SAFETY BACKUP SCRIPT - CHECK BEFORE DELETION
-- ============================================================================
-- Run this FIRST to see what exists in your database
-- This helps you verify what will be deleted
-- ============================================================================

-- ============================================================================
-- STEP 1: CHECK TABLES
-- ============================================================================
SELECT
  schemaname,
  tablename,
  tableowner
FROM pg_tables
WHERE schemaname = 'public'
ORDER BY tablename;

-- ============================================================================
-- STEP 2: CHECK VIEWS
-- ============================================================================
SELECT
  schemaname,
  viewname,
  viewowner
FROM pg_views
WHERE schemaname = 'public'
ORDER BY viewname;

-- ============================================================================
-- STEP 3: CHECK ROW COUNTS (Important Data Check)
-- ============================================================================
DO $$
DECLARE
  table_record RECORD;
  row_count INTEGER;
BEGIN
  RAISE NOTICE '========================================';
  RAISE NOTICE 'CURRENT DATA IN DATABASE:';
  RAISE NOTICE '========================================';

  FOR table_record IN
    SELECT tablename
    FROM pg_tables
    WHERE schemaname = 'public'
    ORDER BY tablename
  LOOP
    EXECUTE format('SELECT COUNT(*) FROM %I', table_record.tablename) INTO row_count;
    RAISE NOTICE '  % : % rows', table_record.tablename, row_count;
  END LOOP;

  RAISE NOTICE '========================================';
END $$;

-- ============================================================================
-- STEP 4: CHECK RLS POLICIES
-- ============================================================================
SELECT
  schemaname,
  tablename,
  policyname,
  cmd,
  roles
FROM pg_policies
WHERE schemaname = 'public'
ORDER BY tablename, policyname;

-- ============================================================================
-- STEP 5: SUMMARY
-- ============================================================================
DO $$
DECLARE
  table_count INTEGER;
  view_count INTEGER;
  policy_count INTEGER;
BEGIN
  SELECT COUNT(*) INTO table_count FROM pg_tables WHERE schemaname = 'public';
  SELECT COUNT(*) INTO view_count FROM pg_views WHERE schemaname = 'public';
  SELECT COUNT(*) INTO policy_count FROM pg_policies WHERE schemaname = 'public';

  RAISE NOTICE '========================================';
  RAISE NOTICE 'DATABASE SUMMARY:';
  RAISE NOTICE '========================================';
  RAISE NOTICE '  Tables: %', table_count;
  RAISE NOTICE '  Views: %', view_count;
  RAISE NOTICE '  Policies: %', policy_count;
  RAISE NOTICE '========================================';
  RAISE NOTICE '';
  RAISE NOTICE '⚠️  WARNING: Review the data above!';
  RAISE NOTICE '⚠️  If you proceed with 01_CLEAN_DROP_ALL.sql,';
  RAISE NOTICE '⚠️  ALL this data will be PERMANENTLY DELETED!';
  RAISE NOTICE '========================================';
END $$;
