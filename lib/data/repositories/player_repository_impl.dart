import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:impostor/domain/repositories/player_repository.dart';

class PlayerRepositoryImpl implements IPlayerRepository {
  static const String _key = 'saved_players_v2';

  @override
  Future<List<PlayerSetupData>> loadSavedPlayers() async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString(_key);
    if (data == null) return [];

    try {
      final List<dynamic> list = json.decode(data);
      return list.map((item) => PlayerSetupData.fromJson(item)).toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<void> savePlayers(List<PlayerSetupData> players) async {
    final prefs = await SharedPreferences.getInstance();
    final String data = json.encode(players.map((p) => p.toJson()).toList());
    await prefs.setString(_key, data);
  }
}
