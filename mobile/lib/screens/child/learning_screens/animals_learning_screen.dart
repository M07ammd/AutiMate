import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:atuimate_app/screens/child/learning_screens/learning_screen.dart';
import 'package:atuimate_app/screens/child/learning_screens/school_learning_screen.dart';
import 'package:atuimate_app/screens/child/learning_screens/colors _screen.dart';

class AnimalsLearningScreen extends StatelessWidget {
  const AnimalsLearningScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffEAF7FB),
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
            // ================= TITLE =================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: const [
                  Text(
                    "Animals",
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

            // ================= GRID =================
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
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.9,
                  children: const [
                    AnimalCard("Dog", "assets/images/dog.png", "assets/audio/dog.mp3"),
                    AnimalCard("Cat", "assets/images/cat.png", "assets/audio/cat.mp3"),
                    AnimalCard("Rabbit", "assets/images/rabbit.png", "assets/audio/rabbit.mp3"),
                    AnimalCard("Bird", "assets/images/bird.png", "assets/audio/bird.mp3"),
                    AnimalCard("Turtle", "assets/images/turtle.png", "assets/audio/turtle.mp3"),
                    AnimalCard("Mouse", "assets/images/mouse.png", "assets/audio/mouse.mp3"),
                    AnimalCard("Sheep", "assets/images/Sheep.png", "assets/audio/sheep.mp3"),
                    AnimalCard("Horse", "assets/images/horse.png", "assets/audio/horse.mp3"),
                    AnimalCard("Cow", "assets/images/cow.png", "assets/audio/cow.mp3"),
                    AnimalCard("Lion", "assets/images/lion.png", "assets/audio/lion.mp3"),
                    AnimalCard("Elephant", "assets/images/elephant.png", "assets/audio/elephant.mp3"),
                    AnimalCard("Monkey", "assets/images/monkey.png", "assets/audio/monkey.mp3"),
                    AnimalCard("Duck", "assets/images/duck.png", "assets/audio/duck.mp3"),
                    AnimalCard("Chicken", "assets/images/chicken.png", "assets/audio/chicken.mp3"),
                    AnimalCard("Fish", "assets/images/fish.png", "assets/audio/fish.mp3"),
                    AnimalCard("Goat", "assets/images/goat.png", "assets/audio/goat.mp3"),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ================= BOTTOM BUTTONS =================
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _BottomPillButton(
                    text: "School",
                    emoji: "🏫",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const SchoolLearningScreen(),
                        ),
                      );
                    },
                  ),
                  _BottomPillButton(
                    text: "Colors",
                    emoji: "🎨",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ColorsScreen(),
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

// ================= BOTTOM BUTTON =================
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
        padding: const EdgeInsets.symmetric(
          horizontal: 22,
          vertical: 12,
        ),
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
// ================= ANIMAL CARD =================
class AnimalCard extends StatefulWidget {
  final String title;
  final String image;
  final String sound;

  const AnimalCard(this.title, this.image, this.sound, {super.key});

  @override
  State<AnimalCard> createState() => _AnimalCardState();
}

class _AnimalCardState extends State<AnimalCard> {
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
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xffEAF7FB),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Image.asset(
                    widget.image,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  widget.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xff0F172A),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
