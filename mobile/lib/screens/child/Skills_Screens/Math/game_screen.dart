import 'dart:math';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:atuimate_app/services/api_service.dart';
import 'package:atuimate_app/screens/child/Skills_Screens/Math/data.dart';
import 'package:atuimate_app/models/math.dart';
import 'package:atuimate_app/screens/child/Skills_Screens/Math/result_screen.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {

  final String gameTitle = "Math & Learn";

  final String gameTypeApi = "PUZZLE";

  final AudioPlayer player = AudioPlayer();
  final AudioPlayer effectPlayer = AudioPlayer();

  List<Animal> currentOptions = [];
  Animal? correctAnimal;

  Animal? selectedAnimal;
  Animal? shakingAnimal;

  bool showResult = false;
  String message = "";

  int score = 0;
  int questionCount = 0;
  int totalQuestions = 5;

  late DateTime startTime;

  @override
  void initState() {
    super.initState();
    startTime = DateTime.now();
    generateQuestion();
  }

  void generateQuestion() {
    allAnimals.shuffle();
    currentOptions = allAnimals.take(3).toList();
    correctAnimal = currentOptions[Random().nextInt(3)];

    selectedAnimal = null;
    shakingAnimal = null;
    showResult = false;
    message = "";

    playSound();
    setState(() {});
  }

  Future<void> playSound() async {
    if (correctAnimal != null) {
      await player.setAsset(correctAnimal!.sound);
      await player.play();
    }
  }

  void checkAnswer(Animal selected) async {
    setState(() {
      selectedAnimal = selected;
      showResult = true;
    });

    if (selected == correctAnimal) {
      score++;
      message = "Great job! 🎉";

      await effectPlayer.setAsset("assets/audio/correct.mp3");
      effectPlayer.play();
    } else {
      message = "Listen again and choose correctly";

      await effectPlayer.setAsset("assets/audio/wrong.mp3");
      effectPlayer.play();

      setState(() {
        shakingAnimal = selected;
      });

      Future.delayed(const Duration(milliseconds: 500), () {
        setState(() {
          shakingAnimal = null;
        });
      });

      playSound();

      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          selectedAnimal = null;
          showResult = false;
          message = "";
        });
      });

      return;
    }
  }

  @override
  void dispose() {
    player.dispose();
    effectPlayer.dispose();
    super.dispose();
  }

  Widget buildStars() {
    return Row(
      children: [
        const Icon(Icons.star, color: Colors.amber),
        const SizedBox(width: 5),
        Text(
          "$score",
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget buildAnimalCard(Animal animal) {
    bool isSelected = selectedAnimal == animal;
    bool isCorrect = animal == correctAnimal;

    Color borderColor = Colors.transparent;

    if (showResult && isSelected) {
      borderColor = isCorrect ? Colors.green : Colors.red;
    }

    return GestureDetector(
      onTap: () {
        if (!(showResult && selectedAnimal == correctAnimal)) {
          checkAnswer(animal);
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        transform: Matrix4.translationValues(
          shakingAnimal == animal
              ? (Random().nextDouble() * 10 - 5)
              : 0,
          0,
          0,
        ),
        width: 110,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: borderColor, width: 3),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 6)
          ],
        ),
        child: Column(
          children: [
            Image.asset(animal.image, height: 80),
            const SizedBox(height: 10),
            Text(animal.name),
          ],
        ),
      ),
    );
  }

  Future<void> sendScore() async {
    int timeSpent =
        DateTime.now().difference(startTime).inSeconds;

    final prefs = await SharedPreferences.getInstance();

    int total = prefs.getInt("daily_score") ?? 0;
    total += score;
    await prefs.setInt("daily_score", total);

    try {
      final response = await ApiService.saveGameScore(
        gameType: gameTypeApi,
        score: score,
        moves: questionCount,
        timeSpent: timeSpent,
        completed: true,
      );

      print("✅ SAVED 👉 ${response.data}");
      print("🔥 TOTAL TODAY 👉 $total");

    } catch (e) {
      print("❌ ERROR 👉 $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [

          Image.asset(
            "assets/images/bg .png",
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),

          SafeArea(
            child: Column(
              children: [

                Container(
                  margin: const EdgeInsets.all(20),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: const [
                      BoxShadow(color: Colors.black12, blurRadius: 8)
                    ],
                  ),
                  child: Column(
                    children: [

                      Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.home),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                          buildStars(),
                        ],
                      ),

                      const SizedBox(height: 10),

                      /// 🟣 اسم اللعبة
                      Text(
                        gameTitle,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),

                      const SizedBox(height: 10),

                      const Text(
                        "Listen carefully",
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold),
                      ),
                      const Text("and choose the correct picture"),

                      const SizedBox(height: 20),

                      GestureDetector(
                        onTap: playSound,
                        child: Image.asset(
                          "assets/images/volume-up.png",
                          width: 60,
                        ),
                      ),

                      const SizedBox(height: 15),

                      Text(
                        message.isEmpty
                            ? "Tap to play again"
                            : message,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: message.contains("Great")
                              ? Colors.green
                              : Colors.red,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children:
                  currentOptions.map((e) => buildAnimalCard(e)).toList(),
                ),

                const Spacer(),

                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: [

                      ElevatedButton.icon(
                        onPressed: playSound,
                        icon: const Icon(Icons.refresh),
                        label: const Text("Repeat"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff49B27D),
                          foregroundColor: Colors.white,
                        ),
                      ),

                      ElevatedButton.icon(
                        onPressed: (showResult &&
                            selectedAnimal == correctAnimal)
                            ? () async {

                          questionCount++;

                          if (questionCount == totalQuestions) {

                            await sendScore();

                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ResultScreen(
                                  score: score,
                                  timeSpent: DateTime.now()
                                      .difference(startTime)
                                      .inSeconds,
                                  gameTitle: gameTitle,
                                ),
                              ),
                            );

                          } else {
                            generateQuestion();
                          }
                        }
                            : null,
                        icon: const Icon(Icons.arrow_forward),
                        label: const Text("Next"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}