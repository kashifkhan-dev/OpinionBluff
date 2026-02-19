class OnboardingData {
  final String playerPreference;

  OnboardingData({this.playerPreference = ''});

  OnboardingData copyWith({String? playerPreference}) {
    return OnboardingData(playerPreference: playerPreference ?? this.playerPreference);
  }
}
