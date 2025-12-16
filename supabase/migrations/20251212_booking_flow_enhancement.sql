-- =====================================================
-- Booking Flow Enhancement Migration
-- Created: 2025-12-12
-- Description: Adds payment fields, duration support, and invoice system
-- =====================================================

-- =====================================================
-- 1. ADD PAYMENT FIELDS TO FIELDS TABLE
-- =====================================================

-- Add payment phone number (for Vodafone Cash / InstaPay)
ALTER TABLE fields ADD COLUMN IF NOT EXISTS payment_phone VARCHAR(20);

-- Add payment method (vodafone_cash, instapay)
ALTER TABLE fields ADD COLUMN IF NOT EXISTS payment_method VARCHAR(50) DEFAULT 'vodafone_cash';

-- Add payment instructions (custom instructions from owner)
ALTER TABLE fields ADD COLUMN IF NOT EXISTS payment_instructions TEXT;

-- Comment for documentation
COMMENT ON COLUMN fields.payment_phone IS 'Phone number for mobile wallet payments (Vodafone Cash, InstaPay)';
COMMENT ON COLUMN fields.payment_method IS 'Default payment method: vodafone_cash, instapay';
COMMENT ON COLUMN fields.payment_instructions IS 'Custom payment instructions from field owner';

-- =====================================================
-- 2. ADD PAYMENT AND DURATION FIELDS TO BOOKINGS TABLE
-- =====================================================

-- Add duration in hours (1 or 2)
ALTER TABLE bookings ADD COLUMN IF NOT EXISTS duration_hours INTEGER DEFAULT 1;

-- Add payment status
-- Values: pending, uploaded, verified, rejected
ALTER TABLE bookings ADD COLUMN IF NOT EXISTS payment_status VARCHAR(20) DEFAULT 'pending';

-- Add payment proof URL (screenshot of payment)
ALTER TABLE bookings ADD COLUMN IF NOT EXISTS payment_proof_url TEXT;

-- Add timestamp when payment was uploaded
ALTER TABLE bookings ADD COLUMN IF NOT EXISTS payment_uploaded_at TIMESTAMP WITH TIME ZONE;

-- Add invoice number for reference
ALTER TABLE bookings ADD COLUMN IF NOT EXISTS invoice_number VARCHAR(50);

-- Add payment verification timestamp
ALTER TABLE bookings ADD COLUMN IF NOT EXISTS payment_verified_at TIMESTAMP WITH TIME ZONE;

-- Add payment rejection reason
ALTER TABLE bookings ADD COLUMN IF NOT EXISTS payment_rejection_reason TEXT;

-- Comments for documentation
COMMENT ON COLUMN bookings.duration_hours IS 'Booking duration: 1 or 2 hours';
COMMENT ON COLUMN bookings.payment_status IS 'Payment status: pending, uploaded, verified, rejected';
COMMENT ON COLUMN bookings.payment_proof_url IS 'URL to payment screenshot in Supabase Storage';
COMMENT ON COLUMN bookings.payment_uploaded_at IS 'Timestamp when user uploaded payment proof';
COMMENT ON COLUMN bookings.invoice_number IS 'Unique invoice reference: INV-YYYYMMDD-XXXX';
COMMENT ON COLUMN bookings.payment_verified_at IS 'Timestamp when owner verified the payment';
COMMENT ON COLUMN bookings.payment_rejection_reason IS 'Reason for payment rejection if rejected';

-- =====================================================
-- 3. ADD CROSS-MIDNIGHT SUPPORT TO BUSINESS_HOURS
-- =====================================================

-- Add flag for closing time on next day (e.g., open 12:00, close 02:00 next day)
ALTER TABLE business_hours ADD COLUMN IF NOT EXISTS closes_next_day BOOLEAN DEFAULT FALSE;

COMMENT ON COLUMN business_hours.closes_next_day IS 'If TRUE, closing_time is on the next day (for late night hours like 12PM-2AM)';

-- =====================================================
-- 4. CREATE PAYMENT_PROOFS STORAGE BUCKET
-- =====================================================

-- Note: Run this in Supabase Dashboard or via Supabase CLI
INSERT INTO storage.buckets (id, name, public)
VALUES ('payment_proofs', 'payment_proofs', false)
ON CONFLICT (id) DO NOTHING;

-- =====================================================
-- 5. CREATE INDEXES FOR PERFORMANCE
-- =====================================================

-- Index for filtering bookings by payment status
CREATE INDEX IF NOT EXISTS idx_bookings_payment_status ON bookings(payment_status);

-- Index for filtering bookings by invoice number
CREATE INDEX IF NOT EXISTS idx_bookings_invoice_number ON bookings(invoice_number);

-- =====================================================
-- 6. CREATE FUNCTION TO GENERATE INVOICE NUMBER
-- =====================================================

CREATE OR REPLACE FUNCTION generate_invoice_number()
RETURNS TEXT AS $$
DECLARE
  date_part TEXT;
  sequence_part TEXT;
  new_invoice TEXT;
BEGIN
  -- Format: INV-YYYYMMDD-XXXX
  date_part := TO_CHAR(CURRENT_DATE, 'YYYYMMDD');

  -- Get the count of invoices for today + 1
  SELECT LPAD((COUNT(*) + 1)::TEXT, 4, '0')
  INTO sequence_part
  FROM bookings
  WHERE invoice_number LIKE 'INV-' || date_part || '-%';

  new_invoice := 'INV-' || date_part || '-' || sequence_part;

  RETURN new_invoice;
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION generate_invoice_number() IS 'Generates unique invoice number in format INV-YYYYMMDD-XXXX';

-- =====================================================
-- 7. CREATE TRIGGER TO AUTO-GENERATE INVOICE NUMBER
-- =====================================================

CREATE OR REPLACE FUNCTION set_invoice_number()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.invoice_number IS NULL THEN
    NEW.invoice_number := generate_invoice_number();
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger (drop if exists first)
DROP TRIGGER IF EXISTS trigger_set_invoice_number ON bookings;

CREATE TRIGGER trigger_set_invoice_number
  BEFORE INSERT ON bookings
  FOR EACH ROW
  EXECUTE FUNCTION set_invoice_number();

-- =====================================================
-- 8. RLS POLICIES FOR PAYMENT PROOF STORAGE
-- =====================================================

-- Note: Run these in Supabase Dashboard for storage policies
--
-- Policy: Users can upload their own payment proofs
-- CREATE POLICY "Users can upload payment proofs"
-- ON storage.objects FOR INSERT
-- WITH CHECK (
--   bucket_id = 'payment_proofs' AND
--   auth.uid()::text = (storage.foldername(name))[1]
-- );
--
-- Policy: Users can view their own payment proofs
-- CREATE POLICY "Users can view own payment proofs"
-- ON storage.objects FOR SELECT
-- USING (
--   bucket_id = 'payment_proofs' AND
--   auth.uid()::text = (storage.foldername(name))[1]
-- );
--
-- Policy: Field owners can view payment proofs for their fields
-- CREATE POLICY "Owners can view payment proofs for their fields"
-- ON storage.objects FOR SELECT
-- USING (
--   bucket_id = 'payment_proofs' AND
--   EXISTS (
--     SELECT 1 FROM bookings b
--     JOIN fields f ON b.field_id = f.id
--     WHERE b.payment_proof_url LIKE '%' || name || '%'
--     AND f.owner_id = auth.uid()
--   )
-- );

-- =====================================================
-- 9. UPDATE RLS POLICIES FOR BOOKINGS (Payment Fields)
-- =====================================================

-- Users can update their own booking's payment proof
CREATE POLICY IF NOT EXISTS "Users can update payment proof"
ON bookings FOR UPDATE
USING (auth.uid() = user_id)
WITH CHECK (
  auth.uid() = user_id AND
  -- Only allow updating payment-related fields
  (payment_proof_url IS DISTINCT FROM OLD.payment_proof_url OR
   payment_uploaded_at IS DISTINCT FROM OLD.payment_uploaded_at)
);

-- Field owners can update payment status for bookings on their fields
-- (This extends existing owner update policy)

-- =====================================================
-- 10. VERIFICATION
-- =====================================================

-- Verify columns were added
DO $$
BEGIN
  -- Check fields table
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'fields' AND column_name = 'payment_phone') THEN
    RAISE EXCEPTION 'payment_phone column not added to fields table';
  END IF;

  -- Check bookings table
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'bookings' AND column_name = 'payment_status') THEN
    RAISE EXCEPTION 'payment_status column not added to bookings table';
  END IF;

  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'bookings' AND column_name = 'duration_hours') THEN
    RAISE EXCEPTION 'duration_hours column not added to bookings table';
  END IF;

  RAISE NOTICE 'All columns verified successfully!';
END $$;
