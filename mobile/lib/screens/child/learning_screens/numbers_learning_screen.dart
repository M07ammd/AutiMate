import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:atuimate_app/screens/child/learning_screens/learning_screen.dart';


class NumbersLearningScreen extends StatelessWidget {
  const NumbersLearningScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFCE7F3),
      body: SafeArea(
        child: Column(
          children: [
            // ================= HEADER =================
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
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                children: const [
                  Text(
                    "Numbers",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff0F172A),
                    ),
                  ),
                  SizedBox(width: 6),
                  Icon(Icons.volume_up),

                ],
              ),
            ),

            // ================= GRID =================
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1.80,
                  children: const [
                    NumberCard(
                      "ONE",
                      "assets/images/one.png",
                      "assets/audio/one.mp3",
                      Color(0xffFDE047),
                    ),
                    NumberCard(
                      "TWO",
                      "assets/images/two.png",
                      "assets/audio/two.mp3",
                      Color.fromARGB(255, 72, 233, 101),
                    ),
                    NumberCard(
                      "THREE",
                      "assets/images/three.png",
                      "assets/audio/three.mp3",
                      Color(0xffBAE6FD),
                    ),
                    NumberCard(
                      "FOUR",
                      "assets/images/four.png",
                      "assets/audio/four.mp3",
                      Color(0xffFED7AA),
                    ),
                    NumberCard(
                      "FIVE",
                      "assets/images/five.png",
                      "assets/audio/five.mp3",
                      Color(0xffE9D5FF),
                    ),
                    NumberCard(
                      "SIX",
                      "assets/images/six.png",
                      "assets/audio/six.mp3",
                      Color(0xffFECACA),
                    ),
                    NumberCard(
                      "SEVEN",
                      "assets/images/seven.png",
                      "assets/audio/seven.mp3",
                      Color(0xff99F6E4),
                    ),
                    NumberCard(
                      "EIGHT",
                      "assets/images/eight.png",
                      "assets/audio/eight.mp3",
                      Color(0xffDDD6FE),
                    ),
                    NumberCard(
                      "NINE",
                      "assets/images/nine.png",
                      "assets/audio/nine.mp3",
                      Color.fromARGB(102, 123, 157, 13),
                    ),
                    NumberCard(
                      "TEN",
                      "assets/images/ten.png",
                      "assets/audio/ten.mp3",
                      Color(0xffFBCFE8),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ================= BOTTOM =================
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _BottomPillButton(
                    text: "Colors",
                    emoji: "🎨",
                    onTap: () {},
                  ),
                  _BottomPillButton(
                    text: "Arabic Alpha",
                    emoji: "🔤",
                    onTap: () {},
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

// ================= NUMBER CARD =================
class NumberCard extends StatefulWidget {
  final String title;
  final String image;
  final String sound;
  final Color color;

  const NumberCard(this.title, this.image, this.sound, this.color, {super.key});

  @override
  State<NumberCard> createState() => _NumberCardState();
}

class _NumberCardState extends State<NumberCard> {
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
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: widget.color,
                borderRadius: BorderRadius.circular(22),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 6),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(22),
                child: Center(
                  child: Image.asset(
                    widget.image,
                    fit: BoxFit.contain,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    shape: BoxShape.circle,
                    boxShadow: const [
                      BoxShadow(color: Colors.black12, blurRadius: 4),
                    ],
                  ),
                  padding: const EdgeInsets.all(4),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ================= BOTTOM PILL =================
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
