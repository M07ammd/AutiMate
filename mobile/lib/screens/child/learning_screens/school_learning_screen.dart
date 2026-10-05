import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'people_learning_screen.dart';
import 'animals_learning_screen.dart';
import 'package:atuimate_app/screens/child/learning_screens/learning_screen.dart';


class SchoolLearningScreen extends StatelessWidget {
  const SchoolLearningScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffDFF5EF),
      body: SafeArea(
        child: Column(
          children: [
            // ================= HEADER =================
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

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: const [
                  Text(
                    "School",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff0F172A),
                    ),
                  ),
                  SizedBox(width: 6),
                  Icon(Icons.volume_up),
                  Spacer(),

                ],
              ),
            ),

            const SizedBox(height: 16),


            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.1,
                  children: const [
                    SchoolCard(
                      "Board",
                      "assets/images/board.png",
                      "assets/audio/Board.mp3",
                    ),
                    SchoolCard(
                      "Teacher",
                      "assets/images/Teacher.png",
                      "assets/audio/Teacher.mp3",
                    ),
                    SchoolCard(
                      "Pencil",
                      "assets/images/Pencil.png",
                      "assets/audio/Pencil.mp3",
                    ),
                    SchoolCard(
                      "Book",
                      "assets/images/Book.png",
                      "assets/audio/Book.mp3",
                    ),
                    SchoolCard(
                      "Classroom",
                      "assets/images/Classroom.png",
                      "assets/audio/Classroom.mp3",
                    ),
                    SchoolCard(
                      "Courtyard",
                      "assets/images/Courtyard.png",
                      "assets/audio/Courtyard.mp3",
                    ),
                    SchoolCard(
                      "Desk",
                      "assets/images/Desk.png",
                      "assets/audio/Desk.mp3",
                    ),
                    SchoolCard(
                      "Chair",
                      "assets/images/chair.png",
                      "assets/audio/Chair.mp3",
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _BottomPillButton(
                    text: "People",
                    emoji: "👨‍👩‍👧",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const PeopleLearningScreen(),
                        ),
                      );
                    },
                  ),
                  _BottomPillButton(
                    text: "Animals",
                    emoji: "🐄",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AnimalsLearningScreen(),
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
}

class SchoolCard extends StatefulWidget {
  final String title;
  final String image;
  final String sound;

  const SchoolCard(this.title, this.image, this.sound, {super.key});

  @override
  State<SchoolCard> createState() => _SchoolCardState();
}

class _SchoolCardState extends State<SchoolCard> {
  final AudioPlayer _player = AudioPlayer();
  double scale = 1;

  void _playSound() async {
    await _player.setAsset(widget.sound);
    _player.play();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => scale = 0.95),
      onTapUp: (_) => setState(() => scale = 1),
      onTapCancel: () => setState(() => scale = 1),
      onTap: _playSound,
      child: AnimatedScale(
        scale: scale,
        duration: const Duration(milliseconds: 150),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
          ),
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Image.asset(widget.image, fit: BoxFit.contain),
                ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: const BoxDecoration(
                  color: Color(0xffCFF3E6),
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(20),
                  ),
                ),
                child: Text(
                  widget.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Text(
          "$text $emoji",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xff0F172A),
          ),
        ),
      ),
    );
  }
}
