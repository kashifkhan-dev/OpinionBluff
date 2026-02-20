import 'package:flutter/material.dart';
import 'dart:math' as math;

class OnboardingBackground extends StatefulWidget {
  final Widget child;

  const OnboardingBackground({super.key, required this.child});

  static const List<Color> themeColors = [
    Color.fromARGB(255, 4, 3, 12),
    Color.fromARGB(255, 2, 13, 34),
    Color.fromARGB(255, 1, 24, 47),
  ];

  @override
  State<OnboardingBackground> createState() => _OnboardingBackgroundState();
}

class _OnboardingBackgroundState extends State<OnboardingBackground> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 15))..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Stack(
          children: [
            // Animated Deep Immersive Dark Gradient Background
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    transform: GradientRotation(_controller.value * 2 * math.pi),
                    colors: OnboardingBackground.themeColors,
                    stops: const [0.0, 0.45, 1.0],
                  ),
                ),
              ),
            ),
            // Primary Ambient Glow (Soft and Subtle)
            Positioned(
              bottom: -200 + (100 * math.sin(_controller.value * 2 * math.pi)),
              right: -200 + (100 * math.cos(_controller.value * 2 * math.pi)),
              child: Container(
                width: 800,
                height: 800,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [const Color(0xFF093F76).withValues(alpha: 0.12), Colors.transparent],
                  ),
                ),
              ),
            ),
            // Secondary Ambient Glow
            Positioned(
              top: -150 + (80 * math.cos(_controller.value * 2 * math.pi)),
              left: -150 + (80 * math.sin(_controller.value * 2 * math.pi)),
              child: Container(
                width: 600,
                height: 600,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [const Color(0xFF001E57).withValues(alpha: 0.18), Colors.transparent],
                  ),
                ),
              ),
            ),
            // The child is now wrapped in SafeArea again to protect content layout
            SafeArea(child: widget.child),
          ],
        );
      },
    );
  }
}
