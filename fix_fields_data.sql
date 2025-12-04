-- ============================================================================
-- FIX DEMO FIELDS ISSUES
-- ============================================================================
-- This script fixes two issues:
-- 1. Updates sport_type column to match sport_category names
-- 2. Updates fields_count in cities table
-- 3. Creates triggers to auto-update fields_count in the future
-- ============================================================================

-- ========================================================================
-- PART 1: UPDATE SPORT_TYPE TO MATCH SPORT_CATEGORY
-- ========================================================================
-- The sport_type column is legacy but still exists in the schema
-- Update it to match the actual sport category name

UPDATE fields f
SET sport_type = sc.name
FROM sport_categories sc
WHERE f.sport_category_id = sc.id;

-- ========================================================================
-- PART 2: UPDATE FIELDS_COUNT IN CITIES TABLE
-- ========================================================================
-- Manually update the cached fields_count for each city

UPDATE cities c
SET fields_count = (
    SELECT COUNT(*)
    FROM fields f
    WHERE f.city_id = c.id
      AND f.is_active = true
);

-- ========================================================================
-- PART 3: CREATE TRIGGER TO AUTO-UPDATE FIELDS_COUNT
-- ========================================================================
-- This ensures fields_count stays accurate when fields are added/removed/updated

-- Function to update city fields count
CREATE OR REPLACE FUNCTION update_city_fields_count()
RETURNS TRIGGER AS $$
BEGIN
    -- Update the old city (if city changed or field deleted)
    IF TG_OP = 'DELETE' OR (TG_OP = 'UPDATE' AND OLD.city_id != NEW.city_id) THEN
        UPDATE cities
        SET fields_count = (
            SELECT COUNT(*)
            FROM fields
            WHERE city_id = OLD.city_id
              AND is_active = true
        )
        WHERE id = OLD.city_id;
    END IF;

    -- Update the new city (if field inserted or city changed or is_active changed)
    IF TG_OP = 'INSERT' OR (TG_OP = 'UPDATE' AND (OLD.city_id != NEW.city_id OR OLD.is_active != NEW.is_active)) THEN
        UPDATE cities
        SET fields_count = (
            SELECT COUNT(*)
            FROM fields
            WHERE city_id = NEW.city_id
              AND is_active = true
        )
        WHERE id = NEW.city_id;
    END IF;

    RETURN COALESCE(NEW, OLD);
END;
$$ LANGUAGE plpgsql;

-- Drop trigger if exists
DROP TRIGGER IF EXISTS trigger_update_city_fields_count ON fields;

-- Create trigger
CREATE TRIGGER trigger_update_city_fields_count
AFTER INSERT OR UPDATE OR DELETE ON fields
FOR EACH ROW
EXECUTE FUNCTION update_city_fields_count();

-- ========================================================================
-- PART 4: CREATE TRIGGER TO AUTO-UPDATE SPORT_TYPE
-- ========================================================================
-- This ensures sport_type stays in sync with sport_category

-- Function to update sport_type from category
CREATE OR REPLACE FUNCTION update_field_sport_type()
RETURNS TRIGGER AS $$
BEGIN
    -- Update sport_type to match the category name
    IF NEW.sport_category_id IS NOT NULL THEN
        SELECT name INTO NEW.sport_type
        FROM sport_categories
        WHERE id = NEW.sport_category_id;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Drop trigger if exists
DROP TRIGGER IF EXISTS trigger_update_field_sport_type ON fields;

-- Create trigger
CREATE TRIGGER trigger_update_field_sport_type
BEFORE INSERT OR UPDATE OF sport_category_id ON fields
FOR EACH ROW
EXECUTE FUNCTION update_field_sport_type();

-- ========================================================================
-- VERIFICATION QUERIES
-- ========================================================================

-- Check fields by sport type
SELECT 
    sport_type,
    COUNT(*) as field_count
FROM fields
GROUP BY sport_type
ORDER BY sport_type;

-- Check cities with field counts
SELECT 
    name,
    fields_count,
    is_active
FROM cities
ORDER BY name;

-- Check fields with their categories
SELECT 
    f.name as field_name,
    f.sport_type,
    sc.name as category_name,
    c.name as city_name
FROM fields f
LEFT JOIN sport_categories sc ON f.sport_category_id = sc.id
LEFT JOIN cities c ON f.city_id = c.id
ORDER BY sc.name, f.name;

-- ========================================================================
-- SUCCESS MESSAGE
-- ========================================================================
DO $$
DECLARE
    total_fields INTEGER;
    total_cities_with_fields INTEGER;
BEGIN
    SELECT COUNT(*) INTO total_fields FROM fields WHERE is_active = true;
    SELECT COUNT(*) INTO total_cities_with_fields FROM cities WHERE fields_count > 0;
    
    RAISE NOTICE '========================================';
    RAISE NOTICE '✅ FIXES APPLIED SUCCESSFULLY!';
    RAISE NOTICE '========================================';
    RAISE NOTICE 'Updates:';
    RAISE NOTICE '  ✅ Updated sport_type for all fields';
    RAISE NOTICE '  ✅ Updated fields_count for all cities';
    RAISE NOTICE '';
    RAISE NOTICE 'Triggers Created:';
    RAISE NOTICE '  ✅ Auto-update fields_count on field changes';
    RAISE NOTICE '  ✅ Auto-update sport_type on category changes';
    RAISE NOTICE '';
    RAISE NOTICE 'Current Stats:';
    RAISE NOTICE '  📊 Total active fields: %', total_fields;
    RAISE NOTICE '  📍 Cities with fields: %', total_cities_with_fields;
    RAISE NOTICE '========================================';
END $$;
