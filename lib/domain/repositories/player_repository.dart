enum PlayerGender { male, female }

abstract class IPlayerRepository {
  Future<List<PlayerSetupData>> loadSavedPlayers();
  Future<void> savePlayers(List<PlayerSetupData> players);
}

class PlayerSetupData {
  final String name;
  final PlayerGender gender;
  final String? avatarAssetPath;
  final String? customImagePath;

  PlayerSetupData({required this.name, required this.gender, this.avatarAssetPath, this.customImagePath});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'gender': gender.index,
      'avatarAssetPath': avatarAssetPath,
      'customImagePath': customImagePath,
    };
  }

  factory PlayerSetupData.fromJson(Map<String, dynamic> json) {
    return PlayerSetupData(
      name: json['name'] ?? '',
      gender: PlayerGender.values[json['gender'] ?? 0],
      avatarAssetPath: json['avatarAssetPath'],
      customImagePath: json['customImagePath'],
    );
  }

  PlayerSetupData copyWith({String? name, PlayerGender? gender, String? avatarAssetPath, String? customImagePath}) {
    return PlayerSetupData(
      name: name ?? this.name,
      gender: gender ?? this.gender,
      avatarAssetPath: avatarAssetPath ?? this.avatarAssetPath,
      customImagePath: customImagePath ?? this.customImagePath,
    );
  }
}
