enum PunishmentDifficulty { low, hard, veryHard }

class Punishment {
  final String id;
  final String name;
  final PunishmentDifficulty difficulty;
  final bool isCustom;

  Punishment({required this.id, required this.name, required this.difficulty, this.isCustom = false});

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'difficulty': difficulty.index, 'isCustom': isCustom};

  factory Punishment.fromJson(Map<String, dynamic> json) => Punishment(
    id: json['id'],
    name: json['name'],
    difficulty: PunishmentDifficulty.values[json['difficulty']],
    isCustom: json['isCustom'] ?? false,
  );
}
