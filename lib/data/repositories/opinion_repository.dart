import 'dart:convert';
import 'package:flutter/services.dart';

class TopicPack {
  final String id;
  final String title;
  final List<String> topics;

  TopicPack({required this.id, required this.title, required this.topics});

  factory TopicPack.fromJson(Map<String, dynamic> json) {
    return TopicPack(id: json['id'], title: json['title'], topics: List<String>.from(json['topics']));
  }
}

class OpinionRepository {
  Future<List<TopicPack>> loadPacks() async {
    final String response = await rootBundle.loadString('assets/topics.json');
    final data = await json.decode(response);
    final List packsJson = data['packs'];
    return packsJson.map((json) => TopicPack.fromJson(json)).toList();
  }

  Future<List<String>> getTopicsForPack(String packTitle) async {
    final packs = await loadPacks();
    final pack = packs.firstWhere((p) => p.title.toLowerCase() == packTitle.toLowerCase(), orElse: () => packs.first);
    return pack.topics;
  }
}
