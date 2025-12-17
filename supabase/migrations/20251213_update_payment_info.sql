-- ============================================
-- Update Payment Info for Existing Fields
-- Date: 2025-12-13
-- Description: Sets default payment phone and method for all fields
-- ============================================

-- Update all fields with default Vodafone Cash payment info
UPDATE fields
SET 
  payment_phone = '01068700814',
  payment_method = 'vodafone_cash'
WHERE payment_phone IS NULL OR payment_phone = '';

-- Verify the update
SELECT 
  id,
  name,
  payment_phone,
  payment_method
FROM fields
ORDER BY created_at DESC;

-- ============================================
-- Optional: Update specific field by ID
-- ============================================
-- UPDATE fields
-- SET 
--   payment_phone = '01068700814',
--   payment_method = 'vodafone_cash'
-- WHERE id = 'your-field-id-here';

-- ============================================
-- Optional: Update fields for specific admin
-- ============================================
-- UPDATE fields
-- SET 
--   payment_phone = '01068700814',
--   payment_method = 'vodafone_cash'
-- WHERE owner_id = 'admin-user-id-here';

-- ============================================
-- Check payment method enum values used
-- ============================================
-- Valid values: 'vodafone_cash', 'instapay'

COMMENT ON COLUMN fields.payment_phone IS 'Phone number for mobile wallet payments (Vodafone Cash, InstaPay). Default: 01068700814';
COMMENT ON COLUMN fields.payment_method IS 'Payment method: vodafone_cash or instapay. Default: vodafone_cash';
