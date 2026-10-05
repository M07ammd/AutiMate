import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:just_audio/just_audio.dart';
import 'package:record/record.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:atuimate_app/services/chatbot_api.dart';
import 'package:atuimate_app/services/api_service.dart';
import 'package:atuimate_app/services/audio_service.dart';
import 'package:atuimate_app/models/chatbot_message_model.dart';
import 'package:atuimate_app/utils/theme_helper.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

/// Advanced Voice Chat Modal Dialog
class VoiceChatModal extends StatefulWidget {
  final String? sessionId;
  final String? initialSessionId;

  const VoiceChatModal({
    super.key,
    this.sessionId,
    this.initialSessionId,
  });

  @override
  State<VoiceChatModal> createState() => _VoiceChatModalState();

  /// Show as modal from parent screen
  static Future<Map<String, dynamic>?> show(
    BuildContext context, {
    String? sessionId,
  }) {
    return showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      backgroundColor: Colors.transparent,
      builder: (context) => VoiceChatModal(
        sessionId: sessionId,
      ),
    );
  }
}

class _VoiceChatModalState extends State<VoiceChatModal>
    with TickerProviderStateMixin {
  late ChatbotApi chatbot;
  late AudioRecorder audioRecorder;
  late AudioPlayer audioPlayer;
  late AnimationController _pulseController;
  late AnimationController _listingController;

  String? sessionId;
  bool isRecording = false;
  bool isProcessing = false;
  bool isPlayingResponse = false;
  String? recordingPath;

  String userMessage = "";
  String assistantMessage = "";
  List<double> waveformBars = List.generate(20, (_) => 0.2);

  @override
  void initState() {
    super.initState();
    chatbot = ChatbotApi(ApiService.dio);
    audioRecorder = AudioRecorder();
    audioPlayer = AudioPlayer();
    sessionId = widget.sessionId;

    // Pulse animation for character
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..repeat();

    // Listening waveform animation
    _listingController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    // Request microphone permission early
    Permission.microphone.request();
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    _pulseController.dispose();
    _listingController.dispose();
    super.dispose();
  }

  Future<void> startRecording() async {
    try {
      // 🔇 وقّف أي صوت AI شغال قبل ما نفتح الميكروفون
      await AudioService.stopAudio();
      print("🔇 AI audio stopped before recording");

      // ⏳ استنى 700ms عشان الـ speaker يهدى قبل فتح الميك
      await Future.delayed(const Duration(milliseconds: 700));

      final dir = await getApplicationDocumentsDirectory();
      recordingPath =
          '${dir.path}/voice_${DateTime.now().millisecondsSinceEpoch}.m4a';

      await audioRecorder.start(
        RecordConfig(
          encoder: AudioEncoder.aacLc,
          bitRate: 128000,
          sampleRate: 16000,
        ),
        path: recordingPath!,
      );

      setState(() {
        isRecording = true;
        userMessage = "";
        assistantMessage = "";
        _animateWaveform();
      });

      print("🎤 Recording started: $recordingPath");
    } catch (e) {
      print("❌ Recording error: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Recording error: $e")),
        );
      }
    }
  }

  Future<void> stopRecording() async {
    try {
      final path = await audioRecorder.stop();
      setState(() {
        isRecording = false;
        _listingController.stop();
      });

      if (path != null) {
        // ✅ تحقق من الملف المسجّل قبل الإرسال
        await _validateRecordedAudio(path);
      }
    } catch (e) {
      print("❌ Stop recording error: $e");
    }
  }

  /// 🔍 تحقق من جودة الصوت المسجّل وعرض معلوماته
  Future<void> _validateRecordedAudio(String path) async {
    final file = File(path);
    if (!file.existsSync()) {
      print("❌ AUDIO VALIDATION: File not found at $path");
      return;
    }

    final sizeBytes = file.lengthSync();
    final sizeKb = (sizeBytes / 1024).toStringAsFixed(1);

    print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
    print("🎙️ RECORDED AUDIO VALIDATION");
    print("📁 Path      : $path");
    print("📏 Size      : $sizeKb KB ($sizeBytes bytes)");
    print("🎵 Format    : ${path.split('.').last.toUpperCase()}");

    // تحذير لو الملف صغير جداً (أقل من 5KB = مشكلة)
    if (sizeBytes < 5000) {
      print("⚠️ WARNING: File is too small ($sizeKb KB) - Recording may be empty or corrupted!");
      print("⚠️ Possible causes: Microphone not working, permission denied, or too short recording");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("⚠️ Audio file is too small - Is the mic working?"),
            backgroundColor: Colors.orange,
            duration: Duration(seconds: 4),
          ),
        );
      }
      return; // لا ترسل ملف فارغ
    }

    // لو الملف مناسب → شغّله مؤقتاً في الـ console عشان تسمعه
    print("✅ File looks good - sending to server...");
    print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");

    setState(() {
      userMessage = "Sending... 🚀";
    });

    await sendVoiceMessage(path);
  }

  void _animateWaveform() {
    _listingController.repeat(reverse: true);
    if (mounted) {
      _generateWaveform();
    }
  }

  void _generateWaveform() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted && isRecording) {
        setState(() {
          waveformBars = List.generate(
            20,
            (i) => 0.2 + (0.8 * (0.5 + 0.5 * ((_listingController.value * 2 - 1).abs()))),
          );
        });
        _generateWaveform();
      }
    });
  }

  Future<void> sendVoiceMessage(String filePath) async {
    setState(() {
      isProcessing = true;
    });

    try {
      print("📨 Sending voice message...");

      // Create session if needed
      if (sessionId == null || sessionId!.isEmpty) {
        print("Creating new session...");
        final session = await chatbot.createSession();
        sessionId = session["id"] ?? session["_id"];
        print("New session ID: $sessionId");
      }

      // ✅ الصوت بيتشغّل داخل sendVoiceMessage مباشرة
      // وبيرجع { userMessage, assistantMessage, reply_audio: null }
      setState(() => isPlayingResponse = true);
      final response = await chatbot.sendVoiceMessage(
        sessionId: sessionId!,
        audioFile: File(filePath),
      );

      print("✅ Response received: $response");

      setState(() {
        userMessage = response["userMessage"] ?? "🎤 Voice Message";
        assistantMessage = response["assistantMessage"] ?? "Replied";
        isProcessing = false;
        isPlayingResponse = false; 
      });

      // ⚠️ لا تشغَّل الصوت هنا - اتشغّل بالفعل داخل chatbot_api.sendVoiceMessage
      // if (response["reply_audio"] != null ...) { ... } ← محذوف عشان الصوت اتشغّل بالفعل

      if (mounted) {
        await Future.delayed(const Duration(seconds: 2));
      }
    } catch (e) {
      print("❌ Voice message error: $e");
      setState(() {
        isProcessing = false;
        isPlayingResponse = false;
        assistantMessage = "❌ Error: ${e.toString()}";
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error: $e"),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: ThemeHelper.getBackgroundColor(context),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Voice Chat 🎤",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close, color: ThemeHelper.getTextColor(context)),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          const Divider(),

          // Character & Messages
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    // Character Animation
                    ScaleTransition(
                      scale: Tween<double>(begin: 0.95, end: 1.05).animate(
                        CurvedAnimation(
                          parent: _pulseController,
                          curve: Curves.easeInOut,
                        ),
                      ),
                      child: Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).primaryColor.withOpacity(0.1),
                          border: Border.all(
                            color: Theme.of(context).primaryColor,
                            width: 2,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(75),
                          child: isRecording || isProcessing
                              ? Lottie.asset(
                                  'assets/animations/brain_animation.json',
                                  fit: BoxFit.cover,
                                )
                              : isPlayingResponse
                                  ? Lottie.asset(
                                      'assets/animations/answer_true.json',
                                      fit: BoxFit.cover,
                                    )
                                  : Image.asset(
                                      'assets/images/profile.jpg',
                                      fit: BoxFit.cover,
                                    ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Status Text
                    Text(
                      isRecording
                          ? 'Recording... 🎙️'
                          : isProcessing
                              ? 'Processing...'
                              : isPlayingResponse
                                  ? 'Replying...'
                                  : 'Tap the button to speak',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isRecording
                            ? Colors.red
                            : isProcessing
                                ? Colors.orange
                                : isPlayingResponse
                                    ? Colors.green
                                    : ThemeHelper.getTextColor(context),
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Waveform Visualizer
                    if (isRecording || isProcessing)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          waveformBars.length,
                          (index) => Container(
                            width: 3,
                            height: 40 * waveformBars[index],
                            margin: const EdgeInsets.symmetric(horizontal: 2),
                            decoration: BoxDecoration(
                              color: isRecording
                                  ? Colors.red
                                  : Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                      ),

                    const SizedBox(height: 20),


                  ],
                ),
              ),
            ),
          ),

          // Record Button
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              children: [
                // Waveform bars animation
                if (isRecording)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        10,
                        (i) => Container(
                          width: 4,
                          height: 30 * waveformBars[i],
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          decoration: BoxDecoration(
                            color: Colors.redAccent,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                    ),
                  ),

                // Main button
                GestureDetector(
                  onTap: isProcessing
                      ? null
                      : () {
                          if (isRecording) {
                            stopRecording();
                          } else {
                            startRecording();
                          }
                        },
                  child: Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: isRecording
                            ? [Colors.red, Colors.redAccent]
                            : [
                                Theme.of(context).primaryColor,
                                Theme.of(context).primaryColor.withOpacity(0.7),
                              ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: (isRecording ? Colors.red : Theme.of(context).primaryColor)
                              .withOpacity(0.5),
                          blurRadius: 20,
                          spreadRadius: isRecording ? 5 : 0,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Icon(
                        isRecording ? Icons.stop : Icons.mic,
                        color: Colors.white,
                        size: 45,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
