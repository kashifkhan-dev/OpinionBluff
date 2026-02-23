import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:opinion_bluff/domain/entities/topic_pack.dart';
import 'package:opinion_bluff/presentation/viewmodels/locale_view_model.dart';

class OpinionRepository {
  Future<List<TopicPack>> loadPacks() async {
    final String response = await rootBundle.loadString('assets/topics.json');
    final data = await json.decode(response);
    final List packsJson = data['packs'];
    return packsJson.map((json) => TopicPack.fromJson(json)).toList();
  }

  Future<List<String>> getTopicsForPack(String packId, AppLanguage language) async {
    final packs = await loadPacks();
    final pack = packs.firstWhere((p) => p.id == packId, orElse: () => packs.first);
    return pack.topics.map((t) => t.getForLanguage(language)).toList();
  }
}
