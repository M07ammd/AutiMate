/*import 'package:flutter/material.dart';
import 'package:atuimate_app/models/routine_step.dart';
import 'package:atuimate_app/services/api_service.dart';
import 'routine_focus_screen.dart';
import 'package:atuimate_app/screens/child/child_home_screen.dart';

const Color kBackground = Color(0xFFF7F1E8);
const Color kPrimary = Color(0xff49B388);

class ChooseRoutineScreen extends StatefulWidget {
  const ChooseRoutineScreen({super.key});

  @override
  State<ChooseRoutineScreen> createState() => _ChooseRoutineScreenState();
}

class _ChooseRoutineScreenState extends State<ChooseRoutineScreen> {
  List<RoutineStep> allSteps = [];
  List<RoutineStep> selectedSteps = [];

  @override
  void initState() {
    super.initState();
    fetchCatalog();
  }

  Future<void> fetchCatalog() async {
    try {
      final data = await ApiService.getRoutineCatalog();
      print("CATALOG => $data");


      setState(() {
        allSteps =
            (data as List).map((e) => RoutineStep.fromJson(e)).toList();
      });
    } catch (e) {
      print("ERROR FETCH CATALOG ❌ $e");
    }
  }

  void toggleSelection(RoutineStep step) {
    setState(() {
      final exists = selectedSteps.any((e) => e.id == step.id);

      if (exists) {
        selectedSteps.removeWhere((e) => e.id == step.id);
      } else {
        selectedSteps.add(step);
      }
    });
  }

  Future<void> startRoutine() async {
    try {
      for (var step in selectedSteps) {
        await ApiService.addStepToRoutine(step.id);
      }

      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const RoutineFocusScreen()),
      );
    } catch (e) {
      print("START ROUTINE ERROR ❌ $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      //appBar: AppBar(title: const Text("Choose Routine")),
      appBar: AppBar(
        toolbarHeight: 80,

        backgroundColor: Colors.transparent,

        elevation: 0,
        centerTitle: true,

        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Color(0xff0F172A),
          ),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const ChildHomeScreen(),
              ),
            );
          },
        ),

        title: const Text(
          "Choose Routine",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0E2A47),
          ),
        ),
      ),

      body: allSteps.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: allSteps.length,
        gridDelegate:
        const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemBuilder: (context, index) {
          final step = allSteps[index];
          final isSelected =
          selectedSteps.any((e) => e.id == step.id);

          return GestureDetector(
            onTap: () => toggleSelection(step),
            child: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color:
                  isSelected ? kPrimary : Colors.transparent,
                  width: 3,
                ),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: _buildImage(step.image),
                  ),
                  Text(step.title),
                ],
              ),
            ),
          );
        },
      ),

      floatingActionButton: selectedSteps.isNotEmpty
          ? FloatingActionButton(
        onPressed: startRoutine,
        child: const Icon(Icons.play_arrow),
      )
          : null,
    );
  }
  Widget _buildImage(String path) {
    if (path.startsWith("http")) {
      return Image.network(path, fit: BoxFit.cover);
    } else {
      return Image.asset(path.replaceAll("file:///", ""));
    }
  }
}*/
import 'package:flutter/material.dart';
import 'package:atuimate_app/models/routine_step.dart';
import 'package:atuimate_app/services/api_service.dart';
import 'package:atuimate_app/screens/child/child_home_screen.dart';
import 'routine_focus_screen.dart';
import 'routine_order_screen.dart';

const Color kBackground = Color(0xFFF7F1E8);
const Color kPrimary = Color(0xff49B388);

class ChooseRoutineScreen extends StatefulWidget {
  const ChooseRoutineScreen({super.key});

  @override
  State<ChooseRoutineScreen> createState() => _ChooseRoutineScreenState();
}

class _ChooseRoutineScreenState extends State<ChooseRoutineScreen> {
  List<RoutineStep> allSteps = [];
  List<RoutineStep> selectedSteps = [];

  bool hasPendingRoutine = false;
  bool isCheckingRoutine = true;

  @override
  void initState() {
    super.initState();
    fetchCatalog();
    checkPendingRoutine();
  }

  Future<void> fetchCatalog() async {
    try {
      final data = await ApiService.getRoutineCatalog();

      setState(() {
        allSteps =
            (data as List).map((e) => RoutineStep.fromJson(e)).toList();
      });
    } catch (e) {
      print("ERROR FETCH CATALOG ❌ $e");
    }
  }

  Future<void> checkPendingRoutine() async {
    try {
      final routine = await ApiService.getTodayRoutine();

      hasPendingRoutine = routine.any(
            (task) => task["status"] == "PENDING",
      );
    } catch (e) {
      print("CHECK ROUTINE ERROR ❌ $e");
    }

    if (mounted) {
      setState(() {
        isCheckingRoutine = false;
      });
    }
  }

  void toggleSelection(RoutineStep step) {
    setState(() {
      final exists = selectedSteps.any((e) => e.id == step.id);

      if (exists) {
        selectedSteps.removeWhere((e) => e.id == step.id);
      } else {
        selectedSteps.add(step);
      }
    });
  }

  Future<void> startRoutine() async {
    try {
      for (var step in selectedSteps) {
        await ApiService.addStepToRoutine(step.id);
      }

      setState(() {
        hasPendingRoutine = true;
      });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const RoutineFocusScreen(),
        ),
      ).then((_) {
        checkPendingRoutine();
      });
    } catch (e) {
      print("START ROUTINE ERROR ❌ $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isCheckingRoutine) {
      return const Scaffold(
        backgroundColor: kBackground,
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: kBackground,

      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,

        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Color(0xff0F172A),
          ),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => const ChildHomeScreen(),
              ),
            );
          },
        ),

        title: const Text(
          "Choose Routine",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0E2A47),
          ),
        ),
      ),

      body: hasPendingRoutine
          ? Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.play_circle_fill,
                size: 120,
                color: kPrimary,
              ),

              const SizedBox(height: 20),

              const Text(
                "You have an unfinished routine",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                "Continue where you stopped",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimary,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                        const RoutineFocusScreen(),
                      ),
                    ).then((_) {
                      checkPendingRoutine();
                    });
                  },
                  icon: const Icon(Icons.play_arrow),
                  label: const Text(
                    "Continue Routine",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      )
          : allSteps.isEmpty
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : GridView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: allSteps.length,
        gridDelegate:
        const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemBuilder: (context, index) {
          final step = allSteps[index];

          final isSelected =
          selectedSteps.any((e) => e.id == step.id);

          return GestureDetector(
            onTap: () => toggleSelection(step),
            child: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? kPrimary
                      : Colors.transparent,
                  width: 3,
                ),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: _buildImage(step.image),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 4,
                    ),
                    child: Text(
                      step.title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton:
      !hasPendingRoutine && selectedSteps.isNotEmpty
          ? FloatingActionButton.extended(
        backgroundColor: kPrimary,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => RoutineOrderScreen(
                selectedSteps: selectedSteps,
              ),
            ),
          );
        },
        icon: const Icon(Icons.arrow_forward),
        label: const Text("Next"),
      )
          : null,
    );
  }

  Widget _buildImage(String path) {
    if (path.startsWith("http")) {
      return Image.network(
        path,
        fit: BoxFit.cover,
      );
    } else {
      return Image.asset(
        path.replaceAll("file:///", ""),
        fit: BoxFit.contain,
      );
    }
  }
}