class OnboardingModel {
  final String title;
  final String description;
  final String image;

  OnboardingModel({
    required this.title,
    required this.description,
    required this.image,
  });
}

// Global list containing the onboarding content
List<OnboardingModel> onboardingData = [
  OnboardingModel(
    image:
        'assets/images/Onboarding 1.png', // Ensure whitespace and uppercase letter exist
    title: 'Track Your Life',
    description: 'Monitor your daily activities and progress with precision.',
  ),
  OnboardingModel(
    image: 'assets/images/Onboarding 2.png',
    title: 'Cyber Quests',
    description: 'Complete daily challenges and upgrade your real-life stats.',
  ),
  OnboardingModel(
    image: 'assets/images/Onboarding 3.png',
    title: 'Data Mastery',
    description: 'Visualize your growth through our advanced OS interface.',
  ),
];
