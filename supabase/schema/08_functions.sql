-- ============================================================================
-- FUNCTIONS
-- Sport Kick Database - Schema Part 8
-- ============================================================================

-- ============================================================================
-- ROLE HELPER FUNCTIONS (SECURITY DEFINER - bypass RLS)
-- ============================================================================

CREATE OR REPLACE FUNCTION get_current_user_role()
RETURNS TEXT
LANGUAGE plpgsql
SECURITY DEFINER
STABLE
AS $$
BEGIN
  RETURN (SELECT role FROM public.profiles WHERE id = auth.uid());
END;
$$;

CREATE OR REPLACE FUNCTION is_super_admin()
RETURNS BOOLEAN
LANGUAGE plpgsql
SECURITY DEFINER
STABLE
AS $$
BEGIN
  RETURN (SELECT role = 'super_admin' FROM public.profiles WHERE id = auth.uid());
END;
$$;

CREATE OR REPLACE FUNCTION is_admin()
RETURNS BOOLEAN
LANGUAGE plpgsql
SECURITY DEFINER
STABLE
AS $$
BEGIN
  RETURN (SELECT role IN ('admin', 'super_admin') FROM public.profiles WHERE id = auth.uid());
END;
$$;

CREATE OR REPLACE FUNCTION is_user()
RETURNS BOOLEAN
LANGUAGE plpgsql
SECURITY DEFINER
STABLE
AS $$
BEGIN
  RETURN (SELECT role = 'user' FROM public.profiles WHERE id = auth.uid());
END;
$$;

-- ============================================================================
-- INVOICE FUNCTIONS
-- ============================================================================

CREATE OR REPLACE FUNCTION generate_invoice_number()
RETURNS TEXT AS $$
DECLARE
  date_part TEXT;
  sequence_part TEXT;
  new_invoice TEXT;
BEGIN
  date_part := TO_CHAR(CURRENT_DATE, 'YYYYMMDD');
  SELECT LPAD((COUNT(*) + 1)::TEXT, 4, '0')
  INTO sequence_part
  FROM bookings
  WHERE invoice_number LIKE 'INV-' || date_part || '-%';
  new_invoice := 'INV-' || date_part || '-' || sequence_part;
  RETURN new_invoice;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION set_invoice_number()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.invoice_number IS NULL THEN
    NEW.invoice_number := generate_invoice_number();
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- ============================================================================
-- BOOKING FUNCTIONS
-- ============================================================================

CREATE OR REPLACE FUNCTION validate_booking_date_on_insert()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.booking_date < CURRENT_DATE - INTERVAL '1 day' THEN
    RAISE EXCEPTION 'Booking date cannot be more than 1 day in the past';
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION complete_passed_bookings()
RETURNS INTEGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  updated_count INTEGER;
BEGIN
  UPDATE bookings
  SET status = 'completed', updated_at = NOW()
  WHERE status = 'confirmed'
    AND (booking_date + end_time::time) < NOW();
  GET DIAGNOSTICS updated_count = ROW_COUNT;
  RETURN updated_count;
END;
$$;

GRANT EXECUTE ON FUNCTION complete_passed_bookings() TO authenticated;
GRANT EXECUTE ON FUNCTION complete_passed_bookings() TO anon;
GRANT EXECUTE ON FUNCTION complete_passed_bookings() TO service_role;

-- ============================================================================
-- BUSINESS HOURS FUNCTIONS
-- ============================================================================

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
  SELECT bh.id, bh.day_of_week, bh.is_open, bh.opening_time, bh.closing_time
  FROM business_hours bh
  WHERE bh.field_id = p_field_id
  ORDER BY bh.day_of_week;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION is_field_open_at(p_field_id UUID, p_day_of_week INTEGER, p_time TIME)
RETURNS BOOLEAN AS $$
DECLARE
  v_is_open BOOLEAN;
  v_opening_time TIME;
  v_closing_time TIME;
BEGIN
  SELECT is_open, opening_time, closing_time
  INTO v_is_open, v_opening_time, v_closing_time
  FROM business_hours
  WHERE field_id = p_field_id AND day_of_week = p_day_of_week;
  IF NOT FOUND THEN RETURN true; END IF;
  IF v_is_open = false THEN RETURN false; END IF;
  RETURN p_time >= v_opening_time AND p_time <= v_closing_time;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION initialize_default_business_hours(p_field_id UUID)
RETURNS VOID AS $$
BEGIN
  INSERT INTO business_hours (field_id, day_of_week, is_open, opening_time, closing_time)
  VALUES
    (p_field_id, 0, true, '00:00:00', '23:59:59'),
    (p_field_id, 1, true, '00:00:00', '23:59:59'),
    (p_field_id, 2, true, '00:00:00', '23:59:59'),
    (p_field_id, 3, true, '00:00:00', '23:59:59'),
    (p_field_id, 4, true, '00:00:00', '23:59:59'),
    (p_field_id, 5, true, '00:00:00', '23:59:59'),
    (p_field_id, 6, true, '00:00:00', '23:59:59')
  ON CONFLICT (field_id, day_of_week) DO NOTHING;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION update_business_hours_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- ============================================================================
-- REVIEW FUNCTIONS
-- ============================================================================

CREATE OR REPLACE FUNCTION update_field_review_stats(p_field_id UUID)
RETURNS VOID AS $$
DECLARE
  v_avg_rating DECIMAL(3,2);
  v_review_count INTEGER;
BEGIN
  SELECT ROUND(AVG(rating)::NUMERIC, 2), COUNT(*)
  INTO v_avg_rating, v_review_count
  FROM reviews WHERE field_id = p_field_id;

  UPDATE fields
  SET average_rating = v_avg_rating, total_reviews = v_review_count, updated_at = NOW()
  WHERE id = p_field_id;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION trigger_after_review_insert()
RETURNS TRIGGER AS $$
BEGIN
  PERFORM update_field_review_stats(NEW.field_id);
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION trigger_after_review_update()
RETURNS TRIGGER AS $$
BEGIN
  IF OLD.field_id != NEW.field_id THEN
    PERFORM update_field_review_stats(OLD.field_id);
  END IF;
  PERFORM update_field_review_stats(NEW.field_id);
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION trigger_after_review_delete()
RETURNS TRIGGER AS $$
BEGIN
  PERFORM update_field_review_stats(OLD.field_id);
  RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION update_reviews_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_field_reviews(p_field_id UUID, p_limit INTEGER DEFAULT 10, p_offset INTEGER DEFAULT 0)
RETURNS TABLE (
  id UUID, field_id UUID, user_id UUID, booking_id UUID,
  rating INTEGER, comment TEXT, created_at TIMESTAMPTZ, updated_at TIMESTAMPTZ,
  user_name TEXT, user_avatar TEXT
) AS $$
BEGIN
  RETURN QUERY
  SELECT r.id, r.field_id, r.user_id, r.booking_id, r.rating, r.comment, r.created_at, r.updated_at,
         p.full_name, p.avatar_url
  FROM reviews r
  INNER JOIN profiles p ON r.user_id = p.id
  WHERE r.field_id = p_field_id
  ORDER BY r.created_at DESC
  LIMIT p_limit OFFSET p_offset;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION can_user_review_field(p_user_id UUID, p_field_id UUID, p_booking_id UUID)
RETURNS BOOLEAN AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1 FROM bookings
    WHERE id = p_booking_id AND user_id = p_user_id AND field_id = p_field_id
      AND status = 'completed'
      AND NOT EXISTS (SELECT 1 FROM reviews WHERE booking_id = p_booking_id)
  );
END;
$$ LANGUAGE plpgsql;

-- ============================================================================
-- NOTIFICATION FUNCTIONS
-- ============================================================================

CREATE OR REPLACE FUNCTION notify_field_owner_on_booking()
RETURNS TRIGGER AS $$
DECLARE
  v_field_owner_id UUID;
  v_field_name TEXT;
  v_user_name TEXT;
BEGIN
  SELECT f.owner_id, f.name INTO v_field_owner_id, v_field_name
  FROM public.fields f WHERE f.id = NEW.field_id;

  SELECT p.full_name INTO v_user_name
  FROM public.profiles p WHERE p.id = NEW.user_id;

  IF NEW.is_manual = true THEN RETURN NEW; END IF;

  INSERT INTO public.notifications (
    user_id, title, body, type, reference_id, reference_type, data
  ) VALUES (
    v_field_owner_id,
    'New Booking Request',
    COALESCE(v_user_name, 'A customer') || ' booked ' || COALESCE(v_field_name, 'your field') ||
    ' on ' || TO_CHAR(NEW.booking_date, 'DD Mon YYYY') || ' at ' || NEW.start_time::TEXT,
    'booking', NEW.id, 'booking',
    jsonb_build_object(
      'booking_id', NEW.id, 'field_id', NEW.field_id, 'field_name', v_field_name,
      'user_id', NEW.user_id, 'user_name', v_user_name, 'booking_date', NEW.booking_date,
      'start_time', NEW.start_time, 'end_time', NEW.end_time,
      'total_price', NEW.total_price, 'status', NEW.status
    )
  );
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION notify_owner_on_payment_upload()
RETURNS TRIGGER AS $$
DECLARE
  v_field_owner_id UUID;
  v_field_name TEXT;
  v_user_name TEXT;
BEGIN
  IF OLD.payment_proof_url IS NULL AND NEW.payment_proof_url IS NOT NULL THEN
    SELECT f.owner_id, f.name INTO v_field_owner_id, v_field_name
    FROM public.fields f WHERE f.id = NEW.field_id;

    SELECT p.full_name INTO v_user_name
    FROM public.profiles p WHERE p.id = NEW.user_id;

    INSERT INTO public.notifications (
      user_id, title, body, type, reference_id, reference_type, data
    ) VALUES (
      v_field_owner_id,
      'Payment Proof Uploaded',
      COALESCE(v_user_name, 'A customer') || ' uploaded payment proof for booking on ' ||
      TO_CHAR(NEW.booking_date, 'DD Mon YYYY'),
      'payment', NEW.id, 'booking',
      jsonb_build_object(
        'booking_id', NEW.id, 'field_id', NEW.field_id,
        'user_id', NEW.user_id, 'payment_proof_url', NEW.payment_proof_url
      )
    );
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION get_unread_notification_count(p_user_id UUID)
RETURNS INTEGER AS $$
BEGIN
  RETURN (SELECT COUNT(*)::INTEGER FROM public.notifications WHERE user_id = p_user_id AND is_read = false);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION mark_notifications_read(p_notification_ids UUID[])
RETURNS void AS $$
BEGIN
  UPDATE public.notifications
  SET is_read = true, read_at = NOW()
  WHERE id = ANY(p_notification_ids) AND user_id = auth.uid();
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION mark_all_notifications_read()
RETURNS void AS $$
BEGIN
  UPDATE public.notifications
  SET is_read = true, read_at = NOW()
  WHERE user_id = auth.uid() AND is_read = false;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

GRANT EXECUTE ON FUNCTION get_unread_notification_count TO authenticated;
GRANT EXECUTE ON FUNCTION mark_notifications_read TO authenticated;
GRANT EXECUTE ON FUNCTION mark_all_notifications_read TO authenticated;

-- ============================================================================
-- FCM TOKEN FUNCTIONS
-- ============================================================================

CREATE OR REPLACE FUNCTION update_user_fcm_tokens_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- ============================================================================
-- RECURRING BOOKING FUNCTIONS
-- ============================================================================

CREATE OR REPLACE FUNCTION update_recurring_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION create_recurring_booking_request(
  p_field_id UUID, p_day_of_week INTEGER, p_start_time TIME, p_duration_hours INTEGER DEFAULT 1
) RETURNS UUID AS $$
DECLARE
  v_end_time TIME;
  v_recurring_id UUID;
  v_field_exists BOOLEAN;
  v_slot_available BOOLEAN;
  v_within_business_hours BOOLEAN;
BEGIN
  IF p_duration_hours NOT IN (1, 2) THEN
    RAISE EXCEPTION 'Duration must be 1 or 2 hours';
  END IF;

  v_end_time := p_start_time + (p_duration_hours || ' hours')::INTERVAL;

  SELECT EXISTS(SELECT 1 FROM fields WHERE id = p_field_id AND is_active = true) INTO v_field_exists;
  IF NOT v_field_exists THEN RAISE EXCEPTION 'Field not found or inactive'; END IF;

  SELECT EXISTS(
    SELECT 1 FROM business_hours
    WHERE field_id = p_field_id AND day_of_week = p_day_of_week AND is_open = true
      AND opening_time <= p_start_time AND closing_time >= v_end_time
  ) INTO v_within_business_hours;
  IF NOT v_within_business_hours THEN RAISE EXCEPTION 'Requested time is outside business hours'; END IF;

  SELECT NOT EXISTS(
    SELECT 1 FROM recurring_bookings
    WHERE field_id = p_field_id AND day_of_week = p_day_of_week AND start_time = p_start_time
      AND status IN ('pending_approval', 'active')
  ) INTO v_slot_available;
  IF NOT v_slot_available THEN RAISE EXCEPTION 'This slot already has an active recurring booking'; END IF;

  INSERT INTO recurring_bookings (user_id, field_id, day_of_week, start_time, end_time, duration_hours, status)
  VALUES (auth.uid(), p_field_id, p_day_of_week, p_start_time, v_end_time, p_duration_hours, 'pending_approval')
  RETURNING id INTO v_recurring_id;

  RETURN v_recurring_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION approve_recurring_booking(p_recurring_id UUID) RETURNS BOOLEAN AS $$
DECLARE
  v_recurring RECORD;
  v_booking_date DATE;
  v_price DECIMAL;
  v_postgres_dow INTEGER;
  i INTEGER;
BEGIN
  SELECT rb.*, f.owner_id, f.price_per_hour INTO v_recurring
  FROM recurring_bookings rb JOIN fields f ON f.id = rb.field_id
  WHERE rb.id = p_recurring_id;

  IF v_recurring.owner_id != auth.uid() THEN RAISE EXCEPTION 'Not authorized'; END IF;
  IF v_recurring.status != 'pending_approval' THEN RAISE EXCEPTION 'Not pending approval'; END IF;

  v_price := v_recurring.price_per_hour * v_recurring.duration_hours;

  UPDATE recurring_bookings SET
    status = 'active', approved_by = auth.uid(), approved_at = NOW(), started_at = CURRENT_DATE
  WHERE id = p_recurring_id;

  -- Convert app day_of_week to PostgreSQL DOW
  v_postgres_dow := (v_recurring.day_of_week + 1) % 7;

  v_booking_date := CURRENT_DATE;
  WHILE EXTRACT(DOW FROM v_booking_date) != v_postgres_dow LOOP
    v_booking_date := v_booking_date + INTERVAL '1 day';
  END LOOP;

  IF v_booking_date = CURRENT_DATE AND v_recurring.start_time < CURRENT_TIME THEN
    v_booking_date := v_booking_date + INTERVAL '7 days';
  END IF;

  -- Generate 4 weeks of bookings
  FOR i IN 0..3 LOOP
    INSERT INTO bookings (
      user_id, field_id, booking_date, start_time, end_time,
      duration_hours, total_price, status, payment_status, recurring_booking_id, created_at
    ) VALUES (
      v_recurring.user_id, v_recurring.field_id,
      v_booking_date + (i * 7 || ' days')::INTERVAL,
      v_recurring.start_time, v_recurring.end_time, v_recurring.duration_hours,
      v_price, 'pending', 'pending', p_recurring_id, NOW()
    );
  END LOOP;

  UPDATE recurring_bookings SET
    last_generated_date = v_booking_date + INTERVAL '21 days',
    next_generation_date = v_booking_date + INTERVAL '28 days'
  WHERE id = p_recurring_id;

  RETURN TRUE;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION reject_recurring_booking(p_recurring_id UUID, p_reason TEXT) RETURNS BOOLEAN AS $$
DECLARE v_owner_id UUID;
BEGIN
  SELECT f.owner_id INTO v_owner_id
  FROM recurring_bookings rb JOIN fields f ON f.id = rb.field_id
  WHERE rb.id = p_recurring_id;

  IF v_owner_id != auth.uid() THEN RAISE EXCEPTION 'Not authorized'; END IF;

  UPDATE recurring_bookings SET status = 'rejected', rejection_reason = p_reason
  WHERE id = p_recurring_id AND status = 'pending_approval';

  IF NOT FOUND THEN RAISE EXCEPTION 'Request not found or not pending'; END IF;
  RETURN TRUE;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION cancel_recurring_booking(p_recurring_id UUID, p_reason TEXT DEFAULT 'user_request')
RETURNS BOOLEAN AS $$
DECLARE
  v_recurring RECORD;
  v_one_week_from_now DATE;
BEGIN
  SELECT * INTO v_recurring FROM recurring_bookings
  WHERE id = p_recurring_id AND user_id = auth.uid();

  IF v_recurring IS NULL THEN RAISE EXCEPTION 'Not found or unauthorized'; END IF;
  IF v_recurring.status != 'active' THEN RAISE EXCEPTION 'Can only cancel active subscriptions'; END IF;

  v_one_week_from_now := CURRENT_DATE + INTERVAL '7 days';

  UPDATE recurring_bookings SET
    status = 'canceled', canceled_at = NOW(), canceled_by = auth.uid(), cancellation_reason = p_reason
  WHERE id = p_recurring_id;

  UPDATE bookings SET status = 'canceled'
  WHERE recurring_booking_id = p_recurring_id AND status = 'pending' AND booking_date >= v_one_week_from_now;

  RETURN TRUE;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION get_my_recurring_bookings()
RETURNS TABLE (
  id UUID, field_id UUID, field_name TEXT, field_image_url TEXT, city_name TEXT,
  day_of_week INTEGER, start_time TIME, end_time TIME, duration_hours INTEGER,
  price_per_booking DECIMAL, status TEXT, rejection_reason TEXT, started_at DATE,
  created_at TIMESTAMPTZ, next_booking_date DATE, next_booking_paid BOOLEAN,
  total_bookings_count BIGINT, completed_bookings_count BIGINT
) AS $$
BEGIN
  PERFORM check_and_cancel_missed_recurring_payments();

  RETURN QUERY
  SELECT
    rb.id, rb.field_id, f.name, f.images[1], c.name,
    rb.day_of_week, rb.start_time, rb.end_time, rb.duration_hours,
    (f.price_per_hour * rb.duration_hours), rb.status, rb.rejection_reason, rb.started_at, rb.created_at,
    (SELECT MIN(b.booking_date) FROM bookings b WHERE b.recurring_booking_id = rb.id AND b.booking_date >= CURRENT_DATE AND b.status != 'canceled'),
    (SELECT b.payment_status != 'pending' FROM bookings b WHERE b.recurring_booking_id = rb.id AND b.booking_date >= CURRENT_DATE AND b.status != 'canceled' ORDER BY b.booking_date ASC LIMIT 1),
    (SELECT COUNT(*) FROM bookings b WHERE b.recurring_booking_id = rb.id),
    (SELECT COUNT(*) FROM bookings b WHERE b.recurring_booking_id = rb.id AND b.status = 'completed')
  FROM recurring_bookings rb
  JOIN fields f ON f.id = rb.field_id
  LEFT JOIN cities c ON c.id = f.city_id
  WHERE rb.user_id = auth.uid()
  ORDER BY CASE rb.status WHEN 'active' THEN 1 WHEN 'pending_approval' THEN 2 ELSE 3 END, rb.created_at DESC;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION get_pending_recurring_requests()
RETURNS TABLE (
  id UUID, field_id UUID, field_name TEXT, user_id UUID, user_name TEXT,
  user_email TEXT, user_phone TEXT, user_avatar_url TEXT,
  day_of_week INTEGER, start_time TIME, end_time TIME, duration_hours INTEGER,
  price_per_booking DECIMAL, created_at TIMESTAMPTZ
) AS $$
BEGIN
  RETURN QUERY
  SELECT
    rb.id, rb.field_id, f.name, rb.user_id, p.full_name, p.email, p.phone, p.avatar_url,
    rb.day_of_week, rb.start_time, rb.end_time, rb.duration_hours,
    (f.price_per_hour * rb.duration_hours), rb.created_at
  FROM recurring_bookings rb
  JOIN fields f ON f.id = rb.field_id
  JOIN profiles p ON p.id = rb.user_id
  WHERE f.owner_id = auth.uid() AND rb.status = 'pending_approval'
  ORDER BY rb.created_at ASC;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION on_recurring_payment_verified()
RETURNS TRIGGER AS $$
DECLARE
  v_recurring RECORD;
  v_future_count INTEGER;
  v_next_date DATE;
  v_price DECIMAL;
BEGIN
  IF NEW.recurring_booking_id IS NULL THEN RETURN NEW; END IF;

  IF OLD.payment_status = 'pending_verification' AND NEW.payment_status = 'verified' THEN
    SELECT rb.*, f.price_per_hour INTO v_recurring
    FROM recurring_bookings rb JOIN fields f ON f.id = rb.field_id
    WHERE rb.id = NEW.recurring_booking_id AND rb.status = 'active';

    IF v_recurring IS NULL THEN RETURN NEW; END IF;

    SELECT COUNT(*) INTO v_future_count FROM bookings
    WHERE recurring_booking_id = NEW.recurring_booking_id AND booking_date > CURRENT_DATE AND status IN ('pending', 'confirmed');

    IF v_future_count < 4 THEN
      v_next_date := v_recurring.last_generated_date + INTERVAL '7 days';
      v_price := v_recurring.price_per_hour * v_recurring.duration_hours;

      INSERT INTO bookings (
        user_id, field_id, booking_date, start_time, end_time,
        duration_hours, total_price, status, payment_status, recurring_booking_id, created_at
      ) VALUES (
        v_recurring.user_id, v_recurring.field_id, v_next_date,
        v_recurring.start_time, v_recurring.end_time, v_recurring.duration_hours,
        v_price, 'pending', 'pending', v_recurring.id, NOW()
      );

      UPDATE recurring_bookings SET
        last_generated_date = v_next_date, next_generation_date = v_next_date + INTERVAL '7 days'
      WHERE id = v_recurring.id;
    END IF;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION check_and_cancel_missed_recurring_payments()
RETURNS INTEGER AS $$
DECLARE
  v_canceled_count INTEGER := 0;
  v_recurring RECORD;
BEGIN
  FOR v_recurring IN
    SELECT DISTINCT rb.id FROM recurring_bookings rb
    JOIN bookings b ON b.recurring_booking_id = rb.id
    WHERE rb.status = 'active' AND b.status = 'pending' AND b.payment_status = 'pending' AND b.booking_date < CURRENT_DATE
  LOOP
    UPDATE recurring_bookings SET status = 'canceled', canceled_at = NOW(), cancellation_reason = 'missed_payment'
    WHERE id = v_recurring.id;
    UPDATE bookings SET status = 'canceled' WHERE recurring_booking_id = v_recurring.id AND status = 'pending';
    v_canceled_count := v_canceled_count + 1;
  END LOOP;
  RETURN v_canceled_count;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION is_slot_reserved_recurring(p_field_id UUID, p_day_of_week INTEGER, p_start_time TIME)
RETURNS BOOLEAN AS $$
BEGIN
  RETURN EXISTS(
    SELECT 1 FROM recurring_bookings
    WHERE field_id = p_field_id AND day_of_week = p_day_of_week
      AND start_time <= p_start_time AND end_time > p_start_time AND status = 'active'
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION get_reserved_recurring_slots(p_field_id UUID)
RETURNS TABLE (day_of_week INTEGER, start_time TIME, end_time TIME, user_name TEXT) AS $$
BEGIN
  RETURN QUERY
  SELECT rb.day_of_week, rb.start_time, rb.end_time, p.full_name
  FROM recurring_bookings rb JOIN profiles p ON p.id = rb.user_id
  WHERE rb.field_id = p_field_id AND rb.status = 'active';
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ============================================================================
-- USER PREFERENCES FUNCTIONS
-- ============================================================================

-- Trigger function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_user_preferences_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Get or create user preferences with default values
CREATE OR REPLACE FUNCTION get_or_create_user_preferences(p_user_id UUID)
RETURNS user_preferences
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_prefs user_preferences;
BEGIN
  SELECT * INTO v_prefs FROM user_preferences WHERE user_id = p_user_id;
  IF NOT FOUND THEN
    INSERT INTO user_preferences (user_id) VALUES (p_user_id) RETURNING * INTO v_prefs;
  END IF;
  RETURN v_prefs;
END;
$$;

-- Check if notification should be sent based on user preferences
CREATE OR REPLACE FUNCTION should_send_notification(p_user_id UUID, p_notification_type TEXT)
RETURNS BOOLEAN
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_prefs user_preferences;
BEGIN
  SELECT * INTO v_prefs FROM user_preferences WHERE user_id = p_user_id;
  IF NOT FOUND THEN RETURN true; END IF;
  IF NOT v_prefs.push_notifications_enabled THEN RETURN false; END IF;
  CASE p_notification_type
    WHEN 'booking_confirmation' THEN RETURN v_prefs.booking_confirmation_notifications;
    WHEN 'booking_reminder' THEN RETURN v_prefs.booking_reminder_notifications;
    WHEN 'booking_status' THEN RETURN v_prefs.booking_status_notifications;
    WHEN 'field_owner_message' THEN RETURN v_prefs.field_owner_messages_notifications;
    ELSE RETURN true;
  END CASE;
END;
$$;
