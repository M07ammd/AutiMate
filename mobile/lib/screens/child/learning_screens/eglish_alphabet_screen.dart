import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:atuimate_app/screens/child/learning_screens/learning_screen.dart';


class EnglishAlphabetScreen extends StatelessWidget {
  const EnglishAlphabetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFFF1D6),
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
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: const [
                  Row(
                    children: [
                      Text(
                        "English alpha",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff0F172A),
                        ),
                      ),
                      SizedBox(width: 6),
                      Icon(Icons.volume_up, size: 20),
                    ],
                  ),
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
                  crossAxisCount: 3,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.95,
                  children: const [
                    LetterBox("A", "Apple", "assets/audio/a.mp3"),
                    LetterBox("B", "Ball", "assets/audio/b1.mp3"),
                    LetterBox("C", "Carrot", "assets/audio/c.mp3"),
                    LetterBox("D", "Dog", "assets/audio/d.mp3"),
                    LetterBox("E", "Elephant", "assets/audio/e.mp3"),
                    LetterBox("F", "Fish", "assets/audio/f.mp3"),
                    LetterBox("G", "Grapes", "assets/audio/g.mp3"),
                    LetterBox("H", "Hat", "assets/audio/h.mp3"),
                    LetterBox("I", "Ice", "assets/audio/i.mp3"),
                    LetterBox("J", "Juice", "assets/audio/j.mp3"),
                    LetterBox("K", "Kite", "assets/audio/k.mp3"),
                    LetterBox("L", "Lion", "assets/audio/l.mp3"),
                    LetterBox("M", "Moon", "assets/audio/m.mp3"),
                    LetterBox("N", "Nap", "assets/audio/n.mp3"),
                    LetterBox("O", "Orange", "assets/audio/o.mp3"),
                    LetterBox("P", "Pen", "assets/audio/p.mp3"),
                    LetterBox("Q", "Queen", "assets/audio/q.mp3"),
                    LetterBox("R", "Rabbit", "assets/audio/r.mp3"),
                    LetterBox("S", "Sun", "assets/audio/s.mp3"),
                    LetterBox("T", "Tree", "assets/audio/t.mp3"),
                    LetterBox("U", "Umbrella", "assets/audio/u.mp3"),
                    LetterBox("V", "Vet", "assets/audio/v.mp3"),
                    LetterBox("W", "Water", "assets/audio/w.mp3"),
                    LetterBox("X", "Xylophone", "assets/audio/x.mp3"),
                    LetterBox("Y", "Yo-Yo", "assets/audio/y.mp3"),
                    LetterBox("Z", "Zebra", "assets/audio/z.mp3"),
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
                    text: "Arabic Alpha",
                    emoji: "🔤",
                    onTap: () {
                      // Navigate
                    },
                  ),
                  _BottomPillButton(
                    text: "Converse",
                    emoji: "💬",
                    onTap: () {
                      // Navigate
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

// ================= LETTER BOX =================
class LetterBox extends StatefulWidget {
  final String letter;
  final String word;
  final String sound;

  const LetterBox(this.letter, this.word, this.sound, {super.key});

  @override
  State<LetterBox> createState() => _LetterBoxState();
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
            color: Color(0xff0F172A),
          ),
        ),
      ),
    );
  }
}
class _LetterBoxState extends State<LetterBox> {
  final AudioPlayer _player = AudioPlayer();
  double scale = 1;

  void _playSound() async {
    await _player.setAsset(widget.sound);
    _player.play();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => scale = 0.93),
      onTapUp: (_) => setState(() => scale = 1),
      onTapCancel: () => setState(() => scale = 1),
      onTap: _playSound,
      child: AnimatedScale(
        scale: scale,
        duration: const Duration(milliseconds: 120),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xffFFF7E6),
            borderRadius: BorderRadius.circular(18),
            boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.letter,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xffF59E0B),
                ),
              ),
              const SizedBox(height: 6),
              Text(widget.word, style: const TextStyle(fontSize: 14)),
            ],
          ),
        ),
      ),
    );
  }

}
