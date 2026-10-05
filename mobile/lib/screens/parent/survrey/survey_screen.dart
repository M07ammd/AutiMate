import 'package:flutter/material.dart';
import 'package:atuimate_app/services/api_service.dart';
import 'result_screen.dart';

class SurveyScreen extends StatefulWidget {
  const SurveyScreen({super.key});

  @override
  State<SurveyScreen> createState() => _SurveyScreenState();
}

class _SurveyScreenState extends State<SurveyScreen> {
  int currentIndex = 0;
  bool isLoading = true;

  List<SurveyQuestion> questions = [];

  @override
  void initState() {
    super.initState();
    loadQuestions();
  }

  Future<void> loadQuestions() async {
    final data = await ApiService.getSurveyQuestions();

    setState(() {
      questions = data
          .map((q) => SurveyQuestion(
        id: q["id"],
        question: q["text"],
        type: "bool",
      ))
          .toList();

      questions.addAll([
        SurveyQuestion(id: "age", question: "Child age?", type: "choice"),
        SurveyQuestion(id: "gender", question: "Child gender?", type: "choice"),
        SurveyQuestion(id: "ethnicity", question: "Ethnicity?", type: "choice"),
        SurveyQuestion(id: "jaundice", question: "Jaundice?", type: "bool"),
        SurveyQuestion(
            id: "autism",
            question: "Family autism history?",
            type: "bool"),
        SurveyQuestion(
            id: "Country_of_res", question: "Country?", type: "choice"),
        SurveyQuestion(
            id: "used_app_before",
            question: "Used app before?",
            type: "bool"),
        SurveyQuestion(
            id: "relation",
            question: "Relation to child?",
            type: "choice"),
      ]);

      isLoading = false;
    });
  }

  void nextQuestion() {
    final q = questions[currentIndex];

    if (q.answer == null || q.answer.toString().isEmpty) return;

    if (currentIndex < questions.length - 1) {
      setState(() => currentIndex++);
    } else {
      submitSurvey();
    }
  }


  Future<void> submitSurvey() async {
    try {
      Map<String, dynamic> answers = {};

      for (var q in questions) {
        if (q.type == "bool") {
          answers[q.id] = q.answer == true ? 1 : 0;
        } else {
          answers[q.id] = q.answer;
        }
      }

      answers["jaundice"] = answers["jaundice"] == 1 ? "yes" : "no";
      answers["autism"] = answers["autism"] == 1 ? "yes" : "no";
      answers["used_app_before"] =
      answers["used_app_before"] == 1 ? "yes" : "no";

      final childId = await ApiService.getChildId();

      print("========== SURVEY ==========");
      print("CHILD ID => $childId");
      print("ANSWERS => $answers");

      final res = await ApiService.submitSurvey(
        childId: childId,
        answers: answers,
      );

      print("SURVEY RESPONSE => $res");

      if (!mounted) return;

      if (res["assessment"] == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Assessment not found in response"),
          ),
        );
        return;
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ResultScreen(
            assessment: Map<String, dynamic>.from(
              res["assessment"],
            ),
          ),
        ),
      );
    } catch (e) {
      print("SUBMIT ERROR => $e");

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: $e"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final q = questions[currentIndex];

    return Scaffold(
      backgroundColor: const Color(0xffF4F6F6),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 10),

              const Text(
                "Quick survey",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF45BB89),
                ),
              ),

              const Text(
                "Answer these questions easily ✨",
                style: TextStyle(color: Color(0xFF45BB89)),
              ),

              const SizedBox(height: 20),

              AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                height: 160,
                child: Image.asset("assets/images/survey.png"),
              ),

              const SizedBox(height: 20),

              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Container(
                  key: ValueKey(currentIndex),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF45BB89).withOpacity(.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "${currentIndex + 1}) ${q.question}",
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              buildAnswer(q),

              const Spacer(),

              Align(
                alignment: Alignment.bottomRight,
                child: FloatingActionButton(
                  backgroundColor: const Color(0xFF45BB89),
                  onPressed: nextQuestion,
                  child: const Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildAnswer(SurveyQuestion q) {
    /// YES / NO
    if (q.type == "bool") {
      return Row(
        children: [
          Expanded(child: answerButton("Yes", true, q.answer == true)),
          const SizedBox(width: 15),
          Expanded(child: answerButton("No", false, q.answer == false)),
        ],
      );
    }

    /// AGE (➕➖)
    if (q.id == "age") {
      int value = q.answer ?? 1;

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFF45BB89)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "$value",
              style: const TextStyle(fontSize: 18),
            ),
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    if (value > 1) {
                      setState(() => q.answer = value - 1);
                    }
                  },
                  icon: const Icon(Icons.remove),
                ),
                IconButton(
                  onPressed: () {
                    setState(() => q.answer = value + 1);
                  },
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
          ],
        ),
      );
    }

    /// CHOICES
    if (q.type == "choice") {
      List<String> options = [];

      if (q.id == "gender") {
        options = ["m", "f"];
      } else if (q.id == "ethnicity") {
        options = [
          "White-European",
          "Middle Eastern",
          "Asian",
          "Black",
          "Other"
        ];
      } else if (q.id == "Country_of_res") {
        options = [
          "Egypt",
          "United States",
          "Saudi Arabia",
          "UAE",
          "Other"
        ];
      } else if (q.id == "relation") {
        options = [
          "Self",
          "Parent",
          "Relative",
          "Doctor",
          "Other"
        ];
      }

      return DropdownButtonFormField<String>(
        value: q.answer,
        items: options
            .map((e) => DropdownMenuItem(
          value: e,
          child: Text(
            e == "m"
                ? "Male"
                : e == "f"
                ? "Female"
                : e,
          ),
        ))
            .toList(),
        onChanged: (v) => setState(() => q.answer = v),
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
        ),
      );
    }

    return const SizedBox();
  }

  Widget answerButton(String text, bool value, bool selected) {
    return GestureDetector(
      onTap: () => setState(() => questions[currentIndex].answer = value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF45BB89) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFF45BB89)),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: selected ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class SurveyQuestion {
  final String id;
  final String question;
  final String type;

  dynamic answer;

  SurveyQuestion({
    required this.id,
    required this.question,
    required this.type,
    this.answer,
  });
}
