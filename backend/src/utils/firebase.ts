import { initializeApp, getApps } from "firebase-admin/app";
import { getMessaging } from "firebase-admin/messaging";

// Initialize Firebase Admin (Only if credentials are provided)
const initializeFirebase = () => {
    try {
        if (!getApps().length) {
            if (process.env.GOOGLE_APPLICATION_CREDENTIALS) {
                initializeApp();
                console.log("✅ Firebase Admin initialized successfully.");
            } else {
                console.warn("⚠️ Firebase Admin skipped: GOOGLE_APPLICATION_CREDENTIALS not set.");
            }
        }
    } catch (error) {
        console.error("❌ Firebase Admin initialization error:", error);
    }
};

initializeFirebase();

/**
 * Send Push Notification to a specific FCM Token
 */
export const sendPushNotification = async (fcmToken: string, title: string, body: string, data?: any) => {
    if (!getApps().length) {
        console.warn("⚠️ Notification skipped: Firebase is not initialized. Token:", fcmToken);
        return false;
    }

    try {
        const message = {
            notification: {
                title,
                body,
            },
            data: data || {},
            token: fcmToken,
        };

        const response = await getMessaging().send(message);
        console.log("✅ Successfully sent message:", response);
        return true;
    } catch (error) {
        console.error("❌ Error sending push notification:", error);
        return false;
    }
};
