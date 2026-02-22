import 'package:flutter/material.dart';

enum AppLanguage {
  english('en'),
  french('fr'),
  spanish('es');

  final String code;
  const AppLanguage(this.code);
}

class LocaleViewModel extends ChangeNotifier {
  AppLanguage _currentLanguage = AppLanguage.english;
  AppLanguage get currentLanguage => _currentLanguage;

  void setLanguage(AppLanguage lang) {
    if (_currentLanguage != lang) {
      _currentLanguage = lang;
      notifyListeners();
    }
  }
}
