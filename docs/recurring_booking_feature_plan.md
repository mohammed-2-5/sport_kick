# Recurring Booking Feature Plan

## Feature Summary

Allow users to reserve a weekly time slot that auto-generates bookings (max 4 weeks ahead) until canceled. This creates predictable revenue for field owners and guaranteed slots for regular players.

---

## Business Rules & Decisions

| Decision | Value | Rationale |
|----------|-------|-----------|
| Payment Model | Per-booking (pending until paid & approved) | Ensures steady cash flow, reduces no-shows |
| Cancellation | 1 week notice required, full cancel only | Protects owners from last-minute losses |
| Pause/Skip | Not allowed | Keeps system simple, slots are valuable |
| Max Duration | 4 weeks ahead (rolling) | Balances commitment with flexibility |
| Approval | Owner must approve recurring request | Prevents abuse, allows owner control |
| Conflict UI | Red "Reserved" badge on blocked slots | Clear visual indication for other users |
| Price Lock | Price locked at time of each booking generation | Fair for both parties when prices change |
| Missed Payment | 1 missed payment = auto-cancel recurring | Simple rule, protects owners |

---

## Database Schema

### 1. `recurring_bookings` Table

```sql
-- Recurring booking subscription template
CREATE TABLE recurring_bookings (
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
  started_at DATE, -- When first approved
  last_generated_date DATE, -- Last booking date generated
  next_generation_date DATE, -- When next booking should be created

  -- Approval Workflow
  approved_by UUID REFERENCES profiles(id),
  approved_at TIMESTAMPTZ,
  rejection_reason TEXT,

  -- Cancellation
  canceled_at TIMESTAMPTZ,
  canceled_by UUID REFERENCES profiles(id), -- User, owner, or system
  cancellation_reason TEXT, -- 'user_request', 'missed_payment', 'owner_canceled', etc.

  -- Audit
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),

  -- Constraints
  CONSTRAINT valid_time_range CHECK (end_time > start_time),
  CONSTRAINT valid_duration CHECK (
    EXTRACT(HOUR FROM end_time - start_time) = duration_hours
  )
);

-- Prevent duplicate active/pending subscriptions for same slot
CREATE UNIQUE INDEX idx_recurring_unique_slot
ON recurring_bookings(field_id, day_of_week, start_time)
WHERE status IN ('pending_approval', 'active');

-- Performance indexes
CREATE INDEX idx_recurring_user ON recurring_bookings(user_id);
CREATE INDEX idx_recurring_field ON recurring_bookings(field_id);
CREATE INDEX idx_recurring_status ON recurring_bookings(status) WHERE status = 'active';
CREATE INDEX idx_recurring_next_gen ON recurring_bookings(next_generation_date) WHERE status = 'active';

-- Auto-update timestamp trigger
CREATE TRIGGER set_recurring_updated_at
  BEFORE UPDATE ON recurring_bookings
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
```

### 2. Modify `bookings` Table

```sql
-- Link individual bookings to their recurring parent
ALTER TABLE bookings
ADD COLUMN recurring_booking_id UUID REFERENCES recurring_bookings(id) ON DELETE SET NULL;

-- Add flag for easy filtering
ALTER TABLE bookings
ADD COLUMN is_recurring BOOLEAN GENERATED ALWAYS AS (recurring_booking_id IS NOT NULL) STORED;

-- Index for finding recurring bookings
CREATE INDEX idx_bookings_recurring ON bookings(recurring_booking_id) WHERE recurring_booking_id IS NOT NULL;
```

### 3. Row Level Security Policies

```sql
-- Enable RLS
ALTER TABLE recurring_bookings ENABLE ROW LEVEL SECURITY;

-- Users can view their own recurring bookings
CREATE POLICY "Users view own recurring" ON recurring_bookings
  FOR SELECT USING (auth.uid() = user_id);

-- Users can create recurring booking requests
CREATE POLICY "Users create recurring" ON recurring_bookings
  FOR INSERT WITH CHECK (auth.uid() = user_id AND status = 'pending_approval');

-- Users can cancel their own active recurring bookings
CREATE POLICY "Users cancel own recurring" ON recurring_bookings
  FOR UPDATE USING (auth.uid() = user_id)
  WITH CHECK (status = 'canceled');

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
CREATE POLICY "Super admins full access" ON recurring_bookings
  FOR ALL USING (
    EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'super_admin')
  );
```

---

## Booking Lifecycle Flow

```
┌─────────────────────────────────────────────────────────────────────────┐
│                        RECURRING BOOKING LIFECYCLE                       │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                          │
│  1. USER REQUESTS                                                        │
│     └─> Status: pending_approval                                         │
│         └─> Owner receives notification                                  │
│                                                                          │
│  2. OWNER REVIEWS                                                        │
│     ├─> APPROVE: Status → active                                         │
│     │   └─> Generate 4 weeks of pending bookings                         │
│     │   └─> User receives approval notification                          │
│     │                                                                    │
│     └─> REJECT: Status → rejected                                        │
│         └─> User receives rejection notification with reason             │
│                                                                          │
│  3. WEEKLY CYCLE (for each generated booking)                            │
│     ├─> 4 days before: User notified of upcoming payment                 │
│     ├─> 2 days before: Payment reminder if not paid                      │
│     ├─> User pays → payment_status: pending_verification                 │
│     ├─> Owner verifies → booking status: confirmed                       │
│     └─> Slot date arrives: booking status: completed (auto)              │
│                                                                          │
│  4. BOOKING GENERATION (maintains 4-week buffer)                         │
│     ├─> Triggered when payment is verified                               │
│     ├─> Check if active recurring has < 4 future bookings                │
│     ├─> Generate next booking at field's current price                   │
│     └─> Update last_generated_date                                       │
│                                                                          │
│  5. MISSED PAYMENT = AUTO-CANCEL                                         │
│     ├─> If booking date passes without payment                           │
│     ├─> Recurring status → canceled (reason: 'missed_payment')           │
│     ├─> All future pending bookings canceled                             │
│     └─> User & owner notified                                            │
│                                                                          │
│  6. USER CANCELLATION                                                    │
│     ├─> User requests cancel (1 week notice required)                    │
│     ├─> All future pending bookings are canceled                         │
│     ├─> Status → canceled                                                │
│     └─> Owner notified                                                   │
│                                                                          │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## How It Works Without Cron (Supabase Free Tier)

### The Problem with Cron Jobs
- **pg_cron** requires Supabase Pro plan ($25/month)
- **Supabase Scheduled Functions** also require Pro plan
- We need an alternative for the free tier

### Solution: Event-Driven Architecture (No Cron Needed!)

Instead of scheduled jobs, we use **database triggers** and **payment events** to drive the system:

```
┌─────────────────────────────────────────────────────────────────────────┐
│                    EVENT-DRIVEN BOOKING GENERATION                       │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                          │
│  TRIGGER 1: On Approval                                                  │
│  ─────────────────────────────────────────────────────────────────────  │
│  When: Owner approves recurring booking                                  │
│  Action: Generate 4 weeks of pending bookings immediately                │
│                                                                          │
│  TRIGGER 2: On Payment Verification                                      │
│  ─────────────────────────────────────────────────────────────────────  │
│  When: Owner verifies a recurring booking payment                        │
│  Action: Check if < 4 future bookings exist, generate next one           │
│                                                                          │
│  TRIGGER 3: On App Open / Screen Load                                    │
│  ─────────────────────────────────────────────────────────────────────  │
│  When: User opens "My Bookings" or owner opens dashboard                 │
│  Action: Call cleanup function to check for missed payments              │
│                                                                          │
│  TRIGGER 4: On Booking Query                                             │
│  ─────────────────────────────────────────────────────────────────────  │
│  When: Any booking query for a recurring booking                         │
│  Action: Check if booking date passed + unpaid → auto-cancel             │
│                                                                          │
└─────────────────────────────────────────────────────────────────────────┘
```

### Why This Works Better

| Aspect | Cron Job | Event-Driven |
|--------|----------|--------------|
| Cost | Requires Pro ($25/mo) | Free |
| Timing | Fixed schedule (may miss) | Instant on event |
| Reliability | Can fail silently | Guaranteed execution |
| Debugging | Hard to trace | Clear event chain |
| Scale | Fixed intervals | Scales with usage |

---

## RPC Functions (Supabase Edge Functions)

### User Actions

```sql
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
    cancellation_reason = p_reason,
    updated_at = NOW()
  WHERE id = p_recurring_id;

  -- Cancel all future pending bookings (respecting 1 week notice)
  UPDATE bookings SET
    status = 'canceled',
    updated_at = NOW()
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
  day_of_week INTEGER,
  start_time TIME,
  end_time TIME,
  duration_hours INTEGER,
  status TEXT,
  started_at DATE,
  created_at TIMESTAMPTZ,
  next_booking_date DATE,
  next_booking_paid BOOLEAN,
  total_bookings_count BIGINT,
  completed_bookings_count BIGINT
) AS $$
BEGIN
  RETURN QUERY
  SELECT
    rb.id,
    rb.field_id,
    f.name AS field_name,
    f.image_url AS field_image_url,
    rb.day_of_week,
    rb.start_time,
    rb.end_time,
    rb.duration_hours,
    rb.status,
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
```

### Owner Actions

```sql
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
    started_at = CURRENT_DATE,
    updated_at = NOW()
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
    rejection_reason = p_reason,
    updated_at = NOW()
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
```

### Event-Driven Functions (No Cron!)

```sql
-- ============================================================================
-- TRIGGER 1: Generate next booking when payment is verified
-- ============================================================================
-- This replaces the cron job! Every time a recurring booking payment is verified,
-- we check if we need to generate the next week's booking.

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
        next_generation_date = v_next_date + INTERVAL '7 days',
        updated_at = NOW()
      WHERE id = v_recurring.id;
    END IF;
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Create the trigger
CREATE TRIGGER trigger_recurring_payment_verified
  AFTER UPDATE ON bookings
  FOR EACH ROW
  WHEN (OLD.payment_status IS DISTINCT FROM NEW.payment_status)
  EXECUTE FUNCTION on_recurring_payment_verified();


-- ============================================================================
-- TRIGGER 2: Check for missed payments on any booking query
-- ============================================================================
-- This function is called when querying bookings. It checks if any recurring
-- bookings have missed payments and auto-cancels them.

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
      AND b.date < CURRENT_DATE  -- Booking date has passed
  LOOP
    -- Cancel the recurring booking
    UPDATE recurring_bookings SET
      status = 'canceled',
      canceled_at = NOW(),
      cancellation_reason = 'missed_payment',
      updated_at = NOW()
    WHERE id = v_recurring.id;

    -- Cancel all future pending bookings
    UPDATE bookings SET
      status = 'canceled',
      updated_at = NOW()
    WHERE recurring_booking_id = v_recurring.id
      AND status = 'pending'
      AND date >= CURRENT_DATE;

    -- Mark the missed booking as canceled too
    UPDATE bookings SET
      status = 'canceled',
      updated_at = NOW()
    WHERE recurring_booking_id = v_recurring.id
      AND status = 'pending'
      AND date < CURRENT_DATE;

    v_canceled_count := v_canceled_count + 1;
  END LOOP;

  RETURN v_canceled_count;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;


-- ============================================================================
-- FUNCTION: Get bookings with auto-cleanup (call this instead of direct query)
-- ============================================================================
-- This function first cleans up missed payments, then returns bookings.
-- Use this in your Flutter app when loading bookings.

CREATE OR REPLACE FUNCTION get_user_bookings_with_cleanup()
RETURNS TABLE (
  id UUID,
  field_id UUID,
  field_name TEXT,
  date DATE,
  start_time TIME,
  end_time TIME,
  status TEXT,
  payment_status TEXT,
  total_price DECIMAL,
  is_recurring BOOLEAN,
  recurring_booking_id UUID
) AS $$
BEGIN
  -- First, cleanup any missed recurring payments
  PERFORM check_and_cancel_missed_recurring_payments();

  -- Then return the user's bookings
  RETURN QUERY
  SELECT
    b.id,
    b.field_id,
    f.name AS field_name,
    b.date,
    b.start_time,
    b.end_time,
    b.status,
    b.payment_status,
    b.total_price,
    (b.recurring_booking_id IS NOT NULL) AS is_recurring,
    b.recurring_booking_id
  FROM bookings b
  JOIN fields f ON f.id = b.field_id
  WHERE b.user_id = auth.uid()
  ORDER BY b.date DESC, b.start_time DESC;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;


-- ============================================================================
-- FUNCTION: Get owner bookings with auto-cleanup
-- ============================================================================
CREATE OR REPLACE FUNCTION get_owner_bookings_with_cleanup(p_field_id UUID DEFAULT NULL)
RETURNS TABLE (
  id UUID,
  field_id UUID,
  field_name TEXT,
  user_id UUID,
  user_name TEXT,
  date DATE,
  start_time TIME,
  end_time TIME,
  status TEXT,
  payment_status TEXT,
  total_price DECIMAL,
  is_recurring BOOLEAN
) AS $$
BEGIN
  -- First, cleanup any missed recurring payments
  PERFORM check_and_cancel_missed_recurring_payments();

  -- Then return the owner's bookings
  RETURN QUERY
  SELECT
    b.id,
    b.field_id,
    f.name AS field_name,
    b.user_id,
    p.full_name AS user_name,
    b.date,
    b.start_time,
    b.end_time,
    b.status,
    b.payment_status,
    b.total_price,
    (b.recurring_booking_id IS NOT NULL) AS is_recurring
  FROM bookings b
  JOIN fields f ON f.id = b.field_id
  JOIN profiles p ON p.id = b.user_id
  WHERE f.owner_id = auth.uid()
    AND (p_field_id IS NULL OR b.field_id = p_field_id)
  ORDER BY b.date DESC, b.start_time DESC;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
```

---

## How the Event-Driven System Works

### Scenario 1: New Recurring Booking Approved

```
User requests recurring booking for Fridays at 18:00
                    ↓
Owner approves the request
                    ↓
approve_recurring_booking() runs:
  - Sets status = 'active'
  - Generates 4 bookings: Week 1, 2, 3, 4 (all 'pending' payment)
  - Sets last_generated_date = Week 4's date
                    ↓
User now has 4 pending bookings to pay for
```

### Scenario 2: User Pays for Week 1

```
User uploads payment proof for Week 1 booking
                    ↓
Owner verifies payment → payment_status = 'verified'
                    ↓
trigger_recurring_payment_verified fires:
  - Checks: Are there < 4 future bookings?
  - Yes (only weeks 2, 3, 4 remain = 3 future bookings)
  - Generates Week 5 booking automatically
                    ↓
User now has 4 future bookings again (weeks 2, 3, 4, 5)
```

### Scenario 3: User Misses Payment

```
Week 1 booking date arrives, but payment_status = 'pending'
                    ↓
Next time any booking query happens (user opens app):
                    ↓
get_user_bookings_with_cleanup() runs:
  - Calls check_and_cancel_missed_recurring_payments()
  - Finds Week 1 booking is past date + unpaid
  - Cancels the recurring booking (status = 'canceled')
  - Cancels all future bookings (weeks 2, 3, 4)
                    ↓
User sees their subscription is canceled due to missed payment
```

### Scenario 4: User Wants to Cancel

```
User clicks "Cancel Subscription" (today is Monday)
                    ↓
cancel_recurring_booking() runs:
  - Validates 1-week notice rule
  - Sets status = 'canceled'
  - Cancels bookings from next Monday onwards
  - This week's booking (if exists) remains valid
                    ↓
Owner is notified of cancellation
```

---

## Notification Events

| Event | Recipients | Channel | Timing |
|-------|------------|---------|--------|
| New recurring request | Owner | Push + In-app | Immediate |
| Request approved | User | Push + In-app | Immediate |
| Request rejected | User | Push + In-app | Immediate |
| Upcoming booking | User | Push | 4 days before |
| Payment reminder | User | Push | 2 days before |
| Payment verified | User | Push + In-app | Immediate |
| New booking generated | User | In-app only | On generation |
| Subscription auto-canceled | User + Owner | Push + In-app | Immediate |
| Subscription user-canceled | Owner | Push + In-app | Immediate |

---

## Conflict Resolution

| Scenario | Resolution |
|----------|------------|
| Field hours change, slot no longer available | Notify user, cancel recurring (user can create new request) |
| Field price changes | Use new price for newly generated bookings only |
| Field deleted | Recurring auto-canceled (CASCADE), notify user |
| User deleted | Recurring auto-canceled (CASCADE) |
| Two users request same slot | First approved wins, second gets rejected with explanation |
| Owner force-cancels recurring | 1-week notice to user, refund any pre-paid bookings |
| Missed payment | Auto-cancel immediately, user must create new request |

---

## Flutter Implementation

### 1. Domain Layer

```
lib/features/recurring_bookings/domain/
├── entities/
│   └── recurring_booking_entity.dart
├── repositories/
│   └── recurring_booking_repository.dart
└── usecases/
    ├── create_recurring_request_usecase.dart
    ├── cancel_recurring_booking_usecase.dart
    ├── get_my_recurring_bookings_usecase.dart
    ├── approve_recurring_booking_usecase.dart
    ├── reject_recurring_booking_usecase.dart
    └── get_pending_recurring_requests_usecase.dart
```

### 2. Data Layer

```
lib/features/recurring_bookings/data/
├── models/
│   └── recurring_booking_model.dart
├── datasources/
│   └── recurring_booking_remote_datasource.dart
└── repositories/
    └── recurring_booking_repository_impl.dart
```

### 3. Presentation Layer

```
lib/features/recurring_bookings/presentation/
├── cubit/
│   ├── recurring_booking_cubit.dart
│   ├── recurring_booking_state.dart
│   ├── recurring_requests_cubit.dart      # For owner
│   └── recurring_requests_state.dart
├── pages/
│   ├── my_recurring_bookings_page.dart    # User's subscriptions
│   ├── create_recurring_page.dart         # User creates request
│   └── recurring_requests_page.dart       # Owner approval queue
└── widgets/
    ├── recurring_booking_card.dart
    ├── recurring_request_card.dart
    ├── recurring_toggle_button.dart       # On booking flow
    ├── reserved_slot_badge.dart           # Red badge on time slots
    └── recurring_status_badge.dart
```

---

## Implementation Order

### Phase 1: Database (Day 1-2)
1. [ ] Create `recurring_bookings` table migration
2. [ ] Add `recurring_booking_id` column to `bookings` table
3. [ ] Create indexes for performance
4. [ ] Set up RLS policies
5. [ ] Test schema with sample data

### Phase 2: Backend RPC Functions (Day 3-4)
1. [ ] Implement `create_recurring_booking_request`
2. [ ] Implement `cancel_recurring_booking`
3. [ ] Implement `get_my_recurring_bookings`
4. [ ] Implement `approve_recurring_booking`
5. [ ] Implement `reject_recurring_booking`
6. [ ] Implement `get_pending_recurring_requests`
7. [ ] Test all functions via Supabase dashboard

### Phase 3: Event-Driven Triggers (Day 5)
1. [ ] Implement `on_recurring_payment_verified` trigger
2. [ ] Implement `check_and_cancel_missed_recurring_payments`
3. [ ] Implement `get_user_bookings_with_cleanup`
4. [ ] Implement `get_owner_bookings_with_cleanup`
5. [ ] Test trigger execution manually

### Phase 4: Flutter Domain Layer (Day 6)
1. [ ] Create `RecurringBookingEntity`
2. [ ] Create `RecurringBookingRepository` interface
3. [ ] Create all use cases

### Phase 5: Flutter Data Layer (Day 7)
1. [ ] Create `RecurringBookingModel`
2. [ ] Create `RecurringBookingRemoteDataSource`
3. [ ] Create `RecurringBookingRepositoryImpl`
4. [ ] Register in dependency injection
5. [ ] Update existing booking queries to use cleanup functions

### Phase 6: Flutter User UI (Day 8-9)
1. [ ] Create `RecurringBookingCubit` and states
2. [ ] Create `MyRecurringBookingsPage`
3. [ ] Create `CreateRecurringPage`
4. [ ] Add recurring toggle to booking flow
5. [ ] Create `RecurringBookingCard` widget
6. [ ] Add navigation routes

### Phase 7: Flutter Owner UI (Day 10)
1. [ ] Create `RecurringRequestsCubit` and states
2. [ ] Create `RecurringRequestsPage`
3. [ ] Create `RecurringRequestCard` with approve/reject actions
4. [ ] Add to owner dashboard navigation

### Phase 8: Time Slot UI Updates (Day 11)
1. [ ] Create `ReservedSlotBadge` widget
2. [ ] Update time slot grid to check for recurring conflicts
3. [ ] Show "Reserved" badge on blocked slots
4. [ ] Disable slot selection for reserved times

### Phase 9: Notifications (Day 12)
1. [ ] Integrate with existing notification system
2. [ ] Create notification templates for all events
3. [ ] Test notification delivery

### Phase 10: Testing & Polish (Day 13-14)
1. [ ] Write unit tests for cubits
2. [ ] Write integration tests for booking flow
3. [ ] Edge case testing
4. [ ] UI polish and animations
5. [ ] Documentation

---

## Testing Checklist

### User Flow
- [ ] User can create recurring request
- [ ] User sees pending request in "My Subscriptions"
- [ ] User is notified when approved/rejected
- [ ] User can view all auto-generated bookings
- [ ] User can cancel with 1-week notice
- [ ] User cannot cancel within 1 week

### Owner Flow
- [ ] Owner sees pending requests
- [ ] Owner can approve and 4 bookings are created
- [ ] Owner can reject with reason
- [ ] Owner is notified of cancellations
- [ ] Owner can force-cancel recurring

### Auto-Cancel Flow (Critical!)
- [ ] Booking date passes without payment → recurring canceled
- [ ] All future bookings canceled on missed payment
- [ ] User notified of auto-cancellation
- [ ] Owner notified of auto-cancellation
- [ ] User can create new recurring request after cancel

### Event-Driven Generation
- [ ] Payment verified → next booking generated
- [ ] Always maintains 4 future bookings
- [ ] Price changes apply to newly generated bookings
- [ ] No duplicate bookings generated

### Conflict Handling
- [ ] Cannot request already-reserved slot
- [ ] Reserved slots show badge
- [ ] Field deletion cascades correctly
- [ ] User deletion cascades correctly

---

## Success Metrics

| Metric | Target |
|--------|--------|
| Recurring booking requests per week | Track baseline |
| Approval rate | > 80% |
| Auto-cancellation rate (missed payments) | < 5% |
| User voluntary cancellation rate | < 10% per month |
| User retention (recurring users) | > 90% monthly |

---

## Implementation Progress (Updated: 2025-12-17)

### Completed

#### Phase 1: Database
- [x] Create `recurring_bookings` table migration (`supabase/migrations/20251217_recurring_bookings.sql`)
- [x] Add `recurring_booking_id` column to `bookings` table
- [x] Create indexes for performance
- [x] Set up RLS policies
- [x] Create all RPC functions

#### Phase 4: Flutter Domain Layer
- [x] `RecurringBookingEntity` with status enum
- [x] `RecurringBookingRepository` interface with all operations
- [x] Use cases:
  - `CreateRecurringRequestUseCase`
  - `CancelRecurringBookingUseCase`
  - `GetMyRecurringBookingsUseCase`
  - `ApproveRecurringBookingUseCase`
  - `RejectRecurringBookingUseCase`
  - `GetPendingRecurringRequestsUseCase`
  - `GetReservedSlotsUseCase`

#### Phase 5: Flutter Data Layer
- [x] `RecurringBookingModel` with JSON serialization
- [x] `RecurringBookingRemoteDataSource` with Supabase RPC calls
- [x] `RecurringBookingRepositoryImpl` with error handling
- [x] Registered in dependency injection (`injection_container.dart`)

#### Phase 6: Flutter User UI
- [x] `MyRecurringBookingsCubit` and `MyRecurringBookingsState`
- [x] `CreateRecurringCubit` and `CreateRecurringState`
- [x] `MyRecurringBookingsPage` with cancel confirmation dialog
- [x] `CreateRecurringPage` with success dialog
- [x] `MyRecurringBookingsContent` with sections (active, pending, history)
- [x] `CreateRecurringContent` with field card, summary
- [x] `RecurringBookingCard` with progress indicator
- [x] `RecurringStatusBadge` with colors/icons
- [x] `DaySelector` for weekly day selection
- [x] `RecurringDurationSelector` for 1h/2h toggle
- [x] `RecurringTimeSlotGrid` with reserved slot indicators

#### Phase 7: Flutter Owner UI
- [x] `RecurringRequestsCubit` and `RecurringRequestsState`
- [x] `RecurringRequestsPage` with stats and reject dialog
- [x] `RecurringRequestsContent` with pending/active sections
- [x] `RecurringRequestCard` with approve/reject buttons
- [x] `ActiveSubscriptionCard` for owner view

#### Phase 8: Time Slot UI Updates
- [x] Reserved slots show red badge in `RecurringTimeSlotGrid`
- [x] Tooltip showing who reserved the slot
- [x] Disabled slot selection for reserved times

#### Routes Added
- `/myRecurringBookings` - User's recurring subscriptions
- `/createRecurring` - Create new recurring booking (requires field)
- `/owner/recurring-requests` - Owner's recurring requests management

### Pending

#### Phase 2-3: Backend Triggers
- [ ] Test RPC functions in Supabase dashboard
- [ ] Verify trigger execution for payment verification
- [ ] Test auto-cancel on missed payment

#### Phase 9: Notifications
- [ ] Integrate recurring booking events with notification system
- [ ] Create notification templates for approval/rejection
- [ ] Add payment reminder notifications

#### Phase 10: Testing & Polish
- [ ] Write unit tests for recurring booking cubits
- [ ] Integration tests for full flow
- [ ] Edge case testing (conflicts, cancellations)
- [ ] UI polish and animations

### Files Created

```
lib/features/recurring_bookings/
├── data/
│   ├── datasources/
│   │   └── recurring_booking_remote_datasource.dart
│   ├── models/
│   │   └── recurring_booking_model.dart
│   └── repositories/
│       └── recurring_booking_repository_impl.dart
├── domain/
│   ├── entities/
│   │   └── recurring_booking_entity.dart
│   ├── repositories/
│   │   └── recurring_booking_repository.dart
│   └── usecases/
│       ├── approve_recurring_booking_usecase.dart
│       ├── cancel_recurring_booking_usecase.dart
│       ├── create_recurring_request_usecase.dart
│       ├── get_my_recurring_bookings_usecase.dart
│       ├── get_pending_recurring_requests_usecase.dart
│       ├── get_reserved_slots_usecase.dart
│       └── reject_recurring_booking_usecase.dart
└── presentation/
    ├── cubit/
    │   ├── create_recurring_cubit.dart
    │   ├── create_recurring_state.dart
    │   ├── my_recurring_bookings_cubit.dart
    │   ├── my_recurring_bookings_state.dart
    │   ├── recurring_requests_cubit.dart
    │   └── recurring_requests_state.dart
    ├── pages/
    │   ├── create_recurring_page.dart
    │   ├── my_recurring_bookings_page.dart
    │   └── recurring_requests_page.dart
    └── widgets/
        ├── active_subscription_card.dart
        ├── create_recurring_content.dart
        ├── day_selector.dart
        ├── my_recurring_bookings_content.dart
        ├── recurring_booking_card.dart
        ├── recurring_duration_selector.dart
        ├── recurring_request_card.dart
        ├── recurring_requests_content.dart
        ├── recurring_status_badge.dart
        └── recurring_time_slot_grid.dart
```

### Database Migration
- `supabase/migrations/20251217_recurring_bookings.sql`
