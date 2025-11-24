-- ============================================================================
-- CLEAN DROP ALL - REMOVE ENTIRE OLD SCHEMA
-- ============================================================================
-- ⚠️  WARNING: This will DELETE EVERYTHING in your database!
-- ⚠️  Make sure you ran 00_SAFETY_BACKUP.sql first!
-- ⚠️  This operation is IRREVERSIBLE!
-- ============================================================================

-- ============================================================================
-- STEP 1: DROP ALL POLICIES (Must be first)
-- ============================================================================
DO $$
DECLARE
  policy_record RECORD;
BEGIN
  RAISE NOTICE '========================================';
  RAISE NOTICE 'DROPPING ALL RLS POLICIES...';
  RAISE NOTICE '========================================';

  FOR policy_record IN
    SELECT schemaname, tablename, policyname
    FROM pg_policies
    WHERE schemaname = 'public'
  LOOP
    EXECUTE format('DROP POLICY IF EXISTS %I ON %I.%I CASCADE',
      policy_record.policyname,
      policy_record.schemaname,
      policy_record.tablename
    );
    RAISE NOTICE '  ✓ Dropped policy: % on %', policy_record.policyname, policy_record.tablename;
  END LOOP;

  RAISE NOTICE '✅ All policies dropped';
END $$;

-- ============================================================================
-- STEP 2: DROP ALL VIEWS (Before tables)
-- ============================================================================
DO $$
DECLARE
  view_record RECORD;
BEGIN
  RAISE NOTICE '========================================';
  RAISE NOTICE 'DROPPING ALL VIEWS...';
  RAISE NOTICE '========================================';

  FOR view_record IN
    SELECT schemaname, viewname
    FROM pg_views
    WHERE schemaname = 'public'
    ORDER BY viewname
  LOOP
    EXECUTE format('DROP VIEW IF EXISTS %I.%I CASCADE',
      view_record.schemaname,
      view_record.viewname
    );
    RAISE NOTICE '  ✓ Dropped view: %', view_record.viewname;
  END LOOP;

  RAISE NOTICE '✅ All views dropped';
END $$;

-- ============================================================================
-- STEP 3: DROP ALL TABLES (With CASCADE for foreign keys)
-- ============================================================================
DO $$
DECLARE
  table_record RECORD;
BEGIN
  RAISE NOTICE '========================================';
  RAISE NOTICE 'DROPPING ALL TABLES...';
  RAISE NOTICE '========================================';

  FOR table_record IN
    SELECT schemaname, tablename
    FROM pg_tables
    WHERE schemaname = 'public'
    AND tablename NOT LIKE 'pg_%'
    ORDER BY tablename
  LOOP
    EXECUTE format('DROP TABLE IF EXISTS %I.%I CASCADE',
      table_record.schemaname,
      table_record.tablename
    );
    RAISE NOTICE '  ✓ Dropped table: %', table_record.tablename;
  END LOOP;

  RAISE NOTICE '✅ All tables dropped';
END $$;

-- ============================================================================
-- STEP 4: DROP ALL FUNCTIONS (Clean up any custom functions)
-- ============================================================================
DO $$
DECLARE
  function_record RECORD;
BEGIN
  RAISE NOTICE '========================================';
  RAISE NOTICE 'DROPPING ALL FUNCTIONS...';
  RAISE NOTICE '========================================';

  FOR function_record IN
    SELECT
      n.nspname as schema_name,
      p.proname as function_name,
      pg_get_function_identity_arguments(p.oid) as args
    FROM pg_proc p
    JOIN pg_namespace n ON p.pronamespace = n.oid
    WHERE n.nspname = 'public'
    AND p.prokind = 'f'
  LOOP
    EXECUTE format('DROP FUNCTION IF EXISTS %I.%I(%s) CASCADE',
      function_record.schema_name,
      function_record.function_name,
      function_record.args
    );
    RAISE NOTICE '  ✓ Dropped function: %(%)', function_record.function_name, function_record.args;
  END LOOP;

  RAISE NOTICE '✅ All functions dropped';
END $$;

-- ============================================================================
-- STEP 5: DROP ALL TRIGGERS
-- ============================================================================
DO $$
DECLARE
  trigger_record RECORD;
BEGIN
  RAISE NOTICE '========================================';
  RAISE NOTICE 'DROPPING ALL TRIGGERS...';
  RAISE NOTICE '========================================';

  FOR trigger_record IN
    SELECT
      schemaname,
      tablename,
      triggername
    FROM pg_trigger t
    JOIN pg_class c ON t.tgrelid = c.oid
    JOIN pg_namespace n ON c.relnamespace = n.oid
    WHERE n.nspname = 'public'
    AND NOT t.tgisinternal
  LOOP
    EXECUTE format('DROP TRIGGER IF EXISTS %I ON %I.%I CASCADE',
      trigger_record.triggername,
      trigger_record.schemaname,
      trigger_record.tablename
    );
    RAISE NOTICE '  ✓ Dropped trigger: % on %', trigger_record.triggername, trigger_record.tablename;
  END LOOP;

  RAISE NOTICE '✅ All triggers dropped';
END $$;

-- ============================================================================
-- STEP 6: VERIFICATION
-- ============================================================================
DO $$
DECLARE
  table_count INTEGER;
  view_count INTEGER;
  policy_count INTEGER;
  function_count INTEGER;
BEGIN
  SELECT COUNT(*) INTO table_count FROM pg_tables WHERE schemaname = 'public';
  SELECT COUNT(*) INTO view_count FROM pg_views WHERE schemaname = 'public';
  SELECT COUNT(*) INTO policy_count FROM pg_policies WHERE schemaname = 'public';
  SELECT COUNT(*) INTO function_count FROM pg_proc p
    JOIN pg_namespace n ON p.pronamespace = n.oid
    WHERE n.nspname = 'public' AND p.prokind = 'f';

  RAISE NOTICE '========================================';
  RAISE NOTICE 'CLEANUP VERIFICATION:';
  RAISE NOTICE '========================================';
  RAISE NOTICE '  Tables remaining: %', table_count;
  RAISE NOTICE '  Views remaining: %', view_count;
  RAISE NOTICE '  Policies remaining: %', policy_count;
  RAISE NOTICE '  Functions remaining: %', function_count;
  RAISE NOTICE '========================================';

  IF table_count = 0 AND view_count = 0 AND policy_count = 0 THEN
    RAISE NOTICE '✅ DATABASE COMPLETELY CLEAN!';
    RAISE NOTICE '✅ Ready to run 02_FRESH_SCHEMA.sql';
  ELSE
    RAISE NOTICE '⚠️  Some objects still remain';
    RAISE NOTICE '⚠️  Review and manually delete if needed';
  END IF;

  RAISE NOTICE '========================================';
END $$;
