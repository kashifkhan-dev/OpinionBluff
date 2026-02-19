import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cupertino_native_better/cupertino_native_better.dart';
import 'package:opinion_bluff/presentation/widgets/onboarding_background.dart';

class HypeScreen extends StatelessWidget {
  const HypeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: OnboardingBackground(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              // Back Button
              Align(
                alignment: Alignment.centerLeft,
                child: CNButton.icon(
                  icon: CNSymbol('chevron.left', size: 20),
                  config: CNButtonConfig(style: CNButtonStyle.glass),
                  onPressed: () => context.pop(),
                ),
              ),
              const SizedBox(height: 48),
              const Text(
                'Are you ready\nto party?',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: -0.5),
              ),
              const SizedBox(height: 60),
              // Review Card
              LiquidGlassContainer(
                config: LiquidGlassConfig(effect: CNGlassEffect.prominent, cornerRadius: 32, interactive: true),
                child: Padding(
                  padding: const EdgeInsets.all(28.0),
                  child: Column(
                    children: [
                      // Stars
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.star_rounded, color: Colors.amber, size: 24),
                            Icon(Icons.star_rounded, color: Colors.amber, size: 24),
                            Icon(Icons.star_rounded, color: Colors.amber, size: 24),
                            Icon(Icons.star_rounded, color: Colors.amber, size: 24),
                            Icon(Icons.star_rounded, color: Colors.amber, size: 24),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        '“This is honestly just so cool and fun — literally saves every night with friends or family.”',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          height: 1.5,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        '#1 Party App Worldwide',
                        style: TextStyle(
                          color: Colors.blueAccent,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              // Invite Friends (Secondary)
              SizedBox(
                height: 54,
                child: CNButton(
                  label: 'Invite Friends',
                  config: CNButtonConfig(style: CNButtonStyle.glass),
                  onPressed: () {
                    // Placeholder for invite logic
                  },
                ),
              ),
              const SizedBox(height: 16),
              // Let's Go (Primary)
              SizedBox(
                height: 64,
                child: CNButton(
                  label: 'Let’s Go',
                  config: CNButtonConfig(style: CNButtonStyle.prominentGlass),
                  onPressed: () => context.go('/home'),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
