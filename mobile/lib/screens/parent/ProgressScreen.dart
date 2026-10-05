
import 'package:flutter/material.dart';
import 'package:atuimate_app/services/api_service.dart';
import 'package:atuimate_app/screens/parent/parent_home.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen>
    with SingleTickerProviderStateMixin {
  bool loading = true;

  Map<String, dynamic>? progress;
  Map<String, dynamic>? reports;
  Map<String, dynamic>? ai;

  late AnimationController controller;
  late Animation<double> animation;

  double toDouble(dynamic val) {
    if (val == null) return 0.0;
    return (val as num).toDouble();
  }
  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    animation = Tween<double>(begin: 0, end: 0).animate(controller);
    load();
  }
  Future<void> load() async {
    Map<String, dynamic>? p;
    Map<String, dynamic>? r;
    Map<String, dynamic>? a;
    try {
      print("🚀 CALL PROGRESS");
      p = await ApiService.getChildProgress();
      print("✅ PROGRESS OK");
    } catch (e) {
      print("❌ PROGRESS ERROR $e");
    }

    try {
      print("🚀 CALL REPORTS");
      r = await ApiService.getProgressReports();
      print("✅ REPORTS OK");
    } catch (e) {
      print("❌ REPORTS ERROR $e");
    }

    try {
      print("🚀 CALL AI");
      a = await ApiService.getAiDashboard();
      print("✅ AI OK");
    } catch (e) {
      print("❌ AI ERROR $e");
    }

    animation = Tween<double>(
      begin: 0,
      end: toDouble(p?['overallProgress']),
    ).animate(CurvedAnimation(parent: controller, curve: Curves.easeOut));

    controller.forward();
    setState(() {
      progress = p;
      reports = r;
      ai = a;
      loading = false;
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final today = reports?['today'] ?? {};
    final weekly = reports?['weeklyChart'] ?? [];
    final aiData = ai ?? {};

    return Scaffold(
      backgroundColor: const Color(0xffF6F8FC),
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,

        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Color(0xFF0E2A47),
          ),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const ParentHome(),
              ),
            );
          },
        ),

        title: const Text(
          "Progress",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0E2A47),
          ),
        ),
      ),
      body: FadeTransition(
        opacity: controller,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              AnimatedBuilder(
                animation: controller,
                builder: (context, _) {
                  return FancyProgress(value: animation.value);
                },
              ),

              const SizedBox(height: 20),
              Row(
                children: [
                  _mini("⭐ Stars", "${progress?['stars'] ?? 0}"),
                  _mini("🏆 Level", "${progress?['level'] ?? 0}"),
                ],
              ),

              const SizedBox(height: 15),
              _card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Today Tasks",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    LinearProgressIndicator(
                      value: toDouble(today['percentage']) / 100,
                      color: const Color(0xFF45BB89),
                      backgroundColor: Colors.grey.shade200,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "${today['completed'] ?? 0} / ${today['total'] ?? 0} tasks",
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 15),
              _card(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: weekly.map<Widget>((e) {
                    double h = toDouble(e['percentage']) / 100;

                    return Column(
                      children: [
                        Container(
                          height: 60,
                          width: 8,
                          alignment: Alignment.bottomCenter,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Container(
                            height: 60 * h,
                            decoration: BoxDecoration(
                              color: const Color(0xFF45BB89),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(e['day'].toString()),
                      ],
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 20),

              /// AI DASHBOARD
              _card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("🤖 AI Insights",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 15),

                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        _chip("Sessions", aiData['totalSessions'] ?? 0),
                        _chip("Duration",
                            "${aiData['totalDurationSeconds'] ?? 0} sec"),
                        _chip(
                          "Focus",
                          "${(toDouble(aiData['averageFocusScore']) * 100).toInt()}%",
                        ),
                        _chip("Emotion",
                            aiData['dominantEmotionOverall'] ?? "-"),
                        _chip("Section", aiData['mostUsedSection'] ?? "-"),
                        _chip("Game", aiData['mostPlayedGame'] ?? "-"),
                      ],
                    ),

                    const SizedBox(height: 15),

                    const Text("Emotion Breakdown"),
                    const SizedBox(height: 8),

                    Column(
                      children:
                      (aiData['emotionBreakdown'] as Map? ?? {}).entries.map<Widget>((e) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              Expanded(flex: 2, child: Text(e.key)),
                              Expanded(
                                flex: 6,
                                child: LinearProgressIndicator(
                                  value: toDouble(e.value),
                                  color: const Color(0xFF45BB89),
                                  backgroundColor: Colors.grey.shade200,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// ================= UI =================

  Widget FancyProgress({required double value}) {
    double progress = (value / 100).clamp(0, 1);

    return SizedBox(
      height: 260,
      width: 260,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            height: 240,
            width: 240,
            child: CircularProgressIndicator(
              value: 1,
              strokeWidth: 18,
              color: Colors.grey.shade200,
            ),
          ),
          SizedBox(
            height: 240,
            width: 240,
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: 18,
              strokeCap: StrokeCap.round,
              valueColor: const AlwaysStoppedAnimation(Color(0xFF45BB89)),
            ),
          ),
          Text(
            "${value.toInt()}%",
            style: const TextStyle(
              fontSize: 42,
              fontWeight: FontWeight.bold,
              color: Color(0xFF45BB89),
            ),
          ),
        ],
      ),
    );
  }

  Widget _card({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)
        ],
      ),
      child: child,
    );
  }

  Widget _mini(String title, String value) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xffF9FAFB),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Text(title),
            const SizedBox(height: 5),
            Text(
              value,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _chip(String title, dynamic value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF45BB89).withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text("$title: $value"),
    );
  }
}