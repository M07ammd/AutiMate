/*class ChatMessage {
  final String text;
  final bool isUser;

  ChatMessage({required this.text, required this.isUser});
}
*/
class ChatMessage {
  final String id;
  final String text;
  final bool isUser;
  final DateTime createdAt;

  ChatMessage({
    required this.id,
    required this.text,
    required this.isUser,
    required this.createdAt,
  });

  factory ChatMessage.fromJson(
      Map<String, dynamic> json,
      ) {
    return ChatMessage(
      id: json["id"] ?? "",
      text: json["content"] ?? "",
      isUser: json["role"] == "user",
      createdAt: DateTime.tryParse(
        json["createdAt"] ?? "",
      ) ??
          DateTime.now(),
    );
  }
}