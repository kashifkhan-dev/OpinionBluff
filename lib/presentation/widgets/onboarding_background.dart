import 'package:flutter/material.dart';

class OnboardingBackground extends StatelessWidget {
  final Widget child;

  const OnboardingBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background Gradient
        Positioned.fill(
          child: Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(-0.7, -0.8),
                radius: 1.8,
                colors: [Color(0xFF1E3A8A), Color(0xFF0F172A), Color(0xFF000000)],
              ),
            ),
          ),
        ),
        // Ambient Glow
        Positioned(
          top: -100,
          right: -100,
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(colors: [Colors.blue.withOpacity(0.2), Colors.transparent]),
            ),
          ),
        ),
        SafeArea(child: child),
      ],
    );
  }
}
