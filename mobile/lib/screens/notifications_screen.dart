import 'package:flutter/material.dart';
import '../../models/notification_model.dart';
import '../../services/api_service.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() =>
      _NotificationsScreenState();
}

class _NotificationsScreenState
    extends State<NotificationsScreen> {

  bool loading = true;

  List<NotificationModel> notifications = [];

  @override
  void initState() {
    super.initState();
    loadNotifications();
  }

  Future<void> loadNotifications() async {
    try {
      final data =
      await ApiService.getNotifications();

      setState(() {
        notifications = data;
        loading = false;
      });

      print("✅ Notifications Loaded");
      print("COUNT => ${notifications.length}");

    } catch (e) {

      print("❌ Notifications Error");
      print(e);

      setState(() {
        loading = false;
      });
    }
  }

  String getTime(DateTime createdAt) {

    final diff =
    DateTime.now().difference(createdAt);

    if (diff.inMinutes < 1) {
      return "Just now";
    }

    if (diff.inHours < 1) {
      return "${diff.inMinutes}m";
    }

    if (diff.inDays < 1) {
      return "${diff.inHours}h";
    }

    return "${diff.inDays}d";
  }

  Future<void> deleteNotification(
      String notificationId) async {
    try {

      await ApiService.deleteNotification(
        notificationId,
      );

      loadNotifications();

    } catch (e) {
      print("DELETE ERROR => $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,

        title: const Text(
          "Notifications",
          style: TextStyle(
            color: Color(0xff163560),
            fontWeight: FontWeight.bold,
          ),
        ),

        actions: [

          IconButton(
            onPressed: () async {

              await ApiService
                  .markAllNotificationsAsRead();

              loadNotifications();
            },
            icon: const Icon(
              Icons.done_all,
              color: Color(0xff49B388),
            ),
          ),

        ],

        iconTheme: const IconThemeData(
          color: Color(0xff163560),
        ),
      ),

      body: loading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : notifications.isEmpty
          ? const Center(
        child: Text(
          "No Notifications Yet",
          style: TextStyle(
            fontSize: 16,
          ),
        ),
      )
          : RefreshIndicator(
        onRefresh: loadNotifications,
        child: ListView.builder(
          padding:
          const EdgeInsets.all(16),

          itemCount:
          notifications.length,

          itemBuilder:
              (context, index) {

            final item =
            notifications[index];

            return Container(
              margin:
              const EdgeInsets.only(
                bottom: 12,
              ),

              decoration:
              BoxDecoration(
                color: item.isRead
                    ? Colors.white
                    : const Color(
                  0xffEEF8F3,
                ),

                borderRadius:
                BorderRadius.circular(
                  16,
                ),

                border: Border.all(
                  color:
                  Colors.black12,
                ),
              ),

              child: ListTile(

                onTap: () async {

                  if (!item.isRead) {

                    await ApiService
                        .markNotificationAsRead(
                      item.id,
                    );

                    loadNotifications();
                  }
                },

                leading: CircleAvatar(
                  backgroundColor:
                  item.isRead
                      ? Colors.grey.shade200
                      : const Color(
                    0xff49B388,
                  ),

                  child: Icon(
                    Icons.notifications,
                    color: item.isRead
                        ? Colors.grey
                        : Colors.white,
                  ),
                ),

                title: Text(
                  item.title,
                  style: TextStyle(
                    fontWeight:
                    item.isRead
                        ? FontWeight.w500
                        : FontWeight.bold,

                    color:
                    const Color(
                      0xff163560,
                    ),
                  ),
                ),

                subtitle: Padding(
                  padding:
                  const EdgeInsets.only(
                    top: 8,
                  ),
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment
                        .start,
                    children: [

                      Text(
                        item.message,
                        style:
                        const TextStyle(
                          fontSize: 14,
                          color:
                          Colors.grey,
                          height: 1.4,
                        ),
                      ),

                      const SizedBox(
                        height: 6,
                      ),

                      Text(
                        getTime(
                          item.createdAt,
                        ),
                        style:
                        TextStyle(
                          fontSize: 12,
                          color:
                          item.isRead
                              ? Colors
                              .grey
                              : const Color(
                            0xff49B388,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                trailing: IconButton(
                  onPressed: () =>
                      deleteNotification(
                        item.id,
                      ),
                  icon: const Icon(
                    Icons.delete_outline,
                    color: Colors.red,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}