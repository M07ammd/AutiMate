import { Router } from "express";
import {
    getNotificationsController,
    markAsReadController,
    markAllAsReadController,
    deleteNotificationController,
    createTestNotificationController,
    updateFcmTokenController,
} from "./notifications.controller";
import { requireAuth } from "../../middlewares/auth";
import { validate } from "../../utils/validate";
import {
    getNotificationsSchema,
    markAsReadSchema,
    deleteNotificationSchema,
    createTestNotificationSchema,
    updateFcmTokenSchema,
    } from "./notifications.schemas";

const router = Router();

// ==========================================
// ✅ Notifications Routes
// ==========================================

// الحصول على الإشعارات
router.get(
    "/",
    requireAuth,
    validate(getNotificationsSchema),
    getNotificationsController
);

// تعليم كل الإشعارات كمقروءة
router.post(
    "/mark-all-read",
    requireAuth,
    markAllAsReadController
);

// تعليم إشعار كمقروء
router.patch(
    "/:notificationId/read",
    requireAuth,
    validate(markAsReadSchema),
    markAsReadController
);

// حذف إشعار
router.delete(
    "/:notificationId",
    requireAuth,
    validate(deleteNotificationSchema),
    deleteNotificationController
);

// تحديث Token الإشعارات (FCM) الخاص بالجهاز
router.patch(
    "/token",
    requireAuth,
    validate(updateFcmTokenSchema),
    updateFcmTokenController
);

// ✅ للاختبار فقط: إنشاء إشعار تجريبي
router.post(
    "/test",
    requireAuth,
    validate(createTestNotificationSchema),
    createTestNotificationController
);

export default router;