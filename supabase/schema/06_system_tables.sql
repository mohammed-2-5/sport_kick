-- ============================================================================
-- SYSTEM TABLES
-- Sport Kick Database - Schema Part 6
-- Tables: platform_settings, user_fcm_tokens, user_preferences
-- ============================================================================

-- ============================================================================
-- TABLE: platform_settings
-- ============================================================================
CREATE TABLE platform_settings (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  setting_key TEXT UNIQUE NOT NULL,
  setting_value JSONB NOT NULL,
  description TEXT,
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  updated_by UUID REFERENCES auth.users(id)
);

CREATE INDEX idx_platform_settings_key ON platform_settings(setting_key);

COMMENT ON TABLE platform_settings IS 'App-wide configuration managed by super admins';

-- ============================================================================
-- TABLE: user_fcm_tokens
-- ============================================================================
CREATE TABLE user_fcm_tokens (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  fcm_token TEXT NOT NULL,
  user_role TEXT NOT NULL DEFAULT 'user',
  device_info JSONB,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),

  CONSTRAINT user_fcm_tokens_user_unique UNIQUE(user_id)
);

CREATE INDEX idx_user_fcm_tokens_user_id ON user_fcm_tokens(user_id);
CREATE INDEX idx_user_fcm_tokens_user_role ON user_fcm_tokens(user_role);

COMMENT ON TABLE user_fcm_tokens IS 'Firebase Cloud Messaging tokens for push notifications';

-- ============================================================================
-- TABLE: user_preferences
-- ============================================================================
CREATE TABLE user_preferences (
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

CREATE INDEX idx_user_preferences_theme_mode ON user_preferences(theme_mode);
CREATE INDEX idx_user_preferences_language ON user_preferences(language);

COMMENT ON TABLE user_preferences IS 'User-specific preferences for appearance, notifications, and privacy';

-- ============================================================================
-- STORAGE BUCKET: payment_proofs
-- ============================================================================
INSERT INTO storage.buckets (id, name, public)
VALUES ('payment_proofs', 'payment_proofs', false)
ON CONFLICT (id) DO NOTHING;
