import 'dart:async';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import '../model/data.dart';
import 'game_over_screen.dart';
import 'package:atuimate_app/services/api_service.dart';
class MyFlipCardGame extends StatefulWidget {
  const MyFlipCardGame({super.key});

  @override
  State<MyFlipCardGame> createState() => _MyFlipCardGameState();
}

class _MyFlipCardGameState extends State<MyFlipCardGame> {
  int currentLevel = 1;
  final int maxLevels = 4; // Levels: 1(4 cards), 2(6), 3(8), 4(12)

  int _previousIndex = -1;
  int _time = 3;
  int gameDuration = 0;
  int moves = 0;

  bool _flip = false;
  bool _start = false;
  bool _wait = false;
  bool _isFinished = false;

  Timer? _timer;
  Timer? _durationTimer;

  int _left = 0;
  List<String> _data = [];
  List<bool> _cardFlips = [];
  List<GlobalKey<FlipCardState>> _cardStateKeys = [];

  @override
  void initState() {
    super.initState();
    initializeGameData();
    startTimer();
    startDuration();
    startGameAfterDelay();
  }

  void initializeGameData() {
    int pairCount;
    if (currentLevel == 1) pairCount = 2; // 4 cards
    else if (currentLevel == 2) pairCount = 3; // 6 cards
    else if (currentLevel == 3) pairCount = 4; // 8 cards
    else pairCount = 6; // 12 cards

    int totalCards = pairCount * 2;
    _data = createShuffledListFromImageSource(pairCount);
    _cardFlips = getInitialItemStateList(totalCards);
    _cardStateKeys = createFlipCardStateKeysList(totalCards);
    _left = pairCount;
    _isFinished = false;
    _flip = false;
    _wait = false;
    _previousIndex = -1;
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_time == 0) {
        t.cancel();
        return;
      }
      setState(() => _time--);
    });
  }

  void startDuration() {
    _durationTimer = Timer.periodic(
      const Duration(seconds: 1),
          (t) => setState(() => gameDuration++),
    );
  }

  void startGameAfterDelay() {
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      setState(() => _start = true);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _durationTimer?.cancel();
    super.dispose();
  }

  Widget getItem(int index) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(_data[index]),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isFinished) {
      return const SizedBox();
    }

    int crossAxisCount = 2;
    if (_data.length == 6) crossAxisCount = 3;
    else if (_data.length == 8) crossAxisCount = 4;
    else if (_data.length >= 12) crossAxisCount = 3;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("Level: $currentLevel/$maxLevels", style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xff3CB371))),
                  Text("Pairs: $_left"),
                  Text("Moves: $moves"),
                ],
              ),
            ),
            Expanded(
              child: GridView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: _data.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: crossAxisCount == 4 ? 0.8 : 1.0,
                  ),
                itemBuilder: (context, index) {
                  return _start
                      ? FlipCard(
                    key: _cardStateKeys[index],
                    flipOnTouch: _wait ? false : _cardFlips[index],
                    onFlip: () => _onFlip(index),
                    front: _cardFront(),
                    back: getItem(index),
                  )
                      : getItem(index);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _cardFront() {
    return Container(
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        image: const DecorationImage(
          image: AssetImage("assets/images/image_cover.jpg"),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }

  void _onFlip(int index) async {
    if (_wait) return;

    if (!_flip) {
      _flip = true;
      _previousIndex = index;
      return;
    }

    _flip = false;
    moves++;

    if (_data[_previousIndex] != _data[index]) {
      _wait = true;
      Future.delayed(const Duration(milliseconds: 1200), () {
        _cardStateKeys[_previousIndex].currentState?.toggleCard();
        _cardStateKeys[index].currentState?.toggleCard();
        setState(() => _wait = false);
      });
    } else {
      _cardFlips[_previousIndex] = false;
      _cardFlips[index] = false;
      _left--;
    }

    if (_cardFlips.every((e) => !e)) {
      if (currentLevel < maxLevels) {
        _durationTimer?.cancel();
        
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => AlertDialog(
            title: const Text("Great Job! 🌟", textAlign: TextAlign.center, style: TextStyle(color: Colors.green)),
            content: Text("You completed Level $currentLevel. Ready for the next?", textAlign: TextAlign.center),
            actions: [
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xff3CB371)),
                  onPressed: () {
                    Navigator.pop(context);
                    setState(() {
                      currentLevel++;
                      _time = 3;
                      _start = false;
                    });
                    initializeGameData();
                    startTimer();
                    startDuration();
                    startGameAfterDelay();
                  },
                  child: const Text("Next Level", style: TextStyle(color: Colors.white)),
                ),
              )
            ],
          ),
        );
      } else {
        _isFinished = true;
        _durationTimer?.cancel();
        _timer?.cancel();

        int score = 2000 - (gameDuration * 5) - (moves * 10);
        if (score < 0) score = 0;

        await ApiService.saveGameScore(
          gameType: "MEMORY",
          score: score,
          moves: moves,
          timeSpent: gameDuration,
          completed: true,
        );

        Future.delayed(const Duration(milliseconds: 500), () {
          if (!mounted) return;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => GameOverScreen(
                duration: gameDuration,
                score: score,
                moves: moves,
              ),
            ),
          );
        });
      }
    }

    setState(() {});
  }
}
