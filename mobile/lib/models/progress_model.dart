class ProgressModel {
  final double language;
  final double games;
  final double tasks;

  ProgressModel({
    required this.language,
    required this.games,
    required this.tasks,
  });

  factory ProgressModel.fromJson(Map<String, dynamic> json) {
    return ProgressModel(
      language: (json["language"] ?? 0).toDouble(),
      games: (json["games"] ?? 0).toDouble(),
      tasks: (json["tasks"] ?? 0).toDouble(),
    );
  }
}
