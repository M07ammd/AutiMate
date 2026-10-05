import 'package:atuimate_app/config/env.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:atuimate_app/models/notification_model.dart';

class ApiService {
  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: Env.apiBaseUrl,
      headers: {
        "Content-Type": "application/json",
      },
    ),
  )
    ..interceptors.add(
      InterceptorsWrapper(

        onRequest: (options, handler) async {
          final prefs = await SharedPreferences.getInstance();
          String? token = prefs.getString("accessToken");

          if (token != null && token.isNotEmpty) {
            options.headers["Authorization"] = "Bearer $token";
          }

          return handler.next(options);
        },

        onError: (DioException e, handler) async {
          if (e.response?.statusCode == 401) {
            final prefs = await SharedPreferences.getInstance();
            String? refreshToken = prefs.getString("refreshToken");

            if (refreshToken != null) {
              try {
                final refreshDio = Dio(BaseOptions(
                  baseUrl: Env.apiBaseUrl,
                ));

                final response = await refreshDio.post(
                  "/auth/refresh",
                  data: {"refreshToken": refreshToken},
                );

                String newAccessToken = response.data["accessToken"];

                await prefs.setString("accessToken", newAccessToken);

                e.requestOptions.headers["Authorization"] =
                "Bearer $newAccessToken";

                final retryResponse = await dio.fetch(e.requestOptions);

                return handler.resolve(retryResponse);

              } catch (_) {
                await prefs.clear();
                return handler.next(e);
              }
            }
          }

          return handler.next(e);
        },
      ),
    );
  // ================= AUTH =================
  Future<Response> registerParent({
    required String fullName,
    required String email,
    required String password,
    required String confirmPassword,
    required String phone,
  }) async {
    return await dio.post("/auth/register-parent", data: {
      "fullName": fullName,
      "email": email,
      "password": password,
      "confirmPassword": confirmPassword,
      "phone": phone,
    });
  }

  Future<Response> login({
    required String email,
    required String password,
  }) async {
    return await dio.post("/auth/login", data: {
      "email": email,
      "password": password,
    });
  }
  // ================= CHILD =================
  static Future<Response> createChild({
    required String childName,
    required String email,
    required String password,
    required String confirmPassword,
    required String gender,
    required String dateOfBirth,
  }) async {
    return await dio.post(
      "/auth/create-child",
      data: {
        "childName": childName,
        "email": email,
        "password": password,
        "confirmPassword": confirmPassword,
        "gender": gender,
        "dateOfBirth": dateOfBirth,
      },
    );
  }
  static Future<List<dynamic>> getMyChildren() async {
    final response = await dio.get("/auth/my-children");

    print("CHILDREN RESPONSE 👉 ${response.data}");

    return response.data["children"] ?? [];
  }

  // ================= COMMUNITY =================

  Future<Response> getCommunityPosts({
    String sort = "latest",
    bool savedOnly = false,
    int limit = 20,
    int offset = 0,
  }) async {
    return await dio.get(
      "/community/posts",
      queryParameters: {
        "sort": sort,
        if (savedOnly) "savedOnly": "true",
        "limit": limit,
        "offset": offset,
      },
    );
  }

  Future<Response> createCommunityPost({
    required String content,
    String? imageUrl,
  }) async {
    return await dio.post(
      "/community/posts",
      data: {
        "content": content,
        if (imageUrl != null && imageUrl.isNotEmpty)
          "imageUrl": imageUrl,
      },
    );
  }

  Future<Response> deletePost(String postId) async {
    return await dio.delete("/community/posts/$postId");
  }

  Future<Response> likePost(String postId) async {
    return await dio.post("/community/posts/$postId/like");
  }

  Future<Response> unlikePost(String postId) async {
    return await dio.delete("/community/posts/$postId/like");
  }

  Future<Response> savePost(String postId) async {
    return await dio.post("/community/posts/$postId/save");
  }

  Future<Response> unsavePost(String postId) async {
    return await dio.delete("/community/posts/$postId/save");
  }

  Future<Response> getPostComments(String postId) async {
    return await dio.get("/community/posts/$postId/comments");
  }

  Future<Response> addComment({
    required String postId,
    required String content,
  }) async {
    return await dio.post(
      "/community/posts/$postId/comments",
      data: {"content": content},
    );
  }

  // ================= SURVEY QUESTIONS =================
  static Future<List<dynamic>> getSurveyQuestions() async {
    final res = await dio.get("/survey/questions");
    return res.data["questions"] ?? [];
  }

  // ================= SUBMIT SURVEY =================
  static Future<Map<String, dynamic>> submitSurvey({
    required String childId,
    required Map<String, dynamic> answers,
  }) async {
    try {
      print("POST /survey/submit");

      final res = await dio.post(
        "/survey/submit",
        data: {
          "childId": childId,
          "answers": answers,
        },
      );

      print("STATUS => ${res.statusCode}");
      print("DATA => ${res.data}");

      return Map<String, dynamic>.from(res.data);
    } catch (e) {
      print("API ERROR => $e");
      rethrow;
    }
  }

  // ================= GET RESULT (FALLBACK FROM DOCS) =================
  static Future<Map<String, dynamic>> getSurveyResultByChildId(
      String childId) async {
    final res = await dio.get("/survey/assessment/$childId");

    print("RESULT RESPONSE => ${res.data}");

    return res.data ?? {};
  }

  // ================= CHILD ID =================
  static Future<String> getChildId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("childId") ?? "";
  }

  // ================= ROUTINE =================

  static Future<List<dynamic>> getRoutineCatalog() async {
    final prefs = await SharedPreferences.getInstance();
    String? childId = prefs.getString("childId");

    final res = await dio.get(
      "/routine/catalog",
      queryParameters: childId != null ? {"childId": childId} : null,
    );

    print("STATUS => ${res.statusCode}");
    print("RESPONSE => ${res.data}");

    return res.data["catalog"] ?? [];
  }

  /// 🟢2. Add Step
  static Future<void> addStepToRoutine(String templateId) async {
    final prefs = await SharedPreferences.getInstance();
    String? childId = prefs.getString("childId");

    await dio.post(
      "/routine/catalog/$templateId",
      data: childId != null ? {"childId": childId} : null,
    );
  }

  ///  3. Add Custom Task
  static Future<void> addCustomTask({
    required String title,
    String? time,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    String? childId = prefs.getString("childId");

    await dio.post(
      "/routine/tasks",
      data: {
        "title": title,
        if (time != null) "scheduledTime": time,
        if (childId != null) "childId": childId,
      },
    );
  }

  /// 🟢 4. Today Routine
  static Future<List<dynamic>> getTodayRoutine() async {
    final prefs = await SharedPreferences.getInstance();
    String? childId = prefs.getString("childId");

    final res = await dio.get(
      "/routine/today",
      queryParameters: childId != null ? {"childId": childId} : null,
    );

    return res.data["routine"] ?? [];
  }

  /// 🟢 5. Complete Task
  static Future<int> completeTask(String taskId) async {
    final res = await dio.post("/routine/tasks/$taskId/complete");

    return res.data["stars"] ?? 0;
  }

  /// 🟢 6. Skip Task
  static Future<void> skipTask(String taskId) async {
    await dio.post("/routine/tasks/$taskId/skip");
  }

  /// 🟢 7. Delete Task
  static Future<void> deleteTask(String taskId) async {
    final prefs = await SharedPreferences.getInstance();
    String? childId = prefs.getString("childId");

    await dio.delete(
      "/routine/tasks/$taskId",
      queryParameters: childId != null ? {"childId": childId} : null,
    );
  }

  /// 🟢 8. Progress
  static Future<double> getRoutineProgress() async {
    final prefs = await SharedPreferences.getInstance();
    String? childId = prefs.getString("childId");

    final res = await dio.get(
      "/routine/progress",
      queryParameters: childId != null ? {"childId": childId} : null,
    );

    return (res.data["percentage"] ?? 0) / 100;
  }

  // ================= SETTINGS =================

  /// 🟢 Update Profile
  static Future<Map<String, dynamic>?> updateProfile({
    required String fullName,
    required String phone,
  }) async {
    try {
      final response = await dio.patch(
        "/settings/profile",
        data: {
          "fullName": fullName,
          "phone": phone,
        },
      );

      print("UPDATE STATUS => ${response.statusCode}");
      print("UPDATE DATA => ${response.data}");

      return response.data;

    } catch (e) {
      print("UPDATE ERROR ❌ $e");
      return null;
    }
  }

  /// 🟢 Change Password
  static Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final response = await dio.post(
        "/settings/change-password",
        data: {
          "currentPassword": currentPassword,
          "newPassword": newPassword,
        },
      );

      print("PASSWORD STATUS => ${response.statusCode}");
      print("PASSWORD DATA => ${response.data}");

      return response.data["ok"] == true;

    } catch (e) {
      print("PASSWORD ERROR ❌ $e");
      return false;
    }
  }
  /// 🟢 Get Profile
  static Future<Map<String, dynamic>> getProfile() async {
    final response = await dio.get("/settings/profile");
    return response.data;
  }


// ================= FORGOT PASSWORD =================

  ///  Request OTP (Send code to email)
  static Future<Response> requestOtp(String email) async {
    try {
      final response = await dio.post(
        "/auth/forgot/request",
        data: {
          "email": email,
        },
      );

      print("REQUEST OTP RESPONSE 👉 ${response.data}");
      return response;
    } catch (e) {
      print("REQUEST OTP ERROR ❌ $e");
      throw Exception("Failed to send OTP");
    }
  }

  // Verify OTP (Check code)
  static Future<Response> verifyOtp({
    required String email,
    required String code,
  }) async {
    try {
      final response = await dio.post(
        "/auth/forgot/verify",
        data: {
          "email": email,
          "code": code,
        },
      );

      print("VERIFY OTP RESPONSE 👉 ${response.data}");
      return response;
    } catch (e) {
      print("VERIFY OTP ERROR ❌ $e");
      throw Exception("Invalid OTP");
    }
  }

  ///  Reset Password (New password + token)
  static Future<Response> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    try {
      final response = await dio.post(
        "/auth/forgot/reset",
        data: {
          "token": token,
          "newPassword": newPassword,
        },
      );

      print("RESET PASSWORD RESPONSE 👉 ${response.data}");
      return response;
    } catch (e) {
      print("RESET PASSWORD ERROR ❌ $e");
      throw Exception("Failed to reset password");
    }
  }

  /// 🟢 Save Game Score
  static Future<Response> saveGameScore({
    required String gameType,
    required int score,
    required int moves,
    required int timeSpent,
    required bool completed,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? childId = prefs.getString("childId");

      final response = await dio.post(
        "/games/score",
        data: {
          if (childId != null) "childId": childId,
          "gameType": gameType,
          "score": score,
          "moves": moves,
          "timeSpent": timeSpent,
          "completed": completed,
        },
      );

      print("✅ GAME SCORE SAVED: ${response.data}");
      return response;

    } on DioException catch (e) {
      print("❌ STATUS: ${e.response?.statusCode}");
      print("❌ RESPONSE: ${e.response?.data}");
      throw Exception(e.response?.data.toString());
    }
  }


  /// 🟢 Get Leaderboard
  static Future<List<dynamic>> getLeaderboard(String gameType) async {
    try {
      final response = await dio.get(
        "/games/leaderboard/$gameType",
      );

      print("LEADERBOARD 👉 ${response.data}");

      return response.data;

    } catch (e) {
      print("LEADERBOARD ERROR ❌ $e");
      throw Exception("Failed to load leaderboard");
    }
  }
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();

    final refreshToken = prefs.getString("refreshToken");

    if (refreshToken == null || refreshToken.isEmpty) {
      print("NO refresh token found ❌");
      return;
    }

    try {
      final response = await dio.post(
        "/auth/logout",
        data: {
          "refreshToken": refreshToken,
        },
      );

      print("LOGOUT SUCCESS ✅ ${response.data}");
    } catch (e) {
      if (e is DioException) {
        print("LOGOUT STATUS 👉 ${e.response?.statusCode}");
        print("LOGOUT DATA 👉 ${e.response?.data}");
      }
      rethrow;
    }
  }
  //ai
/*
  static Future<Response> saveSessionReport({
    required String childId,
    required String gameId,
    required double durationSeconds,
    required double distractionPercentage,
    required Map<String, dynamic> emotionPercentages,
  }) async {
    try {
      final response = await dio.post(
        "/api/reports",
        data: {
          "child_id": childId,
          "game_id": gameId,
          "report_data": {
            "duration_seconds": durationSeconds,
            "distraction_percentage": distractionPercentage,
            "emotion_percentages": emotionPercentages,
          }
        },
      );

      print("SESSION REPORT SAVED ✅ ${response.data}");
      return response;
    } catch (e) {
      print("SAVE REPORT ERROR ❌ $e");
      throw Exception("Failed to save session report");
    }
  }

*/


  static Future<Response> saveSessionReport({
    required String childId,
    required String gameId,
    required int durationSeconds,
    required double distractionPercentage,
    required Map<String, dynamic> emotionPercentages,
  }) async {

    final Map<String, dynamic> payload = {
      "child_id": childId,
      "game_id": gameId,
      "report_data": {
        "duration_seconds": durationSeconds,
        "distraction_percentage": distractionPercentage,
        "emotion_percentages": emotionPercentages,
      }
    };

    print("====== 🚀 جاري إرسال تقرير الجلسة إلى السيرفر ======");
    print("البيانات المُرسلة (Payload): $payload");
    print("==================================================");

    try {
      final response = await dio.post(
        "/api/reports",
        data: payload,
      );

      print("✅ تم حفظ التقرير بنجاح! رد السيرفر: ${response.data}");
      return response;

    } on DioException catch (e) {
      print("❌ خطأ من السيرفر (DioException):");
      print("- كود الخطأ (Status Code): ${e.response?.statusCode}");

      if (e.response?.data != null) {
        print("- تفاصيل الخطأ من الباك إند: ${e.response?.data}");
      } else {
        print("- رسالة الخطأ: ${e.message}");
      }
      print("==================================================");

      throw Exception("Failed to save session report: ${e.response?.statusCode}");

    } catch (e) {
      print("❌ خطأ غير متوقع: $e");
      throw Exception("Failed to save session report: $e");
    }
  }

  // ================= PROGRESS =================

  /*static Future<Map<String, dynamic>> getChildProgress() async {
    final prefs = await SharedPreferences.getInstance();
    String? childId = prefs.getString("childId");

    if (childId == null || childId.isEmpty) {
      throw Exception("Child ID not found");
    }

    final response = await dio.get("/progress/child/$childId");

    print("PROGRESS 👉 ${response.data}");

    return response.data;
  }


  static Future<Map<String, dynamic>> getWeeklyReports() async {
    final prefs = await SharedPreferences.getInstance();
    String? childId = prefs.getString("childId");

    if (childId == null || childId.isEmpty) {
      throw Exception("Child ID not found");
    }

    final response = await dio.get("/progress/reports/$childId");

    print("WEEKLY 👉 ${response.data}");

    return response.data;
  }



  static Future<Map<String, dynamic>> getAIDashboard() async {
    final prefs = await SharedPreferences.getInstance();
    String? childId = prefs.getString("childId");

    if (childId == null || childId.isEmpty) {
      throw Exception("Child ID not found");
    }

    final response = await dio.get("/ai-sessions/$childId/dashboard");

    print("AI 👉 ${response.data}");

    return response.data;
  }*/

// ================= PROGRESS =================
  /// 🟣 1. Overall Progress
  static Future<Map<String, dynamic>> getChildProgress() async {
    final prefs = await SharedPreferences.getInstance();
    String? childId = prefs.getString("childId");

    if (childId == null || childId.isEmpty) {
      throw Exception("No childId found ❌");
    }

    final res = await dio.get("/progress/child/$childId");

    print("📊 PROGRESS RESPONSE 👉 ${res.data}");

    return res.data;
  }
  /// 🟣 2. Weekly + Today Reports
  static Future<Map<String, dynamic>> getProgressReports() async {
    final prefs = await SharedPreferences.getInstance();
    String? childId = prefs.getString("childId");

    if (childId == null || childId.isEmpty) {
      throw Exception("No childId found ❌");
    }

    final res = await dio.get("/progress/reports/$childId");

    print("📅 REPORTS RESPONSE 👉 ${res.data}");

    return res.data;
  }
  /// 🟣 3. AI Dashboard
  static Future<Map<String, dynamic>> getAiDashboard() async {
    final prefs = await SharedPreferences.getInstance();
    String? childId = prefs.getString("childId");

    if (childId == null || childId.isEmpty) {
      throw Exception("No childId found ❌");
    }

    final res = await dio.get("/ai-sessions/$childId/dashboard");

    print("🤖 AI DASHBOARD 👉 ${res.data}");

    return res.data["data"];
  }
  // ================= NOTIFICATIONS =================
// ================= NOTIFICATIONS =================

  static Future<List<NotificationModel>> getNotifications({
    bool unreadOnly = false,
    int limit = 50,
    int offset = 0,
  }) async {
    try {
      print("🔔 GET NOTIFICATIONS");

      final response = await dio.get(
        "/notifications",
        queryParameters: {
          "unreadOnly": unreadOnly.toString(),
          "limit": limit,
          "offset": offset,
        },
      );

      print("✅ STATUS => ${response.statusCode}");
      print("✅ DATA => ${response.data}");

      final List data =
          response.data["notifications"] ?? [];

      return data
          .map((e) => NotificationModel.fromJson(e))
          .toList();

    } on DioException catch (e) {

      print("❌ GET NOTIFICATIONS ERROR");
      print("❌ STATUS => ${e.response?.statusCode}");
      print("❌ DATA => ${e.response?.data}");

      rethrow;
    }
  }

  static Future<void> markNotificationAsRead(
      String notificationId,
      ) async {
    try {

      print("🔔 MARK AS READ => $notificationId");

      final response = await dio.patch(
        "/notifications/$notificationId/read",
      );

      print("✅ STATUS => ${response.statusCode}");
      print("✅ DATA => ${response.data}");

    } on DioException catch (e) {

      print("❌ MARK READ ERROR");
      print("❌ STATUS => ${e.response?.statusCode}");
      print("❌ DATA => ${e.response?.data}");

      rethrow;
    }
  }

  static Future<void> markAllNotificationsAsRead() async {
    try {

      print("🔔 MARK ALL AS READ");

      final response = await dio.post(
        "/notifications/mark-all-read",
      );

      print("✅ STATUS => ${response.statusCode}");
      print("✅ DATA => ${response.data}");

    } on DioException catch (e) {

      print("❌ MARK ALL ERROR");
      print("❌ STATUS => ${e.response?.statusCode}");
      print("❌ DATA => ${e.response?.data}");

      rethrow;
    }
  }

  static Future<void> deleteNotification(
      String notificationId,
      ) async {
    try {

      print("🗑 DELETE NOTIFICATION => $notificationId");

      final response = await dio.delete(
        "/notifications/$notificationId",
      );

      print("✅ STATUS => ${response.statusCode}");
      print("✅ DATA => ${response.data}");

    } on DioException catch (e) {

      print("❌ DELETE ERROR");
      print("❌ STATUS => ${e.response?.statusCode}");
      print("❌ DATA => ${e.response?.data}");

      rethrow;
    }
  }
}

