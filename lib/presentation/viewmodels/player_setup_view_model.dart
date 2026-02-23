import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlayerSetupViewModel extends ChangeNotifier {
  List<String> _playerNames = [];
  int _playerCount = 3;

  List<String> get playerNames => _playerNames;
  int get playerCount => _playerCount;

  PlayerSetupViewModel() {
    _loadSavedNames();
  }

  Future<void> _loadSavedNames() async {
    final prefs = await SharedPreferences.getInstance();
    _playerNames = prefs.getStringList('saved_player_names') ?? [];
    if (_playerNames.length < 12) {
      final List<String> newList = List.from(_playerNames);
      while (newList.length < 12) {
        newList.add('');
      }
      _playerNames = newList;
    }
    notifyListeners();
  }

  void setPlayerCount(int count) {
    if (count < 3 || count > 12) return;
    _playerCount = count;
    notifyListeners();
  }

  void updatePlayerName(int index, String name) {
    if (index >= 0 && index < _playerNames.length) {
      _playerNames[index] = name;
      _saveNames();
      notifyListeners();
    }
  }

  void reorderPlayers(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) newIndex -= 1;
    final item = _playerNames.removeAt(oldIndex);
    _playerNames.insert(newIndex, item);
    _saveNames();
    notifyListeners();
  }

  Future<void> _saveNames() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('saved_player_names', _playerNames);
  }

  List<String> get activePlayerNames =>
      _playerNames.take(_playerCount).map((n) => n.trim().isEmpty ? 'Player' : n.trim()).toList();

  bool get areNamesValid {
    return _playerNames.take(_playerCount).every((name) => name.trim().isNotEmpty);
  }
}
