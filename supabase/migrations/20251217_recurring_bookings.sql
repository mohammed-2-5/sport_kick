-- ============================================================================
-- RECURRING BOOKINGS FEATURE
-- ============================================================================
-- This migration creates the recurring_bookings table and all associated
-- functions, triggers, and policies for the recurring booking feature.
-- Works with Supabase FREE tier (no pg_cron required).
-- ============================================================================

-- ============================================================================
-- 1. CREATE RECURRING_BOOKINGS TABLE
-- ============================================================================

CREATE TABLE IF NOT EXISTS recurring_bookings (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),

  -- Relationships
  user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  field_id UUID NOT NULL REFERENCES fields(id) ON DELETE CASCADE,

  -- Schedule Definition
  day_of_week INTEGER NOT NULL CHECK (day_of_week BETWEEN 0 AND 6), -- 0=Saturday
  start_time TIME NOT NULL,
  end_time TIME NOT NULL,
  duration_hours INTEGER NOT NULL DEFAULT 1 CHECK (duration_hours IN (1, 2)),

  -- Status: pending_approval, active, canceled, rejected
  status TEXT NOT NULL DEFAULT 'pending_approval'
    CHECK (status IN ('pending_approval', 'active', 'canceled', 'rejected')),

  -- Lifecycle Dates
  started_at DATE,
  last_generated_date DATE,
  next_generation_date DATE,

  -- Approval Workflow
  approved_by UUID REFERENCES profiles(id),
  approved_at TIMESTAMPTZ,
  rejection_reason TEXT,

  -- Cancellation
  canceled_at TIMESTAMPTZ,
  canceled_by UUID REFERENCES profiles(id),
  cancellation_reason TEXT,

  -- Audit
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),

  -- Constraints
  CONSTRAINT valid_time_range CHECK (end_time > start_time)
);

-- Prevent duplicate active/pending subscriptions for same slot
CREATE UNIQUE INDEX IF NOT EXISTS idx_recurring_unique_slot
ON recurring_bookings(field_id, day_of_week, start_time)
WHERE status IN ('pending_approval', 'active');

-- Performance indexes
CREATE INDEX IF NOT EXISTS idx_recurring_user ON recurring_bookings(user_id);
CREATE INDEX IF NOT EXISTS idx_recurring_field ON recurring_bookings(field_id);
CREATE INDEX IF NOT EXISTS idx_recurring_status ON recurring_bookings(status) WHERE status = 'active';
CREATE INDEX IF NOT EXISTS idx_recurring_next_gen ON recurring_bookings(next_generation_date) WHERE status = 'active';

-- Auto-update timestamp trigger
CREATE OR REPLACE FUNCTION update_recurring_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS set_recurring_updated_at ON recurring_bookings;
CREATE TRIGGER set_recurring_updated_at
  BEFORE UPDATE ON recurring_bookings
  FOR EACH ROW EXECUTE FUNCTION update_recurring_updated_at();


-- ============================================================================
-- 2. MODIFY BOOKINGS TABLE
-- ============================================================================

-- Add recurring_booking_id column if not exists
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'bookings' AND column_name = 'recurring_booking_id'
  ) THEN
    ALTER TABLE bookings
    ADD COLUMN recurring_booking_id UUID REFERENCES recurring_bookings(id) ON DELETE SET NULL;
  END IF;
END $$;

-- Index for finding recurring bookings
CREATE INDEX IF NOT EXISTS idx_bookings_recurring
ON bookings(recurring_booking_id)
WHERE recurring_booking_id IS NOT NULL;


-- ============================================================================
-- 3. ROW LEVEL SECURITY POLICIES
-- ============================================================================

ALTER TABLE recurring_bookings ENABLE ROW LEVEL SECURITY;

-- Drop existing policies if they exist
DROP POLICY IF EXISTS "Users view own recurring" ON recurring_bookings;
DROP POLICY IF EXISTS "Users create recurring" ON recurring_bookings;
DROP POLICY IF EXISTS "Users cancel own recurring" ON recurring_bookings;
DROP POLICY IF EXISTS "Owners view field recurring" ON recurring_bookings;
DROP POLICY IF EXISTS "Owners manage recurring" ON recurring_bookings;
DROP POLICY IF EXISTS "Super admins full access recurring" ON recurring_bookings;

-- Users can view their own recurring bookings
CREATE POLICY "Users view own recurring" ON recurring_bookings
  FOR SELECT USING (auth.uid() = user_id);

-- Users can create recurring booking requests
CREATE POLICY "Users create recurring" ON recurring_bookings
  FOR INSERT WITH CHECK (auth.uid() = user_id AND status = 'pending_approval');

-- Users can cancel their own active recurring bookings
CREATE POLICY "Users cancel own recurring" ON recurring_bookings
  FOR UPDATE USING (auth.uid() = user_id);

-- Owners can view recurring bookings for their fields
CREATE POLICY "Owners view field recurring" ON recurring_bookings
  FOR SELECT USING (
    field_id IN (SELECT id FROM fields WHERE owner_id = auth.uid())
  );

-- Owners can approve/reject/cancel recurring bookings for their fields
CREATE POLICY "Owners manage recurring" ON recurring_bookings
  FOR UPDATE USING (
    field_id IN (SELECT id FROM fields WHERE owner_id = auth.uid())
  );

-- Super admins have full access
CREATE POLICY "Super admins full access recurring" ON recurring_bookings
  FOR ALL USING (
    EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'super_admin')
  );


-- ============================================================================
-- 4. RPC FUNCTIONS - USER ACTIONS
-- ============================================================================

-- Create a recurring booking request
CREATE OR REPLACE FUNCTION create_recurring_booking_request(
  p_field_id UUID,
  p_day_of_week INTEGER,
  p_start_time TIME,
  p_duration_hours INTEGER DEFAULT 1
) RETURNS UUID AS $$
DECLARE
  v_end_time TIME;
  v_recurring_id UUID;
  v_field_exists BOOLEAN;
  v_slot_available BOOLEAN;
  v_within_business_hours BOOLEAN;
BEGIN
  -- Validate duration
  IF p_duration_hours NOT IN (1, 2) THEN
    RAISE EXCEPTION 'Duration must be 1 or 2 hours';
  END IF;

  -- Calculate end time
  v_end_time := p_start_time + (p_duration_hours || ' hours')::INTERVAL;

  -- Check field exists and is active
  SELECT EXISTS(SELECT 1 FROM fields WHERE id = p_field_id AND is_active = true)
  INTO v_field_exists;

  IF NOT v_field_exists THEN
    RAISE EXCEPTION 'Field not found or inactive';
  END IF;

  -- Check slot is within business hours
  SELECT EXISTS(
    SELECT 1 FROM business_hours
    WHERE field_id = p_field_id
      AND day_of_week = p_day_of_week
      AND is_open = true
      AND open_time <= p_start_time
      AND close_time >= v_end_time
  ) INTO v_within_business_hours;

  IF NOT v_within_business_hours THEN
    RAISE EXCEPTION 'Requested time is outside business hours';
  END IF;

  -- Check no existing active/pending recurring for this slot
  SELECT NOT EXISTS(
    SELECT 1 FROM recurring_bookings
    WHERE field_id = p_field_id
      AND day_of_week = p_day_of_week
      AND start_time = p_start_time
      AND status IN ('pending_approval', 'active')
  ) INTO v_slot_available;

  IF NOT v_slot_available THEN
    RAISE EXCEPTION 'This slot already has an active recurring booking';
  END IF;

  -- Create the request
  INSERT INTO recurring_bookings (
    user_id, field_id, day_of_week, start_time, end_time, duration_hours, status
  ) VALUES (
    auth.uid(), p_field_id, p_day_of_week, p_start_time, v_end_time, p_duration_hours, 'pending_approval'
  ) RETURNING id INTO v_recurring_id;

  RETURN v_recurring_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Cancel a recurring booking (user)
CREATE OR REPLACE FUNCTION cancel_recurring_booking(
  p_recurring_id UUID,
  p_reason TEXT DEFAULT 'user_request'
) RETURNS BOOLEAN AS $$
DECLARE
  v_recurring RECORD;
  v_one_week_from_now DATE;
BEGIN
  -- Get the recurring booking
  SELECT * INTO v_recurring FROM recurring_bookings
  WHERE id = p_recurring_id AND user_id = auth.uid();

  IF v_recurring IS NULL THEN
    RAISE EXCEPTION 'Recurring booking not found or unauthorized';
  END IF;

  IF v_recurring.status != 'active' THEN
    RAISE EXCEPTION 'Can only cancel active subscriptions';
  END IF;

  v_one_week_from_now := CURRENT_DATE + INTERVAL '7 days';

  -- Update the recurring booking
  UPDATE recurring_bookings SET
    status = 'canceled',
    canceled_at = NOW(),
    canceled_by = auth.uid(),
    cancellation_reason = p_reason
  WHERE id = p_recurring_id;

  -- Cancel all future pending bookings (respecting 1 week notice)
  UPDATE bookings SET
    status = 'canceled'
  WHERE recurring_booking_id = p_recurring_id
    AND status = 'pending'
    AND date >= v_one_week_from_now;

  RETURN TRUE;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Get user's recurring bookings
CREATE OR REPLACE FUNCTION get_my_recurring_bookings()
RETURNS TABLE (
  id UUID,
  field_id UUID,
  field_name TEXT,
  field_image_url TEXT,
  city_name TEXT,
  day_of_week INTEGER,
  start_time TIME,
  end_time TIME,
  duration_hours INTEGER,
  price_per_booking DECIMAL,
  status TEXT,
  rejection_reason TEXT,
  started_at DATE,
  created_at TIMESTAMPTZ,
  next_booking_date DATE,
  next_booking_paid BOOLEAN,
  total_bookings_count BIGINT,
  completed_bookings_count BIGINT
) AS $$
BEGIN
  -- First, cleanup any missed recurring payments
  PERFORM check_and_cancel_missed_recurring_payments();

  RETURN QUERY
  SELECT
    rb.id,
    rb.field_id,
    f.name AS field_name,
    f.image_url AS field_image_url,
    c.name AS city_name,
    rb.day_of_week,
    rb.start_time,
    rb.end_time,
    rb.duration_hours,
    (f.price_per_hour * rb.duration_hours) AS price_per_booking,
    rb.status,
    rb.rejection_reason,
    rb.started_at,
    rb.created_at,
    (SELECT MIN(b.date) FROM bookings b
     WHERE b.recurring_booking_id = rb.id
       AND b.date >= CURRENT_DATE
       AND b.status != 'canceled') AS next_booking_date,
    (SELECT b.payment_status != 'pending' FROM bookings b
     WHERE b.recurring_booking_id = rb.id
       AND b.date >= CURRENT_DATE
       AND b.status != 'canceled'
     ORDER BY b.date ASC LIMIT 1) AS next_booking_paid,
    (SELECT COUNT(*) FROM bookings b WHERE b.recurring_booking_id = rb.id) AS total_bookings_count,
    (SELECT COUNT(*) FROM bookings b
     WHERE b.recurring_booking_id = rb.id AND b.status = 'completed') AS completed_bookings_count
  FROM recurring_bookings rb
  JOIN fields f ON f.id = rb.field_id
  LEFT JOIN cities c ON c.id = f.city_id
  WHERE rb.user_id = auth.uid()
  ORDER BY
    CASE rb.status
      WHEN 'active' THEN 1
      WHEN 'pending_approval' THEN 2
      ELSE 3
    END,
    rb.created_at DESC;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;


-- ============================================================================
-- 5. RPC FUNCTIONS - OWNER ACTIONS
-- ============================================================================

-- Approve a recurring booking request (generates 4 weeks of bookings)
CREATE OR REPLACE FUNCTION approve_recurring_booking(
  p_recurring_id UUID
) RETURNS BOOLEAN AS $$
DECLARE
  v_recurring RECORD;
  v_booking_date DATE;
  v_price DECIMAL;
  i INTEGER;
BEGIN
  -- Get the recurring booking with field info
  SELECT rb.*, f.owner_id, f.price_per_hour
  INTO v_recurring
  FROM recurring_bookings rb
  JOIN fields f ON f.id = rb.field_id
  WHERE rb.id = p_recurring_id;

  -- Verify ownership
  IF v_recurring.owner_id != auth.uid() THEN
    RAISE EXCEPTION 'Not authorized to approve this booking';
  END IF;

  IF v_recurring.status != 'pending_approval' THEN
    RAISE EXCEPTION 'This request is not pending approval';
  END IF;

  -- Calculate price based on duration
  v_price := v_recurring.price_per_hour * v_recurring.duration_hours;

  -- Update recurring booking status
  UPDATE recurring_bookings SET
    status = 'active',
    approved_by = auth.uid(),
    approved_at = NOW(),
    started_at = CURRENT_DATE
  WHERE id = p_recurring_id;

  -- Find next occurrence of this day_of_week
  v_booking_date := CURRENT_DATE;
  WHILE EXTRACT(DOW FROM v_booking_date) != v_recurring.day_of_week LOOP
    v_booking_date := v_booking_date + INTERVAL '1 day';
  END LOOP;

  -- If today is the day but time has passed, start next week
  IF v_booking_date = CURRENT_DATE AND v_recurring.start_time < CURRENT_TIME THEN
    v_booking_date := v_booking_date + INTERVAL '7 days';
  END IF;

  -- Generate 4 weeks of bookings
  FOR i IN 0..3 LOOP
    INSERT INTO bookings (
      user_id, field_id, date, start_time, end_time,
      duration_hours, total_price, status, payment_status,
      recurring_booking_id, created_at
    ) VALUES (
      v_recurring.user_id,
      v_recurring.field_id,
      v_booking_date + (i * 7 || ' days')::INTERVAL,
      v_recurring.start_time,
      v_recurring.end_time,
      v_recurring.duration_hours,
      v_price,
      'pending',
      'pending',
      p_recurring_id,
      NOW()
    );
  END LOOP;

  -- Update generation tracking
  UPDATE recurring_bookings SET
    last_generated_date = v_booking_date + INTERVAL '21 days',
    next_generation_date = v_booking_date + INTERVAL '28 days'
  WHERE id = p_recurring_id;

  RETURN TRUE;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Reject a recurring booking request
CREATE OR REPLACE FUNCTION reject_recurring_booking(
  p_recurring_id UUID,
  p_reason TEXT
) RETURNS BOOLEAN AS $$
DECLARE
  v_owner_id UUID;
BEGIN
  -- Verify ownership
  SELECT f.owner_id INTO v_owner_id
  FROM recurring_bookings rb
  JOIN fields f ON f.id = rb.field_id
  WHERE rb.id = p_recurring_id;

  IF v_owner_id != auth.uid() THEN
    RAISE EXCEPTION 'Not authorized to reject this booking';
  END IF;

  -- Update status
  UPDATE recurring_bookings SET
    status = 'rejected',
    rejection_reason = p_reason
  WHERE id = p_recurring_id
    AND status = 'pending_approval';

  IF NOT FOUND THEN
    RAISE EXCEPTION 'Request not found or not pending';
  END IF;

  RETURN TRUE;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Get pending recurring requests for owner's fields
CREATE OR REPLACE FUNCTION get_pending_recurring_requests()
RETURNS TABLE (
  id UUID,
  field_id UUID,
  field_name TEXT,
  user_id UUID,
  user_name TEXT,
  user_email TEXT,
  user_phone TEXT,
  user_avatar_url TEXT,
  day_of_week INTEGER,
  start_time TIME,
  end_time TIME,
  duration_hours INTEGER,
  price_per_booking DECIMAL,
  created_at TIMESTAMPTZ
) AS $$
BEGIN
  RETURN QUERY
  SELECT
    rb.id,
    rb.field_id,
    f.name AS field_name,
    rb.user_id,
    p.full_name AS user_name,
    p.email AS user_email,
    p.phone AS user_phone,
    p.avatar_url AS user_avatar_url,
    rb.day_of_week,
    rb.start_time,
    rb.end_time,
    rb.duration_hours,
    (f.price_per_hour * rb.duration_hours) AS price_per_booking,
    rb.created_at
  FROM recurring_bookings rb
  JOIN fields f ON f.id = rb.field_id
  JOIN profiles p ON p.id = rb.user_id
  WHERE f.owner_id = auth.uid()
    AND rb.status = 'pending_approval'
  ORDER BY rb.created_at ASC;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Get active recurring bookings for owner's fields
CREATE OR REPLACE FUNCTION get_active_recurring_bookings_for_owner()
RETURNS TABLE (
  id UUID,
  field_id UUID,
  field_name TEXT,
  user_id UUID,
  user_name TEXT,
  day_of_week INTEGER,
  start_time TIME,
  end_time TIME,
  duration_hours INTEGER,
  price_per_booking DECIMAL,
  started_at DATE,
  total_completed BIGINT
) AS $$
BEGIN
  RETURN QUERY
  SELECT
    rb.id,
    rb.field_id,
    f.name AS field_name,
    rb.user_id,
    p.full_name AS user_name,
    rb.day_of_week,
    rb.start_time,
    rb.end_time,
    rb.duration_hours,
    (f.price_per_hour * rb.duration_hours) AS price_per_booking,
    rb.started_at,
    (SELECT COUNT(*) FROM bookings b
     WHERE b.recurring_booking_id = rb.id AND b.status = 'completed') AS total_completed
  FROM recurring_bookings rb
  JOIN fields f ON f.id = rb.field_id
  JOIN profiles p ON p.id = rb.user_id
  WHERE f.owner_id = auth.uid()
    AND rb.status = 'active'
  ORDER BY rb.started_at DESC;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;


-- ============================================================================
-- 6. EVENT-DRIVEN FUNCTIONS (NO CRON NEEDED!)
-- ============================================================================

-- Generate next booking when payment is verified
CREATE OR REPLACE FUNCTION on_recurring_payment_verified()
RETURNS TRIGGER AS $$
DECLARE
  v_recurring RECORD;
  v_future_count INTEGER;
  v_next_date DATE;
  v_price DECIMAL;
BEGIN
  -- Only process if this is a recurring booking and payment was just verified
  IF NEW.recurring_booking_id IS NULL THEN
    RETURN NEW;
  END IF;

  IF OLD.payment_status = 'pending_verification' AND NEW.payment_status = 'verified' THEN
    -- Get the recurring booking
    SELECT rb.*, f.price_per_hour
    INTO v_recurring
    FROM recurring_bookings rb
    JOIN fields f ON f.id = rb.field_id
    WHERE rb.id = NEW.recurring_booking_id
      AND rb.status = 'active';

    IF v_recurring IS NULL THEN
      RETURN NEW;
    END IF;

    -- Count future pending/confirmed bookings
    SELECT COUNT(*) INTO v_future_count
    FROM bookings
    WHERE recurring_booking_id = NEW.recurring_booking_id
      AND date > CURRENT_DATE
      AND status IN ('pending', 'confirmed');

    -- If less than 4 future bookings, generate the next one
    IF v_future_count < 4 THEN
      -- Find next booking date (1 week after last generated)
      v_next_date := v_recurring.last_generated_date + INTERVAL '7 days';
      v_price := v_recurring.price_per_hour * v_recurring.duration_hours;

      -- Create the booking
      INSERT INTO bookings (
        user_id, field_id, date, start_time, end_time,
        duration_hours, total_price, status, payment_status,
        recurring_booking_id, created_at
      ) VALUES (
        v_recurring.user_id,
        v_recurring.field_id,
        v_next_date,
        v_recurring.start_time,
        v_recurring.end_time,
        v_recurring.duration_hours,
        v_price,
        'pending',
        'pending',
        v_recurring.id,
        NOW()
      );

      -- Update tracking
      UPDATE recurring_bookings SET
        last_generated_date = v_next_date,
        next_generation_date = v_next_date + INTERVAL '7 days'
      WHERE id = v_recurring.id;
    END IF;
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Create the trigger
DROP TRIGGER IF EXISTS trigger_recurring_payment_verified ON bookings;
CREATE TRIGGER trigger_recurring_payment_verified
  AFTER UPDATE ON bookings
  FOR EACH ROW
  WHEN (OLD.payment_status IS DISTINCT FROM NEW.payment_status)
  EXECUTE FUNCTION on_recurring_payment_verified();


-- Check for missed payments and auto-cancel
CREATE OR REPLACE FUNCTION check_and_cancel_missed_recurring_payments()
RETURNS INTEGER AS $$
DECLARE
  v_canceled_count INTEGER := 0;
  v_recurring RECORD;
BEGIN
  -- Find recurring bookings with unpaid bookings where the date has passed
  FOR v_recurring IN
    SELECT DISTINCT rb.id, rb.user_id
    FROM recurring_bookings rb
    JOIN bookings b ON b.recurring_booking_id = rb.id
    WHERE rb.status = 'active'
      AND b.status = 'pending'
      AND b.payment_status = 'pending'
      AND b.date < CURRENT_DATE
  LOOP
    -- Cancel the recurring booking
    UPDATE recurring_bookings SET
      status = 'canceled',
      canceled_at = NOW(),
      cancellation_reason = 'missed_payment'
    WHERE id = v_recurring.id;

    -- Cancel all pending bookings (past and future)
    UPDATE bookings SET
      status = 'canceled'
    WHERE recurring_booking_id = v_recurring.id
      AND status = 'pending';

    v_canceled_count := v_canceled_count + 1;
  END LOOP;

  RETURN v_canceled_count;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;


-- ============================================================================
-- 7. HELPER FUNCTIONS
-- ============================================================================

-- Check if a slot has active recurring booking (for UI badge)
CREATE OR REPLACE FUNCTION is_slot_reserved_recurring(
  p_field_id UUID,
  p_day_of_week INTEGER,
  p_start_time TIME
) RETURNS BOOLEAN AS $$
BEGIN
  RETURN EXISTS(
    SELECT 1 FROM recurring_bookings
    WHERE field_id = p_field_id
      AND day_of_week = p_day_of_week
      AND start_time <= p_start_time
      AND end_time > p_start_time
      AND status = 'active'
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Get reserved slots for a field (for UI)
CREATE OR REPLACE FUNCTION get_reserved_recurring_slots(p_field_id UUID)
RETURNS TABLE (
  day_of_week INTEGER,
  start_time TIME,
  end_time TIME,
  user_name TEXT
) AS $$
BEGIN
  RETURN QUERY
  SELECT
    rb.day_of_week,
    rb.start_time,
    rb.end_time,
    p.full_name AS user_name
  FROM recurring_bookings rb
  JOIN profiles p ON p.id = rb.user_id
  WHERE rb.field_id = p_field_id
    AND rb.status = 'active';
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
