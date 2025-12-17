// supabase/functions/complete-bookings/index.ts
// 
// Edge Function to auto-complete expired bookings
// This can be triggered by an external scheduler (cron-job.org, GitHub Actions, etc.)
//
// Deploy: supabase functions deploy complete-bookings
// 
// Test locally: supabase functions serve complete-bookings
// Invoke: curl -i --location --request POST 'https://YOUR_PROJECT.supabase.co/functions/v1/complete-bookings' \
//   --header 'Authorization: Bearer YOUR_ANON_KEY'

import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

const corsHeaders = {
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

Deno.serve(async (req) => {
    // Handle CORS preflight
    if (req.method === 'OPTIONS') {
        return new Response('ok', { headers: corsHeaders })
    }

    try {
        // Create Supabase client with service role (bypasses RLS)
        const supabaseUrl = Deno.env.get('SUPABASE_URL')!
        const supabaseServiceKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!

        const supabase = createClient(supabaseUrl, supabaseServiceKey)

        // Call the RPC function to complete passed bookings
        const { data, error } = await supabase.rpc('complete_passed_bookings')

        if (error) {
            console.error('Error completing bookings:', error)
            return new Response(
                JSON.stringify({ error: error.message }),
                {
                    status: 500,
                    headers: { ...corsHeaders, 'Content-Type': 'application/json' }
                }
            )
        }

        const completedCount = data ?? 0
        console.log(`Auto-completed ${completedCount} bookings`)

        return new Response(
            JSON.stringify({
                success: true,
                completed_count: completedCount,
                timestamp: new Date().toISOString()
            }),
            {
                status: 200,
                headers: { ...corsHeaders, 'Content-Type': 'application/json' }
            }
        )

    } catch (err) {
        console.error('Unexpected error:', err)
        return new Response(
            JSON.stringify({ error: 'Internal server error' }),
            {
                status: 500,
                headers: { ...corsHeaders, 'Content-Type': 'application/json' }
            }
        )
    }
})
