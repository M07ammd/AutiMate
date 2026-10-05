class RoutineStep {
  final String id;
  final String title;
  final String image;
  final String status;

  RoutineStep({
    required this.id,
    required this.title,
    required this.image,
    required this.status,
  });

  factory RoutineStep.fromJson(Map<String, dynamic> json) {
    return RoutineStep(
      id: json["id"] ?? "",
      title: json["title"] ?? "",
      image: json["imageUrl"] ??
          "assets/routines/default-task.jpg",
      status: json["status"] ?? "PENDING",
    );
  }
}