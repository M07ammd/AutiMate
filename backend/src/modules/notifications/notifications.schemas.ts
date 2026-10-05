import { z } from "zod";

// ==========================================
// ✅ Schema: الحصول على الإشعارات
// ==========================================
export const getNotificationsSchema = z.object({
    query: z.object({
        unreadOnly: z.string().optional(),
        limit: z.string().regex(/^\d+$/).optional(),
        offset: z.string().regex(/^\d+$/).optional(),
    }),
});

// ==========================================
// ✅ Schema: تعليم إشعار كمقروء
// ==========================================
export const markAsReadSchema = z.object({
    params: z.object({
        notificationId: z.string().uuid("معرف الإشعار غير صالح"),
    }),
});

// ==========================================
// ✅ Schema: حذف إشعار
// ==========================================
export const deleteNotificationSchema = z.object({
    params: z.object({
        notificationId: z.string().uuid("معرف الإشعار غير صالح"),
    }),
});

// ==========================================
// ✅ Schema: إنشاء إشعار تجريبي
// ==========================================
export const createTestNotificationSchema = z.object({
    body: z.object({
        type: z.enum([
        "SURVEY_REMINDER",
        "ACTIVITY_REMINDER",
        "NEW_POST",
        "NEW_COMMENT",
        "NEW_LIKE",
        "NEW_SAVE",
        "PROGRESS_UPDATE",
        "SYSTEM",
        ]),
        title: z.string().min(1, "العنوان مطلوب"),
        message: z.string().min(1, "الرسالة مطلوبة"),
    }),
});

// ==========================================
// ✅ Schema: تحديث Token الإشعارات (FCM)
// ==========================================
export const updateFcmTokenSchema = z.object({
    body: z.object({
        fcmToken: z.string().min(1, "Token is required"),
    }),
});