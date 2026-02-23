import 'package:flutter/material.dart';
import 'package:opinion_bluff/domain/entities/game_round.dart';
import 'package:opinion_bluff/domain/entities/punishment.dart';

class GameConfigViewModel extends ChangeNotifier {
  String _selectedPack = 'Daily Life';
  TopicMode _topicMode = TopicMode.same;

  // Punishments
  final List<Punishment> _predefinedPunishments = [
    Punishment(id: 'pushups', name: 'punishment_pushups', difficulty: PunishmentDifficulty.low),
    Punishment(id: 'sing', name: 'punishment_sing', difficulty: PunishmentDifficulty.low),
    Punishment(id: 'dance', name: 'punishment_dance', difficulty: PunishmentDifficulty.hard),
    Punishment(id: 'dinner', name: 'punishment_dinner', difficulty: PunishmentDifficulty.hard),
    Punishment(id: 'prank', name: 'punishment_prank', difficulty: PunishmentDifficulty.veryHard),
    Punishment(id: 'shave', name: 'punishment_shave', difficulty: PunishmentDifficulty.veryHard),
  ];
  final List<Punishment> _customPunishments = [];
  String _selectedPunishmentId = 'pushups';

  int _durationIndex = 4; // Index for '3 minutes'
  final List<String> _durationOptions = [
    '30 seconds',
    '60 seconds',
    '90 seconds',
    '2 minutes',
    '3 minutes',
    '5 minutes',
  ];

  String get selectedPack => _selectedPack;
  String get duration => _durationOptions[_durationIndex];
  String get selectedPunishmentId => _selectedPunishmentId;

  List<Punishment> get allPunishments => [..._predefinedPunishments, ..._customPunishments];
  List<Punishment> get customPunishments => _customPunishments;

  Map<PunishmentDifficulty, List<Punishment>> get categorizedPunishments {
    final Map<PunishmentDifficulty, List<Punishment>> map = {
      PunishmentDifficulty.low: [],
      PunishmentDifficulty.hard: [],
      PunishmentDifficulty.veryHard: [],
    };
    for (var p in allPunishments) {
      map[p.difficulty]?.add(p);
    }
    return map;
  }

  String get selectedPunishment {
    final p = allPunishments.firstWhere(
      (p) => p.id == _selectedPunishmentId,
      orElse: () => _predefinedPunishments.first,
    );
    return p.name;
  }

  String get durationValue => _durationOptions[_durationIndex].split(' ')[0];
  String get durationUnit => _durationOptions[_durationIndex].contains('second') ? 'sec' : 'min';

  TopicMode get topicMode => _topicMode;

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

  void updatePack(String value) {
    _selectedPack = value;
    notifyListeners();
  }

  void updateTopicMode(TopicMode mode) {
    _topicMode = mode;
    notifyListeners();
  }

  void updatePunishment(String punishmentId) {
    _selectedPunishmentId = punishmentId;
    notifyListeners();
  }

  void addCustomPunishment(String name, PunishmentDifficulty difficulty) {
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final punishment = Punishment(id: id, name: name, difficulty: difficulty, isCustom: true);
    _customPunishments.add(punishment);
    _selectedPunishmentId = id;
    notifyListeners();
  }

  void deleteCustomPunishment(String id) {
    _customPunishments.removeWhere((p) => p.id == id);
    if (_selectedPunishmentId == id) {
      _selectedPunishmentId = _predefinedPunishments.first.id;
    }
    notifyListeners();
  }
}
