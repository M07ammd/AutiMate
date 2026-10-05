import { prisma } from "../../config/prisma";
import { sendPushNotification } from "../../utils/firebase";

// ==========================================
// ✅ خدمة: الحصول على الإشعارات
// ==========================================
export const getNotifications = async (
    userId: string,
    filters?: {
        unreadOnly?: boolean;
        limit?: number;
        offset?: number;
    }
    ) => {
    const limit = filters?.limit || 50;
    const offset = filters?.offset || 0;

    const where: any = { userId };

    if (filters?.unreadOnly) {
        where.read = false;
    }

    const notifications = await prisma.notification.findMany({
        where,
        select: {
        id: true,
        type: true,
        title: true,
        message: true,
        relatedId: true,
        relatedType: true,
        actionUrl: true,
        read: true,
        createdAt: true,
        },
        orderBy: {
        createdAt: "desc",
        },
        take: limit,
        skip: offset,
    });

    // حساب عدد الإشعارات غير المقروءة
    const unreadCount = await prisma.notification.count({
        where: {
        userId,
        read: false,
        },
    });

    return {
        notifications,
        unreadCount,
    };
};

// ==========================================
// ✅ خدمة: تعليم إشعار كمقروء
// ==========================================
export const markAsRead = async (notificationId: string, userId: string) => {
    const notification = await prisma.notification.findUnique({
        where: { id: notificationId },
        select: { id: true, userId: true, read: true },
    });

    if (!notification) {
        throw Object.assign(new Error("الإشعار غير موجود"), { status: 404 });
    }

    if (notification.userId !== userId) {
        throw Object.assign(new Error("غير مصرح لك"), { status: 403 });
    }

    if (notification.read) {
        return { ok: true, message: "الإشعار مقروء بالفعل" };
    }

    await prisma.notification.update({
        where: { id: notificationId },
        data: { read: true },
    });

    return { ok: true, message: "تم تحديد الإشعار كمقروء" };
};

// ==========================================
// ✅ خدمة: تعليم كل الإشعارات كمقروءة
// ==========================================
export const markAllAsRead = async (userId: string) => {
    const result = await prisma.notification.updateMany({
        where: {
        userId,
        read: false,
        },
        data: {
        read: true,
        },
    });

    return {
        ok: true,
        message: "تم تحديد كل الإشعارات كمقروءة",
        count: result.count,
    };
};

// ==========================================
// ✅ خدمة: حذف إشعار
// ==========================================
export const deleteNotification = async (
    notificationId: string,
    userId: string
    ) => {
    const notification = await prisma.notification.findUnique({
        where: { id: notificationId },
        select: { id: true, userId: true },
    });

    if (!notification) {
        throw Object.assign(new Error("الإشعار غير موجود"), { status: 404 });
    }

    if (notification.userId !== userId) {
        throw Object.assign(new Error("غير مصرح لك"), { status: 403 });
    }

    await prisma.notification.delete({
        where: { id: notificationId },
    });

    return { ok: true, message: "تم حذف الإشعار بنجاح" };
};

// ==========================================
// ✅ خدمة: إنشاء إشعار (للاستخدام الداخلي)
// ==========================================
export const createNotification = async (data: {
    userId: string;
    type: string;
    title: string;
    message: string;
    relatedId?: string;
    relatedType?: string;
    actionUrl?: string;
    }) => {
    console.log(`🔔 [createNotification] START → userId=${data.userId} | type=${data.type} | title=${data.title}`);

    try {
        const notification = await prisma.notification.create({
            data: {
                userId: data.userId,
                type: data.type as any,
                title: data.title,
                message: data.message,
                relatedId: data.relatedId,
                relatedType: data.relatedType,
                actionUrl: data.actionUrl,
            },
            select: {
                id: true,
                type: true,
                title: true,
                message: true,
                createdAt: true,
            },
        });

        console.log(`✅ [createNotification] SAVED → id=${notification.id}`);

        // جلب التوكن الخاص بالمستخدم لإرسال الإشعار
        const user = await prisma.user.findUnique({
            where: { id: data.userId },
            select: { fcmToken: true },
        });

        if (user?.fcmToken) {
            await sendPushNotification(user.fcmToken, data.title, data.message, {
                type: data.type,
                relatedId: data.relatedId || "",
                actionUrl: data.actionUrl || "",
            });
        }

        return notification;
    } catch (err) {
        console.error(`❌ [createNotification] FAILED → userId=${data.userId} | type=${data.type}`, err);
        throw err;
    }
};

// ==========================================
// ✅ خدمة: تحديث Token الإشعارات
// ==========================================
export const updateFcmToken = async (userId: string, fcmToken: string) => {
    await prisma.user.update({
        where: { id: userId },
        data: { fcmToken },
    });

    return { ok: true, message: "تم تحديث Token الإشعارات بنجاح" };
};