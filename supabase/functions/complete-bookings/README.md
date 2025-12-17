# Auto-Complete Bookings - Free Scheduler Setup

## Overview
This setup uses a **free external scheduler** to trigger a Supabase Edge Function every hour.

---

## Step 1: Deploy the Edge Function

```bash
# Navigate to project root
cd c:\Users\moham\StudioProjects\spo_kick

# Login to Supabase CLI (if not already)
supabase login

# Link your project
supabase link --project-ref YOUR_PROJECT_REF

# Deploy the function
supabase functions deploy complete-bookings
```

---

## Step 2: Get Your Function URL

After deploying, your function URL will be:
```
https://YOUR_PROJECT_REF.supabase.co/functions/v1/complete-bookings
```

---

## Step 3: Choose a Free Scheduler

### Option A: cron-job.org (Recommended - Easiest)

1. Go to [cron-job.org](https://cron-job.org) and create free account
2. Click **"Create Cronjob"**
3. Fill in:
   - **Title**: Auto Complete Bookings
   - **URL**: `https://YOUR_PROJECT_REF.supabase.co/functions/v1/complete-bookings`
   - **Schedule**: Every hour (`0 * * * *`)
   - **Request Method**: POST
   - **Headers**: Add header:
     - Name: `Authorization`
     - Value: `Bearer YOUR_ANON_KEY`
4. Save and enable

### Option B: GitHub Actions (Free - 2000 min/month)

Create file: `.github/workflows/complete-bookings.yml`
```yaml
name: Auto Complete Bookings
on:
  schedule:
    - cron: '0 * * * *'  # Every hour
  workflow_dispatch:  # Manual trigger
jobs:
  complete:
    runs-on: ubuntu-latest
    steps:
      - name: Trigger Edge Function
        run: |
          curl -X POST \
            'https://YOUR_PROJECT_REF.supabase.co/functions/v1/complete-bookings' \
            -H 'Authorization: Bearer ${{ secrets.SUPABASE_ANON_KEY }}'
```
Then add `SUPABASE_ANON_KEY` to repository secrets.

### Option C: Pipedream (Free - 250 invocations/day)

1. Go to [pipedream.com](https://pipedream.com)
2. Create a workflow with Cron trigger
3. Add HTTP action to call your Edge Function

---

## Step 4: Test Manually

```bash
curl -X POST \
  'https://YOUR_PROJECT_REF.supabase.co/functions/v1/complete-bookings' \
  -H 'Authorization: Bearer YOUR_ANON_KEY'
```

Expected response:
```json
{
  "success": true,
  "completed_count": 0,
  "timestamp": "2025-12-15T06:00:00.000Z"
}
```

---

## How It Works

```
┌─────────────────┐     ┌──────────────────┐     ┌──────────────┐
│ External Cron   │────▶│ Edge Function    │────▶│ Database     │
│ (cron-job.org)  │     │ complete-booking │     │ RPC call     │
│ Every hour      │     │                  │     │              │
└─────────────────┘     └──────────────────┘     └──────────────┘
                         Runs every hour           Updates status
                         automatically             confirmed → completed
```

---

## Keys Needed

| Key | Where to find |
|-----|---------------|
| `PROJECT_REF` | Supabase Dashboard → Settings → General |
| `ANON_KEY` | Supabase Dashboard → Settings → API |

---

## Cost: $0 🎉

All components are free:
- ✅ Supabase Edge Functions (500K/month free)
- ✅ cron-job.org (unlimited free cron jobs)
- ✅ GitHub Actions (2000 min/month free)
