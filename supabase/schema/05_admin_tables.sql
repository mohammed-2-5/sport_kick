-- ============================================================================
-- ADMIN TABLES
-- Sport Kick Database - Schema Part 5
-- Tables: admin_invitations, admin_field_assignments, login_activity
-- ============================================================================

-- ============================================================================
-- TABLE: admin_invitations
-- ============================================================================
CREATE TABLE admin_invitations (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  email TEXT NOT NULL,
  default_password TEXT NOT NULL,
  full_name TEXT NOT NULL,
  phone TEXT,
  created_by UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  admin_id UUID REFERENCES profiles(id) ON DELETE SET NULL,
  status TEXT DEFAULT 'pending',
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  accepted_at TIMESTAMP WITH TIME ZONE,

  CONSTRAINT admin_invitations_status_check CHECK (status IN ('pending', 'accepted', 'expired'))
);

CREATE INDEX idx_admin_invitations_email ON admin_invitations(email);
CREATE INDEX idx_admin_invitations_status ON admin_invitations(status);
CREATE INDEX idx_admin_invitations_created_by ON admin_invitations(created_by);

COMMENT ON TABLE admin_invitations IS 'Admin account creation tracking';

-- ============================================================================
-- TABLE: admin_field_assignments
-- ============================================================================
CREATE TABLE admin_field_assignments (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  admin_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  field_id UUID NOT NULL REFERENCES fields(id) ON DELETE CASCADE,
  assigned_by UUID NOT NULL REFERENCES profiles(id) ON DELETE NO ACTION,
  notes TEXT,
  assigned_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),

  CONSTRAINT unique_admin_field UNIQUE (admin_id, field_id)
);

CREATE INDEX idx_admin_assignments_admin ON admin_field_assignments(admin_id);
CREATE INDEX idx_admin_assignments_field ON admin_field_assignments(field_id);
CREATE INDEX idx_admin_assignments_assigned_by ON admin_field_assignments(assigned_by);

COMMENT ON TABLE admin_field_assignments IS 'Audit trail for admin-to-field assignments';

-- ============================================================================
-- TABLE: login_activity
-- ============================================================================
CREATE TABLE login_activity (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  timestamp TIMESTAMPTZ DEFAULT NOW(),
  ip_address TEXT,
  device_type TEXT,
  device_name TEXT,
  location TEXT,
  status TEXT DEFAULT 'success',
  user_agent TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_login_activity_user_id ON login_activity(user_id);
CREATE INDEX idx_login_activity_timestamp ON login_activity(timestamp DESC);
CREATE INDEX idx_login_activity_status ON login_activity(status);

COMMENT ON TABLE login_activity IS 'Security and audit logging';
COMMENT ON COLUMN login_activity.status IS 'success, failed, blocked';
