-- ============================================================================
-- INITIAL DATA (Seeds)
-- Sport Kick Database - Required data for app functionality
-- ============================================================================

-- ============================================================================
-- PLATFORM SETTINGS
-- ============================================================================

INSERT INTO platform_settings (setting_key, setting_value, description)
VALUES (
  'default_operating_hours',
  '{
    "monday": {"isOpen": true, "openTime": "08:00", "closeTime": "22:00"},
    "tuesday": {"isOpen": true, "openTime": "08:00", "closeTime": "22:00"},
    "wednesday": {"isOpen": true, "openTime": "08:00", "closeTime": "22:00"},
    "thursday": {"isOpen": true, "openTime": "08:00", "closeTime": "22:00"},
    "friday": {"isOpen": true, "openTime": "08:00", "closeTime": "22:00"},
    "saturday": {"isOpen": true, "openTime": "09:00", "closeTime": "23:00"},
    "sunday": {"isOpen": true, "openTime": "09:00", "closeTime": "23:00"}
  }',
  'Default operating hours for new fields'
) ON CONFLICT (setting_key) DO NOTHING;

INSERT INTO platform_settings (setting_key, setting_value, description)
VALUES (
  'enforce_operating_hours',
  'true',
  'Whether to enforce operating hours for all fields'
) ON CONFLICT (setting_key) DO NOTHING;

-- ============================================================================
-- SPORT CATEGORIES
-- ============================================================================

INSERT INTO sport_categories (name, icon, description) VALUES
  ('Football', 'sports_soccer', 'Association football / soccer fields'),
  ('Basketball', 'sports_basketball', 'Basketball courts'),
  ('Tennis', 'sports_tennis', 'Tennis courts'),
  ('Padel', 'sports_cricket', 'Padel courts'),
  ('Volleyball', 'sports_volleyball', 'Volleyball courts')
ON CONFLICT (name) DO NOTHING;

-- ============================================================================
-- INITIAL CITIES (Egypt)
-- ============================================================================

INSERT INTO cities (name, name_ar, is_active) VALUES
  ('Cairo', 'القاهرة', true),
  ('Alexandria', 'الإسكندرية', true),
  ('Giza', 'الجيزة', true),
  ('Sharm El Sheikh', 'شرم الشيخ', true),
  ('Hurghada', 'الغردقة', true),
  ('Luxor', 'الأقصر', true),
  ('Aswan', 'أسوان', true),
  ('Mansoura', 'المنصورة', true),
  ('Tanta', 'طنطا', true),
  ('Port Said', 'بورسعيد', true)
ON CONFLICT (name) DO NOTHING;
