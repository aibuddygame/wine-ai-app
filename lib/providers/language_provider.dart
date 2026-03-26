import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider extends ChangeNotifier {
  static const String _languageKey = 'app_language';
  
  Locale _currentLocale = const Locale('en');
  
  Locale get currentLocale => _currentLocale;
  
  bool get isEnglish => _currentLocale.languageCode == 'en';
  bool get isTraditionalChinese => _currentLocale.languageCode == 'zh';

  LanguageProvider() {
    _loadLanguagePreference();
  }

  Future<void> _loadLanguagePreference() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final languageCode = prefs.getString(_languageKey);
      if (languageCode != null) {
        _currentLocale = Locale(languageCode);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading language preference: $e');
    }
  }

  Future<void> setLocale(Locale locale) async {
    if (_currentLocale == locale) return;
    
    _currentLocale = locale;
    notifyListeners();
    
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_languageKey, locale.languageCode);
    } catch (e) {
      debugPrint('Error saving language preference: $e');
    }
  }

  void toggleLanguage() {
    if (isEnglish) {
      setLocale(const Locale('zh', 'TW'));
    } else {
      setLocale(const Locale('en'));
    }
  }
}
