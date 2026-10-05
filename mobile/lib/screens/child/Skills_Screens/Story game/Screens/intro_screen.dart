import 'package:flutter/material.dart';
import 'package:atuimate_app/models/story_model.dart';
import 'game_screen.dart';

class IntroScreen extends StatelessWidget {
  final StoryModel story;

  const IntroScreen({super.key, required this.story});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [

          Positioned.fill(
            child: Image.asset("assets/images/bg2.png", fit: BoxFit.cover),
          ),

          Column(
            children: [

              const SizedBox(height: 100),

              const Text(
                "Look at the story",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 20),

              Row(
                children: story.images.map((img) {
                  return Expanded(
                    child: Container(
                      margin: const EdgeInsets.all(6),
                      height: 130,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset(
                          "assets/images/$img.png",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),

              const Spacer(),

              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => GameScreen(story: story),
                    ),
                  );
                },
                child: const Text("Start"),
              ),

              const SizedBox(height: 20),
            ],
          )
        ],
      ),
    );
  }
}