import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:impostor/domain/entities/punishment.dart';

class PunishmentRepository {
  Future<Map<PunishmentDifficulty, List<Punishment>>> loadPunishments() async {
    final String response = await rootBundle.loadString('assets/punishments/punishments.json');
    final Map<String, dynamic> data = json.decode(response);

    final Map<PunishmentDifficulty, List<Punishment>> result = {
      PunishmentDifficulty.low: [],
      PunishmentDifficulty.hard: [],
      PunishmentDifficulty.veryHard: [],
    };

    if (data.containsKey('low')) {
      result[PunishmentDifficulty.low] = (data['low'] as List)
          .map((item) => Punishment.fromJson(item, PunishmentDifficulty.low))
          .toList();
    }
    if (data.containsKey('hard')) {
      result[PunishmentDifficulty.hard] = (data['hard'] as List)
          .map((item) => Punishment.fromJson(item, PunishmentDifficulty.hard))
          .toList();
    }
    if (data.containsKey('veryHard')) {
      result[PunishmentDifficulty.veryHard] = (data['veryHard'] as List)
          .map((item) => Punishment.fromJson(item, PunishmentDifficulty.veryHard))
          .toList();
    }

    return result;
  }
}
