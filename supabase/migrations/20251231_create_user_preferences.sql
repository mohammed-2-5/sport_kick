-- ============================================================================
-- Migration: Create user_preferences table
-- Date: 2025-12-31
-- Description: User preferences for notifications, theme, privacy settings
-- ============================================================================

-- ============================================================================
-- 1. CREATE TABLE
-- ============================================================================

CREATE TABLE IF NOT EXISTS user_preferences (
  -- Primary key links to auth.users
  user_id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,

  -- Appearance Settings
  theme_mode TEXT NOT NULL DEFAULT 'system'
    CHECK (theme_mode IN ('light', 'dark', 'system')),
  language TEXT NOT NULL DEFAULT 'en'
    CHECK (language IN ('en', 'ar')),

  -- Notifications - Master Toggle
  push_notifications_enabled BOOLEAN NOT NULL DEFAULT true,

  -- Notifications - Granular Filters
  booking_confirmation_notifications BOOLEAN NOT NULL DEFAULT true,
  booking_reminder_notifications BOOLEAN NOT NULL DEFAULT true,
  booking_status_notifications BOOLEAN NOT NULL DEFAULT true,
  field_owner_messages_notifications BOOLEAN NOT NULL DEFAULT true,

  -- Privacy Settings
  show_profile_picture BOOLEAN NOT NULL DEFAULT true,
  show_phone_number BOOLEAN NOT NULL DEFAULT false,
  show_email BOOLEAN NOT NULL DEFAULT false,

  -- Timestamps
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Add table comment
COMMENT ON TABLE user_preferences IS 'Stores user-specific preferences for appearance, notifications, and privacy';

-- ============================================================================
-- 2. INDEXES
-- ============================================================================

-- Index for theme filtering (if needed for analytics)
CREATE INDEX IF NOT EXISTS idx_user_preferences_theme_mode
  ON user_preferences(theme_mode);

-- Index for language filtering
CREATE INDEX IF NOT EXISTS idx_user_preferences_language
  ON user_preferences(language);

-- ============================================================================
-- 3. ENABLE ROW LEVEL SECURITY
-- ============================================================================

ALTER TABLE user_preferences ENABLE ROW LEVEL SECURITY;

-- ============================================================================
-- 4. RLS POLICIES
-- ============================================================================

-- Policy: Users can view their own preferences
CREATE POLICY "Users can view own preferences"
  ON user_preferences
  FOR SELECT
  USING (auth.uid() = user_id);

-- Policy: Users can insert their own preferences
CREATE POLICY "Users can insert own preferences"
  ON user_preferences
  FOR INSERT
  WITH CHECK (auth.uid() = user_id);

-- Policy: Users can update their own preferences
CREATE POLICY "Users can update own preferences"
  ON user_preferences
  FOR UPDATE
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

-- Policy: Users can delete their own preferences
CREATE POLICY "Users can delete own preferences"
  ON user_preferences
  FOR DELETE
  USING (auth.uid() = user_id);

-- ============================================================================
-- 5. TRIGGER FUNCTION AND TRIGGER FOR updated_at
-- ============================================================================

-- Function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_user_preferences_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger to auto-update updated_at timestamp
CREATE TRIGGER trigger_update_user_preferences_updated_at
  BEFORE UPDATE ON user_preferences
  FOR EACH ROW
  EXECUTE FUNCTION update_user_preferences_updated_at();

-- ============================================================================
-- 6. HELPER FUNCTION: Get or Create User Preferences
-- ============================================================================

CREATE OR REPLACE FUNCTION get_or_create_user_preferences(p_user_id UUID)
RETURNS user_preferences
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_prefs user_preferences;
BEGIN
  -- Try to get existing preferences
  SELECT * INTO v_prefs
  FROM user_preferences
  WHERE user_id = p_user_id;

  -- If not found, create default preferences
  IF NOT FOUND THEN
    INSERT INTO user_preferences (user_id)
    VALUES (p_user_id)
    RETURNING * INTO v_prefs;
  END IF;

  RETURN v_prefs;
END;
$$;

-- Grant execute permission
GRANT EXECUTE ON FUNCTION get_or_create_user_preferences(UUID) TO authenticated;

-- ============================================================================
-- 7. FUNCTION: Check Notification Preferences Before Sending
-- ============================================================================

CREATE OR REPLACE FUNCTION should_send_notification(
  p_user_id UUID,
  p_notification_type TEXT
)
RETURNS BOOLEAN
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_prefs user_preferences;
BEGIN
  -- Get user preferences
  SELECT * INTO v_prefs
  FROM user_preferences
  WHERE user_id = p_user_id;

  -- If no preferences found, assume all notifications enabled
  IF NOT FOUND THEN
    RETURN true;
  END IF;

  -- Check master toggle first
  IF NOT v_prefs.push_notifications_enabled THEN
    RETURN false;
  END IF;

  -- Check specific notification type
  CASE p_notification_type
    WHEN 'booking_confirmation' THEN
      RETURN v_prefs.booking_confirmation_notifications;
    WHEN 'booking_reminder' THEN
      RETURN v_prefs.booking_reminder_notifications;
    WHEN 'booking_status' THEN
      RETURN v_prefs.booking_status_notifications;
    WHEN 'field_owner_message' THEN
      RETURN v_prefs.field_owner_messages_notifications;
    ELSE
      -- Unknown type, default to enabled
      RETURN true;
  END CASE;
END;
$$;

-- Grant execute permission
GRANT EXECUTE ON FUNCTION should_send_notification(UUID, TEXT) TO authenticated;

-- ============================================================================
-- END OF MIGRATION
-- ============================================================================
