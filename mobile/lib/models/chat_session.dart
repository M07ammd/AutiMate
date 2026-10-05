class ChatSession {
  final String id;
  final String title;

  ChatSession({
    required this.id,
    required this.title,
  });

  factory ChatSession.fromJson(
      Map<String, dynamic> json,
      ) {
    return ChatSession(
      id: json["id"] ?? "",
      title:
      json["title"] ??
          "New Conversation",
    );
  }
}