import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:record/record.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:atuimate_app/services/chatbot_api.dart';
import 'package:atuimate_app/services/api_service.dart';
import 'package:atuimate_app/services/audio_service.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class VoiceChatScreen extends StatefulWidget {
  final String? sessionId;

  const VoiceChatScreen({super.key, this.sessionId});

  @override
  State<VoiceChatScreen> createState() => _VoiceChatScreenState();
}

class _VoiceChatScreenState extends State<VoiceChatScreen>
    with TickerProviderStateMixin {
  late ChatbotApi chatbot;
  late AudioRecorder audioRecorder;
  late AudioPlayer audioPlayer;
  late AnimationController _animationController;

  String? sessionId;
  bool isRecording = false;
  bool isProcessing = false;
  String? recordingPath;
  List<double> waveformData = [];

  @override
  void initState() {
    super.initState();

    chatbot = ChatbotApi(ApiService.dio);
    audioRecorder = AudioRecorder();
    audioPlayer = AudioPlayer();
    sessionId = widget.sessionId;

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> startRecording() async {
    try {
      bool hasPermission = await Permission.microphone.request().isGranted;
      if (!hasPermission) {
        print("❌ Microphone permission denied");
        return;
      }

      // 🔇 وقّف أي صوت AI شغال قبل ما نفتح الميكروفون
      // عشان الميكروفون ميسجلش صوت الـ speaker بدل صوت المستخدم
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
        waveformData = [];
      });

      print("🎤 Recording started: $recordingPath");
    } catch (e) {
      print("❌ Recording error: $e");
    }
  }

  Future<void> stopRecording() async {
    try {
      final path = await audioRecorder.stop();
      setState(() {
        isRecording = false;
      });

      if (path != null) {
        await sendVoiceMessage(path);
      }
    } catch (e) {
      print("❌ Stop recording error: $e");
    }
  }

  Future<void> sendVoiceMessage(String filePath) async {
    setState(() {
      isProcessing = true;
    });

    try {
      // إنشاء جلسة جديدة إذا لم تكن موجودة أو كانت فارغة
      if (sessionId == null || sessionId!.isEmpty) {
        print("⚠️ Session ID is null/empty, creating new session...");
        final session = await chatbot.createSession();
        sessionId = session["id"] ?? session["_id"];
        
        if (sessionId == null || sessionId!.isEmpty) {
          throw Exception("Failed to create session - no ID returned");
        }
        print("✅ New session created: $sessionId");
      }

      print("📤 Sending voice message with sessionId: $sessionId");

      // إرسال الرسالة الصوتية
      final response = await chatbot.sendVoiceMessage(
        sessionId: sessionId!,
        audioFile: File(filePath),
      );

      setState(() {
        isProcessing = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Replied successfully ✅"),
            duration: Duration(seconds: 3),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      setState(() {
        isProcessing = false;
      });

      print("Voice message error: $e");

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

  Future<void> playResponse(String audioData) async {
    try {
      if (audioData.isEmpty) {
        print("⚠️ Audio data is empty");
        return;
      }

      // التحقق من أن البيانات هي Base64 (وليس URL)
      if (audioData.startsWith("http")) {
        // إذا كانت URL
        print("🔊 Playing from URL: $audioData");
        await audioPlayer.setUrl(audioData);
        await audioPlayer.play();
      } else {
        // إذا كانت Base64
        print("🔊 Playing Base64 audio");
        await AudioService.playBase64Audio(audioData);
      }
    } catch (e) {
      print("❌ Audio playback error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Voice Chat',
          style: TextStyle(
            color: Color(0xff3CB371),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Color(0xffF3F4F6),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animation (AI Orb)
              Expanded(
                child: AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    double pulseValue = _animationController.value;
                    double scale = isRecording ? 1.0 + (pulseValue * 0.1) : 1.0;
                    double spread = isRecording ? (pulseValue * 25) : 5.0;

                    return Center(
                      child: Container(
                        width: 160 * scale,
                        height: 160 * scale,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              const Color(0xff3CB371),
                              const Color(0xff3CB371).withOpacity(isRecording ? 0.5 : 0.2),
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xff3CB371).withOpacity(isRecording ? 0.6 : 0.2),
                              blurRadius: isRecording ? 40 : 20,
                              spreadRadius: spread,
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.psychology,
                            size: 80,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 30),

              // Waveform Visualizer
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: AnimatedWaveform(
                  isRecording: isRecording,
                  isProcessing: isProcessing,
                ),
              ),
              const SizedBox(height: 40),

              // Status Text
              Text(
                isRecording
                    ? 'Recording...'
                    : isProcessing
                        ? 'Processing...'
                        : 'Tap the button to record',
                style: const TextStyle(
                  fontSize: 18,
                  color: Color(0xff3CB371),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40),

              // Record Button
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xff3CB371),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xff3CB371).withOpacity(0.4),
                      blurRadius: 15,
                      spreadRadius: isRecording ? 10 : 0,
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: isProcessing
                        ? null
                        : () {
                            if (isRecording) {
                              stopRecording();
                            } else {
                              startRecording();
                            }
                          },
                    customBorder: const CircleBorder(),
                    child: Center(
                      child: Icon(
                        isRecording ? Icons.stop : Icons.mic,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}

/// Animated Waveform Visualizer
class AnimatedWaveform extends StatefulWidget {
  final bool isRecording;
  final bool isProcessing;

  const AnimatedWaveform({
    super.key,
    required this.isRecording,
    required this.isProcessing,
  });

  @override
  State<AnimatedWaveform> createState() => _AnimatedWaveformState();
}

class _AnimatedWaveformState extends State<AnimatedWaveform>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  List<double> bars = List.generate(20, (_) => 0.2);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    if (widget.isRecording || widget.isProcessing) {
      _startAnimation();
    }
  }

  @override
  void didUpdateWidget(AnimatedWaveform oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isRecording || widget.isProcessing) {
      _startAnimation();
    } else {
      _controller.stop();
      setState(() {
        bars = List.generate(20, (_) => 0.2);
      });
    }
  }

  void _startAnimation() {
    _controller.repeat(reverse: true);
    _animateBars();
  }

  void _animateBars() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted && (widget.isRecording || widget.isProcessing)) {
        setState(() {
          bars = List.generate(
            20,
            (_) => 0.2 + (0.8 * (0.5 + 0.5 * ((_controller.value * 2 - 1)))),
          );
        });
        _animateBars();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: bars.map((height) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: Container(
            width: 4,
            height: 40 * height,
            decoration: BoxDecoration(
              color: const Color(0xff3CB371),
              borderRadius: BorderRadius.circular(2),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xff3CB371).withOpacity(0.5),
                  blurRadius: 8,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
