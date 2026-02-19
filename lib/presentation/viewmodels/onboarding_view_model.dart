import 'package:flutter/foundation.dart';
import 'package:opinion_bluff/domain/entities/onboarding_data.dart';

class OnboardingViewModel extends ChangeNotifier {
  OnboardingData _data = OnboardingData();

  OnboardingData get data => _data;

  void updatePlayerPreference(String preference) {
    _data = _data.copyWith(playerPreference: preference);
    notifyListeners();
  }

  bool get isPreferenceSelected => _data.playerPreference.isNotEmpty;
}
