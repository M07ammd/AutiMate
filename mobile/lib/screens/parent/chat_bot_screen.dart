import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';
import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:just_audio/just_audio.dart';
import 'package:atuimate_app/services/chatbot_api.dart';
import 'package:atuimate_app/services/api_service.dart';
import 'package:atuimate_app/models/chatbot_message_model.dart';
import 'chat bot/VoiceChatScreen.dart';

class ChatBotScreen extends StatefulWidget {
  const ChatBotScreen({super.key});

  @override
  State<ChatBotScreen> createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen> {
  final TextEditingController controller = TextEditingController();
  final List<UiChatMessage> messages = [];

  late stt.SpeechToText speech;
  late AudioPlayer audioPlayer;
  bool isListening = false;
  bool isSending = false;
  bool isPlayingAudio = false;

  late ChatbotApi chatbotApi;
  late String sessionId;

  @override
  void initState() {
    super.initState();
    speech = stt.SpeechToText();
    audioPlayer = AudioPlayer();
    
    // تهيئة API
    chatbotApi = ChatbotApi(ApiService.dio);
    
    // إنشاء جلسة محادثة جديدة
    _initializeSession();
  }

  Future<void> _initializeSession() async {
    try {
      final session = await chatbotApi.createSession();
      setState(() {
        sessionId = session["id"] ?? const Uuid().v4();
      });
      print("SESSION CREATED ✅ $sessionId");
    } catch (e) {
      print("INIT SESSION ERROR ❌ $e");
      // استخدام UUID عشوائي في حالة الفشل
      setState(() {
        sessionId = const Uuid().v4();
      });
    }
  }

  Future<void> startListening() async {
    await Permission.microphone.request();

    bool available = await speech.initialize(
      onStatus: (status) => print("SPEECH STATUS: $status"),
      onError: (error) => print("SPEECH ERROR: $error"),
    );

    if (available) {
      setState(() => isListening = true);

      speech.listen(
        localeId: "ar_EG",
        listenFor: const Duration(seconds: 20),
        pauseFor: const Duration(seconds: 5),
        onResult: (result) {
          setState(() {
            controller.text = result.recognizedWords;
          });
        },
      );
    } else {
      print("Speech recognition not available");
    }
  }

  void stopListening() {
    speech.stop();
    setState(() => isListening = false);
  }

  Future<void> sendTextMessage() async {
    if (controller.text.trim().isEmpty) return;

    final messageText = controller.text;
    controller.clear();

    setState(() {
      messages.add(UiChatMessage(text: messageText, isUser: true, isLoading: false));
      isSending = true;
    });

    try {
      final SendTextMessageResponse response = await chatbotApi.sendTextMessage(
        sessionId: sessionId,
        content: messageText,
      );

      final assistantMessage = response.assistantMessage.content;

      setState(() {
        messages.add(UiChatMessage(text: assistantMessage, isUser: false, isLoading: false));
        isSending = false;
      });

      _scrollToBottom();
    } catch (e) {
      print("SEND MESSAGE ERROR ❌ $e");
      setState(() {
        messages.add(
          UiChatMessage(
            text: "حدث خطأ في إرسال الرسالة 😞",
            isUser: false,
            isLoading: false,
          ),
        );
        isSending = false;
      });
    }
  }

  Future<void> sendVoiceMessage() async {
    // تسجيل صوت
    final audioDir = await getTemporaryDirectory();
    final voiceFile = File('${audioDir.path}/voice_message_${DateTime.now().millisecondsSinceEpoch}.wav');

    setState(() {
      messages.add(UiChatMessage(text: "🎙️ جاري التسجيل...", isUser: true, isLoading: true));
      isSending = true;
    });

    try {
      // في التطبيق الفعلي، ستحتاج إلى تسجيل صوت فعلي هنا
      // هذا مثال توضيحي
      print("VOICE RECORDING STARTED 🎙️");

      // بعد التسجيل، إرسال الملف
      final response = await chatbotApi.sendVoiceMessage(
        sessionId: sessionId,
        audioFile: voiceFile,
      );

      // استخراج الرسالة (chatbotApi.sendVoiceMessage يرجع String مباشرة بعد المعالجة)
      final userText = response["userMessage"] as String? ?? "رسالة صوتية";
      final assistantMessage = response["assistantMessage"] as String? ?? "لا يوجد رد";

      setState(() {
        messages.removeLast(); // إزالة رسالة التسجيل
        messages.add(UiChatMessage(text: userText, isUser: true, isLoading: false));
        messages.add(UiChatMessage(text: assistantMessage, isUser: false, isLoading: false));
      });

      setState(() => isSending = false);
      _scrollToBottom();
    } catch (e) {
      print("VOICE MESSAGE ERROR ❌ $e");
      setState(() {
        messages.removeLast();
        messages.add(
          UiChatMessage(
            text: "حدث خطأ في إرسال الرسالة الصوتية 😞",
            isUser: false,
            isLoading: false,
          ),
        );
        isSending = false;
      });
    }
  }

  Future<void> _playAudioFromBase64(String base64Audio) async {
    try {
      // فك تشفير Base64
      List<int> audioBytes = base64Decode(base64Audio);

      // حفظ الملف مؤقتاً
      Directory tempDir = await getTemporaryDirectory();
      File audioFile = File('${tempDir.path}/ai_reply_${DateTime.now().millisecondsSinceEpoch}.wav');
      await audioFile.writeAsBytes(audioBytes);

      // تشغيل الملف
      setState(() => isPlayingAudio = true);
      await audioPlayer.setFilePath(audioFile.path);
      await audioPlayer.play();

      // انتظر حتى ينتهي التشغيل
      audioPlayer.playerStateStream.listen((state) {
        if (state.processingState == ProcessingState.completed) {
          setState(() => isPlayingAudio = false);
        }
      });

      print("PLAYING AI VOICE REPLY ✅");
    } catch (e) {
      print("PLAY AUDIO ERROR ❌ $e");
    }
  }

  void _scrollToBottom() {
    // تمرير لأسفل المحادثة عند الرسالة الجديدة
  }

  @override
  void dispose() {
    speech.stop();
    audioPlayer.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Chatbot",
          style: TextStyle(
            color: const Color(0xff3CB371),
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Theme.of(context).textTheme.titleLarge?.color),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // ================= MESSAGES =================
          Expanded(
            child: messages.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.chat_bubble_outline, size: 60, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text(
                    "ابدأ محادثة جديدة",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                return Align(
                  alignment: message.isUser
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    padding: const EdgeInsets.all(16),
                    constraints: const BoxConstraints(maxWidth: 280),
                    decoration: BoxDecoration(
                      color: message.isUser
                          ? const Color(0xff3CB371)
                          : Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: message.isLoading
                        ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    )
                        : Text(
                      message.text,
                      style: TextStyle(
                        color: message.isUser ? Colors.white : Theme.of(context).textTheme.bodyLarge?.color,
                        fontSize: 15,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // ================= INPUT =================
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Row(
              children: [
                // حقل النص
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                    decoration: BoxDecoration(
                      color: Theme.of(context).inputDecorationTheme.fillColor ?? Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: const Color(0xff3CB371).withOpacity(0.3),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xff3CB371).withOpacity(0.15),
                          spreadRadius: 2,
                          blurRadius: 8,
                          offset: const Offset(0, 0),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: controller,
                      decoration: const InputDecoration(
                        hintText: "اكتب رسالتك هنا...",
                        hintStyle: TextStyle(color: Colors.grey),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                // زر الإرسال
                Container(
                  decoration: const BoxDecoration(
                    color: Color(0xff3CB371),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: isSending
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Icon(Icons.send, color: Colors.white, size: 20),
                    onPressed: isSending ? null : sendTextMessage,
                  ),
                ),

                const SizedBox(width: 8),

                // 🎤 زر المساعد الصوتي
                Container(
                  decoration: const BoxDecoration(
                    color: Color(0xff3CB371),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.mic, color: Colors.white, size: 22),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VoiceChatScreen(
                            sessionId: sessionId,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // تشغيل الصوت
          if (isPlayingAudio)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.volume_up, color: Color(0xff3CB371)),
                  const SizedBox(width: 8),
                  const Text("جاري تشغيل الرد الصوتي..."),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class UiChatMessage {
  final String text;
  final bool isUser;
  final bool isLoading;

  UiChatMessage({
    required this.text,
    required this.isUser,
    this.isLoading = false,
  });
}