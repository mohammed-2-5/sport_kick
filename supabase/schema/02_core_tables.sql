-- ============================================================================
-- CORE TABLES
-- Sport Kick Database - Schema Part 2
-- Tables: profiles, cities, sport_categories, fields
-- ============================================================================

-- ============================================================================
-- TABLE: profiles (User Accounts)
-- ============================================================================
CREATE TABLE profiles (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email TEXT UNIQUE NOT NULL,
  full_name TEXT,
  phone TEXT,
  avatar_url TEXT,
  role TEXT NOT NULL DEFAULT 'user',
  is_active BOOLEAN DEFAULT true,
  password_changed BOOLEAN DEFAULT false,
  preferred_sports TEXT[] DEFAULT '{}',
  selected_city_id UUID,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),

  CONSTRAINT profiles_role_check CHECK (role IN ('user', 'admin', 'super_admin')),
  CONSTRAINT profiles_email_format CHECK (email ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$')
);

CREATE INDEX idx_profiles_role ON profiles(role);
CREATE INDEX idx_profiles_email ON profiles(email);
CREATE INDEX idx_profiles_is_active ON profiles(is_active);
CREATE INDEX idx_profiles_selected_city ON profiles(selected_city_id);

COMMENT ON TABLE profiles IS 'User accounts for all roles (super_admin, admin, user)';
COMMENT ON COLUMN profiles.role IS 'User role: user, admin, super_admin';
COMMENT ON COLUMN profiles.password_changed IS 'TRUE if admin has changed their default password';

-- ============================================================================
-- TABLE: cities (Supported Cities)
-- ============================================================================
CREATE TABLE cities (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name TEXT NOT NULL UNIQUE,
  name_ar TEXT,
  is_active BOOLEAN DEFAULT true,
  fields_count INTEGER DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_cities_is_active ON cities(is_active);
CREATE INDEX idx_cities_name ON cities(name);

COMMENT ON TABLE cities IS 'Supported cities where fields can be located';

-- Add FK from profiles to cities
ALTER TABLE profiles
ADD CONSTRAINT profiles_selected_city_fkey
FOREIGN KEY (selected_city_id) REFERENCES cities(id) ON DELETE SET NULL;

-- ============================================================================
-- TABLE: sport_categories
-- ============================================================================
CREATE TABLE sport_categories (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name TEXT NOT NULL UNIQUE,
  icon TEXT,
  description TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_sport_categories_name ON sport_categories(name);

COMMENT ON TABLE sport_categories IS 'Types of sports (Football, Basketball, etc.)';

-- ============================================================================
-- TABLE: fields (Football Fields/Courts)
-- ============================================================================
CREATE TABLE fields (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  owner_id UUID REFERENCES profiles(id) ON DELETE SET NULL,
  name TEXT NOT NULL,
  description TEXT,
  city_id UUID NOT NULL REFERENCES cities(id) ON DELETE RESTRICT,
  address TEXT,
  latitude NUMERIC(10, 8),
  longitude NUMERIC(11, 8),
  price_per_hour NUMERIC(10, 2) NOT NULL,
  currency TEXT DEFAULT 'EGP',
  sport_category_id UUID REFERENCES sport_categories(id) ON DELETE SET NULL,
  sport_type TEXT DEFAULT 'Football',
  size TEXT,
  surface_type TEXT,
  images TEXT[] DEFAULT '{}',
  amenities TEXT[] DEFAULT '{}',
  is_active BOOLEAN DEFAULT true,
  rating NUMERIC(3, 2) DEFAULT 0.0,
  total_bookings INTEGER DEFAULT 0,
  total_revenue NUMERIC(12, 2) DEFAULT 0.0,
  -- Payment fields (added in migration 20251212)
  payment_phone VARCHAR(20),
  payment_method VARCHAR(50) DEFAULT 'vodafone_cash',
  payment_instructions TEXT,
  -- Review stats
  average_rating DECIMAL(3,2) DEFAULT 0.0,
  total_reviews INTEGER DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),

  CONSTRAINT fields_rating_check CHECK (rating >= 0.0 AND rating <= 5.0),
  CONSTRAINT fields_price_check CHECK (price_per_hour > 0),
  CONSTRAINT fields_latitude_check CHECK (latitude >= -90 AND latitude <= 90),
  CONSTRAINT fields_longitude_check CHECK (longitude >= -180 AND longitude <= 180)
);

CREATE INDEX idx_fields_owner_id ON fields(owner_id);
CREATE INDEX idx_fields_city_id ON fields(city_id);
CREATE INDEX idx_fields_sport_category_id ON fields(sport_category_id);
CREATE INDEX idx_fields_is_active ON fields(is_active);
CREATE INDEX idx_fields_rating ON fields(rating DESC);
CREATE INDEX idx_fields_price ON fields(price_per_hour);
CREATE INDEX idx_fields_city_active ON fields(city_id, is_active);

COMMENT ON TABLE fields IS 'Football fields and sports facilities';
COMMENT ON COLUMN fields.payment_phone IS 'Phone for mobile wallet (Vodafone Cash, InstaPay)';
COMMENT ON COLUMN fields.payment_method IS 'Payment method: vodafone_cash, instapay';
