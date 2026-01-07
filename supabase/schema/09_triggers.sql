-- ============================================================================
-- TRIGGERS
-- Sport Kick Database - Schema Part 9
-- ============================================================================

-- ============================================================================
-- BOOKINGS TRIGGERS
-- ============================================================================

-- Auto-generate invoice number
DROP TRIGGER IF EXISTS trigger_set_invoice_number ON bookings;
CREATE TRIGGER trigger_set_invoice_number
  BEFORE INSERT ON bookings
  FOR EACH ROW
  EXECUTE FUNCTION set_invoice_number();

-- Validate booking date (INSERT only)
DROP TRIGGER IF EXISTS validate_booking_date_trigger ON bookings;
CREATE TRIGGER validate_booking_date_trigger
  BEFORE INSERT ON bookings
  FOR EACH ROW
  EXECUTE FUNCTION validate_booking_date_on_insert();

-- Notify owner on new booking
DROP TRIGGER IF EXISTS trigger_notify_owner_new_booking ON bookings;
CREATE TRIGGER trigger_notify_owner_new_booking
  AFTER INSERT ON bookings
  FOR EACH ROW
  EXECUTE FUNCTION notify_field_owner_on_booking();

-- Notify owner on payment proof upload
DROP TRIGGER IF EXISTS trigger_notify_owner_payment_upload ON bookings;
CREATE TRIGGER trigger_notify_owner_payment_upload
  AFTER UPDATE ON bookings
  FOR EACH ROW
  WHEN (OLD.payment_proof_url IS DISTINCT FROM NEW.payment_proof_url)
  EXECUTE FUNCTION notify_owner_on_payment_upload();

-- Generate next recurring booking on payment verified
DROP TRIGGER IF EXISTS trigger_recurring_payment_verified ON bookings;
CREATE TRIGGER trigger_recurring_payment_verified
  AFTER UPDATE ON bookings
  FOR EACH ROW
  WHEN (OLD.payment_status IS DISTINCT FROM NEW.payment_status)
  EXECUTE FUNCTION on_recurring_payment_verified();

-- ============================================================================
-- BUSINESS HOURS TRIGGERS
-- ============================================================================

DROP TRIGGER IF EXISTS trigger_update_business_hours_updated_at ON business_hours;
CREATE TRIGGER trigger_update_business_hours_updated_at
  BEFORE UPDATE ON business_hours
  FOR EACH ROW
  EXECUTE FUNCTION update_business_hours_updated_at();

-- ============================================================================
-- REVIEWS TRIGGERS
-- ============================================================================

DROP TRIGGER IF EXISTS trigger_update_reviews_updated_at ON reviews;
CREATE TRIGGER trigger_update_reviews_updated_at
  BEFORE UPDATE ON reviews
  FOR EACH ROW
  EXECUTE FUNCTION update_reviews_updated_at();

DROP TRIGGER IF EXISTS after_review_insert ON reviews;
CREATE TRIGGER after_review_insert
  AFTER INSERT ON reviews
  FOR EACH ROW
  EXECUTE FUNCTION trigger_after_review_insert();

DROP TRIGGER IF EXISTS after_review_update ON reviews;
CREATE TRIGGER after_review_update
  AFTER UPDATE ON reviews
  FOR EACH ROW
  EXECUTE FUNCTION trigger_after_review_update();

DROP TRIGGER IF EXISTS after_review_delete ON reviews;
CREATE TRIGGER after_review_delete
  AFTER DELETE ON reviews
  FOR EACH ROW
  EXECUTE FUNCTION trigger_after_review_delete();

-- ============================================================================
-- FCM TOKENS TRIGGERS
-- ============================================================================

DROP TRIGGER IF EXISTS trigger_user_fcm_tokens_updated_at ON user_fcm_tokens;
CREATE TRIGGER trigger_user_fcm_tokens_updated_at
  BEFORE UPDATE ON user_fcm_tokens
  FOR EACH ROW
  EXECUTE FUNCTION update_user_fcm_tokens_updated_at();

-- ============================================================================
-- RECURRING BOOKINGS TRIGGERS
-- ============================================================================

DROP TRIGGER IF EXISTS set_recurring_updated_at ON recurring_bookings;
CREATE TRIGGER set_recurring_updated_at
  BEFORE UPDATE ON recurring_bookings
  FOR EACH ROW
  EXECUTE FUNCTION update_recurring_updated_at();

-- ============================================================================
-- USER PREFERENCES TRIGGERS
-- ============================================================================

DROP TRIGGER IF EXISTS trigger_update_user_preferences_updated_at ON user_preferences;
CREATE TRIGGER trigger_update_user_preferences_updated_at
  BEFORE UPDATE ON user_preferences
  FOR EACH ROW
  EXECUTE FUNCTION update_user_preferences_updated_at();
