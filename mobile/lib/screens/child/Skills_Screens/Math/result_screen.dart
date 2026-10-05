import 'package:flutter/material.dart';
import 'game_screen.dart';

class ResultScreen extends StatelessWidget {
  final int score;
  final int timeSpent;
  final String gameTitle;

  const ResultScreen({
    super.key,
    required this.score,
    required this.timeSpent,
    required this.gameTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xffB2F7EF), Color(0xff7BDFF2)],
          ),
        ),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                const Icon(Icons.emoji_events,
                    size: 80, color: Colors.amber),

                const SizedBox(height: 20),

                Text(
                  gameTitle,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),

                const SizedBox(height: 10),

                const Text("Great Job 🎉"),

                const SizedBox(height: 10),

                Text("Score: $score",
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),

                const SizedBox(height: 10),

                Text("Time: $timeSpent sec"),

                const SizedBox(height: 25),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [

                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const GameScreen(),
                          ),
                        );
                      },
                      child: const Text("Play Again"),
                    ),

                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Home"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}