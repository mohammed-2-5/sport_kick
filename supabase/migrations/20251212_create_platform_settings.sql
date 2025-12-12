-- Platform Settings Table
-- Stores platform-wide configuration including default operating hours

CREATE TABLE IF NOT EXISTS platform_settings (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  setting_key TEXT UNIQUE NOT NULL,
  setting_value JSONB NOT NULL,
  description TEXT,
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  updated_by UUID REFERENCES auth.users(id)
);

-- Create index for faster lookups
CREATE INDEX IF NOT EXISTS idx_platform_settings_key ON platform_settings(setting_key);

-- Enable RLS
ALTER TABLE platform_settings ENABLE ROW LEVEL SECURITY;

-- Everyone can read platform settings
CREATE POLICY "Anyone can read platform settings"
  ON platform_settings
  FOR SELECT
  USING (true);

-- Only super admins can update platform settings
CREATE POLICY "Super admins can update platform settings"
  ON platform_settings
  FOR UPDATE
  USING (
    EXISTS (
      SELECT 1 FROM profiles
      WHERE profiles.id = auth.uid()
      AND profiles.role = 'super_admin'
    )
  );

-- Only super admins can insert platform settings
CREATE POLICY "Super admins can insert platform settings"
  ON platform_settings
  FOR INSERT
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM profiles
      WHERE profiles.id = auth.uid()
      AND profiles.role = 'super_admin'
    )
  );

-- Insert default operating hours
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
)
ON CONFLICT (setting_key) DO NOTHING;

-- Insert enforce operating hours setting
INSERT INTO platform_settings (setting_key, setting_value, description)
VALUES (
  'enforce_operating_hours',
  'true',
  'Whether to enforce operating hours for all fields'
)
ON CONFLICT (setting_key) DO NOTHING;

-- Add comment
COMMENT ON TABLE platform_settings IS 'Stores platform-wide configuration settings managed by super admins';
