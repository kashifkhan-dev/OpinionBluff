import 'package:flutter/foundation.dart';
import 'package:impostor/domain/entities/onboarding_data.dart';
import 'package:impostor/domain/entities/onboarding_step.dart';

class OnboardingViewModel extends ChangeNotifier {
  OnboardingData _data = OnboardingData();
  OnboardingData get data => _data;

  OnboardingStep _currentStep = OnboardingStep.welcome;
  OnboardingStep get currentStep => _currentStep;

  void nextStep() {
    final steps = OnboardingStep.values;
    final currentIndex = steps.indexOf(_currentStep);
    if (currentIndex < steps.length - 1) {
      _currentStep = steps[currentIndex + 1];
      notifyListeners();
    }
  }

  void previousStep() {
    final steps = OnboardingStep.values;
    final currentIndex = steps.indexOf(_currentStep);
    if (currentIndex > 0) {
      _currentStep = steps[currentIndex - 1];
      notifyListeners();
    }
  }

  void setStep(OnboardingStep step) {
    _currentStep = step;
    notifyListeners();
  }

  void updatePlayerPreference(String preference) {
    _data = _data.copyWith(playerPreference: preference);
    notifyListeners();
  }

  bool get isPreferenceSelected => _data.playerPreference.isNotEmpty;
}
