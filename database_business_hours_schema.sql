-- ============================================================================
-- Business Hours Schema for Sport Kick Application
-- ============================================================================
-- Description: Database schema for managing field operating hours
-- Version: 1.0.0
-- Created: 2025-12-02
-- Author: Sport Kick Development Team
-- ============================================================================

-- ============================================================================
-- 1. BUSINESS_HOURS TABLE
-- ============================================================================

CREATE TABLE IF NOT EXISTS business_hours (
  -- Primary Key
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

  -- Foreign Keys
  field_id UUID NOT NULL REFERENCES fields(id) ON DELETE CASCADE,

  -- Business Hours Data
  day_of_week INTEGER NOT NULL CHECK (day_of_week >= 0 AND day_of_week <= 6),
  is_open BOOLEAN NOT NULL DEFAULT true,
  opening_time TIME,
  closing_time TIME,

  -- Timestamps
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

  -- Constraints
  CONSTRAINT unique_field_day UNIQUE (field_id, day_of_week),
  CONSTRAINT valid_times CHECK (
    (is_open = false) OR
    (opening_time IS NOT NULL AND closing_time IS NOT NULL AND opening_time < closing_time)
  )
);

-- ============================================================================
-- 2. INDEXES
-- ============================================================================

-- Index for fast lookup by field
CREATE INDEX IF NOT EXISTS idx_business_hours_field_id
ON business_hours(field_id);

-- Index for fast lookup by day of week
CREATE INDEX IF NOT EXISTS idx_business_hours_day
ON business_hours(day_of_week);

-- Index for open fields
CREATE INDEX IF NOT EXISTS idx_business_hours_open
ON business_hours(is_open)
WHERE is_open = true;

-- ============================================================================
-- 3. TRIGGERS
-- ============================================================================

-- Trigger to auto-update updated_at timestamp
CREATE OR REPLACE FUNCTION update_business_hours_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_business_hours_updated_at
  BEFORE UPDATE ON business_hours
  FOR EACH ROW
  EXECUTE FUNCTION update_business_hours_updated_at();

-- ============================================================================
-- 4. ROW LEVEL SECURITY (RLS) POLICIES
-- ============================================================================

-- Enable RLS
ALTER TABLE business_hours ENABLE ROW LEVEL SECURITY;

-- Policy: Anyone can view business hours
CREATE POLICY "Anyone can view business hours"
  ON business_hours
  FOR SELECT
  USING (true);

-- Policy: Field owners can manage their business hours
CREATE POLICY "Field owners can manage their business hours"
  ON business_hours
  FOR ALL
  USING (
    field_id IN (
      SELECT id FROM fields
      WHERE owner_id = auth.uid()
    )
  );

-- Policy: Super admins have full access
CREATE POLICY "Super admins have full access to business hours"
  ON business_hours
  FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM profiles
      WHERE id = auth.uid()
      AND role = 'super_admin'
    )
  );

-- ============================================================================
-- 5. HELPER FUNCTIONS
-- ============================================================================

-- Function: Get business hours for a specific field
CREATE OR REPLACE FUNCTION get_field_business_hours(p_field_id UUID)
RETURNS TABLE (
  id UUID,
  day_of_week INTEGER,
  is_open BOOLEAN,
  opening_time TIME,
  closing_time TIME
) AS $$
BEGIN
  RETURN QUERY
  SELECT
    bh.id,
    bh.day_of_week,
    bh.is_open,
    bh.opening_time,
    bh.closing_time
  FROM business_hours bh
  WHERE bh.field_id = p_field_id
  ORDER BY bh.day_of_week;
END;
$$ LANGUAGE plpgsql;

-- Function: Check if field is open at specific day/time
CREATE OR REPLACE FUNCTION is_field_open_at(
  p_field_id UUID,
  p_day_of_week INTEGER,
  p_time TIME
)
RETURNS BOOLEAN AS $$
DECLARE
  v_is_open BOOLEAN;
  v_opening_time TIME;
  v_closing_time TIME;
BEGIN
  SELECT
    is_open,
    opening_time,
    closing_time
  INTO v_is_open, v_opening_time, v_closing_time
  FROM business_hours
  WHERE field_id = p_field_id
    AND day_of_week = p_day_of_week;

  -- If no record found, assume open 24/7
  IF NOT FOUND THEN
    RETURN true;
  END IF;

  -- Check if closed for the day
  IF v_is_open = false THEN
    RETURN false;
  END IF;

  -- Check if time is within business hours
  RETURN p_time >= v_opening_time AND p_time <= v_closing_time;
END;
$$ LANGUAGE plpgsql;

-- Function: Get next available opening time for a field
CREATE OR REPLACE FUNCTION get_next_opening_time(
  p_field_id UUID,
  p_from_timestamp TIMESTAMPTZ
)
RETURNS TIMESTAMPTZ AS $$
DECLARE
  v_current_day INTEGER;
  v_current_time TIME;
  v_days_checked INTEGER := 0;
  v_bh RECORD;
BEGIN
  LOOP
    v_current_day := EXTRACT(DOW FROM p_from_timestamp + (v_days_checked || ' days')::INTERVAL);
    v_current_time := (p_from_timestamp + (v_days_checked || ' days')::INTERVAL)::TIME;

    SELECT * INTO v_bh
    FROM business_hours
    WHERE field_id = p_field_id
      AND day_of_week = v_current_day
      AND is_open = true;

    IF FOUND AND (v_days_checked > 0 OR v_current_time < v_bh.opening_time) THEN
      RETURN (DATE(p_from_timestamp) + (v_days_checked || ' days')::INTERVAL + v_bh.opening_time::INTERVAL);
    END IF;

    v_days_checked := v_days_checked + 1;

    -- Prevent infinite loop, check only 7 days ahead
    IF v_days_checked > 7 THEN
      RETURN NULL;
    END IF;
  END LOOP;
END;
$$ LANGUAGE plpgsql;

-- Function: Initialize default business hours for a field (24/7)
CREATE OR REPLACE FUNCTION initialize_default_business_hours(p_field_id UUID)
RETURNS VOID AS $$
BEGIN
  -- Insert default hours for all 7 days (24/7 operation)
  INSERT INTO business_hours (field_id, day_of_week, is_open, opening_time, closing_time)
  VALUES
    (p_field_id, 0, true, '00:00:00', '23:59:59'), -- Sunday
    (p_field_id, 1, true, '00:00:00', '23:59:59'), -- Monday
    (p_field_id, 2, true, '00:00:00', '23:59:59'), -- Tuesday
    (p_field_id, 3, true, '00:00:00', '23:59:59'), -- Wednesday
    (p_field_id, 4, true, '00:00:00', '23:59:59'), -- Thursday
    (p_field_id, 5, true, '00:00:00', '23:59:59'), -- Friday
    (p_field_id, 6, true, '00:00:00', '23:59:59')  -- Saturday
  ON CONFLICT (field_id, day_of_week) DO NOTHING;
END;
$$ LANGUAGE plpgsql;

-- ============================================================================
-- 6. VALIDATION FUNCTIONS
-- ============================================================================

-- Function: Validate booking time against business hours
CREATE OR REPLACE FUNCTION validate_booking_time(
  p_field_id UUID,
  p_booking_time TIMESTAMPTZ
)
RETURNS BOOLEAN AS $$
DECLARE
  v_day_of_week INTEGER;
  v_time TIME;
BEGIN
  v_day_of_week := EXTRACT(DOW FROM p_booking_time);
  v_time := p_booking_time::TIME;

  RETURN is_field_open_at(p_field_id, v_day_of_week, v_time);
END;
$$ LANGUAGE plpgsql;

-- ============================================================================
-- 7. COMMENTS
-- ============================================================================

COMMENT ON TABLE business_hours IS 'Stores operating hours for football fields';
COMMENT ON COLUMN business_hours.day_of_week IS 'Day of week (0=Sunday, 1=Monday, ..., 6=Saturday)';
COMMENT ON COLUMN business_hours.is_open IS 'Whether the field is open on this day';
COMMENT ON COLUMN business_hours.opening_time IS 'Opening time for the day (NULL if closed)';
COMMENT ON COLUMN business_hours.closing_time IS 'Closing time for the day (NULL if closed)';

-- ============================================================================
-- 8. INITIAL DATA (Optional - For Testing)
-- ============================================================================

-- Uncomment to create test data:
/*
-- Example: Set business hours for a test field
INSERT INTO business_hours (field_id, day_of_week, is_open, opening_time, closing_time)
SELECT
  (SELECT id FROM fields LIMIT 1),  -- First field
  generate_series(0, 6) as day,     -- All days
  true,                              -- Open
  '08:00:00'::TIME,                  -- Opens at 8 AM
  '22:00:00'::TIME                   -- Closes at 10 PM
ON CONFLICT (field_id, day_of_week) DO NOTHING;
*/

-- ============================================================================
-- END OF SCHEMA
-- ============================================================================
