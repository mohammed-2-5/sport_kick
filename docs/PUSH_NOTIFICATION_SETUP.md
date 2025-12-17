# Push Notification System Setup Guide

## Overview

Sport Kick uses Firebase Cloud Messaging (FCM) for push notifications. The system notifies field owners when:
- A new booking is created by a user
- A payment proof is uploaded for a booking

## Architecture

```
User Action → Supabase Database → Trigger → Notification Table → Edge Function → FCM → Device
```

## Components

### 1. Database Tables

| Table | Purpose |
|-------|---------|
| `notifications` | Stores all notifications with read/sent status |
| `user_fcm_tokens` | Stores FCM tokens for each user device |

### 2. Database Triggers

| Trigger | Event | Action |
|---------|-------|--------|
| `trigger_notify_owner_new_booking` | Booking INSERT | Creates notification for field owner |
| `trigger_notify_owner_payment_upload` | Booking UPDATE (payment_proof_url) | Creates notification for owner |

### 3. Flutter Client

| File | Purpose |
|------|---------|
| `core/services/notification_service.dart` | FCM initialization, token management, local notifications |
| `features/notifications/...` | Notification list UI, cubit, repository |

### 4. Edge Function (Optional)

The Edge Function `send-push-notification` sends FCM push notifications when new notifications are inserted.

## Setup Instructions

### Step 1: Run Database Migrations

Execute these SQL files in Supabase SQL Editor (in order):
1. `20251212_create_user_fcm_tokens.sql`
2. `20251213_booking_notification_trigger.sql`

### Step 2: Configure Firebase

1. Create Firebase project at [Firebase Console](https://console.firebase.google.com)
2. Add Android/iOS apps to the project
3. Download `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)
4. Place config files in respective platform directories

### Step 3: Deploy Edge Function (Optional)

If you want server-side push notifications:

```bash
# Install Supabase CLI
npm install -g supabase

# Login
supabase login

# Link project
supabase link --project-ref YOUR_PROJECT_REF

# Deploy function
supabase functions deploy send-push-notification

# Set secrets
supabase secrets set FIREBASE_PROJECT_ID=your-project-id
supabase secrets set FIREBASE_SERVICE_ACCOUNT='{"type":"service_account",...}'
```

### Step 4: Configure Database Webhook

In Supabase Dashboard:
1. Go to **Database** > **Webhooks**
2. Click **Create a new webhook**
3. Configure:
   - Name: `send_push_notification`
   - Table: `notifications`
   - Events: `INSERT`
   - Type: `Supabase Edge Functions`
   - Function: `send-push-notification`

## Alternative: Client-Side Realtime

The app already supports realtime notifications via Supabase Realtime subscriptions. This works without the Edge Function but requires the app to be running to receive notifications.

The `NotificationRemoteDataSource` subscribes to:
```dart
_supabase
    .channel('notifications:${_currentUserId}')
    .onPostgresChanges(
        event: PostgresChangeEvent.insert,
        table: 'notifications',
        filter: PostgresChangeFilter(column: 'user_id', value: _currentUserId),
        callback: (payload) { ... }
    )
```

## Testing

### Verify FCM Token Storage

```sql
SELECT user_id, user_role, 
       LEFT(fcm_token, 40) || '...' as token_preview, 
       updated_at
FROM public.user_fcm_tokens
ORDER BY updated_at DESC;
```

### Create Test Notification

```sql
INSERT INTO public.notifications (
    user_id,
    title,
    body,
    type
) VALUES (
    'OWNER_USER_ID',  -- Replace with actual owner ID
    'Test Notification 🔔',
    'This is a test notification.',
    'system'
);
```

### Check Notification Delivery

```sql
SELECT id, user_id, title, type, is_read, is_sent, created_at
FROM public.notifications
ORDER BY created_at DESC
LIMIT 10;
```

## Troubleshooting

### FCM Token Not Saved

1. Check Firebase is initialized in `main.dart`
2. Verify notification permissions granted
3. Check auth cubit calls `_setupNotifications()` on login

### Notifications Not Showing

1. Verify `notifications` table has RLS policies enabled
2. Check Edge Function logs in Supabase Dashboard
3. Verify FCM token is valid (not expired)

### Push Not Received

1. Check device has internet connection
2. Verify FCM token in `user_fcm_tokens` table
3. Check Firebase Cloud Messaging is enabled in Firebase Console
4. Review Edge Function logs for errors

## Security Notes

- FCM tokens are stored per-user with RLS protection
- Service role is used for notification creation (via triggers)
- Edge Function runs with service role permissions
- Firebase service account should be kept secret

---

*Last Updated: December 2025*
