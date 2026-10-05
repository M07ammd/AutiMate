
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:atuimate_app/models/routine_step.dart';
import 'package:atuimate_app/services/api_service.dart';

const Color kPrimary = Color(0xff49B388);
const Color kBg = Color(0xFFF7F1E8);

class RoutineFocusScreen extends StatefulWidget {
  const RoutineFocusScreen({super.key});

  @override
  State<RoutineFocusScreen> createState() => _RoutineFocusScreenState();
}

class _RoutineFocusScreenState extends State<RoutineFocusScreen> {
  List<RoutineStep> steps = [];
  int currentIndex = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchToday();
  }

  Future<void> loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    currentIndex = prefs.getInt("routine_index") ?? 0;
  }

  Future<void> saveProgress() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt("routine_index", currentIndex);
  }

  Future<void> clearProgress() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("routine_index");
  }

  Future<void> fetchToday() async {
    try {
      final data = await ApiService.getTodayRoutine();

      await loadProgress();

      final routineSteps =
      (data as List).map((e) => RoutineStep.fromJson(e)).toList();

      if (currentIndex >= routineSteps.length) {
        currentIndex = 0;
      }

      setState(() {
        steps = routineSteps;
        isLoading = false;
      });
    } catch (e) {
      print("ERROR ❌ $e");

      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> completeStep() async {
    final step = steps[currentIndex];

    try {
      await ApiService.completeTask(step.id);

      if (currentIndex < steps.length - 1) {
        setState(() {
          currentIndex++;
        });

        await saveProgress();
      } else {
        await clearProgress();

        if (mounted) {
          Navigator.pop(context);
        }
      }
    } catch (e) {
      print("COMPLETE ERROR ❌ $e");
    }
  }

  Future<void> skipStep() async {
    final step = steps[currentIndex];

    try {
      await ApiService.skipTask(step.id);

      if (currentIndex < steps.length - 1) {
        setState(() {
          currentIndex++;
        });

        await saveProgress();
      } else {
        await clearProgress();

        if (mounted) {
          Navigator.pop(context);
        }
      }
    } catch (e) {
      print("SKIP ERROR ❌ $e");
    }
  }

  Future<void> deleteCurrentTask() async {
    final step = steps[currentIndex];

    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Delete Task"),
        content: Text(
          "Delete ${step.title}?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              "Delete",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      await ApiService.deleteTask(step.id);

      setState(() {
        steps.removeAt(currentIndex);

        if (currentIndex >= steps.length && currentIndex > 0) {
          currentIndex--;
        }
      });

      await saveProgress();

      if (steps.isEmpty) {
        await clearProgress();

        if (mounted) {
          Navigator.pop(context);
        }
      }
    } catch (e) {
      print("DELETE ERROR ❌ $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        backgroundColor: kBg,
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (steps.isEmpty) {
      return Scaffold(
        backgroundColor: kBg,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: const Center(
          child: Text(
            "No tasks available",
            style: TextStyle(
              fontSize: 22,
            ),
          ),
        ),
      );
    }

    final step = steps[currentIndex];

    return Scaffold(
      backgroundColor: kBg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "${currentIndex + 1} / ${steps.length}",
          style: const TextStyle(
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: LinearProgressIndicator(
                  value: (currentIndex + 1) / steps.length,
                  color: kPrimary,
                  minHeight: 12,
                ),
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 30),

                    // صورة أكبر للطفل
                    Container(
                      height: 260,
                      width: 260,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 12,
                            color: Colors.black12,
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Image.asset(
                          step.image,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        step.title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kPrimary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      onPressed: completeStep,
                      child: const Text(
                        "Done",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: kPrimary,
                        side: const BorderSide(
                          color: kPrimary,
                          width: 2,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      onPressed: skipStep,
                      child: const Text(
                        "Skip",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  TextButton.icon(
                    onPressed: deleteCurrentTask,
                    icon: const Icon(
                      Icons.delete_outline,
                      color: Colors.red,
                    ),
                    label: const Text(
                      "Delete Task",
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 16,
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    "You can leave and come back later.",
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}