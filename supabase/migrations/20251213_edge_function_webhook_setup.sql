-- ============================================================================
-- Migration: Setup Edge Function Webhook for Push Notifications
-- Date: December 13, 2025
-- Purpose: Configure database webhook to trigger Edge Function on notification insert
-- ============================================================================

-- ============================================================================
-- OPTION 1: Database Webhook (Recommended for Supabase hosted)
-- ============================================================================
-- Configure this in Supabase Dashboard:
-- 1. Go to Database > Webhooks
-- 2. Create new webhook with:
--    - Name: send_push_notification
--    - Table: notifications
--    - Events: INSERT
--    - Type: Supabase Edge Functions
--    - Function: send-push-notification
-- ============================================================================

-- ============================================================================
-- OPTION 2: pg_net extension (Alternative for self-hosted)
-- ============================================================================
-- Uncomment if using pg_net extension instead of webhooks

-- Enable pg_net extension (if available)
-- CREATE EXTENSION IF NOT EXISTS pg_net;

-- Function to call Edge Function via pg_net
/*
CREATE OR REPLACE FUNCTION call_send_push_notification()
RETURNS TRIGGER AS $$
DECLARE
  v_url TEXT;
  v_payload JSONB;
BEGIN
  -- Get the Edge Function URL from environment or hardcode
  v_url := 'https://YOUR_PROJECT_REF.supabase.co/functions/v1/send-push-notification';
  
  -- Build payload matching webhook format
  v_payload := jsonb_build_object(
    'type', 'INSERT',
    'table', 'notifications',
    'schema', 'public',
    'record', row_to_json(NEW)::jsonb,
    'old_record', NULL
  );
  
  -- Call Edge Function asynchronously
  PERFORM net.http_post(
    url := v_url,
    headers := jsonb_build_object(
      'Content-Type', 'application/json',
      'Authorization', 'Bearer ' || current_setting('app.settings.service_key', true)
    ),
    body := v_payload::text
  );
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Create trigger to call Edge Function
DROP TRIGGER IF EXISTS trigger_send_push_notification ON public.notifications;
CREATE TRIGGER trigger_send_push_notification
    AFTER INSERT ON public.notifications
    FOR EACH ROW
    EXECUTE FUNCTION call_send_push_notification();
*/

-- ============================================================================
-- Alternative: Simple polling approach (for testing without webhooks)
-- ============================================================================
-- The app can poll for new notifications using realtime subscriptions
-- which is already implemented in the NotificationRemoteDataSource

-- ============================================================================
-- Required Environment Variables for Edge Function:
-- ============================================================================
-- Set these in Supabase Dashboard > Edge Functions > send-push-notification > Secrets:
--
-- FIREBASE_SERVICE_ACCOUNT: Your Firebase service account JSON (stringify it)
-- FIREBASE_PROJECT_ID: Your Firebase project ID (e.g., "spo-kick-12345")
--
-- To get Firebase service account:
-- 1. Go to Firebase Console > Project Settings > Service Accounts
-- 2. Click "Generate new private key"
-- 3. Copy the entire JSON content
-- 4. Stringify it (remove newlines) and set as FIREBASE_SERVICE_ACCOUNT secret
-- ============================================================================

-- ============================================================================
-- Testing: Manual notification insert
-- ============================================================================
-- Use this to test the notification system:
/*
INSERT INTO public.notifications (
    user_id,
    title,
    body,
    type,
    reference_id,
    reference_type,
    data
) VALUES (
    'YOUR_TEST_USER_ID',  -- Replace with actual user ID
    'Test Notification 🔔',
    'This is a test notification from the database.',
    'system',
    NULL,
    NULL,
    '{}'::jsonb
);
*/

-- ============================================================================
-- Verify FCM tokens are being stored
-- ============================================================================
-- Check if FCM tokens exist for users:
-- SELECT user_id, user_role, LEFT(fcm_token, 30) || '...' as token_preview, updated_at
-- FROM public.user_fcm_tokens
-- ORDER BY updated_at DESC;
