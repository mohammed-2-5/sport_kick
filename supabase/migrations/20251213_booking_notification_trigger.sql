-- ============================================================================
-- Migration: Booking Notification System
-- Date: December 13, 2025
-- Purpose: Notify field owners when new bookings are created
-- ============================================================================

-- ============================================================================
-- TABLE: notifications (Store notification history)
-- ============================================================================
CREATE TABLE IF NOT EXISTS public.notifications (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    
    -- Target
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    
    -- Content
    title TEXT NOT NULL,
    body TEXT NOT NULL,
    type TEXT NOT NULL DEFAULT 'booking', -- booking, payment, system, etc.
    
    -- Reference
    reference_id UUID, -- booking_id, field_id, etc.
    reference_type TEXT, -- 'booking', 'field', 'payment'
    
    -- Status
    is_read BOOLEAN DEFAULT false,
    is_sent BOOLEAN DEFAULT false,
    
    -- Metadata
    data JSONB DEFAULT '{}',
    
    -- Timestamps
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    read_at TIMESTAMP WITH TIME ZONE
);

-- Indexes
CREATE INDEX IF NOT EXISTS idx_notifications_user_id ON public.notifications(user_id);
CREATE INDEX IF NOT EXISTS idx_notifications_is_read ON public.notifications(is_read);
CREATE INDEX IF NOT EXISTS idx_notifications_type ON public.notifications(type);
CREATE INDEX IF NOT EXISTS idx_notifications_created_at ON public.notifications(created_at DESC);

-- Comments
COMMENT ON TABLE public.notifications IS 'Stores notification history for all users';
COMMENT ON COLUMN public.notifications.type IS 'Notification type: booking, payment, system, review';
COMMENT ON COLUMN public.notifications.reference_id IS 'ID of related entity (booking, field, etc.)';

-- ============================================================================
-- RLS Policies for notifications
-- ============================================================================
ALTER TABLE public.notifications ENABLE ROW LEVEL SECURITY;

-- Users can view their own notifications
CREATE POLICY "Users can view own notifications" ON public.notifications
    FOR SELECT USING (auth.uid() = user_id);

-- Users can update their own notifications (mark as read)
CREATE POLICY "Users can update own notifications" ON public.notifications
    FOR UPDATE USING (auth.uid() = user_id);

-- Service role can insert notifications (from triggers/edge functions)
CREATE POLICY "Service role can insert notifications" ON public.notifications
    FOR INSERT WITH CHECK (true);

-- Super admins can view all notifications
CREATE POLICY "Super admins can view all notifications" ON public.notifications
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM public.profiles
            WHERE id = auth.uid() AND role = 'super_admin'
        )
    );

-- ============================================================================
-- FUNCTION: Create notification for field owner on new booking
-- ============================================================================
CREATE OR REPLACE FUNCTION notify_field_owner_on_booking()
RETURNS TRIGGER AS $$
DECLARE
    v_field_owner_id UUID;
    v_field_name TEXT;
    v_user_name TEXT;
    v_notification_title TEXT;
    v_notification_body TEXT;
BEGIN
    -- Get field owner and field name
    SELECT f.owner_id, f.name INTO v_field_owner_id, v_field_name
    FROM public.fields f
    WHERE f.id = NEW.field_id;
    
    -- Get booking user name
    SELECT p.full_name INTO v_user_name
    FROM public.profiles p
    WHERE p.id = NEW.user_id;
    
    -- Skip if this is a manual booking (owner created it)
    IF NEW.is_manual = true THEN
        RETURN NEW;
    END IF;
    
    -- Create notification content
    v_notification_title := 'New Booking Request 🎉';
    v_notification_body := COALESCE(v_user_name, 'A customer') || 
                          ' booked ' || COALESCE(v_field_name, 'your field') ||
                          ' on ' || TO_CHAR(NEW.booking_date, 'DD Mon YYYY') ||
                          ' at ' || NEW.start_time::TEXT;
    
    -- Insert notification for field owner
    INSERT INTO public.notifications (
        user_id,
        title,
        body,
        type,
        reference_id,
        reference_type,
        data
    ) VALUES (
        v_field_owner_id,
        v_notification_title,
        v_notification_body,
        'booking',
        NEW.id,
        'booking',
        jsonb_build_object(
            'booking_id', NEW.id,
            'field_id', NEW.field_id,
            'field_name', v_field_name,
            'user_id', NEW.user_id,
            'user_name', v_user_name,
            'booking_date', NEW.booking_date,
            'start_time', NEW.start_time,
            'end_time', NEW.end_time,
            'total_price', NEW.total_price,
            'status', NEW.status
        )
    );
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ============================================================================
-- TRIGGER: New booking notification
-- ============================================================================
DROP TRIGGER IF EXISTS trigger_notify_owner_new_booking ON public.bookings;
CREATE TRIGGER trigger_notify_owner_new_booking
    AFTER INSERT ON public.bookings
    FOR EACH ROW
    EXECUTE FUNCTION notify_field_owner_on_booking();

-- ============================================================================
-- FUNCTION: Create notification on payment proof upload
-- ============================================================================
CREATE OR REPLACE FUNCTION notify_owner_on_payment_upload()
RETURNS TRIGGER AS $$
DECLARE
    v_field_owner_id UUID;
    v_field_name TEXT;
    v_user_name TEXT;
BEGIN
    -- Only trigger when payment_proof_url changes from NULL to a value
    IF OLD.payment_proof_url IS NULL AND NEW.payment_proof_url IS NOT NULL THEN
        -- Get field owner and field name
        SELECT f.owner_id, f.name INTO v_field_owner_id, v_field_name
        FROM public.fields f
        WHERE f.id = NEW.field_id;
        
        -- Get user name
        SELECT p.full_name INTO v_user_name
        FROM public.profiles p
        WHERE p.id = NEW.user_id;
        
        -- Insert notification
        INSERT INTO public.notifications (
            user_id,
            title,
            body,
            type,
            reference_id,
            reference_type,
            data
        ) VALUES (
            v_field_owner_id,
            'Payment Proof Uploaded 💰',
            COALESCE(v_user_name, 'A customer') || ' uploaded payment proof for booking on ' ||
            TO_CHAR(NEW.booking_date, 'DD Mon YYYY'),
            'payment',
            NEW.id,
            'booking',
            jsonb_build_object(
                'booking_id', NEW.id,
                'field_id', NEW.field_id,
                'user_id', NEW.user_id,
                'payment_proof_url', NEW.payment_proof_url
            )
        );
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ============================================================================
-- TRIGGER: Payment proof upload notification
-- ============================================================================
DROP TRIGGER IF EXISTS trigger_notify_owner_payment_upload ON public.bookings;
CREATE TRIGGER trigger_notify_owner_payment_upload
    AFTER UPDATE ON public.bookings
    FOR EACH ROW
    WHEN (OLD.payment_proof_url IS DISTINCT FROM NEW.payment_proof_url)
    EXECUTE FUNCTION notify_owner_on_payment_upload();

-- ============================================================================
-- FUNCTION: Get unread notification count
-- ============================================================================
CREATE OR REPLACE FUNCTION get_unread_notification_count(p_user_id UUID)
RETURNS INTEGER AS $$
BEGIN
    RETURN (
        SELECT COUNT(*)::INTEGER
        FROM public.notifications
        WHERE user_id = p_user_id AND is_read = false
    );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ============================================================================
-- FUNCTION: Mark notifications as read
-- ============================================================================
CREATE OR REPLACE FUNCTION mark_notifications_read(p_notification_ids UUID[])
RETURNS void AS $$
BEGIN
    UPDATE public.notifications
    SET is_read = true, read_at = NOW()
    WHERE id = ANY(p_notification_ids)
    AND user_id = auth.uid();
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ============================================================================
-- FUNCTION: Mark all notifications as read for user
-- ============================================================================
CREATE OR REPLACE FUNCTION mark_all_notifications_read()
RETURNS void AS $$
BEGIN
    UPDATE public.notifications
    SET is_read = true, read_at = NOW()
    WHERE user_id = auth.uid() AND is_read = false;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ============================================================================
-- GRANTS
-- ============================================================================
GRANT ALL ON public.notifications TO authenticated;
GRANT ALL ON public.notifications TO service_role;
GRANT EXECUTE ON FUNCTION get_unread_notification_count TO authenticated;
GRANT EXECUTE ON FUNCTION mark_notifications_read TO authenticated;
GRANT EXECUTE ON FUNCTION mark_all_notifications_read TO authenticated;
