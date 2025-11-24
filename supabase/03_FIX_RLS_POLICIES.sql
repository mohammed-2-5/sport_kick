-- ============================================================================
-- FIX RLS POLICIES - RESOLVE INFINITE RECURSION
-- ============================================================================
-- This script fixes the infinite recursion error in RLS policies
-- by creating helper functions that bypass RLS
-- ============================================================================

-- ============================================================================
-- STEP 1: DROP ALL EXISTING POLICIES
-- ============================================================================
DROP POLICY IF EXISTS "super_admin_view_all_profiles" ON profiles;
DROP POLICY IF EXISTS "users_view_own_profile" ON profiles;
DROP POLICY IF EXISTS "users_update_own_profile" ON profiles;
DROP POLICY IF EXISTS "super_admin_update_profiles" ON profiles;
DROP POLICY IF EXISTS "super_admin_insert_profiles" ON profiles;

DROP POLICY IF EXISTS "everyone_view_active_cities" ON cities;
DROP POLICY IF EXISTS "super_admin_manage_cities" ON cities;

DROP POLICY IF EXISTS "everyone_view_sport_categories" ON sport_categories;
DROP POLICY IF EXISTS "super_admin_manage_categories" ON sport_categories;

DROP POLICY IF EXISTS "super_admin_view_all_fields" ON fields;
DROP POLICY IF EXISTS "admin_view_own_fields" ON fields;
DROP POLICY IF EXISTS "users_view_active_fields" ON fields;
DROP POLICY IF EXISTS "super_admin_manage_fields" ON fields;
DROP POLICY IF EXISTS "admin_update_own_fields" ON fields;

DROP POLICY IF EXISTS "super_admin_view_all_bookings" ON bookings;
DROP POLICY IF EXISTS "admin_view_field_bookings" ON bookings;
DROP POLICY IF EXISTS "users_view_own_bookings" ON bookings;
DROP POLICY IF EXISTS "users_create_bookings" ON bookings;
DROP POLICY IF EXISTS "admin_create_manual_bookings" ON bookings;
DROP POLICY IF EXISTS "users_update_own_bookings" ON bookings;
DROP POLICY IF EXISTS "admin_update_field_bookings" ON bookings;
DROP POLICY IF EXISTS "super_admin_update_bookings" ON bookings;

DROP POLICY IF EXISTS "super_admin_manage_invitations" ON admin_invitations;
DROP POLICY IF EXISTS "super_admin_manage_assignments" ON admin_field_assignments;
DROP POLICY IF EXISTS "admin_view_own_assignments" ON admin_field_assignments;

-- ============================================================================
-- STEP 2: CREATE HELPER FUNCTIONS (BYPASS RLS)
-- ============================================================================

-- Function to get current user's role (bypasses RLS)
CREATE OR REPLACE FUNCTION get_current_user_role()
RETURNS TEXT
LANGUAGE plpgsql
SECURITY DEFINER -- This allows the function to bypass RLS
STABLE
AS $$
BEGIN
  RETURN (
    SELECT role
    FROM public.profiles
    WHERE id = auth.uid()
  );
END;
$$;

-- Function to check if current user is super admin
CREATE OR REPLACE FUNCTION is_super_admin()
RETURNS BOOLEAN
LANGUAGE plpgsql
SECURITY DEFINER
STABLE
AS $$
BEGIN
  RETURN (
    SELECT role = 'super_admin'
    FROM public.profiles
    WHERE id = auth.uid()
  );
END;
$$;

-- Function to check if current user is admin or super admin
CREATE OR REPLACE FUNCTION is_admin()
RETURNS BOOLEAN
LANGUAGE plpgsql
SECURITY DEFINER
STABLE
AS $$
BEGIN
  RETURN (
    SELECT role IN ('admin', 'super_admin')
    FROM public.profiles
    WHERE id = auth.uid()
  );
END;
$$;

-- Function to check if current user is regular user
CREATE OR REPLACE FUNCTION is_user()
RETURNS BOOLEAN
LANGUAGE plpgsql
SECURITY DEFINER
STABLE
AS $$
BEGIN
  RETURN (
    SELECT role = 'user'
    FROM public.profiles
    WHERE id = auth.uid()
  );
END;
$$;

-- ============================================================================
-- STEP 3: PROFILES TABLE POLICIES (FIXED)
-- ============================================================================

-- Super admin can view all profiles
CREATE POLICY "super_admin_view_all_profiles"
ON profiles FOR SELECT
TO authenticated
USING (is_super_admin());

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
USING (is_super_admin())
WITH CHECK (is_super_admin());

-- Super admin can insert profiles (for creating admins)
CREATE POLICY "super_admin_insert_profiles"
ON profiles FOR INSERT
TO authenticated
WITH CHECK (is_super_admin());

-- Allow profile creation on signup (for new users)
CREATE POLICY "allow_profile_insert_on_signup"
ON profiles FOR INSERT
TO authenticated
WITH CHECK (auth.uid() = id);

-- ============================================================================
-- STEP 4: CITIES TABLE POLICIES (FIXED)
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
USING (is_super_admin())
WITH CHECK (is_super_admin());

-- ============================================================================
-- STEP 5: SPORT CATEGORIES TABLE POLICIES (FIXED)
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
USING (is_super_admin())
WITH CHECK (is_super_admin());

-- ============================================================================
-- STEP 6: FIELDS TABLE POLICIES (FIXED)
-- ============================================================================

-- Super admin can view all fields
CREATE POLICY "super_admin_view_all_fields"
ON fields FOR SELECT
TO authenticated
USING (is_super_admin());

-- Admins can view their own fields
CREATE POLICY "admin_view_own_fields"
ON fields FOR SELECT
TO authenticated
USING (owner_id = auth.uid() AND is_admin());

-- Users can view active fields
CREATE POLICY "users_view_active_fields"
ON fields FOR SELECT
TO authenticated
USING (is_active = true AND is_user());

-- Super admin can insert/update/delete any field
CREATE POLICY "super_admin_manage_fields"
ON fields FOR ALL
TO authenticated
USING (is_super_admin())
WITH CHECK (is_super_admin());

-- Admins can update their own fields
CREATE POLICY "admin_update_own_fields"
ON fields FOR UPDATE
TO authenticated
USING (owner_id = auth.uid() AND is_admin())
WITH CHECK (owner_id = auth.uid());

-- ============================================================================
-- STEP 7: BOOKINGS TABLE POLICIES (FIXED)
-- ============================================================================

-- Super admin can view all bookings
CREATE POLICY "super_admin_view_all_bookings"
ON bookings FOR SELECT
TO authenticated
USING (is_super_admin());

-- Admins can view bookings for their fields
CREATE POLICY "admin_view_field_bookings"
ON bookings FOR SELECT
TO authenticated
USING (
  is_admin()
  AND EXISTS (
    SELECT 1 FROM fields f
    WHERE f.id = bookings.field_id
    AND f.owner_id = auth.uid()
  )
);

-- Users can view their own bookings
CREATE POLICY "users_view_own_bookings"
ON bookings FOR SELECT
TO authenticated
USING (user_id = auth.uid() AND is_user());

-- Users can create bookings
CREATE POLICY "users_create_bookings"
ON bookings FOR INSERT
TO authenticated
WITH CHECK (
  user_id = auth.uid()
  AND is_manual = false
  AND is_user()
);

-- Admins can create manual bookings for their fields
CREATE POLICY "admin_create_manual_bookings"
ON bookings FOR INSERT
TO authenticated
WITH CHECK (
  is_manual = true
  AND created_by = auth.uid()
  AND is_admin()
  AND EXISTS (
    SELECT 1 FROM fields f
    WHERE f.id = bookings.field_id
    AND f.owner_id = auth.uid()
  )
);

-- Users can update their own bookings (cancel)
CREATE POLICY "users_update_own_bookings"
ON bookings FOR UPDATE
TO authenticated
USING (user_id = auth.uid() AND is_user())
WITH CHECK (user_id = auth.uid());

-- Admins can update bookings for their fields
CREATE POLICY "admin_update_field_bookings"
ON bookings FOR UPDATE
TO authenticated
USING (
  is_admin()
  AND EXISTS (
    SELECT 1 FROM fields f
    WHERE f.id = bookings.field_id
    AND f.owner_id = auth.uid()
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
USING (is_super_admin())
WITH CHECK (is_super_admin());

-- ============================================================================
-- STEP 8: ADMIN INVITATIONS TABLE POLICIES (FIXED)
-- ============================================================================

-- Super admin can manage all admin invitations
CREATE POLICY "super_admin_manage_invitations"
ON admin_invitations FOR ALL
TO authenticated
USING (is_super_admin())
WITH CHECK (is_super_admin());

-- ============================================================================
-- STEP 9: ADMIN FIELD ASSIGNMENTS TABLE POLICIES (FIXED)
-- ============================================================================

-- Super admin can manage all assignments
CREATE POLICY "super_admin_manage_assignments"
ON admin_field_assignments FOR ALL
TO authenticated
USING (is_super_admin())
WITH CHECK (is_super_admin());

-- Admins can view their own assignments
CREATE POLICY "admin_view_own_assignments"
ON admin_field_assignments FOR SELECT
TO authenticated
USING (admin_id = auth.uid() AND is_admin());

-- ============================================================================
-- VERIFICATION
-- ============================================================================
DO $$
DECLARE
  policy_count INTEGER;
  function_count INTEGER;
BEGIN
  SELECT COUNT(*) INTO policy_count FROM pg_policies WHERE schemaname = 'public';
  SELECT COUNT(*) INTO function_count FROM pg_proc p
    JOIN pg_namespace n ON p.pronamespace = n.oid
    WHERE n.nspname = 'public'
    AND p.proname IN ('get_current_user_role', 'is_super_admin', 'is_admin', 'is_user');

  RAISE NOTICE '========================================';
  RAISE NOTICE '✅ RLS POLICIES FIXED!';
  RAISE NOTICE '========================================';
  RAISE NOTICE 'Helper Functions: %', function_count;
  RAISE NOTICE 'Security Policies: %', policy_count;
  RAISE NOTICE '';
  RAISE NOTICE 'Fixed Issues:';
  RAISE NOTICE '  ✅ No more infinite recursion';
  RAISE NOTICE '  ✅ Role checking uses helper functions';
  RAISE NOTICE '  ✅ All policies recreated';
  RAISE NOTICE '';
  RAISE NOTICE '📝 Next: Test login with super admin';
  RAISE NOTICE '========================================';
END $$;
