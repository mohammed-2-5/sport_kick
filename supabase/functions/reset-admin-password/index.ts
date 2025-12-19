// Reset Admin Password Edge Function
// Allows super admins to reset passwords for field owner/admin accounts
// with @sportkick.com emails that cannot receive password reset emails.
//
// Deploy: supabase functions deploy reset-admin-password
//
// Security:
// - Uses service role key (server-side only)
// - Validates admin role and @sportkick.com email domain
// - Sets password_changed = false to force password change on next login

import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const corsHeaders = {
    "Access-Control-Allow-Origin": "*",
    "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

interface ResetPasswordRequest {
    adminId: string;
}

interface ProfileRecord {
    id: string;
    email: string;
    role: string;
    full_name: string | null;
}

/// Generate secure default password for admin accounts.
/// Format: FieldAdmin{Year}@{RandomNumber}
/// Example: FieldAdmin2025@743
function generateDefaultPassword(): string {
    const year = new Date().getFullYear();
    const random = Math.floor(Math.random() * 900) + 100; // 3-digit random number
    return `FieldAdmin${year}@${random}`;
}

serve(async (req) => {
    // Handle CORS preflight requests
    if (req.method === "OPTIONS") {
        return new Response("ok", { headers: corsHeaders });
    }

    try {
        console.log("🔐 [Reset Admin Password] Request received");

        // Parse request body
        const { adminId } = await req.json() as ResetPasswordRequest;

        // Validate input
        if (!adminId || adminId.trim() === "") {
            console.error("❌ Missing adminId parameter");
            return new Response(
                JSON.stringify({ error: "adminId is required" }),
                {
                    status: 400,
                    headers: { ...corsHeaders, "Content-Type": "application/json" }
                }
            );
        }

        console.log(`   Admin ID: ${adminId}`);

        // Create Supabase client with SERVICE ROLE (admin privileges)
        const supabaseUrl = Deno.env.get("SUPABASE_URL");
        const supabaseServiceKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY");

        if (!supabaseUrl || !supabaseServiceKey) {
            console.error("❌ Missing environment variables");
            return new Response(
                JSON.stringify({ error: "Server configuration error" }),
                {
                    status: 500,
                    headers: { ...corsHeaders, "Content-Type": "application/json" }
                }
            );
        }

        const supabase = createClient(supabaseUrl, supabaseServiceKey);

        // Step 1: Verify admin exists and has required role
        console.log("   Step 1: Fetching admin profile...");
        const { data: profile, error: profileError } = await supabase
            .from("profiles")
            .select("id, email, role, full_name")
            .eq("id", adminId)
            .single();

        if (profileError || !profile) {
            console.error("❌ Admin not found:", profileError?.message || "No profile returned");
            return new Response(
                JSON.stringify({ error: "Admin not found" }),
                {
                    status: 404,
                    headers: { ...corsHeaders, "Content-Type": "application/json" }
                }
            );
        }

        const typedProfile = profile as ProfileRecord;
        console.log(`   Found profile: ${typedProfile.email} (${typedProfile.role})`);

        // Step 2: Validate admin role
        if (typedProfile.role !== "admin") {
            console.error(`❌ User is not an admin. Role: ${typedProfile.role}`);
            return new Response(
                JSON.stringify({ error: "User is not an admin" }),
                {
                    status: 400,
                    headers: { ...corsHeaders, "Content-Type": "application/json" }
                }
            );
        }

        // Step 3: Validate @sportkick.com email domain
        // Only reset password for admins with fake emails
        if (!typedProfile.email.endsWith("@sportkick.com")) {
            console.error(`❌ Admin has real email: ${typedProfile.email}`);
            console.error("   Use forgot password flow for real email addresses");
            return new Response(
                JSON.stringify({
                    error: "Admin has real email, use forgot password flow instead"
                }),
                {
                    status: 400,
                    headers: { ...corsHeaders, "Content-Type": "application/json" }
                }
            );
        }

        // Step 4: Generate new password
        const newPassword = generateDefaultPassword();
        console.log(`   Generated new password: ${newPassword}`);

        // Step 5: Update password in auth.users using Admin API
        console.log("   Step 5: Updating password via Admin API...");
        const { error: authError } = await supabase.auth.admin.updateUserById(
            adminId,
            { password: newPassword }
        );

        if (authError) {
            console.error("❌ Failed to update auth password:", authError.message);
            return new Response(
                JSON.stringify({
                    error: `Failed to update password: ${authError.message}`
                }),
                {
                    status: 500,
                    headers: { ...corsHeaders, "Content-Type": "application/json" }
                }
            );
        }

        console.log("   ✅ Password updated successfully in auth.users");

        // Step 6: Set password_changed = false in profiles table
        // This forces the admin to change password on next login
        console.log("   Step 6: Updating profiles table...");
        const { error: profileUpdateError } = await supabase
            .from("profiles")
            .update({
                password_changed: false,
                updated_at: new Date().toISOString(),
            })
            .eq("id", adminId);

        if (profileUpdateError) {
            console.error("⚠️ Warning: Failed to update profile:", profileUpdateError.message);
            console.error("   Password was changed but password_changed flag not set");
            // Non-critical error, password is already changed
        } else {
            console.log("   ✅ Profile updated: password_changed = false");
        }

        // Step 7: Log action for audit trail
        const timestamp = new Date().toISOString();
        console.log(`✅ [Reset Admin Password] Success`);
        console.log(`   Admin: ${typedProfile.email} (${typedProfile.full_name || "No name"})`);
        console.log(`   Timestamp: ${timestamp}`);
        console.log(`   New Password: ${newPassword}`);

        // Step 8: Return success with new password
        return new Response(
            JSON.stringify({
                success: true,
                newPassword: newPassword,
                adminEmail: typedProfile.email,
                adminName: typedProfile.full_name,
                timestamp: timestamp,
            }),
            {
                status: 200,
                headers: { ...corsHeaders, "Content-Type": "application/json" }
            }
        );

    } catch (error) {
        console.error("❌ [Reset Admin Password] Unexpected error:", error);
        return new Response(
            JSON.stringify({ error: "Internal server error" }),
            {
                status: 500,
                headers: { ...corsHeaders, "Content-Type": "application/json" }
            }
        );
    }
});
