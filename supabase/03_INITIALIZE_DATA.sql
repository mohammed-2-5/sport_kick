-- ============================================================================
-- INITIALIZE DATA & SECURITY
-- ============================================================================
-- This script:
-- 1. Enables Row Level Security (RLS)
-- 2. Creates security policies for all roles
-- 3. Adds initial cities
-- 4. Adds sport categories
-- 5. Creates super admin account
-- ============================================================================

-- ============================================================================
-- PART 1: ENABLE ROW LEVEL SECURITY
-- ============================================================================
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE cities ENABLE ROW LEVEL SECURITY;
ALTER TABLE sport_categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE fields ENABLE ROW LEVEL SECURITY;
ALTER TABLE bookings ENABLE ROW LEVEL SECURITY;
ALTER TABLE admin_invitations ENABLE ROW LEVEL SECURITY;
ALTER TABLE admin_field_assignments ENABLE ROW LEVEL SECURITY;

-- ============================================================================
-- PART 2: RLS POLICIES - PROFILES TABLE
-- ============================================================================

-- Super Admin: Can view all profiles
CREATE POLICY "super_admin_view_all_profiles"
ON profiles FOR SELECT
TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM profiles
    WHERE id = auth.uid() AND role = 'super_admin'
  )
);

-- Users can view their own profile
CREATE POLICY "users_view_own_profile"
ON profiles FOR SELECT
TO authenticated
USING (id = auth.uid());

-- Users can update their own profile
CREATE POLICY "users_update_own_profile"
ON profiles FOR UPDATE
TO authenticated
USING (id = auth.uid())
WITH CHECK (id = auth.uid());

-- Super admin can update any profile
CREATE POLICY "super_admin_update_profiles"
ON profiles FOR UPDATE
TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM profiles
    WHERE id = auth.uid() AND role = 'super_admin'
  )
);

-- Super admin can insert profiles (when creating admins)
CREATE POLICY "super_admin_insert_profiles"
ON profiles FOR INSERT
TO authenticated
WITH CHECK (
  EXISTS (
    SELECT 1 FROM profiles
    WHERE id = auth.uid() AND role = 'super_admin'
  )
);

-- ============================================================================
-- PART 3: RLS POLICIES - CITIES TABLE
-- ============================================================================

-- Everyone can view active cities
CREATE POLICY "everyone_view_active_cities"
ON cities FOR SELECT
TO authenticated
USING (is_active = true);

-- Super admin can manage cities
CREATE POLICY "super_admin_manage_cities"
ON cities FOR ALL
TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM profiles
    WHERE id = auth.uid() AND role = 'super_admin'
  )
)
WITH CHECK (
  EXISTS (
    SELECT 1 FROM profiles
    WHERE id = auth.uid() AND role = 'super_admin'
  )
);

-- ============================================================================
-- PART 4: RLS POLICIES - SPORT CATEGORIES TABLE
-- ============================================================================

-- Everyone can view sport categories
CREATE POLICY "everyone_view_sport_categories"
ON sport_categories FOR SELECT
TO authenticated
USING (true);

-- Super admin can manage sport categories
CREATE POLICY "super_admin_manage_categories"
ON sport_categories FOR ALL
TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM profiles
    WHERE id = auth.uid() AND role = 'super_admin'
  )
)
WITH CHECK (
  EXISTS (
    SELECT 1 FROM profiles
    WHERE id = auth.uid() AND role = 'super_admin'
  )
);

-- ============================================================================
-- PART 5: RLS POLICIES - FIELDS TABLE
-- ============================================================================

-- Super admin can view all fields
CREATE POLICY "super_admin_view_all_fields"
ON fields FOR SELECT
TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM profiles
    WHERE id = auth.uid() AND role = 'super_admin'
  )
);

-- Admins can view their own fields
CREATE POLICY "admin_view_own_fields"
ON fields FOR SELECT
TO authenticated
USING (
  owner_id = auth.uid()
  AND EXISTS (
    SELECT 1 FROM profiles
    WHERE id = auth.uid() AND role IN ('admin', 'super_admin')
  )
);

-- Users can view active fields
CREATE POLICY "users_view_active_fields"
ON fields FOR SELECT
TO authenticated
USING (
  is_active = true
  AND EXISTS (
    SELECT 1 FROM profiles
    WHERE id = auth.uid() AND role = 'user'
  )
);

-- Super admin can insert/update/delete any field
CREATE POLICY "super_admin_manage_fields"
ON fields FOR ALL
TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM profiles
    WHERE id = auth.uid() AND role = 'super_admin'
  )
)
WITH CHECK (
  EXISTS (
    SELECT 1 FROM profiles
    WHERE id = auth.uid() AND role = 'super_admin'
  )
);

-- Admins can update their own fields
CREATE POLICY "admin_update_own_fields"
ON fields FOR UPDATE
TO authenticated
USING (
  owner_id = auth.uid()
  AND EXISTS (
    SELECT 1 FROM profiles
    WHERE id = auth.uid() AND role = 'admin'
  )
)
WITH CHECK (
  owner_id = auth.uid()
);

-- ============================================================================
-- PART 6: RLS POLICIES - BOOKINGS TABLE
-- ============================================================================

-- Super admin can view all bookings
CREATE POLICY "super_admin_view_all_bookings"
ON bookings FOR SELECT
TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM profiles
    WHERE id = auth.uid() AND role = 'super_admin'
  )
);

-- Admins can view bookings for their fields
CREATE POLICY "admin_view_field_bookings"
ON bookings FOR SELECT
TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM fields f
    WHERE f.id = bookings.field_id
    AND f.owner_id = auth.uid()
    AND EXISTS (
      SELECT 1 FROM profiles
      WHERE id = auth.uid() AND role IN ('admin', 'super_admin')
    )
  )
);

-- Users can view their own bookings
CREATE POLICY "users_view_own_bookings"
ON bookings FOR SELECT
TO authenticated
USING (
  user_id = auth.uid()
  AND EXISTS (
    SELECT 1 FROM profiles
    WHERE id = auth.uid() AND role = 'user'
  )
);

-- Users can create bookings
CREATE POLICY "users_create_bookings"
ON bookings FOR INSERT
TO authenticated
WITH CHECK (
  user_id = auth.uid()
  AND is_manual = false -- Users can only create normal bookings
  AND EXISTS (
    SELECT 1 FROM profiles
    WHERE id = auth.uid() AND role = 'user'
  )
);

-- Admins can create manual bookings for their fields
CREATE POLICY "admin_create_manual_bookings"
ON bookings FOR INSERT
TO authenticated
WITH CHECK (
  is_manual = true
  AND created_by = auth.uid()
  AND EXISTS (
    SELECT 1 FROM fields f
    WHERE f.id = bookings.field_id
    AND f.owner_id = auth.uid()
    AND EXISTS (
      SELECT 1 FROM profiles
      WHERE id = auth.uid() AND role IN ('admin', 'super_admin')
    )
  )
);

-- Users can update their own bookings (cancel)
CREATE POLICY "users_update_own_bookings"
ON bookings FOR UPDATE
TO authenticated
USING (
  user_id = auth.uid()
  AND EXISTS (
    SELECT 1 FROM profiles
    WHERE id = auth.uid() AND role = 'user'
  )
)
WITH CHECK (
  user_id = auth.uid()
);

-- Admins can update bookings for their fields (approve/reject)
CREATE POLICY "admin_update_field_bookings"
ON bookings FOR UPDATE
TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM fields f
    WHERE f.id = bookings.field_id
    AND f.owner_id = auth.uid()
    AND EXISTS (
      SELECT 1 FROM profiles
      WHERE id = auth.uid() AND role IN ('admin', 'super_admin')
    )
  )
)
WITH CHECK (
  EXISTS (
    SELECT 1 FROM fields f
    WHERE f.id = bookings.field_id
    AND f.owner_id = auth.uid()
  )
);

-- Super admin can update any booking
CREATE POLICY "super_admin_update_bookings"
ON bookings FOR UPDATE
TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM profiles
    WHERE id = auth.uid() AND role = 'super_admin'
  )
);

-- ============================================================================
-- PART 7: RLS POLICIES - ADMIN INVITATIONS TABLE
-- ============================================================================

-- Super admin can manage all admin invitations
CREATE POLICY "super_admin_manage_invitations"
ON admin_invitations FOR ALL
TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM profiles
    WHERE id = auth.uid() AND role = 'super_admin'
  )
)
WITH CHECK (
  EXISTS (
    SELECT 1 FROM profiles
    WHERE id = auth.uid() AND role = 'super_admin'
  )
);

-- ============================================================================
-- PART 8: RLS POLICIES - ADMIN FIELD ASSIGNMENTS TABLE
-- ============================================================================

-- Super admin can manage all assignments
CREATE POLICY "super_admin_manage_assignments"
ON admin_field_assignments FOR ALL
TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM profiles
    WHERE id = auth.uid() AND role = 'super_admin'
  )
)
WITH CHECK (
  EXISTS (
    SELECT 1 FROM profiles
    WHERE id = auth.uid() AND role = 'super_admin'
  )
);

-- Admins can view their own assignments
CREATE POLICY "admin_view_own_assignments"
ON admin_field_assignments FOR SELECT
TO authenticated
USING (
  admin_id = auth.uid()
  AND EXISTS (
    SELECT 1 FROM profiles
    WHERE id = auth.uid() AND role = 'admin'
  )
);

-- ============================================================================
-- PART 9: INSERT INITIAL DATA - CITIES
-- ============================================================================
INSERT INTO cities (name, is_active) VALUES
  ('Minya', true),
  ('Mallawi', true),
  ('New Minya', true),
  ('Assiut', true)
ON CONFLICT (name) DO NOTHING;

-- ============================================================================
-- PART 10: INSERT INITIAL DATA - SPORT CATEGORIES
-- ============================================================================
INSERT INTO sport_categories (name, icon, description) VALUES
  ('Football', 'sports_soccer', 'Football/Soccer fields'),
  ('Basketball', 'sports_basketball', 'Basketball courts'),
  ('Tennis', 'sports_tennis', 'Tennis courts'),
  ('Volleyball', 'sports_volleyball', 'Volleyball courts'),
  ('Padel', 'sports_tennis', 'Padel tennis courts')
ON CONFLICT (name) DO NOTHING;

-- ============================================================================
-- PART 11: CREATE SUPER ADMIN ACCOUNT
-- ============================================================================
-- NOTE: This requires the user to be created in Supabase Auth first!
-- Instructions:
-- 1. Go to Supabase Dashboard → Authentication → Users
-- 2. Click "Add User"
-- 3. Email: superadmin252001@sportkick.com
-- 4. Password: My252001#
-- 5. Auto Confirm Email: YES
-- 6. Click "Create User"
-- 7. Copy the User ID
-- 8. Run the INSERT below with the correct User ID

-- After creating the auth user, insert profile:
-- REPLACE 'YOUR-USER-ID-HERE' with the actual UUID from Supabase Auth

-- UNCOMMENT AND UPDATE THE LINE BELOW AFTER CREATING AUTH USER:
/*
INSERT INTO profiles (id, email, full_name, role, is_active, password_changed)
VALUES (
  '834c0d1c-cf0c-4495-b599-a593cb8e46f8'::uuid, -- Replace with actual user ID from Supabase Auth
  'superadmin252001@sportkick.com',
  'Super Admin',
  'super_admin',
  true,
  true -- Super admin doesn't need to change password
)
ON CONFLICT (id) DO UPDATE SET
  role = 'super_admin',
  is_active = true;
*/

-- ============================================================================
-- SUCCESS MESSAGE
-- ============================================================================
DO $$
DECLARE
  city_count INTEGER;
  category_count INTEGER;
  policy_count INTEGER;
BEGIN
  SELECT COUNT(*) INTO city_count FROM cities;
  SELECT COUNT(*) INTO category_count FROM sport_categories;
  SELECT COUNT(*) INTO policy_count FROM pg_policies WHERE schemaname = 'public';

  RAISE NOTICE '========================================';
  RAISE NOTICE '✅ INITIALIZATION COMPLETE!';
  RAISE NOTICE '========================================';
  RAISE NOTICE 'Security:';
  RAISE NOTICE '  ✅ RLS enabled on all tables';
  RAISE NOTICE '  ✅ % policies created', policy_count;
  RAISE NOTICE '';
  RAISE NOTICE 'Initial Data:';
  RAISE NOTICE '  ✅ % cities added', city_count;
  RAISE NOTICE '  ✅ % sport categories added', category_count;
  RAISE NOTICE '';
  RAISE NOTICE '========================================';
  RAISE NOTICE '📝 NEXT STEPS:';
  RAISE NOTICE '========================================';
  RAISE NOTICE '1. Create super admin account in Supabase Auth:';
  RAISE NOTICE '   Email: superadmin252001@sportkick.com';
  RAISE NOTICE '   Password: My252001#';
  RAISE NOTICE '';
  RAISE NOTICE '2. Copy the User ID from Auth dashboard';
  RAISE NOTICE '';
  RAISE NOTICE '3. Uncomment and update the INSERT in this file';
  RAISE NOTICE '   with the actual User ID';
  RAISE NOTICE '';
  RAISE NOTICE '4. Run that INSERT statement';
  RAISE NOTICE '';
  RAISE NOTICE '5. Test login in the app!';
  RAISE NOTICE '========================================';
END $$;
