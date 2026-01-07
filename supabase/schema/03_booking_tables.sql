-- ============================================================================
-- BOOKING TABLES
-- Sport Kick Database - Schema Part 3
-- Tables: bookings, business_hours, recurring_bookings
-- ============================================================================

-- ============================================================================
-- TABLE: bookings
-- ============================================================================
CREATE TABLE bookings (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  field_id UUID NOT NULL REFERENCES fields(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  booking_date DATE NOT NULL,
  start_time TIME NOT NULL,
  end_time TIME NOT NULL,
  duration_hours INTEGER DEFAULT 1,
  status TEXT DEFAULT 'pending',
  total_price NUMERIC(10, 2) NOT NULL,
  currency TEXT DEFAULT 'EGP',
  notes TEXT,
  -- Invoice & Payment (added in migration 20251212)
  invoice_number VARCHAR(50),
  payment_status VARCHAR(20) DEFAULT 'pending',
  payment_proof_url TEXT,
  payment_uploaded_at TIMESTAMP WITH TIME ZONE,
  payment_verified_at TIMESTAMP WITH TIME ZONE,
  payment_rejection_reason TEXT,
  -- Status timestamps
  confirmed_at TIMESTAMP WITH TIME ZONE,
  canceled_at TIMESTAMP WITH TIME ZONE,
  cancellation_reason TEXT,
  -- Manual booking (walk-in)
  is_manual BOOLEAN DEFAULT false,
  created_by UUID REFERENCES profiles(id) ON DELETE SET NULL,
  customer_name TEXT,
  customer_phone TEXT,
  customer_email TEXT,
  -- Recurring booking link (added in migration 20251217)
  recurring_booking_id UUID,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),

  CONSTRAINT bookings_status_check CHECK (status IN ('pending', 'confirmed', 'canceled', 'completed')),
  CONSTRAINT bookings_price_check CHECK (total_price > 0),
  CONSTRAINT bookings_time_check CHECK (end_time > start_time)
);

CREATE INDEX idx_bookings_field_id ON bookings(field_id);
CREATE INDEX idx_bookings_user_id ON bookings(user_id);
CREATE INDEX idx_bookings_status ON bookings(status);
CREATE INDEX idx_bookings_date ON bookings(booking_date DESC);
CREATE INDEX idx_bookings_created_by ON bookings(created_by);
CREATE INDEX idx_bookings_is_manual ON bookings(is_manual);
CREATE INDEX idx_bookings_field_date ON bookings(field_id, booking_date);
CREATE INDEX idx_bookings_field_status ON bookings(field_id, status);
CREATE INDEX idx_bookings_payment_status ON bookings(payment_status);
CREATE INDEX idx_bookings_invoice_number ON bookings(invoice_number);
CREATE INDEX idx_bookings_recurring ON bookings(recurring_booking_id) WHERE recurring_booking_id IS NOT NULL;

COMMENT ON TABLE bookings IS 'Field bookings (user and manual/walk-in)';
COMMENT ON COLUMN bookings.is_manual IS 'TRUE if created by admin for walk-in customer';
COMMENT ON COLUMN bookings.payment_status IS 'pending, uploaded, verified, rejected';
COMMENT ON COLUMN bookings.invoice_number IS 'Format: INV-YYYYMMDD-XXXX';

-- ============================================================================
-- TABLE: business_hours
-- ============================================================================
CREATE TABLE business_hours (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  field_id UUID NOT NULL REFERENCES fields(id) ON DELETE CASCADE,
  day_of_week INTEGER NOT NULL CHECK (day_of_week >= 0 AND day_of_week <= 6),
  is_open BOOLEAN NOT NULL DEFAULT true,
  opening_time TIME,
  closing_time TIME,
  closes_next_day BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

  CONSTRAINT unique_field_day UNIQUE (field_id, day_of_week),
  CONSTRAINT valid_times CHECK (
    (is_open = false) OR
    (opening_time IS NOT NULL AND closing_time IS NOT NULL AND opening_time < closing_time)
  )
);

CREATE INDEX idx_business_hours_field_id ON business_hours(field_id);
CREATE INDEX idx_business_hours_day ON business_hours(day_of_week);
CREATE INDEX idx_business_hours_open ON business_hours(is_open) WHERE is_open = true;

COMMENT ON TABLE business_hours IS 'Field operating hours per day';
COMMENT ON COLUMN business_hours.day_of_week IS '0=Sunday, 1=Monday, ..., 6=Saturday';
COMMENT ON COLUMN business_hours.closes_next_day IS 'TRUE if closing_time is on next day (e.g., 12PM-2AM)';

-- ============================================================================
-- TABLE: recurring_bookings (Weekly Subscriptions)
-- ============================================================================
CREATE TABLE recurring_bookings (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  field_id UUID NOT NULL REFERENCES fields(id) ON DELETE CASCADE,
  day_of_week INTEGER NOT NULL CHECK (day_of_week BETWEEN 0 AND 6),
  start_time TIME NOT NULL,
  end_time TIME NOT NULL,
  duration_hours INTEGER NOT NULL DEFAULT 1 CHECK (duration_hours IN (1, 2)),
  status TEXT NOT NULL DEFAULT 'pending_approval'
    CHECK (status IN ('pending_approval', 'active', 'canceled', 'rejected')),
  started_at DATE,
  last_generated_date DATE,
  next_generation_date DATE,
  approved_by UUID REFERENCES profiles(id),
  approved_at TIMESTAMPTZ,
  rejection_reason TEXT,
  canceled_at TIMESTAMPTZ,
  canceled_by UUID REFERENCES profiles(id),
  cancellation_reason TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),

  CONSTRAINT valid_time_range CHECK (end_time > start_time)
);

-- Prevent duplicate active/pending subscriptions for same slot
CREATE UNIQUE INDEX idx_recurring_unique_slot
ON recurring_bookings(field_id, day_of_week, start_time)
WHERE status IN ('pending_approval', 'active');

CREATE INDEX idx_recurring_user ON recurring_bookings(user_id);
CREATE INDEX idx_recurring_field ON recurring_bookings(field_id);
CREATE INDEX idx_recurring_status ON recurring_bookings(status) WHERE status = 'active';
CREATE INDEX idx_recurring_next_gen ON recurring_bookings(next_generation_date) WHERE status = 'active';

COMMENT ON TABLE recurring_bookings IS 'Weekly subscription bookings';
COMMENT ON COLUMN recurring_bookings.day_of_week IS 'App convention: 0=Saturday, 1=Sunday, ..., 6=Friday';

-- Add FK from bookings to recurring_bookings
ALTER TABLE bookings
ADD CONSTRAINT bookings_recurring_fkey
FOREIGN KEY (recurring_booking_id) REFERENCES recurring_bookings(id) ON DELETE SET NULL;
