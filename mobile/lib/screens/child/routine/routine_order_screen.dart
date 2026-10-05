import 'package:flutter/material.dart';
import 'package:atuimate_app/models/routine_step.dart';
import 'package:atuimate_app/services/api_service.dart';
import 'routine_focus_screen.dart';

const Color kPrimary = Color(0xff49B388);
const Color kBackground = Color(0xFFF7F1E8);

class RoutineOrderScreen extends StatefulWidget {
  final List<RoutineStep> selectedSteps;

  const RoutineOrderScreen({
    super.key,
    required this.selectedSteps,
  });

  @override
  State<RoutineOrderScreen> createState() =>
      _RoutineOrderScreenState();
}

class _RoutineOrderScreenState
    extends State<RoutineOrderScreen> {
  late List<RoutineStep> orderedSteps;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    orderedSteps = List.from(widget.selectedSteps);
  }

  Future<void> startRoutine() async {
    setState(() {
      loading = true;
    });

    try {
      for (final step in orderedSteps) {
        await ApiService.addStepToRoutine(step.id);
      }

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const RoutineFocusScreen(),
          ),
        );
      }
    } catch (e) {
      print("ORDER ERROR ❌ $e");
    }

    if (mounted) {
      setState(() {
        loading = false;
      });
    }
  }

  Widget buildImage(String path) {
    if (path.startsWith("http")) {
      return Image.network(
        path,
        fit: BoxFit.contain,
      );
    }

    return Image.asset(
      path.replaceAll("file:///", ""),
      fit: BoxFit.contain,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Arrange Routine",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),

          const Text(
            "Drag the pictures to arrange your routine",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 15),

          Expanded(
            child: ReorderableListView.builder(
              itemCount: orderedSteps.length,
              onReorder: (oldIndex, newIndex) {
                setState(() {
                  if (newIndex > oldIndex) {
                    newIndex--;
                  }

                  final item =
                  orderedSteps.removeAt(oldIndex);

                  orderedSteps.insert(
                    newIndex,
                    item,
                  );
                });
              },
              itemBuilder: (context, index) {
                final step = orderedSteps[index];

                return Card(
                  key: ValueKey("${step.id}-$index"),
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(20),
                  ),
                  child: Container(
                    height: 120,
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 22,
                          backgroundColor: kPrimary,
                          child: Text(
                            "${index + 1}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        const SizedBox(width: 20),

                        Expanded(
                          child: buildImage(step.image),
                        ),

                        const SizedBox(width: 10),

                        const Icon(
                          Icons.drag_handle,
                          size: 32,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(16),
                  ),
                ),
                onPressed:
                loading ? null : startRoutine,
                icon: loading
                    ? const SizedBox(
                  width: 20,
                  height: 20,
                  child:
                  CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
                    : const Icon(
                  Icons.play_arrow,
                ),
                label: const Text(
                  "Start Routine",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
