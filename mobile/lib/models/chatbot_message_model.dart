/// Strongly typed model for chatbot API responses
class ChatMessage {
  final String id;
  final String role; // "user" or "assistant"
  final String content;
  final DateTime? createdAt;

  ChatMessage({
    required this.id,
    required this.role,
    required this.content,
    this.createdAt,
  });

  /// Factory constructor to safely parse from JSON
  factory ChatMessage.fromJson(dynamic json) {
    if (json == null) {
      throw ArgumentError("ChatMessage JSON cannot be null");
    }
    
    if (json is! Map) {
      throw FormatException("ChatMessage must be a Map, got ${json.runtimeType}");
    }

    final map = Map<String, dynamic>.from(json);
    
    return ChatMessage(
      id: (map["id"] ?? map["_id"] ?? "").toString(),
      role: (map["role"] ?? "unknown").toString(),
      content: (map["content"] ?? "").toString(),
      createdAt: map["createdAt"] != null 
          ? DateTime.tryParse(map["createdAt"].toString())
          : null,
    );
  }

  @override
  String toString() => 'ChatMessage(id: $id, role: $role, content: $content)';
}

/// Strongly typed model for text message API response
class SendTextMessageResponse {
  final ChatMessage userMessage;
  final ChatMessage assistantMessage;

  SendTextMessageResponse({
    required this.userMessage,
    required this.assistantMessage,
  });

  /// Factory constructor to safely parse from JSON
  factory SendTextMessageResponse.fromJson(dynamic json) {
    if (json == null) {
      throw ArgumentError("SendTextMessageResponse JSON cannot be null");
    }
    
    if (json is! Map) {
      throw FormatException(
        "SendTextMessageResponse must be a Map, got ${json.runtimeType}. "
        "Raw data: $json"
      );
    }

    final map = Map<String, dynamic>.from(json);

    print("📊 Parsing SendTextMessageResponse");
    print("   userMessage type: ${map["userMessage"].runtimeType}");
    print("   assistantMessage type: ${map["assistantMessage"].runtimeType}");

    return SendTextMessageResponse(
      userMessage: ChatMessage.fromJson(map["userMessage"]),
      assistantMessage: ChatMessage.fromJson(map["assistantMessage"]),
    );
  }

  @override
  String toString() => 'SendTextMessageResponse(user: $userMessage, assistant: $assistantMessage)';
}

/// Strongly typed model for sessions list response
class ChatSession {
  final String id;
  final String title;
  final DateTime createdAt;
  final List<ChatMessage> messages;

  ChatSession({
    required this.id,
    required this.title,
    required this.createdAt,
    this.messages = const [],
  });

  factory ChatSession.fromJson(dynamic json) {
    if (json == null) {
      throw ArgumentError("ChatSession JSON cannot be null");
    }
    
    if (json is! Map) {
      throw FormatException("ChatSession must be a Map, got ${json.runtimeType}");
    }

    final map = Map<String, dynamic>.from(json);

    return ChatSession(
      id: (map["id"] ?? map["_id"] ?? "").toString(),
      title: (map["title"] ?? "").toString(),
      createdAt: map["createdAt"] != null
          ? DateTime.tryParse(map["createdAt"].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}
