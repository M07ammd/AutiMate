import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';

class AudioService {
  /// الـ player الحالي — بنعمل instance جديد لكل تشغيل
  static AudioPlayer? _currentPlayer;

  /// تشغيل صوت من Base64 String
  /// يحول Base64 → Bytes → File مُصلَّح → Player جديد → تشغيل كامل
  static Future<void> playBase64Audio(String base64AudioString) async {
    // وقّف وامسح أي player قديم أولاً
    await _disposeCurrentPlayer();

    File? tempFile;
    AudioPlayer? player;

    try {
      if (base64AudioString.isEmpty) {
        throw Exception("Base64 audio string is empty");
      }

      print("🔊 Starting Base64 audio playback...");
      print("📏 Base64 string length: ${base64AudioString.length}");

      // تنظيف Base64 من أي prefixes
      String cleanBase64 = base64AudioString;
      if (cleanBase64.contains(",")) {
        cleanBase64 = cleanBase64.split(",").last;
        print("✅ Removed data URL prefix from Base64");
      }

      // 1. فك تشفير الـ Base64 إلى Bytes
      List<int> audioBytes;
      try {
        audioBytes = base64Decode(cleanBase64);
      } catch (_) {
        print("⚠️ Trying with padding fix...");
        String padded = cleanBase64;
        while (padded.length % 4 != 0) padded += "=";
        audioBytes = base64Decode(padded);
      }
      print("✅ Decoded ${audioBytes.length} bytes from Base64");

      // 2. كشف صيغة الصوت
      final fileExtension = _detectAudioFormat(audioBytes);
      print("🎵 Detected audio format: $fileExtension");

      // 3. إصلاح WAV header (إزالة LIST chunks وإعادة البناء)
      if (fileExtension == "wav") {
        audioBytes = _fixWavHeader(audioBytes);
        print("🔧 WAV header rebuilt");
      }

      // 4. حفظ الملف مؤقتاً
      final dir = await getTemporaryDirectory();
      final filePath =
          '${dir.path}/ai_reply_${DateTime.now().millisecondsSinceEpoch}.$fileExtension';
      tempFile = File(filePath);
      await tempFile.writeAsBytes(audioBytes);
      print("✅ Audio file saved: $filePath (${tempFile.lengthSync()} bytes)");

      // 5. إنشاء player جديد بـ AndroidAudioAttributes صح
      //    usage=media + contentType=music → يروح لـ STREAM_MUSIC (السماعة)
      player = AudioPlayer();
      _currentPlayer = player;

      await player.setAndroidAudioAttributes(
        const AndroidAudioAttributes(
          contentType: AndroidAudioContentType.music,
          flags: AndroidAudioFlags.none,
          usage: AndroidAudioUsage.media,
        ),
      );

      print("🎵 Playing audio through STREAM_MUSIC...");
      await player.setFilePath(filePath);
      await player.play();
      print("✅ Audio playback started");

      // 6. استنى حتى ينتهي التشغيل بالكامل
      await player.playerStateStream.firstWhere(
        (s) =>
            s.processingState == ProcessingState.completed ||
            s.processingState == ProcessingState.idle,
      );
      print("✅ Audio playback completed");
    } catch (e) {
      print("❌ Error playing Base64 audio: $e");
    } finally {
      // 7. تنظيف
      try {
        await player?.stop();
        await player?.dispose();
        if (player == _currentPlayer) _currentPlayer = null;
      } catch (_) {}
      try {
        if (tempFile != null && tempFile.existsSync()) {
          tempFile.deleteSync();
          print("🗑️ Temporary audio file deleted");
        }
      } catch (_) {}
    }
  }

  /// إعادة بناء WAV نظيف بدون chunks غير معروفة (LIST/INFO) عشان ExoPlayer يشتغل صح
  /// OpenAI TTS بتحط LIST chunk في الـ WAV وده بيخلي ExoPlayer يتعطل
  static List<int> _fixWavHeader(List<int> bytes) {
    if (bytes.length < 44) return bytes;

    // تأكد إنه RIFF/WAVE
    if (bytes[0] != 0x52 || bytes[1] != 0x49 ||
        bytes[2] != 0x46 || bytes[3] != 0x46) return bytes;
    if (bytes[8] != 0x57 || bytes[9] != 0x41 ||
        bytes[10] != 0x56 || bytes[11] != 0x45) return bytes;

    List<int>? fmtData;
    int fmtSize = 0;
    List<int>? audioData;

    int offset = 12; // بعد RIFF....WAVE
    while (offset + 8 <= bytes.length) {
      final chunkId = String.fromCharCodes(bytes.sublist(offset, offset + 4));

      // اقرأ حجم الـ chunk كـ little-endian uint32
      int chunkSize = (bytes[offset + 4] & 0xFF) |
          ((bytes[offset + 5] & 0xFF) << 8) |
          ((bytes[offset + 6] & 0xFF) << 16) |
          ((bytes[offset + 7] & 0xFF) << 24);

      // لو الحجم 0xFFFFFFFF (streaming) أو أكبر من الملف → خد الباقي
      if (chunkSize < 0 || offset + 8 + chunkSize > bytes.length) {
        chunkSize = bytes.length - offset - 8;
      }

      if (chunkId == 'fmt ') {
        fmtSize = chunkSize;
        fmtData = bytes.sublist(offset + 8, offset + 8 + chunkSize);
        print('🔧 Found fmt chunk: size=$chunkSize');
      } else if (chunkId == 'data') {
        // خد الـ PCM data الحقيقي (من بعد الـ header للآخر)
        audioData = bytes.sublist(offset + 8, bytes.length);
        print('🔧 Found data chunk at offset=$offset, actual size=${audioData.length}');
        break; // data دايمًا آخر chunk مهم
      } else {
        print('🔧 Skipping unknown chunk: "$chunkId" (size=$chunkSize)');
      }

      offset += 8 + chunkSize;
      if (chunkSize % 2 != 0) offset++; // WAV chunks word-aligned
    }

    if (fmtData == null || audioData == null || audioData.isEmpty) {
      print('⚠️ WAV parse failed, returning original bytes');
      return bytes;
    }

    // أعد بناء WAV نظيف: RIFF + WAVE + fmt + data بس
    final dataSize = audioData.length;
    final riffPayload = 4 + 8 + fmtSize + 8 + dataSize;

    final clean = <int>[
      // RIFF header
      0x52, 0x49, 0x46, 0x46,
      riffPayload & 0xFF, (riffPayload >> 8) & 0xFF,
      (riffPayload >> 16) & 0xFF, (riffPayload >> 24) & 0xFF,
      0x57, 0x41, 0x56, 0x45, // WAVE
      // fmt chunk
      0x66, 0x6D, 0x74, 0x20, // "fmt "
      fmtSize & 0xFF, (fmtSize >> 8) & 0xFF,
      (fmtSize >> 16) & 0xFF, (fmtSize >> 24) & 0xFF,
      ...fmtData,
      // data chunk
      0x64, 0x61, 0x74, 0x61, // "data"
      dataSize & 0xFF, (dataSize >> 8) & 0xFF,
      (dataSize >> 16) & 0xFF, (dataSize >> 24) & 0xFF,
      ...audioData,
    ];

    print('🔧 Rebuilt clean WAV: ${bytes.length}B → ${clean.length}B (removed LIST/INFO chunks)');
    return clean;
  }

  /// كشف صيغة الملف الصوتي من البيانات الخام
  static String _detectAudioFormat(List<int> bytes) {
    if (bytes.length < 4) {
      print("⚠️ Audio data too short (${bytes.length} bytes), defaulting to wav");
      return "wav";
    }

    // Print first 16 bytes for debugging
    print("🔍 First 16 bytes (hex): ${bytes.take(16).map((b) => b.toRadixString(16).padLeft(2, '0')).join(' ')}");

    // فحص Magic Numbers
    // WAV: "RIFF" (0x52 0x49 0x46 0x46)
    if (bytes[0] == 0x52 && bytes[1] == 0x49 && bytes[2] == 0x46 && bytes[3] == 0x46) {
      print("✅ Format: WAV");
      return "wav";
    }
    
    // MP3: "ID3" (0x49 0x44 0x33) أو 0xFF 0xFB (MPEG sync)
    if ((bytes[0] == 0x49 && bytes[1] == 0x44 && bytes[2] == 0x33) ||
        (bytes[0] == 0xFF && bytes[1] == 0xFB)) {
      print("✅ Format: MP3");
      return "mp3";
    }
    
    // OGG: "OggS" (0x4F 0x67 0x67 0x53)
    if (bytes[0] == 0x4F && bytes[1] == 0x67 && bytes[2] == 0x67 && bytes[3] == 0x53) {
      print("✅ Format: OGG");
      return "ogg";
    }
    
    // AAC: "FF F1" أو "FF F9" (ADTS header)
    if (bytes[0] == 0xFF && (bytes[1] == 0xF1 || bytes[1] == 0xF9)) {
      print("✅ Format: AAC");
      return "aac";
    }

    // M4A/MP4: "ftypmp42" أو "ftypisom"
    if (bytes.length >= 8) {
      if ((bytes[4] == 0x66 && bytes[5] == 0x74 && bytes[6] == 0x79 && bytes[7] == 0x70) ||
          (bytes[4] == 0x6D && bytes[5] == 0x64 && bytes[6] == 0x61)) {
        print("✅ Format: M4A");
        return "m4a";
      }
    }

    print("⚠️ Unknown audio format detected. First bytes: ${bytes.take(16).toList()}");
    print("⚠️ Defaulting to wav - Backend may be sending wrong format!");
    return "wav";
  }

  /// إيقاف تشغيل الصوت الحالي
  static Future<void> stopAudio() async {
    await _disposeCurrentPlayer();
    print("✅ Audio stopped");
  }

  /// إيقاف وتنظيف الـ player الحالي
  static Future<void> _disposeCurrentPlayer() async {
    final old = _currentPlayer;
    _currentPlayer = null;
    if (old != null) {
      try {
        await old.stop();
        await old.dispose();
      } catch (_) {}
    }
  }

  /// التحقق من حالة التشغيل الحالية
  static bool get isPlaying => _currentPlayer?.playing ?? false;

  /// الحصول على Stream لمتابعة حالة التشغيل
  static Stream<Duration?> get durationStream =>
      _currentPlayer?.durationStream ?? const Stream.empty();

  static Stream<Duration> get positionStream =>
      _currentPlayer?.positionStream ?? const Stream.empty();

  /// تنظيف الـ player
  static Future<void> dispose() async {
    await _disposeCurrentPlayer();
    print("✅ AudioService disposed");
  }
}
