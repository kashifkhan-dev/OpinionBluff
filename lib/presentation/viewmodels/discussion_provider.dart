import 'dart:async';
import 'package:flutter/material.dart';
import 'package:opinion_bluff/domain/entities/game_player.dart';

class DiscussionPlayer {
  final int index;
  final String name;
  final String? avatarPath;
  final bool isCustomAvatar;
  bool hasCompleted;
  bool isActive;
  double elapsedTime; // in seconds

  DiscussionPlayer({
    required this.index,
    required this.name,
    this.avatarPath,
    this.isCustomAvatar = false,
    this.hasCompleted = false,
    this.isActive = false,
    this.elapsedTime = 0.0,
  });

  double getProgress(int totalDuration) => (elapsedTime / totalDuration).clamp(0.0, 1.0);
}

class DiscussionProvider extends ChangeNotifier {
  List<DiscussionPlayer> _players = [];
  int _activeIndex = -1;
  Timer? _timer;
  int _durationSeconds = 60;
  DateTime? _lastTick;

  List<DiscussionPlayer> get players => _players;
  int get activeIndex => _activeIndex;
  bool get allCompleted => _players.isNotEmpty && _players.every((p) => p.hasCompleted);
  int get durationSeconds => _durationSeconds;

  void initialize(List<GamePlayer> gamePlayers, String durationStr) {
    _players = gamePlayers
        .map(
          (p) => DiscussionPlayer(
            index: p.index,
            name: p.name,
            avatarPath: p.avatarPath,
            isCustomAvatar: p.isCustomAvatar,
          ),
        )
        .toList();

    // Parse duration string
    final match = RegExp(r'\d+').firstMatch(durationStr);
    int value = match != null ? int.parse(match.group(0)!) : 60;
    if (durationStr.toLowerCase().contains('minute')) {
      _durationSeconds = value * 60;
    } else {
      _durationSeconds = value;
    }

    _activeIndex = -1;
    _stopTimer();

    if (_players.isNotEmpty) {
      startForPlayer(0);
    }
  }

  void startForPlayer(int index) {
    if (index < 0 || index >= _players.length || _players[index].hasCompleted) return;

    _stopTimer();

    for (var p in _players) {
      p.isActive = false;
    }

    _activeIndex = index;
    _players[index].isActive = true;
    notifyListeners();

    _startTimer();
  }

  void _startTimer() {
    _stopTimer();
    _lastTick = DateTime.now();
    _timer = Timer.periodic(const Duration(milliseconds: 32), (timer) {
      if (_activeIndex == -1) {
        _stopTimer();
        return;
      }

      final now = DateTime.now();
      final delta = now.difference(_lastTick!).inMilliseconds / 1000.0;
      _lastTick = now;

      final player = _players[_activeIndex];
      player.elapsedTime += delta;

      if (player.elapsedTime >= _durationSeconds) {
        player.elapsedTime = _durationSeconds.toDouble();
        completeCurrent();
      } else {
        notifyListeners();
      }
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
    _lastTick = null;
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
    player.elapsedTime = _durationSeconds.toDouble();

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
    if (index == _activeIndex) return;

    startForPlayer(index);
  }

  @override
  void dispose() {
    _stopTimer();
    super.dispose();
  }
}
