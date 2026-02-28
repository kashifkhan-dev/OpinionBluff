import 'dart:math';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:impostor/domain/repositories/player_repository.dart';
import 'package:impostor/data/repositories/player_repository_impl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;

class PlayerSetupViewModel extends ChangeNotifier {
  final IPlayerRepository _repository = PlayerRepositoryImpl();
  final ImagePicker _picker = ImagePicker();

  List<PlayerSetupData> _players = [];
  int _playerCount = 3;

  List<PlayerSetupData> get players => _players;
  int get playerCount => _playerCount;

  PlayerSetupViewModel() {
    _init();
  }

  Future<void> _init() async {
    _players = await _repository.loadSavedPlayers();

    // Ensure we have 12 slots
    if (_players.length < 12) {
      final List<PlayerSetupData> newList = List.from(_players);
      while (newList.length < 12) {
        newList.add(PlayerSetupData(name: '', gender: Random().nextBool() ? PlayerGender.male : PlayerGender.female));
      }
      _players = newList;
    }

    // Assign avatars to any that don't have one
    _ensureAvatarsAssigned();
    notifyListeners();
  }

  void _ensureAvatarsAssigned() {
    for (int i = 0; i < _players.length; i++) {
      if (_players[i].avatarAssetPath == null && _players[i].customImagePath == null) {
        _assignRandomAvatarForPlayer(i);
      }
    }
  }

  void _assignRandomAvatarForPlayer(int index) {
    if (index < 0 || index >= _players.length) return;

    final gender = _players[index].gender;
    final prefix = gender == PlayerGender.male ? 'm' : 'f';

    // Find all used avatars of this gender among OTHER active players (to avoid duplicates as much as possible)
    final usedAvatars = _players
        .take(_playerCount)
        .toList()
        .asMap()
        .entries
        .where((e) => e.key != index && e.value.gender == gender && e.value.avatarAssetPath != null)
        .map((e) => e.value.avatarAssetPath!)
        .toSet();

    final allAvatars = List.generate(6, (i) => 'assets/images/avatars/${gender.name}/avatar_$prefix${i + 1}.png');

    final unusedAvatars = allAvatars.where((a) => !usedAvatars.contains(a)).toList();

    String selected;
    if (unusedAvatars.isNotEmpty) {
      selected = unusedAvatars[Random().nextInt(unusedAvatars.length)];
    } else {
      // All used, pick any
      selected = allAvatars[Random().nextInt(allAvatars.length)];
    }

    _players[index] = _players[index].copyWith(avatarAssetPath: selected, customImagePath: null);
  }

  void setPlayerCount(int count) {
    if (count < 3 || count > 12) return;
    _playerCount = count;
    notifyListeners();
  }

  void updatePlayerName(int index, String name) {
    if (index >= 0 && index < _players.length) {
      _players[index] = _players[index].copyWith(name: name);
      _savePlayers();
      notifyListeners();
    }
  }

  void toggleGender(int index) {
    if (index >= 0 && index < _players.length) {
      final newGender = _players[index].gender == PlayerGender.male ? PlayerGender.female : PlayerGender.male;

      _players[index] = _players[index].copyWith(gender: newGender, avatarAssetPath: null);

      _assignRandomAvatarForPlayer(index);
      _savePlayers();
      notifyListeners();
    }
  }

  Future<void> pickImage(int index, ImageSource source) async {
    if (index < 0 || index >= _players.length) return;

    final XFile? image = await _picker.pickImage(source: source, maxWidth: 1024, maxHeight: 1024, imageQuality: 85);

    if (image != null) {
      final appDir = await getApplicationDocumentsDirectory();
      final fileName = 'player_${index}_${DateTime.now().millisecondsSinceEpoch}${p.extension(image.path)}';
      final localPath = p.join(appDir.path, fileName);

      // Copy to local storage
      await File(image.path).copy(localPath);

      _players[index] = _players[index].copyWith(customImagePath: localPath);
      _savePlayers();
      notifyListeners();
    }
  }

  void reorderPlayers(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) newIndex -= 1;
    final item = _players.removeAt(oldIndex);
    _players.insert(newIndex, item);
    _savePlayers();
    notifyListeners();
  }

  Future<void> _savePlayers() async {
    await _repository.savePlayers(_players);
  }

  List<PlayerSetupData> get activePlayers => _players.take(_playerCount).toList();

  bool get areNamesValid {
    return _players.take(_playerCount).every((p) => p.name.trim().isNotEmpty);
  }
}
