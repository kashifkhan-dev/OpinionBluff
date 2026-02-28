import 'dart:math';
import 'package:flutter/material.dart';
import 'package:impostor/domain/entities/game_round.dart';
import 'package:impostor/domain/entities/punishment.dart';
import 'package:impostor/domain/entities/topic_pack.dart';
import 'package:impostor/data/repositories/punishment_repository.dart';
import 'package:impostor/presentation/viewmodels/locale_view_model.dart';

class GameConfigViewModel extends ChangeNotifier {
  final PunishmentRepository _punishmentRepository = PunishmentRepository();
  String _selectedPack = 'Daily Life';
  TopicMode _topicMode = TopicMode.same;

  // Punishments
  Map<PunishmentDifficulty, List<Punishment>> _punishmentsByDifficulty = {
    PunishmentDifficulty.low: [],
    PunishmentDifficulty.hard: [],
    PunishmentDifficulty.veryHard: [],
  };
  final List<Punishment> _customPunishments = [];
  String? _selectedPunishmentId;
  PunishmentDifficulty _selectedPunishmentDifficulty = PunishmentDifficulty.low;

  // Sound Settings
  bool _soundEffectsEnabled = true;
  bool _hapticsEnabled = true;

  int _durationIndex = 4; // Index for '3 minutes'
  final List<String> _durationOptions = [
    '30 seconds',
    '60 seconds',
    '90 seconds',
    '2 minutes',
    '3 minutes',
    '5 minutes',
  ];

  GameConfigViewModel() {
    _loadPunishments();
  }

  Future<void> _loadPunishments() async {
    _punishmentsByDifficulty = await _punishmentRepository.loadPunishments();
    if (_punishmentsByDifficulty[_selectedPunishmentDifficulty]!.isNotEmpty) {
      _selectedPunishmentId =
          _punishmentsByDifficulty[_selectedPunishmentDifficulty]![Random().nextInt(
                _punishmentsByDifficulty[_selectedPunishmentDifficulty]!.length,
              )]
              .id;
    }
    notifyListeners();
  }

  String get selectedPack => _selectedPack;
  String get duration => _durationOptions[_durationIndex];
  String? get selectedPunishmentId => _selectedPunishmentId;
  PunishmentDifficulty get selectedPunishmentDifficulty => _selectedPunishmentDifficulty;

  bool get soundEffectsEnabled => _soundEffectsEnabled;
  bool get hapticsEnabled => _hapticsEnabled;

  List<Punishment> get allPunishments => [
    ..._punishmentsByDifficulty.values.expand((element) => element),
    ..._customPunishments,
  ];
  List<Punishment> get customPunishments => _customPunishments;

  Map<PunishmentDifficulty, List<Punishment>> get categorizedPunishments {
    final Map<PunishmentDifficulty, List<Punishment>> map = {
      PunishmentDifficulty.low: [...?_punishmentsByDifficulty[PunishmentDifficulty.low]],
      PunishmentDifficulty.hard: [...?_punishmentsByDifficulty[PunishmentDifficulty.hard]],
      PunishmentDifficulty.veryHard: [...?_punishmentsByDifficulty[PunishmentDifficulty.veryHard]],
    };
    for (var p in _customPunishments) {
      map[p.difficulty]?.add(p);
    }
    return map;
  }

  String getSelectedPunishmentName(AppLanguage language) {
    final punishmentsOfDifficulty = allPunishments.where((p) => p.difficulty == _selectedPunishmentDifficulty).toList();
    if (punishmentsOfDifficulty.isEmpty) return 'No punishment selected';

    final p = punishmentsOfDifficulty.firstWhere(
      (p) => p.id == _selectedPunishmentId,
      orElse: () => punishmentsOfDifficulty.first,
    );
    return p.getNameForLanguage(language);
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

  void updatePunishmentDifficulty(PunishmentDifficulty difficulty) {
    _selectedPunishmentDifficulty = difficulty;
    final punishmentsOfDifficulty = allPunishments.where((p) => p.difficulty == difficulty).toList();
    if (punishmentsOfDifficulty.isNotEmpty) {
      _selectedPunishmentId = punishmentsOfDifficulty[Random().nextInt(punishmentsOfDifficulty.length)].id;
    }
    notifyListeners();
  }

  void updatePunishment(String punishmentId) {
    _selectedPunishmentId = punishmentId;
    final p = allPunishments.firstWhere((p) => p.id == punishmentId);
    _selectedPunishmentDifficulty = p.difficulty;
    notifyListeners();
  }

  void toggleSoundEffects() {
    _soundEffectsEnabled = !_soundEffectsEnabled;
    notifyListeners();
  }

  void toggleHaptics() {
    _hapticsEnabled = !_hapticsEnabled;
    notifyListeners();
  }

  void addCustomPunishment(String name, PunishmentDifficulty difficulty) {
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final punishment = Punishment(
      id: id,
      name: LocalizedString({'en': name, 'fr': name, 'es': name}),
      difficulty: difficulty,
      isCustom: true,
    );
    _customPunishments.add(punishment);
    _selectedPunishmentId = id;
    _selectedPunishmentDifficulty = difficulty;
    notifyListeners();
  }

  void deleteCustomPunishment(String id) {
    _customPunishments.removeWhere((p) => p.id == id);
    if (_selectedPunishmentId == id) {
      _selectedPunishmentId = allPunishments.isNotEmpty ? allPunishments.first.id : null;
      _selectedPunishmentDifficulty = allPunishments.isNotEmpty
          ? allPunishments.first.difficulty
          : PunishmentDifficulty.low;
    }
    notifyListeners();
  }

  String getRandomPunishmentForDifficulty(PunishmentDifficulty difficulty, AppLanguage language) {
    final punishmentsOfDifficulty = allPunishments.where((p) => p.difficulty == difficulty).toList();
    if (punishmentsOfDifficulty.isEmpty) return 'No punishment selected';
    return punishmentsOfDifficulty[Random().nextInt(punishmentsOfDifficulty.length)].getNameForLanguage(language);
  }
}
