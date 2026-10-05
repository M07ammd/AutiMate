import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:atuimate_app/screens/child/Skills_Screens/Memory Game/views/game_screen.dart';
import 'package:atuimate_app/screens/child/Skills_Screens/skills_screen.dart';
import 'leaderboard_screen.dart';

class GameOverScreen extends StatefulWidget {
  final int duration;
  final int score;
  final int moves;

  const GameOverScreen({
    super.key,
    required this.duration,
    required this.score,
    required this.moves,
  });

  @override
  State<GameOverScreen> createState() => _GameOverScreenState();
}

class _GameOverScreenState extends State<GameOverScreen> {
  final _confettiController =
  ConfettiController(duration: const Duration(seconds: 5));

  @override
  void initState() {
    super.initState();
    _confettiController.play();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: const Color(0xffF7F9FF),
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          Center(
            child: Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 20,
                    color: Colors.black12,
                  )
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "🎉 Well Done!",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 15),

                  Text(
                    "⏱ Time: ${widget.duration}s",
                    style: theme.bodyLarge,
                  ),

                  const SizedBox(height: 10),

                  Text(
                    "🎯 Moves: ${widget.moves}",
                    style: theme.bodyLarge,
                  ),

                  const SizedBox(height: 10),

                  Text(
                    "⭐ Score: ${widget.score}",
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),

                  const SizedBox(height: 20),

                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const MyFlipCardGame(),
                        ),
                      );
                    },
                    child: const Text("🔁 Play Again"),
                  ),

                  const SizedBox(height: 10),

                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const LeaderboardScreen(),
                        ),
                      );
                    },
                    child: const Text("🏆 Leaderboard"),
                  ),

                  const SizedBox(height: 10),

                  TextButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const SkillsScreen(),
                        ),
                            (route) => false,
                      );
                    },
                    child: const Text("🏠 Back to Games"),
                  ),
                ],
              ),
            ),
          ),

          ConfettiWidget(
            confettiController: _confettiController,
            blastDirectionality: BlastDirectionality.explosive,
            numberOfParticles: 25,
            gravity: 0.1,
          ),
        ],
      ),
    );
  }
}
