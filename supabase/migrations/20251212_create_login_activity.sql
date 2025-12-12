-- Login Activity Table
-- Tracks user login events for security monitoring

CREATE TABLE IF NOT EXISTS login_activity (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  timestamp TIMESTAMPTZ DEFAULT NOW(),
  ip_address TEXT,
  device_type TEXT, -- 'mobile', 'web', 'desktop'
  device_name TEXT,
  location TEXT, -- City, Country (optional, from IP)
  status TEXT DEFAULT 'success', -- 'success', 'failed', 'blocked'
  user_agent TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create index for faster queries
CREATE INDEX IF NOT EXISTS idx_login_activity_user_id ON login_activity(user_id);
CREATE INDEX IF NOT EXISTS idx_login_activity_timestamp ON login_activity(timestamp DESC);
CREATE INDEX IF NOT EXISTS idx_login_activity_status ON login_activity(status);

-- Enable RLS
ALTER TABLE login_activity ENABLE ROW LEVEL SECURITY;

-- Users can only view their own login activity
CREATE POLICY "Users can view own login activity"
  ON login_activity
  FOR SELECT
  USING (auth.uid() = user_id);

-- Users can insert their own login activity
CREATE POLICY "Users can insert own login activity"
  ON login_activity
  FOR INSERT
  WITH CHECK (auth.uid() = user_id);

-- Super admins can view all login activity
CREATE POLICY "Super admins can view all login activity"
  ON login_activity
  FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM profiles
      WHERE profiles.id = auth.uid()
      AND profiles.role = 'super_admin'
    )
  );

-- Add comment
COMMENT ON TABLE login_activity IS 'Stores login events for security monitoring and user session tracking';
