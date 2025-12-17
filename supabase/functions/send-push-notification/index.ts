// Send Push Notification Edge Function
// Triggered by database webhook on notifications INSERT
// Sends FCM push notification to user's device
//
// Deploy: supabase functions deploy send-push-notification
// Set secrets:
//   supabase secrets set FIREBASE_PROJECT_ID=your-project-id
//   supabase secrets set FIREBASE_SERVICE_ACCOUNT='{"type":"service_account",...}'

import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const corsHeaders = {
    "Access-Control-Allow-Origin": "*",
    "Access-Control-Allow-Headers":
        "authorization, x-client-info, apikey, content-type",
};

interface NotificationPayload {
    type: "INSERT";
    table: "notifications";
    record: {
        id: string;
        user_id: string;
        title: string;
        body: string;
        type: string;
        data: Record<string, unknown>;
        is_sent: boolean;
    };
}

interface FCMMessage {
    message: {
        token: string;
        notification: {
            title: string;
            body: string;
        };
        data?: Record<string, string>;
        android?: {
            priority: string;
            notification: {
                channel_id: string;
                click_action: string;
            };
        };
        apns?: {
            payload: {
                aps: {
                    sound: string;
                    badge: number;
                };
            };
        };
    };
}

// URL-safe Base64 encode
function base64UrlEncode(data: string | Uint8Array): string {
    let base64: string;
    if (typeof data === 'string') {
        base64 = btoa(data);
    } else {
        base64 = btoa(String.fromCharCode(...data));
    }
    return base64.replace(/\+/g, '-').replace(/\//g, '_').replace(/=+$/, '');
}

async function getAccessToken(): Promise<string> {
    const serviceAccountStr = Deno.env.get("FIREBASE_SERVICE_ACCOUNT") || "{}";
    console.log("Service account exists:", serviceAccountStr.length > 10);

    const serviceAccount = JSON.parse(serviceAccountStr);

    if (!serviceAccount.client_email || !serviceAccount.private_key) {
        console.error("Missing client_email or private_key in service account");
        throw new Error("Invalid service account configuration");
    }

    console.log("Using client_email:", serviceAccount.client_email);

    const now = Math.floor(Date.now() / 1000);
    const header = { alg: "RS256", typ: "JWT" };
    const payload = {
        iss: serviceAccount.client_email,
        sub: serviceAccount.client_email,
        aud: "https://oauth2.googleapis.com/token",
        iat: now,
        exp: now + 3600,
        scope: "https://www.googleapis.com/auth/firebase.messaging",
    };

    // Encode JWT with URL-safe Base64
    const headerB64 = base64UrlEncode(JSON.stringify(header));
    const payloadB64 = base64UrlEncode(JSON.stringify(payload));
    const signatureInput = `${headerB64}.${payloadB64}`;

    // Import private key and sign
    const encoder = new TextEncoder();
    const privateKey = await crypto.subtle.importKey(
        "pkcs8",
        pemToBinary(serviceAccount.private_key),
        { name: "RSASSA-PKCS1-v1_5", hash: "SHA-256" },
        false,
        ["sign"]
    );

    const signature = await crypto.subtle.sign(
        "RSASSA-PKCS1-v1_5",
        privateKey,
        encoder.encode(signatureInput)
    );

    const signatureB64 = base64UrlEncode(new Uint8Array(signature));
    const jwt = `${signatureInput}.${signatureB64}`;

    // Exchange JWT for access token
    const tokenResponse = await fetch("https://oauth2.googleapis.com/token", {
        method: "POST",
        headers: { "Content-Type": "application/x-www-form-urlencoded" },
        body: `grant_type=urn:ietf:params:oauth:grant-type:jwt-bearer&assertion=${jwt}`,
    });

    const tokenData = await tokenResponse.json();

    if (!tokenData.access_token) {
        console.error("Token exchange failed:", JSON.stringify(tokenData));
        throw new Error("Failed to get access token: " + (tokenData.error_description || tokenData.error));
    }

    console.log("Got access token successfully");
    return tokenData.access_token;
}

function pemToBinary(pem: string): ArrayBuffer {
    const b64 = pem
        .replace(/-----BEGIN PRIVATE KEY-----/, "")
        .replace(/-----END PRIVATE KEY-----/, "")
        .replace(/\n/g, "");
    const binary = atob(b64);
    const bytes = new Uint8Array(binary.length);
    for (let i = 0; i < binary.length; i++) {
        bytes[i] = binary.charCodeAt(i);
    }
    return bytes.buffer;
}

serve(async (req) => {
    // Handle CORS preflight
    if (req.method === "OPTIONS") {
        return new Response("ok", { headers: corsHeaders });
    }

    try {
        const payload: NotificationPayload = await req.json();
        const notification = payload.record;

        // Skip if already sent
        if (notification.is_sent) {
            return new Response(JSON.stringify({ message: "Already sent" }), {
                headers: { ...corsHeaders, "Content-Type": "application/json" },
                status: 200,
            });
        }

        // Initialize Supabase client with service role
        const supabaseUrl = Deno.env.get("SUPABASE_URL")!;
        const supabaseKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;
        const supabase = createClient(supabaseUrl, supabaseKey);

        // Get user's FCM tokens
        const { data: tokens, error: tokenError } = await supabase
            .from("user_fcm_tokens")
            .select("fcm_token")
            .eq("user_id", notification.user_id);

        if (tokenError || !tokens || tokens.length === 0) {
            console.log("No FCM tokens found for user:", notification.user_id);
            return new Response(JSON.stringify({ message: "No tokens found" }), {
                headers: { ...corsHeaders, "Content-Type": "application/json" },
                status: 200,
            });
        }

        // Get Firebase access token
        const projectId = Deno.env.get("FIREBASE_PROJECT_ID");
        const accessToken = await getAccessToken();

        // Send to each device token
        const results = await Promise.all(
            tokens.map(async ({ fcm_token }) => {
                const fcmMessage: FCMMessage = {
                    message: {
                        token: fcm_token,
                        notification: {
                            title: notification.title,
                            body: notification.body,
                        },
                        data: {
                            notification_id: notification.id,
                            type: notification.type,
                            ...Object.fromEntries(
                                Object.entries(notification.data || {}).map(([k, v]) => [
                                    k,
                                    String(v),
                                ])
                            ),
                        },
                        android: {
                            priority: "high",
                            notification: {
                                channel_id: "high_importance_channel",
                                click_action: "FLUTTER_NOTIFICATION_CLICK",
                            },
                        },
                        apns: {
                            payload: {
                                aps: {
                                    sound: "default",
                                    badge: 1,
                                },
                            },
                        },
                    },
                };

                try {
                    const response = await fetch(
                        `https://fcm.googleapis.com/v1/projects/${projectId}/messages:send`,
                        {
                            method: "POST",
                            headers: {
                                Authorization: `Bearer ${accessToken}`,
                                "Content-Type": "application/json",
                            },
                            body: JSON.stringify(fcmMessage),
                        }
                    );

                    if (!response.ok) {
                        const errorBody = await response.text();
                        console.error(`FCM Error (${response.status}):`, errorBody);
                        return false;
                    }

                    console.log("FCM push sent successfully!");
                    return true;
                } catch (err) {
                    console.error("FCM fetch error:", err);
                    return false;
                }
            })
        );

        // Mark notification as sent
        await supabase
            .from("notifications")
            .update({ is_sent: true })
            .eq("id", notification.id);

        const successCount = results.filter(Boolean).length;
        console.log(`Sent ${successCount}/${tokens.length} push notifications`);

        return new Response(
            JSON.stringify({
                success: true,
                sent: successCount,
                total: tokens.length,
            }),
            {
                headers: { ...corsHeaders, "Content-Type": "application/json" },
                status: 200,
            }
        );
    } catch (error) {
        console.error("Error sending push notification:", error);
        return new Response(JSON.stringify({ error: error.message }), {
            headers: { ...corsHeaders, "Content-Type": "application/json" },
            status: 500,
        });
    }
});
