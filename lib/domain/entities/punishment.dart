import 'package:impostor/domain/entities/topic_pack.dart';
import 'package:impostor/presentation/viewmodels/locale_view_model.dart';

enum PunishmentDifficulty { low, hard, veryHard }

class Punishment {
  final String id;
  final LocalizedString name;
  final PunishmentDifficulty difficulty;
  final bool isCustom;

  Punishment({required this.id, required this.name, required this.difficulty, this.isCustom = false});

  String getNameForLanguage(AppLanguage language) {
    return name.getForLanguage(language);
  }

  factory Punishment.fromJson(Map<String, dynamic> json, PunishmentDifficulty difficulty) => Punishment(
    id: json['id'],
    name: LocalizedString.fromJson(json['name']),
    difficulty: difficulty,
    isCustom: json['isCustom'] ?? false,
  );
}
