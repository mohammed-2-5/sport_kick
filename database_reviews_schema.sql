-- ============================================================================
-- REVIEWS & RATINGS SYSTEM DATABASE SCHEMA
-- ============================================================================
-- This schema creates the reviews table and related database functions
-- for the Sport Kick application's review and rating system.
--
-- Run this script in your Supabase SQL Editor to set up the reviews feature.
-- ============================================================================

-- ============================================================================
-- 1. CREATE REVIEWS TABLE
-- ============================================================================

CREATE TABLE IF NOT EXISTS reviews (
  -- Primary identifier
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

  -- Foreign keys
  field_id UUID NOT NULL REFERENCES fields(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  booking_id UUID REFERENCES bookings(id) ON DELETE SET NULL,

  -- Review data
  rating INTEGER NOT NULL CHECK (rating >= 1 AND rating <= 5),
  comment TEXT,

  -- Metadata
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

  -- Constraints
  CONSTRAINT unique_user_field_review UNIQUE (user_id, field_id, booking_id)
);

-- ============================================================================
-- 2. CREATE INDEXES FOR PERFORMANCE
-- ============================================================================

-- Index for fetching reviews by field (most common query)
CREATE INDEX IF NOT EXISTS idx_reviews_field_id ON reviews(field_id);

-- Index for fetching reviews by user
CREATE INDEX IF NOT EXISTS idx_reviews_user_id ON reviews(user_id);

-- Index for fetching reviews by booking
CREATE INDEX IF NOT EXISTS idx_reviews_booking_id ON reviews(booking_id);

-- Index for sorting by date
CREATE INDEX IF NOT EXISTS idx_reviews_created_at ON reviews(created_at DESC);

-- Index for filtering by rating
CREATE INDEX IF NOT EXISTS idx_reviews_rating ON reviews(rating);

-- ============================================================================
-- 3. CREATE TRIGGER TO UPDATE updated_at TIMESTAMP
-- ============================================================================

CREATE OR REPLACE FUNCTION update_reviews_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_reviews_updated_at
  BEFORE UPDATE ON reviews
  FOR EACH ROW
  EXECUTE FUNCTION update_reviews_updated_at();

-- ============================================================================
-- 4. CREATE FUNCTION TO UPDATE FIELD STATISTICS
-- ============================================================================

-- Function to recalculate field's average rating and review count
CREATE OR REPLACE FUNCTION update_field_review_stats(p_field_id UUID)
RETURNS VOID AS $$
DECLARE
  v_avg_rating DECIMAL(3,2);
  v_review_count INTEGER;
BEGIN
  -- Calculate average rating and count
  SELECT
    ROUND(AVG(rating)::NUMERIC, 2),
    COUNT(*)
  INTO v_avg_rating, v_review_count
  FROM reviews
  WHERE field_id = p_field_id;

  -- Update the field
  UPDATE fields
  SET
    average_rating = v_avg_rating,
    total_reviews = v_review_count,
    updated_at = NOW()
  WHERE id = p_field_id;
END;
$$ LANGUAGE plpgsql;

-- ============================================================================
-- 5. CREATE TRIGGERS TO AUTO-UPDATE FIELD STATISTICS
-- ============================================================================

-- Trigger after INSERT
CREATE OR REPLACE FUNCTION trigger_after_review_insert()
RETURNS TRIGGER AS $$
BEGIN
  PERFORM update_field_review_stats(NEW.field_id);
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER after_review_insert
  AFTER INSERT ON reviews
  FOR EACH ROW
  EXECUTE FUNCTION trigger_after_review_insert();

-- Trigger after UPDATE
CREATE OR REPLACE FUNCTION trigger_after_review_update()
RETURNS TRIGGER AS $$
BEGIN
  -- Update stats for both old and new field (in case field_id changed)
  IF OLD.field_id != NEW.field_id THEN
    PERFORM update_field_review_stats(OLD.field_id);
  END IF;
  PERFORM update_field_review_stats(NEW.field_id);
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER after_review_update
  AFTER UPDATE ON reviews
  FOR EACH ROW
  EXECUTE FUNCTION trigger_after_review_update();

-- Trigger after DELETE
CREATE OR REPLACE FUNCTION trigger_after_review_delete()
RETURNS TRIGGER AS $$
BEGIN
  PERFORM update_field_review_stats(OLD.field_id);
  RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER after_review_delete
  AFTER DELETE ON reviews
  FOR EACH ROW
  EXECUTE FUNCTION trigger_after_review_delete();

-- ============================================================================
-- 6. ROW LEVEL SECURITY (RLS) POLICIES
-- ============================================================================

-- Enable RLS on reviews table
ALTER TABLE reviews ENABLE ROW LEVEL SECURITY;

-- Policy: Anyone can view reviews
CREATE POLICY "Reviews are viewable by everyone"
  ON reviews
  FOR SELECT
  TO authenticated
  USING (true);

-- Policy: Users can create reviews for their own bookings
CREATE POLICY "Users can create reviews for their bookings"
  ON reviews
  FOR INSERT
  TO authenticated
  WITH CHECK (
    auth.uid() = user_id
    AND EXISTS (
      SELECT 1 FROM bookings
      WHERE id = booking_id
      AND user_id = auth.uid()
      AND status = 'completed'
    )
  );

-- Policy: Users can update their own reviews
CREATE POLICY "Users can update their own reviews"
  ON reviews
  FOR UPDATE
  TO authenticated
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

-- Policy: Users can delete their own reviews
CREATE POLICY "Users can delete their own reviews"
  ON reviews
  FOR DELETE
  TO authenticated
  USING (auth.uid() = user_id);

-- Policy: Super admins can do everything
CREATE POLICY "Super admins have full access to reviews"
  ON reviews
  FOR ALL
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM profiles
      WHERE id = auth.uid()
      AND role = 'super_admin'
    )
  );

-- ============================================================================
-- 7. HELPER FUNCTIONS
-- ============================================================================

-- Function to get reviews for a specific field with pagination
CREATE OR REPLACE FUNCTION get_field_reviews(
  p_field_id UUID,
  p_limit INTEGER DEFAULT 10,
  p_offset INTEGER DEFAULT 0
)
RETURNS TABLE (
  id UUID,
  field_id UUID,
  user_id UUID,
  booking_id UUID,
  rating INTEGER,
  comment TEXT,
  created_at TIMESTAMPTZ,
  updated_at TIMESTAMPTZ,
  user_name TEXT,
  user_avatar TEXT
) AS $$
BEGIN
  RETURN QUERY
  SELECT
    r.id,
    r.field_id,
    r.user_id,
    r.booking_id,
    r.rating,
    r.comment,
    r.created_at,
    r.updated_at,
    p.full_name as user_name,
    p.avatar_url as user_avatar
  FROM reviews r
  INNER JOIN profiles p ON r.user_id = p.id
  WHERE r.field_id = p_field_id
  ORDER BY r.created_at DESC
  LIMIT p_limit
  OFFSET p_offset;
END;
$$ LANGUAGE plpgsql;

-- Function to check if user can review a field
CREATE OR REPLACE FUNCTION can_user_review_field(
  p_user_id UUID,
  p_field_id UUID,
  p_booking_id UUID
)
RETURNS BOOLEAN AS $$
DECLARE
  v_can_review BOOLEAN;
BEGIN
  -- Check if:
  -- 1. User has a completed booking for this field
  -- 2. User hasn't already reviewed this booking
  SELECT EXISTS (
    SELECT 1 FROM bookings
    WHERE id = p_booking_id
    AND user_id = p_user_id
    AND field_id = p_field_id
    AND status = 'completed'
    AND NOT EXISTS (
      SELECT 1 FROM reviews
      WHERE booking_id = p_booking_id
    )
  ) INTO v_can_review;

  RETURN v_can_review;
END;
$$ LANGUAGE plpgsql;

-- Function to get user's review for a field
CREATE OR REPLACE FUNCTION get_user_field_review(
  p_user_id UUID,
  p_field_id UUID
)
RETURNS TABLE (
  id UUID,
  field_id UUID,
  user_id UUID,
  booking_id UUID,
  rating INTEGER,
  comment TEXT,
  created_at TIMESTAMPTZ,
  updated_at TIMESTAMPTZ
) AS $$
BEGIN
  RETURN QUERY
  SELECT
    r.id,
    r.field_id,
    r.user_id,
    r.booking_id,
    r.rating,
    r.comment,
    r.created_at,
    r.updated_at
  FROM reviews r
  WHERE r.user_id = p_user_id
  AND r.field_id = p_field_id
  ORDER BY r.created_at DESC
  LIMIT 1;
END;
$$ LANGUAGE plpgsql;

-- ============================================================================
-- 8. SAMPLE DATA (OPTIONAL - FOR TESTING)
-- ============================================================================

-- Uncomment below to insert sample reviews for testing
-- NOTE: Make sure you have valid field_id, user_id, and booking_id values

/*
INSERT INTO reviews (field_id, user_id, booking_id, rating, comment) VALUES
  ('field-uuid-1', 'user-uuid-1', 'booking-uuid-1', 5, 'Excellent field! Great condition and facilities.'),
  ('field-uuid-1', 'user-uuid-2', 'booking-uuid-2', 4, 'Very good experience. The lighting could be better.'),
  ('field-uuid-2', 'user-uuid-3', 'booking-uuid-3', 5, 'Perfect for our team. Will definitely book again!');
*/

-- ============================================================================
-- SCHEMA SETUP COMPLETE
-- ============================================================================
--
-- Next steps:
-- 1. Run this script in Supabase SQL Editor
-- 2. Verify that the reviews table was created successfully
-- 3. Check that all triggers and functions are working
-- 4. Test RLS policies with different user roles
-- 5. Implement the Flutter app integration
--
-- ============================================================================
