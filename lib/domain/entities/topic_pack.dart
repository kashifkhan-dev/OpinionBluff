import 'package:impostor/presentation/viewmodels/locale_view_model.dart';

class LocalizedString {
  final Map<String, String> _values;

  LocalizedString(this._values);

  factory LocalizedString.fromJson(dynamic json) {
    if (json is String) {
      return LocalizedString({'en': json, 'fr': json, 'es': json});
    }
    return LocalizedString(Map<String, String>.from(json as Map));
  }

  String getForLanguage(AppLanguage lang) {
    return _values[lang.code] ?? _values['en'] ?? '';
  }
}

class TopicPack {
  final String id;
  final LocalizedString title;
  final List<LocalizedString> topics;

  TopicPack({required this.id, required this.title, required this.topics});

  factory TopicPack.fromJson(Map<String, dynamic> json) {
    return TopicPack(
      id: json['id'],
      title: LocalizedString.fromJson(json['title']),
      topics: (json['topics'] as List).map((t) => LocalizedString.fromJson(t)).toList(),
    );
  }
}
