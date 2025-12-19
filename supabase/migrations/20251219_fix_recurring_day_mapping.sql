-- ============================================================================
-- FIX: Day of Week Mapping in Recurring Bookings
-- ============================================================================
-- Issue: PostgreSQL's EXTRACT(DOW) returns 0=Sunday, but app uses 0=Saturday.
-- This caused bookings to be scheduled on the wrong day.
-- 
-- Mapping: PostgreSQL_DOW = (app_day_of_week + 1) % 7
-- ============================================================================

-- Drop and recreate the approve_recurring_booking function with fixed day mapping
CREATE OR REPLACE FUNCTION approve_recurring_booking(
  p_recurring_id UUID
) RETURNS BOOLEAN AS $$
DECLARE
  v_recurring RECORD;
  v_booking_date DATE;
  v_price DECIMAL;
  v_postgres_dow INTEGER;
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

  -- *** FIX: Convert app's day_of_week to PostgreSQL DOW ***
  -- App: 0=Saturday, 1=Sunday, 2=Monday, 3=Tuesday, 4=Wednesday, 5=Thursday, 6=Friday
  -- PostgreSQL: 0=Sunday, 1=Monday, 2=Tuesday, 3=Wednesday, 4=Thursday, 5=Friday, 6=Saturday
  v_postgres_dow := (v_recurring.day_of_week + 1) % 7;

  -- Find next occurrence of this day_of_week
  v_booking_date := CURRENT_DATE;
  WHILE EXTRACT(DOW FROM v_booking_date) != v_postgres_dow LOOP
    v_booking_date := v_booking_date + INTERVAL '1 day';
  END LOOP;

  -- If today is the day but time has passed, start next week
  IF v_booking_date = CURRENT_DATE AND v_recurring.start_time < CURRENT_TIME THEN
    v_booking_date := v_booking_date + INTERVAL '7 days';
  END IF;

  -- Generate 4 weeks of bookings
  FOR i IN 0..3 LOOP
    INSERT INTO bookings (
      user_id, field_id, booking_date, start_time, end_time,
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


-- Also fix the on_recurring_payment_verified function with same mapping
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
      AND booking_date > CURRENT_DATE
      AND status IN ('pending', 'confirmed');

    -- If less than 4 future bookings, generate the next one
    IF v_future_count < 4 THEN
      -- Find next booking date (1 week after last generated)
      v_next_date := v_recurring.last_generated_date + INTERVAL '7 days';
      v_price := v_recurring.price_per_hour * v_recurring.duration_hours;

      -- Create the booking
      INSERT INTO bookings (
        user_id, field_id, booking_date, start_time, end_time,
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
