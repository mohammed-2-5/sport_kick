-- ============================================================================
-- DEMO DATA (Optional - for testing)
-- Sport Kick Database
-- ============================================================================
-- WARNING: Only run this on development/testing environments!
-- ============================================================================

-- NOTE: Demo data requires existing users. Create users first via Supabase Auth,
-- then update these IDs accordingly.

-- Example demo field (update owner_id and city_id before running):
/*
INSERT INTO fields (
  owner_id,
  name,
  description,
  city_id,
  address,
  price_per_hour,
  sport_type,
  size,
  surface_type,
  images,
  amenities,
  is_active,
  payment_phone,
  payment_method
) VALUES (
  'YOUR_ADMIN_USER_ID',  -- Replace with actual admin UUID
  'Demo Field 1',
  'A great football field for practice and matches',
  (SELECT id FROM cities WHERE name = 'Cairo' LIMIT 1),
  '123 Sports Street, Cairo',
  150.00,
  'Football',
  '5-a-side',
  'Artificial Turf',
  ARRAY['https://example.com/field1.jpg'],
  ARRAY['Parking', 'Lighting', 'Changing Rooms', 'Water'],
  true,
  '01012345678',
  'vodafone_cash'
);

-- Initialize business hours for demo field
SELECT initialize_default_business_hours(
  (SELECT id FROM fields WHERE name = 'Demo Field 1' LIMIT 1)
);
*/
