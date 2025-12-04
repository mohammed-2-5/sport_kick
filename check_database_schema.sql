-- ============================================================================
-- DATABASE SCHEMA INSPECTION SCRIPT
-- ============================================================================
-- This script will show you the complete schema of your database including:
-- 1. All tables and their columns
-- 2. Foreign key relationships
-- 3. Indexes
-- 4. Constraints
-- ============================================================================

-- ============================================================================
-- PART 1: SPORT_CATEGORIES TABLE SCHEMA
-- ============================================================================
SELECT 
    'sport_categories' as table_name,
    column_name,
    data_type,
    character_maximum_length,
    column_default,
    is_nullable
FROM information_schema.columns
WHERE table_schema = 'public' 
  AND table_name = 'sport_categories'
ORDER BY ordinal_position;

-- ============================================================================
-- PART 2: FIELDS TABLE SCHEMA
-- ============================================================================
SELECT 
    'fields' as table_name,
    column_name,
    data_type,
    character_maximum_length,
    column_default,
    is_nullable
FROM information_schema.columns
WHERE table_schema = 'public' 
  AND table_name = 'fields'
ORDER BY ordinal_position;

-- ============================================================================
-- PART 3: ALL TABLES IN DATABASE
-- ============================================================================
SELECT 
    table_name,
    (SELECT COUNT(*) 
     FROM information_schema.columns 
     WHERE table_schema = 'public' 
       AND table_name = t.table_name) as column_count
FROM information_schema.tables t
WHERE table_schema = 'public' 
  AND table_type = 'BASE TABLE'
ORDER BY table_name;

-- ============================================================================
-- PART 4: FOREIGN KEY RELATIONSHIPS
-- ============================================================================
SELECT
    tc.table_name as from_table,
    kcu.column_name as from_column,
    ccu.table_name AS to_table,
    ccu.column_name AS to_column,
    tc.constraint_name
FROM information_schema.table_constraints AS tc
JOIN information_schema.key_column_usage AS kcu
    ON tc.constraint_name = kcu.constraint_name
    AND tc.table_schema = kcu.table_schema
JOIN information_schema.constraint_column_usage AS ccu
    ON ccu.constraint_name = tc.constraint_name
    AND ccu.table_schema = tc.table_schema
WHERE tc.constraint_type = 'FOREIGN KEY' 
  AND tc.table_schema = 'public'
ORDER BY tc.table_name, kcu.column_name;

-- ============================================================================
-- PART 5: INDEXES ON SPORT_CATEGORIES
-- ============================================================================
SELECT
    tablename,
    indexname,
    indexdef
FROM pg_indexes
WHERE schemaname = 'public'
  AND tablename = 'sport_categories'
ORDER BY indexname;

-- ============================================================================
-- PART 6: INDEXES ON FIELDS
-- ============================================================================
SELECT
    tablename,
    indexname,
    indexdef
FROM pg_indexes
WHERE schemaname = 'public'
  AND tablename = 'fields'
ORDER BY indexname;

-- ============================================================================
-- PART 7: CHECK CURRENT DATA IN SPORT_CATEGORIES
-- ============================================================================
SELECT 
    id,
    name,
    icon,
    description,
    created_at,
    -- Check if these columns exist
    CASE 
        WHEN EXISTS (
            SELECT 1 FROM information_schema.columns 
            WHERE table_name = 'sport_categories' 
              AND column_name = 'is_active'
        ) THEN 'Column EXISTS'
        ELSE 'Column MISSING'
    END as is_active_status,
    CASE 
        WHEN EXISTS (
            SELECT 1 FROM information_schema.columns 
            WHERE table_name = 'sport_categories' 
              AND column_name = 'display_order'
        ) THEN 'Column EXISTS'
        ELSE 'Column MISSING'
    END as display_order_status
FROM sport_categories
LIMIT 1;

-- ============================================================================
-- PART 8: COUNT RECORDS IN KEY TABLES
-- ============================================================================
SELECT 
    'sport_categories' as table_name,
    COUNT(*) as record_count
FROM sport_categories
UNION ALL
SELECT 
    'fields' as table_name,
    COUNT(*) as record_count
FROM fields
UNION ALL
SELECT 
    'cities' as table_name,
    COUNT(*) as record_count
FROM cities
UNION ALL
SELECT 
    'profiles' as table_name,
    COUNT(*) as record_count
FROM profiles
UNION ALL
SELECT 
    'bookings' as table_name,
    COUNT(*) as record_count
FROM bookings;

-- ============================================================================
-- PART 9: FIELDS WITH THEIR CATEGORIES (Check Relationships)
-- ============================================================================
SELECT 
    f.id as field_id,
    f.name as field_name,
    f.sport_category_id,
    sc.name as category_name,
    f.city_id,
    c.name as city_name
FROM fields f
LEFT JOIN sport_categories sc ON f.sport_category_id = sc.id
LEFT JOIN cities c ON f.city_id = c.id
LIMIT 10;
