import { prisma } from "../../config/prisma";
import { createNotification } from "../notifications/notifications.service";

// ==========================================
// 🔔 Helper: إشعار لكل الآباء التانيين
// ==========================================
const notifyOtherParents = async (
    actorId: string,
    type: string,
    title: string,
    message: string,
    relatedId: string,
    relatedType: string
) => {
    // جيب كل الآباء ما عدا اللي عمل الـ action
    const otherParents = await prisma.user.findMany({
        where: {
            role: "PARENT",
            id: { not: actorId },
        },
        select: { id: true },
    });

    if (otherParents.length === 0) return;

    // ابعت الإشعارات لكلهم بشكل متوازي
    const results = await Promise.allSettled(
        otherParents.map((parent) =>
            createNotification({
                userId: parent.id,
                type,
                title,
                message,
                relatedId,
                relatedType,
            })
        )
    );

    // log أي إشعار فشل
    results.forEach((result, i) => {
        if (result.status === "rejected") {
            console.error(
                `❌ [notifyOtherParents] Failed for userId=${otherParents[i].id}:`,
                result.reason
            );
        }
    });
};

// ==========================================
// ✅ خدمة: إنشاء منشور جديد
// ==========================================
export const createPost = async (
    authorId: string,
    content: string,
    imageUrl?: string
    ) => {
    if (!content || content.trim().length === 0) {
        throw Object.assign(new Error("Content is required"), { status: 400 });
    }

    const post = await prisma.post.create({
        data: {
        authorId,
        content: content.trim(),
        imageUrl: imageUrl || null,
        },
        select: {
        id: true,
        content: true,
        imageUrl: true,
        likesCount: true,
        commentsCount: true,
        sharesCount: true,
        createdAt: true,
        author: {
            select: {
            id: true,
            fullName: true,
            role: true,
            },
        },
        },
    });

    // 🔔 إشعار لكل الآباء التانيين
    const authorName = post.author?.fullName || "أحد الأعضاء";
    notifyOtherParents(
        authorId,
        "NEW_POST",
        "منشور جديد في المجتمع 📝",
        `قام ${authorName} بنشر منشور جديد`,
        post.id,
        "POST"
    ).catch((err) => console.error("❌ [createPost] notifyOtherParents failed:", err));

    return post;
};

// ==========================================
// ✅ خدمة: الحصول على المنشورات
// ==========================================
export const getPosts = async (
    userId: string,
    filters?: {
        sort?: "latest" | "most_liked";
        savedOnly?: boolean;
        limit?: number;
        offset?: number;
    }
    ) => {
    const limit = filters?.limit || 20;
    const offset = filters?.offset || 0;

    // لو المستخدم عايز المنشورات المحفوظة بس
    if (filters?.savedOnly) {
        const savedPosts = await prisma.savedPost.findMany({
        where: { userId },
        select: {
            post: {
            select: {
                id: true,
                content: true,
                imageUrl: true,
                likesCount: true,
                commentsCount: true,
                sharesCount: true,
                createdAt: true,
                author: {
                select: {
                    id: true,
                    fullName: true,
                    role: true,
                },
                },
            },
            },
            createdAt: true,
        },
        orderBy: {
            createdAt: "desc",
        },
        take: limit,
        skip: offset,
    });

    const posts = savedPosts.map((sp) => ({
        ...sp.post,
        isSaved: true,
        isLiked: false,
        }));

        const postIds = posts.map((p) => p.id);
        const likes = await prisma.like.findMany({
        where: {
            userId,
            postId: { in: postIds },
        },
        select: { postId: true },
        });

        const likedPostIds = new Set(likes.map((l) => l.postId));

        return posts.map((post) => ({
        ...post,
        isLiked: likedPostIds.has(post.id),
        }));
    }

    const orderBy: any =
        filters?.sort === "most_liked"
        ? { likesCount: "desc" }
        : { createdAt: "desc" };

    const posts = await prisma.post.findMany({
        select: {
        id: true,
        content: true,
        imageUrl: true,
        likesCount: true,
        commentsCount: true,
        sharesCount: true,
        createdAt: true,
        author: {
            select: {
            id: true,
            fullName: true,
            role: true,
            },
        },
        },
        orderBy,
        take: limit,
        skip: offset,
    });

    const postIds = posts.map((p) => p.id);

    const [savedPosts, likes] = await Promise.all([
        prisma.savedPost.findMany({
        where: {
            userId,
            postId: { in: postIds },
        },
        select: { postId: true },
        }),
        prisma.like.findMany({
        where: {
            userId,
            postId: { in: postIds },
        },
        select: { postId: true },
        }),
    ]);

    const savedPostIds = new Set(savedPosts.map((sp) => sp.postId));
    const likedPostIds = new Set(likes.map((l) => l.postId));

    return posts.map((post) => ({
        ...post,
        isSaved: savedPostIds.has(post.id),
        isLiked: likedPostIds.has(post.id),
    }));
};

// ==========================================
// ✅ خدمة: الحصول على منشور واحد
// ==========================================
export const getPostById = async (postId: string, userId: string) => {
    const post = await prisma.post.findUnique({
        where: { id: postId },
        select: {
        id: true,
        content: true,
        imageUrl: true,
        likesCount: true,
        commentsCount: true,
        sharesCount: true,
        createdAt: true,
        author: {
            select: {
            id: true,
            fullName: true,
            role: true,
            },
        },
        },
    });

    if (!post) {
        throw Object.assign(new Error("Post not found"), { status: 404 });
    }

    const [savedPost, like] = await Promise.all([
        prisma.savedPost.findUnique({
        where: {
            userId_postId: { userId, postId },
        },
        }),
        prisma.like.findUnique({
        where: {
            userId_postId: { userId, postId },
        },
        }),
    ]);

    return {
        ...post,
        isSaved: !!savedPost,
        isLiked: !!like,
    };
};

// ==========================================
// ✅ خدمة: حذف منشور
// ==========================================
export const deletePost = async (postId: string, userId: string) => {
    const post = await prisma.post.findUnique({
        where: { id: postId },
        select: { id: true, authorId: true },
    });

    if (!post) {
        throw Object.assign(new Error("Post not found"), { status: 404 });
    }

    if (post.authorId !== userId) {
        throw Object.assign(new Error("Unauthorized"), { status: 403 });
    }

    await prisma.post.delete({
        where: { id: postId },
    });

    return { ok: true, message: "Post deleted successfully" };
};

// ==========================================
// ✅ خدمة: إعجاب بمنشور
// ==========================================
export const likePost = async (postId: string, userId: string) => {
    // جيب البوست مع الـ authorId عشان نعرف مين نبعتله الإشعار
    const post = await prisma.post.findUnique({
        where: { id: postId },
        select: { id: true, authorId: true },
    });

    if (!post) {
        throw Object.assign(new Error("Post not found"), { status: 404 });
    }

    const existingLike = await prisma.like.findUnique({
        where: {
        userId_postId: { userId, postId },
        },
    });

    if (existingLike) {
        throw Object.assign(new Error("Already liked"), { status: 400 });
    }

    await prisma.$transaction([
        prisma.like.create({
        data: { userId, postId },
        }),
        prisma.post.update({
        where: { id: postId },
        data: { likesCount: { increment: 1 } },
        }),
    ]);

    // 🔔 إشعار لصاحب البوست فقط (لو مش نفس الشخص)
    if (post.authorId !== userId) {
        const actor = await prisma.user.findUnique({
            where: { id: userId },
            select: { fullName: true },
        });

        createNotification({
            userId: post.authorId,
            type: "NEW_LIKE",
            title: "إعجاب جديد ❤️",
            message: `قام ${actor?.fullName || "أحد الآباء"} بالإعجاب بمنشورك`,
            relatedId: postId,
            relatedType: "POST",
        }).catch((err) => console.error("❌ [likePost] createNotification failed:", err));
    }

    return { ok: true, message: "Post liked successfully" };
};

// ==========================================
// ✅ خدمة: إلغاء الإعجاب
// ==========================================
export const unlikePost = async (postId: string, userId: string) => {
    const like = await prisma.like.findUnique({
        where: {
        userId_postId: { userId, postId },
        },
    });

    if (!like) {
        throw Object.assign(new Error("Like not found"), { status: 404 });
    }

    await prisma.$transaction([
        prisma.like.delete({
        where: { id: like.id },
        }),
        prisma.post.update({
        where: { id: postId },
        data: { likesCount: { decrement: 1 } },
        }),
    ]);

    return { ok: true, message: "Post unliked successfully" };
};

// ==========================================
// ✅ خدمة: إضافة تعليق
// ==========================================
export const addComment = async (
    postId: string,
    userId: string,
    content: string
    ) => {
    if (!content || content.trim().length === 0) {
        throw Object.assign(new Error("Content is required"), { status: 400 });
    }

    const post = await prisma.post.findUnique({
        where: { id: postId },
        select: { id: true, authorId: true },
    });

    if (!post) {
        throw Object.assign(new Error("Post not found"), { status: 404 });
    }

    const [comment] = await prisma.$transaction([
        prisma.comment.create({
        data: {
            postId,
            userId,
            content: content.trim(),
        },
        select: {
            id: true,
            content: true,
            createdAt: true,
            user: {
            select: {
                id: true,
                fullName: true,
                role: true,
            },
            },
        },
        }),
        prisma.post.update({
        where: { id: postId },
        data: { commentsCount: { increment: 1 } },
        }),
    ]);

    // 🔔 إشعار لصاحب البوست فقط (لو مش نفس الشخص)
    if (post.authorId !== userId) {
        const commenterName = comment.user?.fullName || "أحد الآباء";
        createNotification({
            userId: post.authorId,
            type: "NEW_COMMENT",
            title: "تعليق جديد 💬",
            message: `قام ${commenterName} بالتعليق على منشورك`,
            relatedId: postId,
            relatedType: "POST",
        }).catch((err) => console.error("❌ [addComment] createNotification failed:", err));
    }

    return comment;
};

// ==========================================
// ✅ خدمة: الحصول على التعليقات
// ==========================================
export const getComments = async (postId: string, limit = 50, offset = 0) => {
    const comments = await prisma.comment.findMany({
        where: { postId },
        select: {
        id: true,
        content: true,
        createdAt: true,
        user: {
            select: {
            id: true,
            fullName: true,
            role: true,
            },
        },
        },
        orderBy: {
        createdAt: "desc",
        },
        take: limit,
        skip: offset,
    });

    return comments;
};

// ==========================================
// ✅ خدمة: حفظ منشور
// ==========================================
export const savePost = async (postId: string, userId: string) => {
    // جيب البوست مع الـ authorId
    const post = await prisma.post.findUnique({
        where: { id: postId },
        select: { id: true, authorId: true },
    });

    if (!post) {
        throw Object.assign(new Error("Post not found"), { status: 404 });
    }

    const existingSave = await prisma.savedPost.findUnique({
        where: {
        userId_postId: { userId, postId },
        },
    });

    if (existingSave) {
        throw Object.assign(new Error("Already saved"), { status: 400 });
    }

    await prisma.savedPost.create({
        data: { userId, postId },
    });

    // 🔔 إشعار لصاحب البوست فقط (لو مش نفس الشخص)
    if (post.authorId !== userId) {
        const saver = await prisma.user.findUnique({
            where: { id: userId },
            select: { fullName: true },
        });

        createNotification({
            userId: post.authorId,
            type: "NEW_SAVE",
            title: "حفظ منشورك 🔖",
            message: `قام ${saver?.fullName || "أحد الآباء"} بحفظ منشورك`,
            relatedId: postId,
            relatedType: "POST",
        }).catch((err) => console.error("❌ [savePost] createNotification failed:", err));
    }

    return { ok: true, message: "Post saved successfully" };
};

// ==========================================
// ✅ خدمة: إلغاء الحفظ
// ==========================================
export const unsavePost = async (postId: string, userId: string) => {
    const savedPost = await prisma.savedPost.findUnique({
        where: {
        userId_postId: { userId, postId },
        },
    });

    if (!savedPost) {
        throw Object.assign(new Error("Saved post not found"), { status: 404 });
    }

    await prisma.savedPost.delete({
        where: { id: savedPost.id },
    });

    return { ok: true, message: "Post unsaved successfully" };
};