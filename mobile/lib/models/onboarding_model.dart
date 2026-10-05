class OnboardingModel {
  final String image;
  final String title;
  final String subtitle;
  final bool isLast;

  OnboardingModel({
    required this.image,
    required this.title,
    required this.subtitle,
    this.isLast = false,
  });
}
