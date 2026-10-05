import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:atuimate_app/screens/child/learning_screens/learning_screen.dart';
import 'package:atuimate_app/screens/child/learning_screens/eglish_alphabet_screen.dart';
import 'package:atuimate_app/screens/child/learning_screens/numbers_learning_screen.dart';

class ArabicAlphabetScreen extends StatelessWidget {
  const ArabicAlphabetScreen({super.key});

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
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Text(
                    "Arabic alphabet",
                    style: TextStyle(
                      fontSize: 20,
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
                  crossAxisCount: 3,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1,
                  children: const [
                    ImageCard("assets/images/alef.png","assets/audio/alef.mp3"),
                    ImageCard("assets/images/baa.png","assets/audio/baa.mp3"),
                    ImageCard("assets/images/taa.png","assets/audio/taa.mp3"),
                    ImageCard("assets/images/thaa.png","assets/audio/thaa.mp3"),
                    ImageCard("assets/images/jeem.png","assets/audio/jeem.mp3"),
                    ImageCard("assets/images/haa.png","assets/audio/haa.mp3"),
                    ImageCard("assets/images/khaa.png","assets/audio/khaa.mp3"),
                    ImageCard("assets/images/dal.png","assets/audio/dal.mp3"),
                    ImageCard("assets/images/thal.png","assets/audio/thal.mp3"),
                    ImageCard("assets/images/raa.png","assets/audio/raa.mp3"),
                    ImageCard("assets/images/zay.png","assets/audio/zay.mp3"),
                    ImageCard("assets/images/seen.png","assets/audio/seen.mp3"),
                    ImageCard("assets/images/sheen.png","assets/audio/sheen.mp3"),
                    ImageCard("assets/images/sad.png","assets/audio/ص.mp3"),
                    ImageCard("assets/images/dad.png","assets/audio/dad.mp3"),
                    ImageCard("assets/images/tah.png","assets/audio/tah.mp3"),
                    ImageCard("assets/images/zah.png","assets/audio/zah.mp3"),
                    ImageCard("assets/images/ain.png","assets/audio/ain.mp3"),
                    ImageCard("assets/images/ghain.png","assets/audio/ghain.mp3"),
                    ImageCard("assets/images/faa.png","assets/audio/faa.mp3"),
                    ImageCard("assets/images/qaf.png","assets/audio/qaf.mp3"),
                    ImageCard("assets/images/kaf.png","assets/audio/kaf.mp3"),
                    ImageCard("assets/images/lam.png","assets/audio/lam.mp3"),
                    ImageCard("assets/images/meem.png","assets/audio/meem.mp3"),
                    ImageCard("assets/images/noon.png","assets/audio/noon.mp3"),
                    ImageCard("assets/images/haa2.png","assets/audio/haa2.mp3"),
                    ImageCard("assets/images/waw.png","assets/audio/waw.mp3"),
                    ImageCard("assets/images/Yaa.png","assets/audio/yaa.mp3"),
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
                  _BottomPillButton(
                    text: "English",
                    emoji: "🔤",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const EnglishAlphabetScreen(),
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

// ================= IMAGE CARD =================
class ImageCard extends StatefulWidget {
  final String image;
  final String sound;

  const ImageCard(this.image, this.sound, {super.key});

  @override
  State<ImageCard> createState() => _ImageCardState();
}

class _ImageCardState extends State<ImageCard> {
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
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Image.asset(
              widget.image,
              fit: BoxFit.contain,
            ),
          ),
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
            color: Color(0xff0F172A),
          ),
        ),
      ),
    );
  }
}