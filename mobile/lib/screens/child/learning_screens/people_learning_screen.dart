import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'school_learning_screen.dart';
import 'package:atuimate_app/screens/child/learning_screens/learning_screen.dart';


class PeopleLearningScreen extends StatelessWidget {
  const PeopleLearningScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xffFCE7F3),
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
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Row(
          children: const [
            Text(
              "People",
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
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.1,
                children: const [
                  PeopleCard(
                    title: "Mother",
                    image: "assets/images/mother.png",
                    sound: "assets/audio/mother.mp3",
                  ),
                  PeopleCard(
                    title: "Father",
                    image: "assets/images/father.png",
                    sound: "assets/audio/father.mp3",
                  ),
                  PeopleCard(
                    title: "Sister",
                    image: "assets/images/sister.png",
                    sound: "assets/audio/sister.mp3",
                  ),
                  PeopleCard(
                    title: "Brother",
                    image: "assets/images/brother.png",
                    sound: "assets/audio/brother.mp3",
                  ),
                  PeopleCard(
                    title: "Family",
                    image: "assets/images/people.png",
                    sound: "assets/audio/family.mp3",
                  ),
                  PeopleCard(
                    title: "Grandparents",
                    image: "assets/images/grandparents.png",
                    sound: "assets/audio/grandparents.mp3",
                  ),
                  PeopleCard(
                    title: "Aunt",
                    image: "assets/images/aunt.png",
                    sound: "assets/audio/aunt.mp3",
                  ),
                  PeopleCard(
                    title: "Uncle",
                    image: "assets/images/uncle.png",
                    sound: "assets/audio/uncle.mp3",
                  ),
                ],
              ),
            ),
          ),

          // ================= BOTTOM BUTTON =================
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const SchoolLearningScreen(),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: const Text(
                  "School 📚",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    )

    );
  }
}

// ================= CARD =================
class PeopleCard extends StatefulWidget {
  final String title;
  final String image;
  final String sound;

  const PeopleCard({
    super.key,
    required this.title,
    required this.image,
    required this.sound,
  });

  @override
  State<PeopleCard> createState() => _PeopleCardState();
}

class _PeopleCardState extends State<PeopleCard> {
  final AudioPlayer _player = AudioPlayer();

  void _playSound() async {
    await _player.setAsset(widget.sound);
    _player.play();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _playSound,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Image.asset(widget.image),
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: const BoxDecoration(
                color: Color(0xffE9D5FF),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(22),
                  bottomRight: Radius.circular(22),
                ),
              ),
              child: Text(
                widget.title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
