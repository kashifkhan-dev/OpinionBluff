import 'dart:async';
import 'package:flutter/material.dart';
import 'package:opinion_bluff/domain/entities/game_player.dart';

class DiscussionPlayer {
  final int index;
  final String name;
  bool hasCompleted;
  bool isActive;
  double progress; // 0.0 -> 1.0

  DiscussionPlayer({
    required this.index,
    required this.name,
    this.hasCompleted = false,
    this.isActive = false,
    this.progress = 0.0,
  });
}

class DiscussionProvider extends ChangeNotifier {
  List<DiscussionPlayer> _players = [];
  int _activeIndex = -1;
  Timer? _timer;
  int _durationSeconds = 60; // Default

  List<DiscussionPlayer> get players => _players;
  int get activeIndex => _activeIndex;
  bool get allCompleted => _players.isNotEmpty && _players.every((p) => p.hasCompleted);

  int get durationSeconds => _durationSeconds;

  void initialize(List<GamePlayer> gamePlayers, String durationStr) {
    _players = gamePlayers.map((p) => DiscussionPlayer(index: p.index, name: p.name)).toList();

    // Parse duration string (e.g., "3 minutes" or "60 seconds")
    final match = RegExp(r'\d+').firstMatch(durationStr);
    int value = match != null ? int.parse(match.group(0)!) : 60;

    if (durationStr.toLowerCase().contains('minute')) {
      _durationSeconds = value * 60;
    } else {
      _durationSeconds = value;
    }

    _activeIndex = -1;
    _stopTimer();

    // Default Behavior: First player becomes active automatically
    if (_players.isNotEmpty) {
      startForPlayer(0);
    }
  }

  void startForPlayer(int index) {
    if (index < 0 || index >= _players.length || _players[index].hasCompleted) return;

    _stopTimer();

    // Reset previous active player if any
    for (var p in _players) {
      p.isActive = false;
    }

    _activeIndex = index;
    _players[index].isActive = true;
    _players[index].progress = 0.0;
    notifyListeners();

    _startTimer();
  }

  void _startTimer() {
    _stopTimer();
    const tick = Duration(milliseconds: 100);
    final totalTicks = (_durationSeconds * 1000) / 100;

    _timer = Timer.periodic(tick, (timer) {
      if (_activeIndex == -1) {
        timer.cancel();
        return;
      }

      final player = _players[_activeIndex];
      player.progress += 1.0 / totalTicks;

      if (player.progress >= 1.0) {
        player.progress = 1.0;
        completeCurrent();
      } else {
        notifyListeners();
      }
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  void skip() {
    completeCurrent();
  }

  void completeCurrent() {
    if (_activeIndex == -1) return;

    _stopTimer();
    final player = _players[_activeIndex];
    player.hasCompleted = true;
    player.isActive = false;
    player.progress = 1.0;

    // Activate next incomplete player automatically
    final nextIndex = _players.indexWhere((p) => !p.hasCompleted);
    if (nextIndex != -1) {
      startForPlayer(nextIndex);
    } else {
      _activeIndex = -1;
      notifyListeners();
    }
  }

  void selectPlayer(int index) {
    if (index < 0 || index >= _players.length || _players[index].hasCompleted) return;

    // If tapping the already active player, do nothing or reset?
    // Manual selection overrides automatic sequence.
    startForPlayer(index);
  }

  @override
  void dispose() {
    _stopTimer();
    super.dispose();
  }
}
