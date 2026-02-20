class GamePlayer {
  final int index;
  final String name;
  final String topic;
  final bool isBluffer;
  bool isRevealed;

  GamePlayer({
    required this.index,
    required this.name,
    required this.topic,
    required this.isBluffer,
    this.isRevealed = false,
  });

  void reveal() {
    isRevealed = true;
  }
}
