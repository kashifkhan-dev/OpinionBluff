import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:cupertino_native_better/cupertino_native_better.dart';
import 'package:opinion_bluff/presentation/widgets/onboarding_background.dart';
import 'package:opinion_bluff/presentation/viewmodels/onboarding_view_model.dart';

class PreferenceScreen extends StatelessWidget {
  const PreferenceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<OnboardingViewModel>();
    final options = ['Friends', 'Family', 'Partner', 'Colleagues'];

    return Scaffold(
      backgroundColor: Colors.black,
      body: OnboardingBackground(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              // Back Button (Native Style)
              Align(
                alignment: Alignment.centerLeft,
                child: CNButton.icon(
                  icon: CNSymbol('chevron.left', size: 20),
                  config: CNButtonConfig(style: CNButtonStyle.glass),
                  onPressed: () => context.pop(),
                ),
              ),
              const SizedBox(height: 40),
              const Text(
                'Who do you most like\nto play with?',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold, letterSpacing: -0.5),
              ),
              const SizedBox(height: 60),
              // Selection Grid
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 1.1,
                  ),
                  itemCount: options.length,
                  itemBuilder: (context, index) {
                    final option = options[index];
                    final isSelected = viewModel.data.playerPreference == option;

                    return GestureDetector(
                      onTap: () => viewModel.updatePlayerPreference(option),
                      child: LiquidGlassContainer(
                        config: LiquidGlassConfig(
                          effect: isSelected ? CNGlassEffect.prominent : CNGlassEffect.regular,
                          cornerRadius: 24,
                          interactive: true,
                        ),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: isSelected
                                ? [BoxShadow(color: Colors.blue.withOpacity(0.3), blurRadius: 15, spreadRadius: 1)]
                                : [],
                          ),
                          child: Center(
                            child: Text(
                              option,
                              style: TextStyle(
                                color: Colors.white.withOpacity(isSelected ? 1.0 : 0.7),
                                fontSize: 18,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const Text(
                'For the best game experience, tell the driver.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white38, fontSize: 13),
              ),
              const SizedBox(height: 24),
              // Continue Button
              SizedBox(
                height: 60,
                child: CNButton(
                  label: 'Continue',
                  config: CNButtonConfig(
                    style: viewModel.isPreferenceSelected ? CNButtonStyle.prominentGlass : CNButtonStyle.glass,
                  ),
                  onPressed: viewModel.isPreferenceSelected ? () => context.go('/hype') : null,
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
