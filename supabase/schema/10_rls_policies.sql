-- ============================================================================
-- ROW LEVEL SECURITY POLICIES
-- Sport Kick Database - Schema Part 10
-- ============================================================================

-- ============================================================================
-- ENABLE RLS ON ALL TABLES
-- ============================================================================

ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE cities ENABLE ROW LEVEL SECURITY;
ALTER TABLE sport_categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE fields ENABLE ROW LEVEL SECURITY;
ALTER TABLE bookings ENABLE ROW LEVEL SECURITY;
ALTER TABLE business_hours ENABLE ROW LEVEL SECURITY;
ALTER TABLE reviews ENABLE ROW LEVEL SECURITY;
ALTER TABLE admin_invitations ENABLE ROW LEVEL SECURITY;
ALTER TABLE admin_field_assignments ENABLE ROW LEVEL SECURITY;
ALTER TABLE login_activity ENABLE ROW LEVEL SECURITY;
ALTER TABLE platform_settings ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_fcm_tokens ENABLE ROW LEVEL SECURITY;
ALTER TABLE notifications ENABLE ROW LEVEL SECURITY;
ALTER TABLE recurring_bookings ENABLE ROW LEVEL SECURITY;

-- ============================================================================
-- PROFILES POLICIES
-- ============================================================================

CREATE POLICY "super_admin_view_all_profiles" ON profiles FOR SELECT
  TO authenticated USING (is_super_admin());

CREATE POLICY "users_view_own_profile" ON profiles FOR SELECT
  TO authenticated USING (id = auth.uid());

CREATE POLICY "users_update_own_profile" ON profiles FOR UPDATE
  TO authenticated USING (id = auth.uid()) WITH CHECK (id = auth.uid());

CREATE POLICY "super_admin_update_profiles" ON profiles FOR UPDATE
  TO authenticated USING (is_super_admin()) WITH CHECK (is_super_admin());

CREATE POLICY "super_admin_insert_profiles" ON profiles FOR INSERT
  TO authenticated WITH CHECK (is_super_admin());

CREATE POLICY "allow_profile_insert_on_signup" ON profiles FOR INSERT
  TO authenticated WITH CHECK (auth.uid() = id);

-- ============================================================================
-- CITIES POLICIES
-- ============================================================================

CREATE POLICY "everyone_view_active_cities" ON cities FOR SELECT
  TO authenticated USING (is_active = true);

CREATE POLICY "super_admin_manage_cities" ON cities FOR ALL
  TO authenticated USING (is_super_admin()) WITH CHECK (is_super_admin());

-- ============================================================================
-- SPORT CATEGORIES POLICIES
-- ============================================================================

CREATE POLICY "everyone_view_sport_categories" ON sport_categories FOR SELECT
  TO authenticated USING (true);

CREATE POLICY "super_admin_manage_categories" ON sport_categories FOR ALL
  TO authenticated USING (is_super_admin()) WITH CHECK (is_super_admin());

-- ============================================================================
-- FIELDS POLICIES
-- ============================================================================

CREATE POLICY "super_admin_view_all_fields" ON fields FOR SELECT
  TO authenticated USING (is_super_admin());

CREATE POLICY "admin_view_own_fields" ON fields FOR SELECT
  TO authenticated USING (owner_id = auth.uid() AND is_admin());

CREATE POLICY "users_view_active_fields" ON fields FOR SELECT
  TO authenticated USING (is_active = true AND is_user());

CREATE POLICY "super_admin_manage_fields" ON fields FOR ALL
  TO authenticated USING (is_super_admin()) WITH CHECK (is_super_admin());

CREATE POLICY "admin_update_own_fields" ON fields FOR UPDATE
  TO authenticated USING (owner_id = auth.uid() AND is_admin())
  WITH CHECK (owner_id = auth.uid());

-- ============================================================================
-- BOOKINGS POLICIES
-- ============================================================================

CREATE POLICY "super_admin_view_all_bookings" ON bookings FOR SELECT
  TO authenticated USING (is_super_admin());

CREATE POLICY "admin_view_field_bookings" ON bookings FOR SELECT
  TO authenticated USING (
    is_admin() AND EXISTS (
      SELECT 1 FROM fields f WHERE f.id = bookings.field_id AND f.owner_id = auth.uid()
    )
  );

CREATE POLICY "users_view_own_bookings" ON bookings FOR SELECT
  TO authenticated USING (user_id = auth.uid() AND is_user());

CREATE POLICY "users_create_bookings" ON bookings FOR INSERT
  TO authenticated WITH CHECK (user_id = auth.uid() AND is_manual = false AND is_user());

CREATE POLICY "admin_create_manual_bookings" ON bookings FOR INSERT
  TO authenticated WITH CHECK (
    is_manual = true AND created_by = auth.uid() AND is_admin() AND
    EXISTS (SELECT 1 FROM fields f WHERE f.id = bookings.field_id AND f.owner_id = auth.uid())
  );

CREATE POLICY "users_update_own_bookings" ON bookings FOR UPDATE
  TO authenticated USING (user_id = auth.uid() AND is_user())
  WITH CHECK (user_id = auth.uid());

CREATE POLICY "admin_update_field_bookings" ON bookings FOR UPDATE
  TO authenticated USING (
    is_admin() AND EXISTS (
      SELECT 1 FROM fields f WHERE f.id = bookings.field_id AND f.owner_id = auth.uid()
    )
  ) WITH CHECK (
    EXISTS (SELECT 1 FROM fields f WHERE f.id = bookings.field_id AND f.owner_id = auth.uid())
  );

CREATE POLICY "super_admin_update_bookings" ON bookings FOR UPDATE
  TO authenticated USING (is_super_admin()) WITH CHECK (is_super_admin());

-- ============================================================================
-- BUSINESS HOURS POLICIES
-- ============================================================================

CREATE POLICY "Anyone can view business hours" ON business_hours FOR SELECT USING (true);

CREATE POLICY "Field owners can manage their business hours" ON business_hours FOR ALL USING (
  field_id IN (SELECT id FROM fields WHERE owner_id = auth.uid())
);

CREATE POLICY "Super admins have full access to business hours" ON business_hours FOR ALL USING (
  EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'super_admin')
);

-- ============================================================================
-- REVIEWS POLICIES
-- ============================================================================

CREATE POLICY "Reviews are viewable by everyone" ON reviews FOR SELECT
  TO authenticated USING (true);

CREATE POLICY "Users can create reviews for their bookings" ON reviews FOR INSERT
  TO authenticated WITH CHECK (
    auth.uid() = user_id AND EXISTS (
      SELECT 1 FROM bookings WHERE id = booking_id AND user_id = auth.uid() AND status = 'completed'
    )
  );

CREATE POLICY "Users can update their own reviews" ON reviews FOR UPDATE
  TO authenticated USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete their own reviews" ON reviews FOR DELETE
  TO authenticated USING (auth.uid() = user_id);

CREATE POLICY "Super admins have full access to reviews" ON reviews FOR ALL
  TO authenticated USING (
    EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'super_admin')
  );

-- ============================================================================
-- ADMIN INVITATIONS POLICIES
-- ============================================================================

CREATE POLICY "super_admin_manage_invitations" ON admin_invitations FOR ALL
  TO authenticated USING (is_super_admin()) WITH CHECK (is_super_admin());

-- ============================================================================
-- ADMIN FIELD ASSIGNMENTS POLICIES
-- ============================================================================

CREATE POLICY "super_admin_manage_assignments" ON admin_field_assignments FOR ALL
  TO authenticated USING (is_super_admin()) WITH CHECK (is_super_admin());

CREATE POLICY "admin_view_own_assignments" ON admin_field_assignments FOR SELECT
  TO authenticated USING (admin_id = auth.uid() AND is_admin());

-- ============================================================================
-- LOGIN ACTIVITY POLICIES
-- ============================================================================

CREATE POLICY "Users can view own login activity" ON login_activity FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own login activity" ON login_activity FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Super admins can view all login activity" ON login_activity FOR SELECT USING (
  EXISTS (SELECT 1 FROM profiles WHERE profiles.id = auth.uid() AND profiles.role = 'super_admin')
);

-- ============================================================================
-- PLATFORM SETTINGS POLICIES
-- ============================================================================

CREATE POLICY "Anyone can read platform settings" ON platform_settings FOR SELECT USING (true);

CREATE POLICY "Super admins can update platform settings" ON platform_settings FOR UPDATE USING (
  EXISTS (SELECT 1 FROM profiles WHERE profiles.id = auth.uid() AND profiles.role = 'super_admin')
);

CREATE POLICY "Super admins can insert platform settings" ON platform_settings FOR INSERT WITH CHECK (
  EXISTS (SELECT 1 FROM profiles WHERE profiles.id = auth.uid() AND profiles.role = 'super_admin')
);

-- ============================================================================
-- USER FCM TOKENS POLICIES
-- ============================================================================

CREATE POLICY "Users can view own FCM tokens" ON user_fcm_tokens FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own FCM tokens" ON user_fcm_tokens FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own FCM tokens" ON user_fcm_tokens FOR UPDATE
  USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own FCM tokens" ON user_fcm_tokens FOR DELETE
  USING (auth.uid() = user_id);

CREATE POLICY "Super admins can view all FCM tokens" ON user_fcm_tokens FOR SELECT USING (
  EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND role = 'super_admin')
);

-- ============================================================================
-- NOTIFICATIONS POLICIES
-- ============================================================================

CREATE POLICY "Users can view own notifications" ON notifications FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can update own notifications" ON notifications FOR UPDATE
  USING (auth.uid() = user_id);

CREATE POLICY "Service role can insert notifications" ON notifications FOR INSERT
  WITH CHECK (true);

CREATE POLICY "Super admins can view all notifications" ON notifications FOR SELECT USING (
  EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND role = 'super_admin')
);

-- ============================================================================
-- RECURRING BOOKINGS POLICIES
-- ============================================================================

CREATE POLICY "Users view own recurring" ON recurring_bookings FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users create recurring" ON recurring_bookings FOR INSERT
  WITH CHECK (auth.uid() = user_id AND status = 'pending_approval');

CREATE POLICY "Users cancel own recurring" ON recurring_bookings FOR UPDATE
  USING (auth.uid() = user_id);

CREATE POLICY "Owners view field recurring" ON recurring_bookings FOR SELECT USING (
  field_id IN (SELECT id FROM fields WHERE owner_id = auth.uid())
);

CREATE POLICY "Owners manage recurring" ON recurring_bookings FOR UPDATE USING (
  field_id IN (SELECT id FROM fields WHERE owner_id = auth.uid())
);

CREATE POLICY "Super admins full access recurring" ON recurring_bookings FOR ALL USING (
  EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'super_admin')
);

-- ============================================================================
-- USER PREFERENCES RLS
-- ============================================================================
ALTER TABLE user_preferences ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own preferences" ON user_preferences FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own preferences" ON user_preferences FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own preferences" ON user_preferences FOR UPDATE
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete own preferences" ON user_preferences FOR DELETE
  USING (auth.uid() = user_id);

-- ============================================================================
-- GRANTS
-- ============================================================================

GRANT ALL ON profiles TO authenticated;
GRANT ALL ON cities TO authenticated;
GRANT ALL ON sport_categories TO authenticated;
GRANT ALL ON fields TO authenticated;
GRANT ALL ON bookings TO authenticated;
GRANT ALL ON business_hours TO authenticated;
GRANT ALL ON reviews TO authenticated;
GRANT ALL ON admin_invitations TO authenticated;
GRANT ALL ON admin_field_assignments TO authenticated;
GRANT ALL ON login_activity TO authenticated;
GRANT ALL ON platform_settings TO authenticated;
GRANT ALL ON user_fcm_tokens TO authenticated;
GRANT ALL ON notifications TO authenticated;
GRANT ALL ON recurring_bookings TO authenticated;
GRANT ALL ON user_preferences TO authenticated;
GRANT ALL ON user_fcm_tokens TO service_role;
GRANT ALL ON notifications TO service_role;
