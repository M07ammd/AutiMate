import 'package:flutter/material.dart';
import 'package:atuimate_app/models/routine_step.dart';
import 'package:atuimate_app/services/api_service.dart';

const Color kBackground = Color(0xFFF7F1E8);
const Color kPrimary = Color(0xff49B388);

class ParentReportScreen extends StatefulWidget {
  const ParentReportScreen({super.key});

  @override
  State<ParentReportScreen> createState() => _ParentReportScreenState();
}

class _ParentReportScreenState extends State<ParentReportScreen> {
  List<RoutineStep> steps = [];
  double progress = 0.0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadReport();
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loadReport();
  }
  Future<void> loadReport() async {
    try {
      setState(() => isLoading = true);
      final routineData = await ApiService.getTodayRoutine();
      final progressData = await ApiService.getRoutineProgress();

      print("REPORT DATA 👉 $routineData");
      setState(() {
        steps = routineData.map((e) => RoutineStep.fromJson(e)).toList();
        progress = progressData;
        isLoading = false;
      });
    } catch (e) {
      print("REPORT ERROR ❌ $e");

      setState(() {
        isLoading = false;
      });
    }
  }
  String getStatusText(String status) {
    if (status == "COMPLETED") return "Completed";
    if (status == "SKIPPED") return "Skipped";
    return "Pending";
  }

  Color getStatusColor(String status) {
    if (status == "COMPLETED") return Colors.green;
    if (status == "SKIPPED") return Colors.red;
    return Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,

      appBar: AppBar(
        toolbarHeight: 110,
        title: const Text("Child Report"),
        centerTitle: true,
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Text(
                  "Progress",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                LinearProgressIndicator(
                  value: progress,
                  minHeight: 10,
                  color: kPrimary,
                ),
                const SizedBox(height: 8),
                Text("${(progress * 100).toInt()}%"),
              ],
            ),
          ),

          Expanded(
            child: steps.isEmpty
                ? const Center(child: Text("No tasks yet"))
                : ListView.builder(
              itemCount: steps.length,
              itemBuilder: (context, index) {
                final step = steps[index];

                return Container(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    children: [
                      /// 🖼 صورة
                      Image.asset(
                        step.image,
                        height: 50,
                        width: 50,
                        fit: BoxFit.contain,
                      ),

                      const SizedBox(width: 12),


                      Expanded(
                        child: Text(
                          step.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: getStatusColor(step.status)
                              .withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          getStatusText(step.status),
                          style: TextStyle(
                            color: getStatusColor(step.status),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}