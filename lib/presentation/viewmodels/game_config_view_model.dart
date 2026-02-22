import 'package:flutter/material.dart';
import 'package:opinion_bluff/domain/entities/game_round.dart';

class GameConfigViewModel extends ChangeNotifier {
  int _players = 3;
  String _selectedPack = 'Daily Life';
  String _gameMode = 'Classic';
  TopicMode _topicMode = TopicMode.same;
  List<String> _playerNames = ['Anna', 'Luis', 'Mark'];

  // Punishments
  final List<String> _predefinedPunishments = [
    'Do 10 push-ups',
    'Pay for dinner',
    'Call your mom or dad and prank them',
    'Sing a song',
    'Dance for 30 seconds',
  ];
  final List<String> _customPunishments = [];
  String _selectedPunishment = 'Do 10 push-ups';

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
  String get selectedPunishment => _selectedPunishment;
  List<String> get allPunishments => [..._predefinedPunishments, ..._customPunishments];
  List<String> get customPunishments => _customPunishments;

  String get durationValue => _durationOptions[_durationIndex].split(' ')[0];
  String get durationUnit => _durationOptions[_durationIndex].contains('second') ? 'sec' : 'min';

  String get gameMode => _gameMode;
  TopicMode get topicMode => _topicMode;
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

  void updateTopicMode(TopicMode mode) {
    _topicMode = mode;
    notifyListeners();
  }

  void updatePunishment(String punishment) {
    _selectedPunishment = punishment;
    notifyListeners();
  }

  void addCustomPunishment(String punishment) {
    if (punishment.isNotEmpty && !_customPunishments.contains(punishment)) {
      _customPunishments.add(punishment);
      _selectedPunishment = punishment;
      notifyListeners();
    }
  }

  void deleteCustomPunishment(String punishment) {
    _customPunishments.remove(punishment);
    if (_selectedPunishment == punishment) {
      _selectedPunishment = _predefinedPunishments.first;
    }
    notifyListeners();
  }
}
