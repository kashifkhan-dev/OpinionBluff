class PlayerRoundData {
  final int playerIndex;
  final String topic;
  final bool isBluffer;

  PlayerRoundData({required this.playerIndex, required this.topic, required this.isBluffer});
}

class GameRound {
  final List<PlayerRoundData> players;
  final String packId;

  GameRound({required this.players, required this.packId});
}
