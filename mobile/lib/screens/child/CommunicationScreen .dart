import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class CommunicationScreen extends StatefulWidget {
  const CommunicationScreen({super.key});

  @override
  State<CommunicationScreen> createState() => _CommunicationScreenState();
}

class _CommunicationScreenState extends State<CommunicationScreen> {
  final AudioPlayer player = AudioPlayer();

  final List<Map<String, String>> needs = [
    {
      "title": "Hungry",
      "image": "assets/images/Hungry.png",
      "audio": "assets/audio/Hungry.mp3",
    },
    {
      "title": "Thirsty",
      "image": "assets/images/Thirsty.png",
      "audio": "assets/audio/thirsty.mp3",
    },
    {
      "title": "Shower",
      "image": "assets/images/Shower.png",
      "audio": "assets/audio/shower.mp3",
    },
    {
      "title": "Play",
      "image": "assets/routines/play.jpg",
      "audio": "assets/audio/Play.mp3",
    },
    {
      "title": "Study",
      "image": "assets/routines/study.jpg",
      "audio": "assets/audio/study.mp3",
    },
    {
      "title": "Sleep",
      "image": "assets/routines/sleep.jpg",
      "audio": "assets/audio/sleep.mp3",
    },
    {
      "title": "alone",
      "image": "assets/images/alone.jpg",
      "audio": "assets/audio/alone.mp3",
    },
    {
      "title": "draw",
      "image": "assets/images/draw.jpg",
      "audio": "assets/audio/draw.mp3",
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
      backgroundColor: const Color(0xFF45BB89),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 8,
                left: 10,
                right: 10,
                bottom: 16,
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'Communication',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 40),
                ],
              ),
            ),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "What do you need now?",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),

            const SizedBox(height: 16),

            Expanded(
              child: Container(
                padding: const EdgeInsets.only(top: 20),
                decoration: const BoxDecoration(
                  color: Color(0xffF2F2F2),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: GridView.builder(
                    itemCount: needs.length,
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 18,
                      crossAxisSpacing: 18,
                      childAspectRatio: 0.75,
                    ),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () async {
                          await playSound(
                            needs[index]["audio"]!,
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xffE6F6EF),
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 6,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Expanded(
                                flex: 5,
                                child: Image.asset(
                                  needs[index]["image"]!,
                                  fit: BoxFit.contain,
                                  width: double.infinity,
                                  errorBuilder:
                                      (context, error, stackTrace) {
                                    return const Icon(
                                      Icons.image_not_supported,
                                      size: 60,
                                      color: Colors.grey,
                                    );
                                  },
                                ),
                              ),

                              const SizedBox(height: 10),

                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                children: [
                                  Flexible(
                                    child: Text(
                                      needs[index]["title"]!,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight:
                                        FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  const Icon(
                                    Icons.volume_up,
                                    size: 22,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}