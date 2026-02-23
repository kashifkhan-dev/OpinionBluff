import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:opinion_bluff/core/localization/app_localizations.dart';

enum AppLanguage {
  english('en'),
  french('fr'),
  spanish('es');

  final String code;
  const AppLanguage(this.code);

  static AppLanguage fromCode(String code) {
    return AppLanguage.values.firstWhere((lang) => lang.code == code, orElse: () => AppLanguage.english);
  }
}

class LocaleViewModel extends ChangeNotifier {
  static const String _prefKey = 'app_language';
  AppLanguage _currentLanguage = AppLanguage.english;
  AppLocalizations _l10n = AppLocalizations(AppLanguage.english);

  LocaleViewModel() {
    _loadSavedLanguage();
  }

  AppLanguage get currentLanguage => _currentLanguage;
  AppLocalizations get l10n => _l10n;

  Future<void> _loadSavedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final String? code = prefs.getString(_prefKey);
    if (code != null) {
      _currentLanguage = AppLanguage.fromCode(code);
      _l10n = AppLocalizations(_currentLanguage);
      notifyListeners();
    }
  }

  Future<void> setLanguage(AppLanguage lang) async {
    if (_currentLanguage != lang) {
      _currentLanguage = lang;
      _l10n = AppLocalizations(_currentLanguage);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_prefKey, lang.code);
      notifyListeners();
    }
  }
}
