import 'package:flutter/material.dart';

class GameConfigViewModel extends ChangeNotifier {
  int _players = 3;
  String _selectedPack = 'Daily Life';
  String _gameMode = 'Classic';
  List<String> _playerNames = ['Player 1', 'Player 2', 'Player 3'];

  int _durationIndex = 4; // Index for '3 minutes'
  final List<String> _durationOptions = [
    '30 seconds',
    '60 seconds',
    '90 seconds',
    '2 minutes',
    '3 minutes',
    '5 minutes',
  ];

  int get players => _players;
  String get selectedPack => _selectedPack;
  String get duration => _durationOptions[_durationIndex];

  String get durationValue => _durationOptions[_durationIndex].split(' ')[0];
  String get durationUnit => _durationOptions[_durationIndex].contains('second') ? 'sec' : 'min';

  String get gameMode => _gameMode;
  List<String> get playerNames => _playerNames;

  void incrementDuration() {
    if (_durationIndex < _durationOptions.length - 1) {
      _durationIndex++;
      notifyListeners();
    }
  }

  void decrementDuration() {
    if (_durationIndex > 0) {
      _durationIndex--;
      notifyListeners();
    }
  }

  void updatePlayers(int value) {
    if (value < 3 || value > 12) return;
    _players = value;

    // Adjust player names list length
    if (_playerNames.length < _players) {
      for (int i = _playerNames.length; i < _players; i++) {
        _playerNames.add('Player ${i + 1}');
      }
    } else if (_playerNames.length > _players) {
      _playerNames = _playerNames.sublist(0, _players);
    }

    notifyListeners();
  }

  void incrementPlayers() {
    updatePlayers(_players + 1);
  }

  void decrementPlayers() {
    updatePlayers(_players - 1);
  }

  void updatePlayerName(int index, String name) {
    if (index >= 0 && index < _playerNames.length) {
      _playerNames[index] = name;
      notifyListeners();
    }
  }

  void updatePack(String value) {
    _selectedPack = value;
    notifyListeners();
  }

  void updateGameMode(String value) {
    _gameMode = value;
    notifyListeners();
  }
}
