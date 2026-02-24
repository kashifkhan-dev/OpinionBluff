class GamePlayer {
  final int index;
  final String name;
  final String topic;
  final bool isBluffer;
  final String? avatarPath;
  final bool isCustomAvatar;
  bool isRevealed;

  GamePlayer({
    required this.index,
    required this.name,
    required this.topic,
    required this.isBluffer,
    this.avatarPath,
    this.isCustomAvatar = false,
    this.isRevealed = false,
  });

  void reveal() {
    isRevealed = true;
  }
}
