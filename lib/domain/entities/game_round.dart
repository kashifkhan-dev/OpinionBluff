enum TopicMode { same, mixed }

class PlayerRoundData {
  final int playerIndex;
  final String topic;
  final bool isBluffer;

  PlayerRoundData({required this.playerIndex, required this.topic, required this.isBluffer});
}

class GameRound {
  final List<PlayerRoundData> players;
  final String packId;
  final TopicMode topicMode;
  final String punishment;

  GameRound({
    required this.players,
    required this.packId,
    this.topicMode = TopicMode.same,
    this.punishment = 'Do 10 push-ups',
  });
}
