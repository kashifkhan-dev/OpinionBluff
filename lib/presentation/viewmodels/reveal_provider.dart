import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:opinion_bluff/domain/entities/game_player.dart';
import 'package:opinion_bluff/domain/entities/game_round.dart';
import 'package:opinion_bluff/data/repositories/opinion_repository.dart';
import 'package:opinion_bluff/presentation/viewmodels/locale_view_model.dart';

class RevealProvider extends ChangeNotifier {
  final OpinionRepository _repository = OpinionRepository();
  List<GamePlayer> _players = [];
  GameRound? _currentRound;
  int _activePlayerIndex = 0;

  bool _isLoading = false;
  bool _isSessionRevealed = false; // Current hold-session state
  double _progress = 0.0;
  Timer? _timer;

  List<GamePlayer> get players => _players;
  GameRound? get currentRound => _currentRound;
  int get activePlayerIndex => _activePlayerIndex;
  bool get isLoading => _isLoading;
  bool get isSessionRevealed => _isSessionRevealed;
  double get progress => _progress;
  GamePlayer? get activePlayer => _players.isNotEmpty ? _players[_activePlayerIndex] : null;
  bool get allPlayersRevealed => _players.isNotEmpty && _players.every((p) => p.isRevealed);

  Future<void> initializeGame(
    List<String> playerNames,
    String selectedPack,
    TopicMode mode,
    String punishment,
    AppLanguage language,
  ) async {
    _players = [];
    _activePlayerIndex = 0;
    resetState();

    final random = Random();
    List<String> selectedTopics = [];

    if (mode == TopicMode.same) {
      // Find pack by English title or ID
      final allPacks = await _repository.loadPacks();
      final pack = allPacks.firstWhere(
        (p) => p.id == selectedPack || p.title.getForLanguage(AppLanguage.english) == selectedPack,
        orElse: () => allPacks.first,
      );
      final topics = pack.topics.map((t) => t.getForLanguage(language)).toList();
      final shuffledTopics = List<String>.from(topics)..shuffle();
      selectedTopics = shuffledTopics.take(playerNames.length).toList();
    } else {
      // Mixed Topic Mode: Randomly select packs per player, ensure uniqueness
      final allPacks = await _repository.loadPacks();
      final Set<String> uniqueTopics = {};

      while (uniqueTopics.length < playerNames.length) {
        final randomPack = allPacks[random.nextInt(allPacks.length)];
        final randomTopic = randomPack.topics[random.nextInt(randomPack.topics.length)].getForLanguage(language);
        uniqueTopics.add(randomTopic);
      }
      selectedTopics = uniqueTopics.toList();
    }

    final blufferIndex = random.nextInt(playerNames.length);

    final List<PlayerRoundData> roundPlayers = [];
    for (int i = 0; i < playerNames.length; i++) {
      final isBluffer = i == blufferIndex;
      final topic = selectedTopics[i % selectedTopics.length]; // Safeguard

      roundPlayers.add(PlayerRoundData(playerIndex: i, topic: topic, isBluffer: isBluffer));
      _players.add(GamePlayer(index: i, name: playerNames[i], topic: topic, isBluffer: isBluffer));
    }

    _currentRound = GameRound(players: roundPlayers, packId: selectedPack, topicMode: mode, punishment: punishment);
    notifyListeners();
  }

  void setActivePlayer(int index) {
    if (index >= 0 && index < _players.length) {
      if (!_players[index].isRevealed) {
        _activePlayerIndex = index;
        resetState();
        notifyListeners();
      }
    }
  }

  void startLoading() {
    // If player already revealed their topic permanently, they can still re-hold to see it,
    // but the loading ritual only happens once.
    // Actually, rule 3 says: "The next player MUST go through the full hold -> load -> reveal process again."
    // And point 2 says: "This happens ONLY once per player."

    if (activePlayer == null || _isLoading || _isSessionRevealed) return;

    // If the player has already permanently revealed, we just show the topic immediately during hold?
    // User says: "Next player MUST go through the full... process again."
    // If I select an already revealed player (via status list), I should probably reset their state to allow re-reveal ritual if they forgot.
    // But point 6 says track player.isRevealed.

    _isLoading = true;
    _progress = 0.0;
    notifyListeners();

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 30), (timer) {
      _progress += 0.02; // 1.5s approx
      if (_progress >= 1.0) {
        _progress = 1.0;
        completeSessionReveal();
      }
      notifyListeners();
    });
  }

  void cancelLoading() {
    _timer?.cancel();
    _isLoading = false;
    _progress = 0.0;
    _isSessionRevealed = false;
    notifyListeners();
  }

  void completeSessionReveal() {
    _timer?.cancel();
    _isLoading = false;
    _isSessionRevealed = true;
    activePlayer?.reveal(); // Mark permanent
    notifyListeners();
  }

  void nextPlayer() {
    final nextIndex = _players.indexWhere((p) => !p.isRevealed);
    if (nextIndex != -1) {
      _activePlayerIndex = nextIndex;
    }
    resetState();
    notifyListeners();
  }

  void resetState() {
    _timer?.cancel();
    _isLoading = false;
    _isSessionRevealed = false;
    _progress = 0.0;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
