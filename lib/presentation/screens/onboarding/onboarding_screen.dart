import 'package:flutter/material.dart';
import 'package:impostor/presentation/widgets/onboarding_background.dart';
import 'package:provider/provider.dart';
import 'package:impostor/domain/repositories/review_repository.dart';
import 'package:impostor/presentation/screens/onboarding/welcome_screen.dart';
import 'package:impostor/presentation/screens/onboarding/preference_screen.dart';
import 'package:impostor/presentation/screens/onboarding/how_to_play_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:cupertino_native_better/cupertino_native_better.dart';
import 'package:impostor/presentation/viewmodels/onboarding_view_model.dart';
import 'package:impostor/presentation/viewmodels/locale_view_model.dart';
import 'package:impostor/presentation/widgets/app_colors.dart';
import 'package:impostor/domain/entities/onboarding_step.dart';

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

  void _nextPage(OnboardingViewModel vm) {
    vm.nextStep();
    _pageController.nextPage(duration: const Duration(milliseconds: 600), curve: Curves.easeInOutCubic);
  }

  void _prevPage(OnboardingViewModel vm) {
    vm.previousStep();
    _pageController.previousPage(duration: const Duration(milliseconds: 600), curve: Curves.easeInOutCubic);
  }

  @override
  Widget build(BuildContext context) {
    final onboardingVm = context.watch<OnboardingViewModel>();
    final colors = AppColors();

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 7, 4, 33), // Deepest dark color
      body: OnboardingBackground(
        child: SafeArea(
          child: Column(
            children: [
              _buildTopBar(context, colors, onboardingVm),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(), // Only navigate via buttons
                  children: [
                    WelcomeScreen(onContinue: () => _nextPage(onboardingVm)),
                    PreferenceScreen(onContinue: () => _nextPage(onboardingVm), onBack: () => _prevPage(onboardingVm)),
                    HowToPlayScreen(
                      onComplete: () async {
                        onboardingVm.setStep(OnboardingStep.finalizing);
                        // Trigger review before navigating to home
                        debugPrint('🏁 [OnboardingScreen] Completion triggered. Requesting review...');
                        await context.read<IReviewRepository>().requestReview();
                        debugPrint('🏠 [OnboardingScreen] Review request flow completed. Navigating to home.');
                        if (context.mounted) {
                          context.go('/home');
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context, AppColors colors, OnboardingViewModel vm) {
    final steps = OnboardingStep.values;
    final currentIndex = steps.indexOf(vm.currentStep);
    final totalSteps = steps.length;
    final localeVm = context.watch<LocaleViewModel>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // LEFT: prominent back button
          SizedBox(
            width: 48,
            height: 48,
            child: (currentIndex > 0 && vm.currentStep != OnboardingStep.finalizing)
                ? CNButton.icon(icon: const CNSymbol('chevron.left', size: 24), onPressed: () => _prevPage(vm))
                : null,
          ),

          // CENTER: progress bar
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(2),
                child: TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.easeInOutCubic,
                  tween: Tween<double>(begin: 0, end: (currentIndex + 1) / totalSteps),
                  builder: (context, value, _) {
                    return LinearProgressIndicator(
                      value: value,
                      backgroundColor: colors.surface,
                      valueColor: AlwaysStoppedAnimation(colors.progress),
                      minHeight: 4,
                    );
                  },
                ),
              ),
            ),
          ),

          // RIGHT: language flag
          SizedBox(width: 48, height: 48, child: _buildLanguageFlag(context, localeVm, colors)),
        ],
      ),
    );
  }

  Widget _buildLanguageFlag(BuildContext context, LocaleViewModel localeVm, AppColors colors) {
    String flag = '🇺🇸';
    if (localeVm.currentLanguage == AppLanguage.french) flag = '🇫🇷';
    if (localeVm.currentLanguage == AppLanguage.spanish) flag = '🇪🇸';

    return CNPopupMenuButton(
      buttonLabel: flag,
      buttonStyle: CNButtonStyle.plain,
      items: AppLanguage.values.map((lang) {
        String f = '🇺🇸';
        if (lang == AppLanguage.french) f = '🇫🇷';
        if (lang == AppLanguage.spanish) f = '🇪🇸';
        return CNPopupMenuItem(label: "$f ${lang.code.toUpperCase()}");
      }).toList(),
      onSelected: (index) {
        final lang = AppLanguage.values[index];
        localeVm.setLanguage(lang);
      },
    );
  }
}
