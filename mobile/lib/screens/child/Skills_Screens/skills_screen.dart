import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:atuimate_app/screens/child/Skills_Screens/Memory Game/views/game_screen.dart';
import 'package:atuimate_app/screens/child/Skills_Screens/Math/game_screen.dart';
import 'package:atuimate_app/screens/child/Skills_Screens/Story game/Screens/intro_screen.dart';
import 'package:atuimate_app/screens/child/Skills_Screens/Story game/data.dart';
import 'package:atuimate_app/widgets/ai_tracking_wrapper.dart';
import 'package:atuimate_app/screens/child/child_home_screen.dart';
import 'dart:math';

class SkillsScreen extends StatelessWidget {
  const SkillsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF0FDFA),

      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,

        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Color(0xff0F172A),
          ),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const ChildHomeScreen(),
              ),
            );
          },
        ),

        title: const Padding(
          padding: EdgeInsets.only(top: 8),
          child: Text(
            "Skills",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0E2A47),
            ),
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _headerCard(),
            const SizedBox(height: 24),

            Expanded(
              child: ListView(
                children: [
                  _gameCard(
                    title: "Story Game",
                    subtitle: "Collect the pieces and complete the picture",
                    color: const Color(0xffFDE68A),
                    animation: "assets/animations/Puzzle.json",
                    onTap: () {
                      final randomStory =
                      stories[Random().nextInt(stories.length)];

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AITrackingWrapper(
                            gameName: "Story Game",
                            child: IntroScreen(
                              story: randomStory,
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  _gameCard(
                    title: "Memory Game",
                    subtitle: "Test your memory and choose the similar ones",
                    color: const Color(0xffBFDBFE),
                    animation: "assets/animations/memory.json",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AITrackingWrapper(
                            gameName: "Memory Game",
                            child: MyFlipCardGame(),
                          ),
                        ),
                      );
                    },
                  ),

                  _gameCard(
                    title: "Math & Learn",
                    subtitle: "Listen carefully and choose the correct picture",
                    color: const Color(0xffBBF7D0),
                    animation: "assets/animations/Cute Tiger.json",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AITrackingWrapper(
                            gameName: "Math & Learn",
                            child: GameScreen(),
                          ),
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

  // ================= HEADER =================
  Widget _headerCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
      decoration: BoxDecoration(
        color: const Color(0xffCFF3D2),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 100,
            child: Image.asset("assets/images/kid.png"),
          ),
          const SizedBox(height: 10),
          const Text(
            "Play & Learn",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          const Text("You can do it ⭐"),
        ],
      ),
    );
  }

  // ================= CARD =================
  Widget _gameCard({
    required String title,
    required String subtitle,
    required Color color,
    required String animation,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          children: [
            SizedBox(
              height: 80,
              width: 80,
              child: Lottie.asset(animation),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(subtitle),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}