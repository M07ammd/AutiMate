import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:atuimate_app/screens/child/Skills_Screens/Story game/data.dart';
import 'package:atuimate_app/models/story_model.dart';
import 'package:atuimate_app/services/api_service.dart';
import 'intro_screen.dart';
import 'package:atuimate_app/screens/child/Skills_Screens/skills_screen.dart';
class GameScreen extends StatefulWidget {
  final StoryModel story;

  const GameScreen({super.key, required this.story});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late List<String> correctOrder;
  late List<String> currentList;

  int score = 0;
  int moves = 0;
  int timeSpent = 0;

  Timer? timer;

  @override
  void initState() {
    super.initState();

    correctOrder = List.from(widget.story.images);
    currentList = List.from(correctOrder)..shuffle();

    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      timeSpent++;
    });
  }

  StoryModel getRandomStory() {
    final random = Random();

    StoryModel newStory;

    do {
      newStory = stories[random.nextInt(stories.length)];
    } while (newStory.title == widget.story.title);

    return newStory;
  }

  void checkResult() {
    bool isCorrect = true;

    for (int i = 0; i < correctOrder.length; i++) {
      if (correctOrder[i] != currentList[i]) {
        isCorrect = false;
        break;
      }
    }

    showResultDialog(isCorrect);
  }

  Future<void> sendResultToAPI() async {
    try {
      await ApiService.saveGameScore(
        gameType: "TIME",
        score: score,
        moves: moves,
        timeSpent: timeSpent,
        completed: true,
      );

      print("✅ Score sent successfully");
    } catch (e) {
      print("❌ Error sending score: $e");
    }
  }

  void showResultDialog(bool isCorrect) {
    if (isCorrect) score += 100;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.asset(
              isCorrect
                  ? "assets/animations/answer_true.json"
                  : "assets/animations/answer_false.json",
              height: 120,
            ),

            const SizedBox(height: 10),

            Text(
              isCorrect ? "Great Job!" : "Try Again",
              style: const TextStyle(fontSize: 22),
            ),

            const SizedBox(height: 20),

            if (isCorrect)
              Column(
                children: [
                  const Text("Continue to next story?"),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        onPressed: () async {
                          Navigator.pop(context);

                          timer?.cancel();
                          await sendResultToAPI();

                          final newStory = getRandomStory();

                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => IntroScreen(story: newStory),
                            ),
                          );
                        },
                        child: const Text("Yes"),
                      ),

                      TextButton(
                        onPressed: () async {
                          Navigator.pop(context);

                          timer?.cancel();
                          await sendResultToAPI();

                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const SkillsScreen(),
                            ),
                                (route) => false,
                          );
                        },
                        child: const Text("No"),
                      ),
                    ],
                  )
                ],
              )
            else
              ElevatedButton(
                onPressed: () async {
                  Navigator.pop(context);

                  timer?.cancel();
                  await sendResultToAPI();

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => IntroScreen(story: widget.story),
                    ),
                  );
                },
                child: const Text("Retry"),
              )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset("assets/images/bg2.png", fit: BoxFit.cover),
          ),

          Column(
            children: [
              const SizedBox(height: 100),

              Text("Score: $score"),

              Expanded(
                child: ReorderableListView(
                  onReorder: (oldIndex, newIndex) {
                    setState(() {
                      moves++;

                      if (newIndex > oldIndex) newIndex--;

                      final item = currentList.removeAt(oldIndex);
                      currentList.insert(newIndex, item);
                    });
                  },
                  children: List.generate(currentList.length, (index) {
                    return Container(
                      key: ValueKey(currentList[index]),
                      margin: const EdgeInsets.all(10),
                      height: 140,
                      child: Image.asset(
                        "assets/images/${currentList[index]}.png",
                        fit: BoxFit.cover,
                      ),
                    );
                  }),
                ),
              ),

              ElevatedButton(
                onPressed: checkResult,
                child: const Text("Check"),
              )
            ],
          )
        ],
      ),
    );
  }
}