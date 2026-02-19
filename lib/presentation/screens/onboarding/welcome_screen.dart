import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cupertino_native_better/cupertino_native_better.dart';
import 'package:opinion_bluff/presentation/widgets/onboarding_background.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 750));

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.666, curve: Curves.easeOutQuart),
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.666, 1.0, curve: Curves.easeIn),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: OnboardingBackground(
        child: Column(
          children: [
            const SizedBox(height: 60),
            // Top Headline
            FadeTransition(
              opacity: _fadeAnimation,
              child: const Text(
                'Welcome to\nOpinion Bluff',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                  shadows: [Shadow(color: Colors.black26, offset: Offset(0, 4), blurRadius: 10)],
                ),
              ),
            ),
            const Spacer(),
            // App Icon
            ScaleTransition(
              scale: _scaleAnimation,
              child: Container(
                width: 240,
                height: 240,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10)),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: Image.asset('assets/images/logo.png', fit: BoxFit.cover),
                ),
              ),
            ),
            const SizedBox(height: 48),
            // Tagline
            FadeTransition(
              opacity: _fadeAnimation,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  'Everything you need for your next\nparty night all in one place.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    height: 1.4,
                  ),
                ),
              ),
            ),
            const Spacer(),
            // Bottom Continue Button
            FadeTransition(
              opacity: _fadeAnimation,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
                child: SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: CNButton(
                    label: 'Continue',
                    config: CNButtonConfig(style: CNButtonStyle.prominentGlass),
                    onPressed: () => context.go('/preference'),
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
