import 'package:dio/dio.dart';
import 'dart:io';
import 'package:atuimate_app/services/audio_service.dart';
import 'package:atuimate_app/models/chatbot_message_model.dart';

class ChatbotApi {
  final Dio dio;

  ChatbotApi(this.dio);

  /// إنشاء جلسة محادثة جديدة
  Future<Map<String, dynamic>> createSession() async {
    try {
      final res = await dio.post(
        "/chatbot/sessions",
        data: {"title": "New Chat"},
      );

      print("CREATE SESSION ✅ ${res.data}");
      
      // استخراج البيانات بشكل آمن
      final data = res.data as Map<String, dynamic>?;
      if (data != null) {
        // محاولة الحصول على الجلسة من أماكن مختلفة
        final session = data["session"] ?? data["data"] ?? data;
        
        // التأكد من وجود ID وتحويل النوع بشكل صريح
        if (session is Map && (session.containsKey("id") || session.containsKey("_id"))) {
          return Map<String, dynamic>.from(session);
        }
      }
      
      // إذا لم نجد session صحيحة، نرمي خطأ
      throw Exception("Invalid session response: $data");
    } on DioException catch (e) {
      print("CREATE SESSION DIO ERROR ❌");
      print("Error: ${e.message}");
      print("Status code: ${e.response?.statusCode}");
      print("Response body: ${e.response?.data}");
      print("Request URL: ${e.requestOptions.path}");
      
      if (e.response?.statusCode == 500) {
        print("⚠️ Backend Server Error - The backend API is having issues");
      }
      
      rethrow;
    } catch (e) {
      print("CREATE SESSION ERROR ❌ $e");
      rethrow;
    }
  }

  /// إرسال رسالة نصية - Returns strongly typed response
  Future<SendTextMessageResponse> sendTextMessage({
    required String sessionId,
    required String content,
  }) async {
    if (sessionId.isEmpty) {
      throw Exception("Session ID cannot be empty");
    }
    
    try {
      print("📨 Sending text message to session: $sessionId");
      print("📨 Content: $content");
      
      final res = await dio.post(
        "/chatbot/sessions/$sessionId/messages",
        data: {"content": content},
        options: Options(
          contentType: "application/json",
          receiveTimeout: const Duration(seconds: 30),
          sendTimeout: const Duration(seconds: 30),
        ),
      );

      print("TEXT MESSAGE RESPONSE ✅ Status: ${res.statusCode}");

      // Get raw response data
      final data = res.data;
      
      print("📊 Raw response type: ${data.runtimeType}");
      print("📊 Raw response data: $data");

      // Validate that response is a Map
      if (data is! Map) {
        throw FormatException(
          "Expected Map response, got ${data.runtimeType}. "
          "Response value: $data"
        );
      }

      // Parse using strongly typed model
      final response = SendTextMessageResponse.fromJson(data);
      
      print("✅ User message: ${response.userMessage.content}");
      print("✅ Assistant message: ${response.assistantMessage.content}");

      return response;
    } on DioException catch (e) {
      print("TEXT MESSAGE DIO ERROR ❌");
      print("Error: ${e.message}");
      print("Status code: ${e.response?.statusCode}");
      print("Response body: ${e.response?.data}");
      print("Request URL: ${e.requestOptions.path}");
      
      if (e.response?.statusCode == 500) {
        print("⚠️ Backend Server Error");
      }
      
      rethrow;
    } catch (e) {
      print("TEXT MESSAGE ERROR ❌ $e");
      print("Error type: ${e.runtimeType}");
      rethrow;
    }
  }

  /// إرسال رسالة صوتية مع تشغيل الرد الصوتي تلقائياً
  /// ⚠️ هذا الطلب يأخذ 15-30 ثانية لأنه يمر بـ 3 مراحل AI:
  ///   1) Whisper (transcription) → 2) Gemini (AI reply) → 3) Groq TTS (audio)
  Future<Map<String, dynamic>> sendVoiceMessage({
    required String sessionId,
    required File audioFile,
  }) async {
    if (sessionId.isEmpty) {
      throw Exception("Session ID cannot be empty");
    }

    if (!audioFile.existsSync()) {
      throw Exception("Audio file does not exist: ${audioFile.path}");
    }

    try {
      print("🎤 Sending voice message to session: $sessionId");
      print("📁 Audio file: ${audioFile.path}");
      print("📏 File size: ${audioFile.lengthSync()} bytes");

      // ✅ تحديد MIME type الصحيح بناءً على امتداد الملف
      // السيرفر بيبعت الملف لـ Whisper - الـ MIME مهم جداً عشان Whisper يتعرف على الصيغة
      final ext = audioFile.path.split('.').last.toLowerCase();
      final String mimeType;
      switch (ext) {
        case 'wav':  mimeType = 'audio/wav';  break;
        case 'mp3':  mimeType = 'audio/mpeg'; break;
        case 'ogg':  mimeType = 'audio/ogg';  break;
        case 'aac':  mimeType = 'audio/aac';  break;
        case 'flac': mimeType = 'audio/flac'; break;
        case 'm4a':
        default:     mimeType = 'audio/mp4';  break; // m4a / aac / mp4
      }

      final formData = FormData.fromMap({
        "audio": await MultipartFile.fromFile(
          audioFile.path,
          // ✅ الاسم مهم: الباك إند بيحتاج voice_message.m4a مش audio.m4a
          filename: "voice_message.$ext",
          contentType: DioMediaType.parse(mimeType),
        ),
      });
      print("📤 Uploading as: $mimeType → voice_message.$ext");

      // ✅ زيادة الـ timeout لـ 90 ثانية - الـ pipeline بياخد وقت (Whisper + Gemini + TTS)
      final res = await dio.post(
        "/chatbot/sessions/$sessionId/voice",
        data: formData,
        options: Options(
          sendTimeout: const Duration(seconds: 90),
          receiveTimeout: const Duration(seconds: 90),
          contentType: "multipart/form-data",
        ),
      );

      print("🎤 VOICE MESSAGE RESPONSE ✅ Status: ${res.statusCode}");

      final data = res.data as Map<String, dynamic>? ?? {};
      print("📊 Response keys: ${data.keys.toList()}");

      // ✅ استخراج النص الحقيقي من Whisper (transcript)
      // الباك إند بيبعت: { userMessage: {id, role, content, createdAt}, assistantMessage: {...}, reply_audio: "..." }
      // content في userMessage هو ما قاله المستخدم فعلاً كما فهمه Whisper
      String userMessage = "🎤 رسالة صوتية";
      if (data["userMessage"] is Map) {
        final um = data["userMessage"] as Map<String, dynamic>;
        userMessage = um["content"]?.toString() ?? userMessage;
      } else if (data["userMessage"] is String) {
        userMessage = data["userMessage"];
      }

      // ✅ استخراج رد الـ AI
      String assistantMessage = "تم الرد";
      if (data["assistantMessage"] is Map) {
        final am = data["assistantMessage"] as Map<String, dynamic>;
        assistantMessage = am["content"]?.toString() ??
                           am["reply"]?.toString() ??
                           assistantMessage;
      } else if (data["assistantMessage"] is String) {
        assistantMessage = data["assistantMessage"];
      } else if (data["reply"] is String) {
        assistantMessage = data["reply"];
      }

      // ✅ استخراج الصوت
      // الباك إند في chatbot.service.ts: reply_audio: data.audio
      // الباك إند في app.py: { audio: base64_string }
      String? replyAudioBase64 = data["reply_audio"] as String?;
      if (replyAudioBase64 == null || replyAudioBase64.isEmpty) {
        replyAudioBase64 = data["audio"] as String?;
        if (replyAudioBase64 != null) print("ℹ️ Audio found under 'audio' key");
      }

      // تنظيف Base64 prefix لو موجود
      if (replyAudioBase64 != null && replyAudioBase64.contains(",")) {
        replyAudioBase64 = replyAudioBase64.split(",").last;
        print("⚠️ Removed data URL prefix from Base64");
      }

      print("🔊 Audio response size: ${replyAudioBase64?.length ?? 0} chars");
      print("✅ User said: $userMessage");
      print("✅ AI replied: $assistantMessage");

      // ✅ تشغيل الصوت هنا مرة واحدة فقط (لا يُشغَّل مرة ثانية في الـ UI)
      if (replyAudioBase64 != null && replyAudioBase64.isNotEmpty) {
        print("🔊 Playing AI voice response...");
        try {
          await AudioService.playBase64Audio(replyAudioBase64);
        } catch (e) {
          print("⚠️ Error playing audio: $e");
        }
      } else {
        print("⚠️ No audio in response");
      }

      return {
        "userMessage": userMessage,
        "assistantMessage": assistantMessage,
        // ⚠️ نرجع null عشان الـ UI ما يشغّلش الصوت مرة ثانية
        "reply_audio": null,
      };
    } on DioException catch (e) {
      print("🎤 VOICE MESSAGE DIO ERROR ❌");
      print("Error: ${e.message}");
      print("Status code: ${e.response?.statusCode}");
      print("Response body: ${e.response?.data}");
      print("Request URL: ${e.requestOptions.path}");

      if (e.response?.statusCode == 500) {
        print("⚠️ Backend Server Error (500)");
      } else if (e.response?.statusCode == 401) {
        print("⚠️ Unauthorized (401) - Check your Token");
      } else if (e.response?.statusCode == 404) {
        print("⚠️ Session not found (404) - Check your sessionId");
      } else if (e.type == DioExceptionType.connectionTimeout) {
        print("⚠️ Connection timeout");
      } else if (e.type == DioExceptionType.receiveTimeout) {
        print("⚠️ Receive timeout - AI pipeline took > 90 seconds");
      }

      rethrow;
    } catch (e) {
      print("🎤 VOICE MESSAGE ERROR ❌ $e");
      rethrow;
    }
  }

  /// الحصول على رسائل جلسة معينة - Returns strongly typed messages
  Future<List<ChatMessage>> getMessages(String sessionId) async {
    try {
      final res = await dio.get("/chatbot/sessions/$sessionId/messages");
      print("MESSAGES ✅ Response status: ${res.statusCode}");
      print("MESSAGES ✅ Response type: ${res.data.runtimeType}");
      
      final data = res.data;
      
      // Handle different response structures
      List<dynamic> messagesList = [];
      
      if (data is List) {
        // If response is directly a list of messages
        messagesList = data;
      } else if (data is Map) {
        // If response is wrapped in a Map
        messagesList = data["messages"] ?? data["data"] ?? [];
        
        // Validate result is a List
        if (messagesList is! List) {
          messagesList = [];
        }
      }
      
      print("MESSAGES ✅ Raw message count: ${messagesList.length}");

      // Convert each message to strongly typed ChatMessage
      final parsedMessages = <ChatMessage>[];
      for (int i = 0; i < messagesList.length; i++) {
        try {
          final msg = messagesList[i];
          parsedMessages.add(ChatMessage.fromJson(msg));
          print("   ✅ Message $i parsed: ${parsedMessages[i]}");
        } catch (e) {
          print("   ❌ Error parsing message at index $i: $e");
          print("   Raw data: ${messagesList[i]}");
        }
      }
      
      print("MESSAGES ✅ Successfully parsed ${parsedMessages.length} messages");
      return parsedMessages;
    } catch (e) {
      print("MESSAGES ERROR ❌ $e");
      print("Error type: ${e.runtimeType}");
      rethrow;
    }
  }

  /// الحصول على جميع الجلسات
  Future<List<ChatSession>> getSessions() async {
    try {
      final res = await dio.get("/chatbot/sessions");
      print("SESSIONS ✅ Response type: ${res.data.runtimeType}");
      
      final data = res.data;
      List<dynamic> sessionsList = [];
      
      if (data is List) {
        sessionsList = data;
      } else if (data is Map) {
        sessionsList = data["sessions"] ?? data["data"] ?? [];
      }
      
      final parsedSessions = <ChatSession>[];
      for (int i = 0; i < sessionsList.length; i++) {
        try {
          parsedSessions.add(ChatSession.fromJson(sessionsList[i]));
        } catch (e) {
          print("❌ Error parsing session at index $i: $e");
        }
      }
      
      print("SESSIONS ✅ Parsed ${parsedSessions.length} sessions");
      return parsedSessions;
    } catch (e) {
      print("SESSIONS ERROR ❌ $e");
      rethrow;
    }
  }
}
