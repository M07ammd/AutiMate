import 'package:atuimate_app/config/env.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:http/http.dart' as http;
import 'package:atuimate_app/services/api_service.dart';

class AITrackingWrapper extends StatefulWidget {
  final Widget child; // واجهة اللعبة الفعلية التي نريد تشغيلها
  final String gameName; // اسم اللعبة (لحفظه في التقرير إذا أردت)

  const AITrackingWrapper({
    Key? key,
    required this.child,
    this.gameName = "لعبة غير محددة",
  }) : super(key: key);

  @override
  _AITrackingWrapperState createState() => _AITrackingWrapperState();
}

class _AITrackingWrapperState extends State<AITrackingWrapper> {
  CameraController? _cameraController;
  Timer? _trackingTimer;
  final String apiUrl = "http://192.168.1.36:8000"; // استبدل بـ IP السيرفر
  bool _isCameraReady = false;

  @override
  void initState() {
    super.initState();
    _startTrackingSystem();
  }

  Future<void> _startTrackingSystem() async {
    // 1. تشغيل الكاميرا بصمت
    final cameras = await availableCameras();
    final frontCamera = cameras.firstWhere((c) => c.lensDirection == CameraLensDirection.front);

    _cameraController = CameraController(frontCamera, ResolutionPreset.medium, enableAudio: false);
    await _cameraController!.initialize();

    if (mounted) setState(() { _isCameraReady = true; });

    await http.post(Uri.parse('$apiUrl/start_session'));

    // 3. بدء الـ Timer للالتقاط كل 3 ثواني في الخلفية
    _trackingTimer = Timer.periodic(Duration(seconds: 3), (timer) {
      _captureAndAnalyze();
    });
  }

  Future<void> _captureAndAnalyze() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) return;

    try {
      final XFile imageFile = await _cameraController!.takePicture();
      final bytes = await File(imageFile.path).readAsBytes();
      final base64Image = base64Encode(bytes);

      final response = await http.post(
        Uri.parse('$apiUrl/analyze_frame'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"image": base64Image}),
      );

      if (response.statusCode == 200) {
        print(response.statusCode);
        // يمكنك هنا طباعة النتيجة لمعرفة حالة الطفل
        print("[${widget.gameName}] نتيجة اللحظة: ${response.body}");
      }
    } catch (e) {
      print("خطأ في التحليل: $e");
    }
  }

/*  Future<void> _stopTrackingSystem() async {
    // 1. إيقاف مؤقت الكاميرا
    _trackingTimer?.cancel();

    try {
      // 2. إيقاف الجلسة في سيرفر البايثون (المحلي) للحصول على التقرير
      final pythonResponse = await http.post(Uri.parse('$apiUrl/end_session'));

      if (pythonResponse.statusCode == 200) {
        // تحويل النص المستلم إلى Map
        final Map<String, dynamic> sessionReport = jsonDecode(pythonResponse.body);
        print("التقرير المستلم من البايثون: $sessionReport");

        // -------------------------------------------------------------
        // 3. الإرسال النظيف باستخدام ApiService الخاص بمشروعك
        // -------------------------------------------------------------
        await ApiService().sendSessionReport(sessionReport);
        print("تم تحويل التقرير بنجاح إلى سيرفرك السحابي");
      }
    } catch (e) {
      print("حدث خطأ أثناء الإنهاء: $e");
    } finally {
      // إغلاق الكاميرا
      _cameraController?.dispose();
    }
  }*/

  /*

  Future<void> _stopTrackingSystem() async {
    _trackingTimer?.cancel();

    try {
      // 1. استلام التقرير من البايثون
      final pythonResponse = await http.post(Uri.parse('$apiUrl/end_session'));

      if (pythonResponse.statusCode == 200) {
        final Map<String, dynamic> sessionReport = jsonDecode(pythonResponse.body);

        // 2. تجهيز وتنسيق المشاعر كما يتوقعها السيرفر السحابي
        final Map<String, dynamic> rawEmotions = sessionReport['emotion_percentages'] ?? {};
        final Map<String, dynamic> formattedEmotions = {
          "happy": (rawEmotions["Happy"] ?? 0.0).toDouble(),
          "sad": (rawEmotions["Sad"] ?? 0.0).toDouble(),
          "angry": (rawEmotions["Angry"] ?? 0.0).toDouble(),
          "neutral": (rawEmotions["Natural"] ?? 0.0).toDouble(), // تحويل Natural إلى neutral
        };

        String currentChildId = await ApiService.getChildId();

        if (currentChildId.isEmpty) {
          print("⚠️ تنبيه: لا يوجد ID مسجل للطفل في الجهاز (قد تفشل العملية)");
        }
        // 3. إرساله إلى Railway باستخدام ApiService
        await ApiService.saveSessionReport(
          childId: currentChildId,
          gameId: widget.gameName,
          durationSeconds: (sessionReport['duration_seconds'] ?? 0).toDouble(),
          distractionPercentage: (sessionReport['distraction_percentage'] ?? 0).toDouble(),
          emotionPercentages: formattedEmotions,
        );
      }
    } catch (e) {
      print("حدث خطأ أثناء إغلاق الجلسة: $e");
    } finally {
      _cameraController?.dispose();
    }
  }*/

  Future<void> _stopTrackingSystem() async {
    _trackingTimer?.cancel();

    try {
      // 1. استلام التقرير من البايثون
      final pythonResponse = await http.post(Uri.parse('$apiUrl/end_session'));

      if (pythonResponse.statusCode == 200) {
        final Map<String, dynamic> sessionReport = jsonDecode(pythonResponse.body);

        // 2. تجهيز المشاعر والقسمة على 100 لتطابق السيرفر السحابي
        final Map<String, dynamic> rawEmotions = Map<String, dynamic>.from(sessionReport['emotion_percentages'] ?? {});

        double happy = (rawEmotions["Happy"] ?? 0.0) / 100.0;
        double sad = (rawEmotions["Sad"] ?? 0.0) / 100.0;
        double angry = (rawEmotions["Angry"] ?? 0.0) / 100.0;
        double neutral = (rawEmotions["Natural"] ?? 0.0) / 100.0;

        // حساب المجموع الحالي
        double totalSum = happy + sad + angry + neutral;

        // توزيع المشاعر بالنسبة والتناسب لتساوي 1.0 بالضبط
        if (totalSum > 0) {
          happy = happy / totalSum;
          sad = sad / totalSum;
          angry = angry / totalSum;
          neutral = neutral / totalSum;
        } else {
          neutral = 1.0; // إذا كانت كلها أصفار، نفترض أن الطبيعي 100%
        }
        final Map<String, dynamic> formattedEmotions = {
          "happy": happy,
          "sad": sad,
          "angry": angry,
          "neutral": neutral,
        };
        // ===============================================
        // 2. استدعاء الدالة وحل مشكلة الوقت (الرقم الصحيح)
        // ===============================================
        String currentChildId = await ApiService.getChildId();
        await ApiService.saveSessionReport(
          childId: currentChildId,
          gameId: widget.gameName,
          // تحويل الوقت لرقم صحيح (int) باستخدام round()
          durationSeconds: (sessionReport['duration_seconds'] ?? 0).round(),
          distractionPercentage: (sessionReport['distraction_percentage'] ?? 0).toDouble(),
          // ملاحظة: إذا كان الباك إند يطلب تغيير الاسم إلى emotion_distribution تأكد من تغييرها في الـ ApiService، لكن حالياً اتركها كما هي
          emotionPercentages: formattedEmotions,
        );
      }
    } catch (e) {
      print("حدث خطأ أثناء إغلاق الجلسة: $e");
    } finally {
      _cameraController?.dispose();
    }
  }





  @override
  void dispose() {
    _stopTrackingSystem();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

