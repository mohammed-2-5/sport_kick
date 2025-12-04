-- Add missing columns to sport_categories table
-- This script adds is_active and display_order columns that are expected by the app

-- Add is_active column (defaults to true)
ALTER TABLE sport_categories
ADD COLUMN IF NOT EXISTS is_active BOOLEAN DEFAULT true;

-- Add display_order column (for sorting categories)
ALTER TABLE sport_categories
ADD COLUMN IF NOT EXISTS display_order INTEGER DEFAULT 0;

-- Update existing categories with display order
UPDATE sport_categories SET display_order = 1, is_active = true WHERE name = 'Football';
UPDATE sport_categories SET display_order = 2, is_active = true WHERE name = 'Basketball';
UPDATE sport_categories SET display_order = 3, is_active = true WHERE name = 'Tennis';
UPDATE sport_categories SET display_order = 4, is_active = true WHERE name = 'Volleyball';
UPDATE sport_categories SET display_order = 5, is_active = true WHERE name = 'Padel';

-- Create index on is_active for better query performance
CREATE INDEX IF NOT EXISTS idx_sport_categories_is_active ON sport_categories(is_active);

-- Create index on display_order for sorting
CREATE INDEX IF NOT EXISTS idx_sport_categories_display_order ON sport_categories(display_order);

-- Display success message
DO $$
DECLARE
  category_count INTEGER;
BEGIN
  SELECT COUNT(*) INTO category_count FROM sport_categories WHERE is_active = true;
  
  RAISE NOTICE '========================================';
  RAISE NOTICE '✅ Sport Categories Updated!';
  RAISE NOTICE '========================================';
  RAISE NOTICE 'Added columns:';
  RAISE NOTICE '  - is_active (BOOLEAN)';
  RAISE NOTICE '  - display_order (INTEGER)';
  RAISE NOTICE '';
  RAISE NOTICE 'Active categories: %', category_count;
  RAISE NOTICE '========================================';
END $$;
