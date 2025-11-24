-- ============================================================================
-- FRESH DATABASE SCHEMA - Sport Kick Platform
-- ============================================================================
-- Complete database schema for 3-role architecture:
-- - Super Admin: Platform owner (full control)
-- - Admin: Field owner (manages assigned fields)
-- - User: Customer (books fields)
-- ============================================================================
-- Version: 2.0
-- Date: November 24, 2025
-- ============================================================================

-- ============================================================================
-- EXTENSIONS
-- ============================================================================
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ============================================================================
-- TABLE 1: PROFILES (User Accounts)
-- ============================================================================
CREATE TABLE profiles (
  -- Identity
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email TEXT UNIQUE NOT NULL,

  -- Personal Information
  full_name TEXT,
  phone TEXT,
  avatar_url TEXT,

  -- Role & Status
  role TEXT NOT NULL DEFAULT 'user',
  is_active BOOLEAN DEFAULT true,
  password_changed BOOLEAN DEFAULT false, -- Track if admin changed default password

  -- Preferences
  preferred_sports TEXT[] DEFAULT '{}',
  selected_city_id UUID, -- Will reference cities table

  -- Timestamps
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),

  -- Constraints
  CONSTRAINT profiles_role_check CHECK (role IN ('user', 'admin', 'super_admin')),
  CONSTRAINT profiles_email_format CHECK (email ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$')
);

-- Indexes
CREATE INDEX idx_profiles_role ON profiles(role);
CREATE INDEX idx_profiles_email ON profiles(email);
CREATE INDEX idx_profiles_is_active ON profiles(is_active);
CREATE INDEX idx_profiles_selected_city ON profiles(selected_city_id);

-- Comments
COMMENT ON TABLE profiles IS 'User accounts for all roles (super_admin, admin, user)';
COMMENT ON COLUMN profiles.role IS 'User role: user (customer), admin (field owner), super_admin (platform owner)';
COMMENT ON COLUMN profiles.is_active IS 'Account status - can be deactivated by super admin';
COMMENT ON COLUMN profiles.password_changed IS 'TRUE if admin has changed their default password';
COMMENT ON COLUMN profiles.selected_city_id IS 'User''s selected city for browsing fields';

-- ============================================================================
-- TABLE 2: CITIES (Supported Cities)
-- ============================================================================
CREATE TABLE cities (
  -- Identity
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),

  -- Information
  name TEXT NOT NULL UNIQUE,
  name_ar TEXT, -- Arabic name (for future i18n)

  -- Status
  is_active BOOLEAN DEFAULT true,

  -- Cached Counts (updated by triggers)
  fields_count INTEGER DEFAULT 0,

  -- Timestamps
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Indexes
CREATE INDEX idx_cities_is_active ON cities(is_active);
CREATE INDEX idx_cities_name ON cities(name);

-- Comments
COMMENT ON TABLE cities IS 'Supported cities where fields can be located';
COMMENT ON COLUMN cities.fields_count IS 'Cached count of active fields in this city';

-- Now add foreign key for selected_city_id
ALTER TABLE profiles
ADD CONSTRAINT profiles_selected_city_fkey
FOREIGN KEY (selected_city_id) REFERENCES cities(id) ON DELETE SET NULL;

-- ============================================================================
-- TABLE 3: SPORT CATEGORIES
-- ============================================================================
CREATE TABLE sport_categories (
  -- Identity
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),

  -- Information
  name TEXT NOT NULL UNIQUE,
  icon TEXT, -- Icon name for UI
  description TEXT,

  -- Timestamps
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Index
CREATE INDEX idx_sport_categories_name ON sport_categories(name);

-- Comments
COMMENT ON TABLE sport_categories IS 'Types of sports (Football, Basketball, etc.)';

-- ============================================================================
-- TABLE 4: FIELDS (Football Fields/Courts)
-- ============================================================================
CREATE TABLE fields (
  -- Identity
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),

  -- Ownership
  owner_id UUID REFERENCES profiles(id) ON DELETE SET NULL,

  -- Basic Information
  name TEXT NOT NULL,
  description TEXT,

  -- Location
  city_id UUID NOT NULL REFERENCES cities(id) ON DELETE RESTRICT,
  address TEXT,
  latitude NUMERIC(10, 8),
  longitude NUMERIC(11, 8),

  -- Pricing
  price_per_hour NUMERIC(10, 2) NOT NULL,
  currency TEXT DEFAULT 'EGP',

  -- Sport Details
  sport_category_id UUID REFERENCES sport_categories(id) ON DELETE SET NULL,
  sport_type TEXT DEFAULT 'Football', -- Legacy, consider removing later
  size TEXT, -- e.g., "5-a-side", "7-a-side", "11-a-side"
  surface_type TEXT, -- e.g., "Grass", "Artificial Turf", "Indoor"

  -- Media & Features
  images TEXT[] DEFAULT '{}',
  amenities TEXT[] DEFAULT '{}', -- e.g., ["Parking", "Changing Rooms", "Lighting"]

  -- Status & Stats
  is_active BOOLEAN DEFAULT true,
  rating NUMERIC(3, 2) DEFAULT 0.0,
  total_bookings INTEGER DEFAULT 0,
  total_revenue NUMERIC(12, 2) DEFAULT 0.0, -- Track revenue

  -- Timestamps
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),

  -- Constraints
  CONSTRAINT fields_rating_check CHECK (rating >= 0.0 AND rating <= 5.0),
  CONSTRAINT fields_price_check CHECK (price_per_hour > 0),
  CONSTRAINT fields_latitude_check CHECK (latitude >= -90 AND latitude <= 90),
  CONSTRAINT fields_longitude_check CHECK (longitude >= -180 AND longitude <= 180)
);

-- Indexes
CREATE INDEX idx_fields_owner_id ON fields(owner_id);
CREATE INDEX idx_fields_city_id ON fields(city_id);
CREATE INDEX idx_fields_sport_category_id ON fields(sport_category_id);
CREATE INDEX idx_fields_is_active ON fields(is_active);
CREATE INDEX idx_fields_rating ON fields(rating DESC);
CREATE INDEX idx_fields_price ON fields(price_per_hour);
CREATE INDEX idx_fields_city_active ON fields(city_id, is_active); -- Composite for user queries

-- Comments
COMMENT ON TABLE fields IS 'Football fields and sports facilities';
COMMENT ON COLUMN fields.owner_id IS 'Admin user who owns/manages this field';
COMMENT ON COLUMN fields.city_id IS 'City where this field is located';
COMMENT ON COLUMN fields.total_revenue IS 'Cached total revenue from confirmed bookings';

-- ============================================================================
-- TABLE 5: BOOKINGS
-- ============================================================================
CREATE TABLE bookings (
  -- Identity
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),

  -- References
  field_id UUID NOT NULL REFERENCES fields(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,

  -- Booking Details
  booking_date DATE NOT NULL,
  start_time TIME NOT NULL,
  end_time TIME NOT NULL,

  -- Status
  status TEXT DEFAULT 'pending',

  -- Pricing
  total_price NUMERIC(10, 2) NOT NULL,
  currency TEXT DEFAULT 'EGP',

  -- Notes
  notes TEXT,

  -- Status Timestamps
  confirmed_at TIMESTAMP WITH TIME ZONE,
  canceled_at TIMESTAMP WITH TIME ZONE,
  cancellation_reason TEXT,

  -- Manual Booking (Walk-in Customers)
  is_manual BOOLEAN DEFAULT false, -- TRUE if created by admin for walk-in
  created_by UUID REFERENCES profiles(id) ON DELETE SET NULL, -- Admin who created manual booking
  customer_name TEXT, -- For manual bookings (walk-in customer name)
  customer_phone TEXT, -- For manual bookings (walk-in customer phone)
  customer_email TEXT, -- For manual bookings (walk-in customer email, optional)

  -- Timestamps
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),

  -- Constraints
  CONSTRAINT bookings_status_check CHECK (status IN ('pending', 'confirmed', 'canceled', 'completed')),
  CONSTRAINT bookings_price_check CHECK (total_price > 0),
  CONSTRAINT bookings_time_check CHECK (end_time > start_time),
  CONSTRAINT bookings_date_check CHECK (booking_date >= CURRENT_DATE - INTERVAL '1 day') -- Allow same-day bookings
);

-- Indexes
CREATE INDEX idx_bookings_field_id ON bookings(field_id);
CREATE INDEX idx_bookings_user_id ON bookings(user_id);
CREATE INDEX idx_bookings_status ON bookings(status);
CREATE INDEX idx_bookings_date ON bookings(booking_date DESC);
CREATE INDEX idx_bookings_created_by ON bookings(created_by);
CREATE INDEX idx_bookings_is_manual ON bookings(is_manual);
CREATE INDEX idx_bookings_field_date ON bookings(field_id, booking_date); -- Composite for availability checks
CREATE INDEX idx_bookings_field_status ON bookings(field_id, status); -- Composite for admin dashboard

-- Comments
COMMENT ON TABLE bookings IS 'Field bookings (both user bookings and admin manual bookings)';
COMMENT ON COLUMN bookings.is_manual IS 'TRUE if this booking was created by admin for walk-in customer';
COMMENT ON COLUMN bookings.created_by IS 'Admin who created this manual booking (NULL for user bookings)';
COMMENT ON COLUMN bookings.customer_name IS 'Walk-in customer name (for manual bookings only)';
COMMENT ON COLUMN bookings.customer_phone IS 'Walk-in customer phone (for manual bookings only)';

-- ============================================================================
-- TABLE 6: ADMIN INVITATIONS (Track Admin Creation)
-- ============================================================================
CREATE TABLE admin_invitations (
  -- Identity
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),

  -- Invitation Details
  email TEXT NOT NULL,
  default_password TEXT NOT NULL, -- Store hashed or send via email
  full_name TEXT NOT NULL,
  phone TEXT,

  -- Creator
  created_by UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,

  -- Status
  admin_id UUID REFERENCES profiles(id) ON DELETE SET NULL, -- Set after admin account created
  status TEXT DEFAULT 'pending',

  -- Timestamps
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  accepted_at TIMESTAMP WITH TIME ZONE,

  -- Constraints
  CONSTRAINT admin_invitations_status_check CHECK (status IN ('pending', 'accepted', 'expired'))
);

-- Indexes
CREATE INDEX idx_admin_invitations_email ON admin_invitations(email);
CREATE INDEX idx_admin_invitations_status ON admin_invitations(status);
CREATE INDEX idx_admin_invitations_created_by ON admin_invitations(created_by);

-- Comments
COMMENT ON TABLE admin_invitations IS 'Track admin account creation by super admin';
COMMENT ON COLUMN admin_invitations.default_password IS 'Default password for new admin (shown once)';
COMMENT ON COLUMN admin_invitations.status IS 'pending: not logged in yet, accepted: logged in and changed password';

-- ============================================================================
-- TABLE 7: ADMIN FIELD ASSIGNMENTS (Audit Trail)
-- ============================================================================
CREATE TABLE admin_field_assignments (
  -- Identity
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),

  -- Assignment
  admin_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  field_id UUID NOT NULL REFERENCES fields(id) ON DELETE CASCADE,

  -- Metadata
  assigned_by UUID NOT NULL REFERENCES profiles(id), -- Super admin who assigned
  notes TEXT,

  -- Timestamps
  assigned_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),

  -- Constraints
  UNIQUE(admin_id, field_id) -- Admin can't be assigned same field twice
);

-- Indexes
CREATE INDEX idx_admin_field_admin ON admin_field_assignments(admin_id);
CREATE INDEX idx_admin_field_field ON admin_field_assignments(field_id);
CREATE INDEX idx_admin_field_assigned_by ON admin_field_assignments(assigned_by);

-- Comments
COMMENT ON TABLE admin_field_assignments IS 'Track which admin manages which fields (audit trail)';
COMMENT ON COLUMN admin_field_assignments.assigned_by IS 'Super admin who made this assignment';

-- ============================================================================
-- VIEWS
-- ============================================================================

-- View 1: User Bookings with Details (for end users and manual bookings)
DROP VIEW IF EXISTS user_bookings_with_details CASCADE;
CREATE VIEW user_bookings_with_details AS
SELECT
  b.id,
  b.field_id,
  b.user_id,
  b.booking_date,
  b.start_time,
  b.end_time,
  b.status,
  b.total_price,
  b.currency,
  b.notes,
  b.confirmed_at,
  b.canceled_at,
  b.cancellation_reason,
  b.is_manual,
  b.created_by,
  b.customer_name,
  b.customer_phone,
  b.customer_email,
  b.created_at,
  b.updated_at,
  -- Field details
  f.name as field_name,
  f.images[1] as field_image,
  f.address as field_address,
  f.city_id as field_city_id,
  c.name as field_city_name,
  -- User details (for normal bookings)
  p.full_name as user_name,
  p.email as user_email,
  p.phone as user_phone
FROM bookings b
LEFT JOIN fields f ON f.id = b.field_id
LEFT JOIN cities c ON c.id = f.city_id
LEFT JOIN profiles p ON p.id = b.user_id;

COMMENT ON VIEW user_bookings_with_details IS 'Complete booking information with field and user details';

-- View 2: Admin Statistics (for each admin/field owner)
DROP VIEW IF EXISTS admin_statistics CASCADE;
CREATE VIEW admin_statistics AS
SELECT
  p.id as admin_id,
  p.email,
  p.full_name,
  p.phone,
  -- Field counts
  COUNT(DISTINCT f.id) as fields_count,
  COUNT(DISTINCT CASE WHEN f.is_active THEN f.id END) as active_fields_count,
  -- Booking counts
  COUNT(DISTINCT b.id) as total_bookings,
  COUNT(DISTINCT CASE WHEN b.status = 'pending' THEN b.id END) as pending_bookings,
  COUNT(DISTINCT CASE WHEN b.status = 'confirmed' THEN b.id END) as confirmed_bookings,
  COUNT(DISTINCT CASE WHEN b.status = 'canceled' THEN b.id END) as canceled_bookings,
  COUNT(DISTINCT CASE WHEN b.status = 'completed' THEN b.id END) as completed_bookings,
  -- Manual bookings
  COUNT(DISTINCT CASE WHEN b.is_manual THEN b.id END) as manual_bookings_count,
  -- Revenue
  COALESCE(SUM(CASE WHEN b.status = 'confirmed' THEN b.total_price ELSE 0 END), 0) as total_revenue,
  COALESCE(SUM(CASE WHEN b.status = 'completed' THEN b.total_price ELSE 0 END), 0) as completed_revenue,
  -- Avg rating
  AVG(f.rating) as avg_field_rating
FROM profiles p
LEFT JOIN fields f ON f.owner_id = p.id
LEFT JOIN bookings b ON b.field_id = f.id
WHERE p.role IN ('admin', 'super_admin')
GROUP BY p.id, p.email, p.full_name, p.phone;

COMMENT ON VIEW admin_statistics IS 'Statistics for each field owner/admin';

-- View 3: Platform Statistics (for super admin)
DROP VIEW IF EXISTS platform_statistics CASCADE;
CREATE VIEW platform_statistics AS
SELECT
  -- User counts
  (SELECT COUNT(*) FROM profiles WHERE role = 'user' AND is_active = true) as total_users,
  (SELECT COUNT(*) FROM profiles WHERE role = 'user' AND created_at >= CURRENT_DATE - INTERVAL '30 days') as new_users_this_month,

  -- Admin counts
  (SELECT COUNT(*) FROM profiles WHERE role = 'admin' AND is_active = true) as total_admins,

  -- Field counts
  (SELECT COUNT(*) FROM fields WHERE is_active = true) as active_fields,
  (SELECT COUNT(*) FROM fields) as total_fields,

  -- City counts
  (SELECT COUNT(DISTINCT city_id) FROM fields WHERE is_active = true) as cities_with_fields,
  (SELECT COUNT(*) FROM cities WHERE is_active = true) as active_cities,

  -- Booking counts
  (SELECT COUNT(*) FROM bookings) as total_bookings,
  (SELECT COUNT(*) FROM bookings WHERE status = 'pending') as pending_bookings,
  (SELECT COUNT(*) FROM bookings WHERE status = 'confirmed') as confirmed_bookings,
  (SELECT COUNT(*) FROM bookings WHERE status = 'completed') as completed_bookings,
  (SELECT COUNT(*) FROM bookings WHERE is_manual = true) as manual_bookings,

  -- Booking counts this month
  (SELECT COUNT(*) FROM bookings WHERE created_at >= CURRENT_DATE - INTERVAL '30 days') as bookings_this_month,

  -- Revenue
  (SELECT COALESCE(SUM(total_price), 0) FROM bookings WHERE status IN ('confirmed', 'completed')) as total_revenue,
  (SELECT COALESCE(SUM(total_price), 0) FROM bookings WHERE status IN ('confirmed', 'completed') AND created_at >= CURRENT_DATE - INTERVAL '30 days') as revenue_this_month;

COMMENT ON VIEW platform_statistics IS 'Platform-wide statistics for super admin dashboard';

-- ============================================================================
-- SUCCESS MESSAGE
-- ============================================================================
DO $$
BEGIN
  RAISE NOTICE '========================================';
  RAISE NOTICE '✅ FRESH SCHEMA CREATED SUCCESSFULLY!';
  RAISE NOTICE '========================================';
  RAISE NOTICE 'Tables created:';
  RAISE NOTICE '  1. profiles (user accounts)';
  RAISE NOTICE '  2. cities (supported cities)';
  RAISE NOTICE '  3. sport_categories (sports types)';
  RAISE NOTICE '  4. fields (facilities)';
  RAISE NOTICE '  5. bookings (reservations)';
  RAISE NOTICE '  6. admin_invitations (admin creation tracking)';
  RAISE NOTICE '  7. admin_field_assignments (audit trail)';
  RAISE NOTICE '';
  RAISE NOTICE 'Views created:';
  RAISE NOTICE '  1. user_bookings_with_details';
  RAISE NOTICE '  2. admin_statistics';
  RAISE NOTICE '  3. platform_statistics';
  RAISE NOTICE '========================================';
  RAISE NOTICE '📝 Next Step: Run 03_INITIALIZE_DATA.sql';
  RAISE NOTICE '========================================';
END $$;
