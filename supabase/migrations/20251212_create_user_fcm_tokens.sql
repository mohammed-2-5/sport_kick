-- Migration: Create user_fcm_tokens table for Firebase Cloud Messaging
-- Date: 2025-12-12
-- Purpose: Store FCM tokens for push notifications

-- Create the user_fcm_tokens table
CREATE TABLE IF NOT EXISTS public.user_fcm_tokens (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    fcm_token TEXT NOT NULL,
    user_role TEXT NOT NULL DEFAULT 'user',
    device_info JSONB,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(user_id)
);

-- Create index for faster lookups
CREATE INDEX IF NOT EXISTS idx_user_fcm_tokens_user_id ON public.user_fcm_tokens(user_id);
CREATE INDEX IF NOT EXISTS idx_user_fcm_tokens_user_role ON public.user_fcm_tokens(user_role);

-- Enable Row Level Security
ALTER TABLE public.user_fcm_tokens ENABLE ROW LEVEL SECURITY;

-- Policy: Users can only see their own tokens
CREATE POLICY "Users can view own FCM tokens" ON public.user_fcm_tokens
    FOR SELECT USING (auth.uid() = user_id);

-- Policy: Users can insert their own tokens
CREATE POLICY "Users can insert own FCM tokens" ON public.user_fcm_tokens
    FOR INSERT WITH CHECK (auth.uid() = user_id);

-- Policy: Users can update their own tokens
CREATE POLICY "Users can update own FCM tokens" ON public.user_fcm_tokens
    FOR UPDATE USING (auth.uid() = user_id);

-- Policy: Users can delete their own tokens
CREATE POLICY "Users can delete own FCM tokens" ON public.user_fcm_tokens
    FOR DELETE USING (auth.uid() = user_id);

-- Policy: Super admins can view all tokens (for sending notifications)
CREATE POLICY "Super admins can view all FCM tokens" ON public.user_fcm_tokens
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM public.profiles
            WHERE id = auth.uid() AND role = 'super_admin'
        )
    );

-- Create function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_user_fcm_tokens_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger for updated_at
DROP TRIGGER IF EXISTS trigger_user_fcm_tokens_updated_at ON public.user_fcm_tokens;
CREATE TRIGGER trigger_user_fcm_tokens_updated_at
    BEFORE UPDATE ON public.user_fcm_tokens
    FOR EACH ROW
    EXECUTE FUNCTION update_user_fcm_tokens_updated_at();

-- Grant permissions
GRANT ALL ON public.user_fcm_tokens TO authenticated;
GRANT ALL ON public.user_fcm_tokens TO service_role;

-- Comment on table
COMMENT ON TABLE public.user_fcm_tokens IS 'Stores Firebase Cloud Messaging tokens for push notifications';
COMMENT ON COLUMN public.user_fcm_tokens.user_id IS 'Reference to the user in auth.users';
COMMENT ON COLUMN public.user_fcm_tokens.fcm_token IS 'Firebase Cloud Messaging token';
COMMENT ON COLUMN public.user_fcm_tokens.user_role IS 'User role (user, admin, super_admin) for topic subscriptions';
COMMENT ON COLUMN public.user_fcm_tokens.device_info IS 'JSON containing device information';
