import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class EmotionsScreen extends StatefulWidget {
  const EmotionsScreen({super.key});

  @override
  State<EmotionsScreen> createState() => _EmotionsScreenState();
}

class _EmotionsScreenState extends State<EmotionsScreen> {
  final player = AudioPlayer();
  int selectedIndex = -1;

  final emotions = [
    {
      "name": "Happy",
      "image": "assets/images/Happy.png",
      "audio": "assets/audio/happy.mp3",
      "sentence": "I love seeing you happy 😊",
    },
    {
      "name": "Sad",
      "image": "assets/images/Sads.png",
      "audio": "assets/audio/sad.mp3",
      "sentence": "It's okay to feel sad 💙",
    },
    {
      "name": "Angry",
      "image": "assets/images/Angry.png",
      "audio": "assets/audio/angry.mp3",
      "sentence": "Take a deep breath ❤️",
    },
    {
      "name": "Scared",
      "image": "assets/images/Scared.png",
      "audio": "assets/audio/scared.mp3",
      "sentence": "You are safe 🤍",
    },
    {
      "name": "Tired",
      "image": "assets/images/Tired.png",
      "audio": "assets/audio/tired.mp3",
      "sentence": "Time to rest 🌙",
    },
    {
      "name": "Worried",
      "image": "assets/images/Worried.png",
      "audio": "assets/audio/worried.mp3",
      "sentence": "Everything will be okay ",
    },
  ];

  Future playSound(String path) async {
    await player.setAsset(path);
    player.play();
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F6F8),

      body: Column(
        children: [
          // ================= HEADER =================
          Container(
            height: 130,
            padding: const EdgeInsets.only(top: 45, left: 10, right: 20),
            decoration: const BoxDecoration(
              color: Color(0xff49B388),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    /// ✅ زرار الرجوع الصح
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        if (Navigator.canPop(context)) {
                          Navigator.pop(context);
                        }
                      },
                    ),
                    const Expanded(
                      child: Center(
                        child: Text(
                          "Emotions",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 40),
                  ],
                ),
                const SizedBox(height: 6),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Learn & Listen",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.volume_up, color: Colors.white),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // ================= LEARN GRID =================
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
              ),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: emotions.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                ),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () async {
                      await playSound(emotions[index]["audio"] as String);
                    },
                    child: Column(
                      children: [
                        Expanded(
                          child: Image.asset(
                            emotions[index]["image"] as String,
                          ),
                        ),
                        Text(
                          emotions[index]["name"] as String,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),

          const SizedBox(height: 20),

          // ================= SELECT =================
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "How are you feeling right now?",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 10),

                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: List.generate(6, (index) {
                      bool selected = selectedIndex == index;

                      return SizedBox(
                        width: 90,
                        child: GestureDetector(
                          onTap: () async {
                            setState(() {
                              selectedIndex = index;
                            });
                            await playSound(
                                emotions[index]["audio"] as String);
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: selected
                                  ? const Color(0xffD6F0E5)
                                  : const Color(0xffF3F3F3),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              children: [
                                Image.asset(
                                  emotions[index]["image"] as String,
                                  height: 55,
                                ),
                                const SizedBox(height: 5),
                                Text(emotions[index]["name"] as String),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // ================= SENTENCE =================
          if (selectedIndex != -1)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 350),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xffD6F0E5),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Text(
                  emotions[selectedIndex]["sentence"] as String,
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
