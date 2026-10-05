class NotificationModel {
  final String id;
  final String type;
  final String title;
  final String message;

  final String? relatedId;
  final String? relatedType;
  final String? actionUrl;

  final bool isRead;
  final DateTime createdAt;

  NotificationModel({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    this.relatedId,
    this.relatedType,
    this.actionUrl,
    required this.isRead,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json["id"]?.toString() ?? "",
      type: json["type"] ?? "",
      title: json["title"] ?? "",
      message: json["message"] ?? "",

      relatedId: json["relatedId"],
      relatedType: json["relatedType"],
      actionUrl: json["actionUrl"],

      isRead: json["read"] ?? false,

      createdAt: json["createdAt"] != null
          ? DateTime.parse(json["createdAt"])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "type": type,
      "title": title,
      "message": message,

      "relatedId": relatedId,
      "relatedType": relatedType,
      "actionUrl": actionUrl,

      "read": isRead,

      "createdAt": createdAt.toIso8601String(),
    };
  }
}