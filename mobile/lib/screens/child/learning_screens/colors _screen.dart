import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:atuimate_app/screens/child/learning_screens/animals_learning_screen.dart';
import 'package:atuimate_app/screens/child/learning_screens/numbers_learning_screen.dart';
import 'package:atuimate_app/screens/child/learning_screens/learning_screen.dart';

class ColorsScreen extends StatelessWidget {
  ColorsScreen({super.key});

  final AudioPlayer player = AudioPlayer();

  void playSound(String path) async {
    await player.setAsset(path);
    player.play();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffEEF0FF),
      body: SafeArea(
        child: Column(
          children: [
            /// ================= HEADER =================
            Padding(
              padding: EdgeInsets.fromLTRB(
                16,
                MediaQuery.of(context).padding.top + 10,
                16,
                16,
              ),
              child: Container(
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LearningScreen(),
                          ),
                        );
                      },
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Image.asset(
                          "assets/images/logo.png",
                          height: 26,
                        ),
                        const SizedBox(width: 6),
                        const Text(
                          "Autimate",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff49B388),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    const SizedBox(width: 40),
                  ],
                ),
              ),
            ),
            // ================= TITLE =================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  const Text(
                    "Colors",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff2B3A67),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.volume_up),
                    onPressed: () {
                      playSound("assets/sounds/colors.mp3");
                    },
                  ),
                  const Spacer(),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // ================= GRID =================
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 1.2,
                  children: [
                    colorItem("Black", Colors.black),
                    colorItem("White", Colors.white),
                    colorItem("Red", Colors.red),
                    colorItem("Blue", Colors.blue),
                    colorItem("Yellow", Colors.yellow),
                    colorItem("Green", Colors.green),
                    colorItem("Brown", Colors.brown),
                    colorItem("Pink", Colors.pink),
                    colorItem("Purple", Colors.purple),
                    colorItem("Orange", Colors.orange),
                  ],
                ),
              ),
            ),

            // ================= BOTTOM BUTTONS =================
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _BottomPillButton(
                    text: "Animals",
                    emoji: "🐶",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AnimalsLearningScreen(),
                        ),
                      );
                    },
                  ),
                  _BottomPillButton(
                    text: "Numbers",
                    emoji: "🔢",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const NumbersLearningScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget colorItem(String name, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xffD8D9FF),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite,
            color: name == "White" ? Colors.grey : color,
            size: 50,
          ),
          const SizedBox(height: 8),
          Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

// ================= BOTTOM BUTTON (FIXED) =================
class _BottomPillButton extends StatelessWidget {
  final String text;
  final String emoji;
  final VoidCallback onTap;

  const _BottomPillButton({
    required this.text,
    required this.emoji,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          "$text $emoji",
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}