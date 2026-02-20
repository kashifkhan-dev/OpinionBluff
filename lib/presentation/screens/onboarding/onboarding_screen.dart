import 'package:flutter/material.dart';
import 'package:opinion_bluff/presentation/widgets/onboarding_background.dart';
import 'package:opinion_bluff/presentation/screens/onboarding/welcome_screen.dart';
import 'package:opinion_bluff/presentation/screens/onboarding/preference_screen.dart';
import 'package:opinion_bluff/presentation/screens/onboarding/hype_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    _pageController.nextPage(duration: const Duration(milliseconds: 500), curve: Curves.easeInOutCubic);
  }

  void _prevPage() {
    _pageController.previousPage(duration: const Duration(milliseconds: 500), curve: Curves.easeInOutCubic);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 7, 4, 33), // Deepest dark color
      body: OnboardingBackground(
        child: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(), // Only navigate via buttons
          children: [
            WelcomeScreen(onContinue: _nextPage),
            PreferenceScreen(onContinue: _nextPage, onBack: _prevPage),
            HypeScreen(onBack: _prevPage),
          ],
        ),
      ),
    );
  }
}
