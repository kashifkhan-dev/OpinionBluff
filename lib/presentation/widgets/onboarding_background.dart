import 'package:flutter/material.dart';
import 'dart:math' as math;

class OnboardingBackground extends StatefulWidget {
  final Widget child;

  const OnboardingBackground({super.key, required this.child});

  @override
  State<OnboardingBackground> createState() => _OnboardingBackgroundState();
}

class _OnboardingBackgroundState extends State<OnboardingBackground> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 10))..repeat();
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
            // Animated Deep Immersive Blue Gradient Background
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    transform: GradientRotation(_controller.value * 2 * math.pi),
                    colors: const [
                      Color.fromARGB(255, 7, 4, 33),
                      Color.fromARGB(255, 1, 22, 61),
                      Color.fromARGB(255, 12, 43, 74),
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
              ),
            ),
            // Primary Ambient Arctic Glow (Bottom Right)
            Positioned(
              bottom: -180 + (60 * (0.5 + 0.5 * math.sin(_controller.value * 2 * math.pi))),
              right: -180 + (60 * (0.5 + 0.5 * math.sin(_controller.value * 2 * math.pi))),
              child: Container(
                width: 700,
                height: 700,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [const Color(0xFF093F76).withValues(alpha: 0.15), Colors.transparent],
                  ),
                ),
              ),
            ),
            // Secondary Ambient Midnight Glow (Top Left)
            Positioned(
              top: -100 - (50 * (0.5 + 0.5 * math.cos(_controller.value * 2 * math.pi))),
              left: -100 - (50 * (0.5 + 0.5 * math.cos(_controller.value * 2 * math.pi))),
              child: Container(
                width: 500,
                height: 500,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [const Color(0xFF001E57).withValues(alpha: 0.25), Colors.transparent],
                  ),
                ),
              ),
            ),
            SafeArea(child: widget.child),
          ],
        );
      },
    );
  }
}
