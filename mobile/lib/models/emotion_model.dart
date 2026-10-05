class Emotion {
  final String name;
  final String image;

  Emotion({required this.name, required this.image});
}

final List<Emotion> emotionsList = [
  Emotion(name: "Happy", image: "assets/images/happy.png"),
  Emotion(name: "Sad", image: "assets/images/sads.png"),
  Emotion(name: "Angry", image: "assets/images/angry.png"),
  Emotion(name: "Scared", image: "assets/images/scared.png"),
];
