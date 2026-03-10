import 'package:flutter/material.dart';

class LocaleProvider with ChangeNotifier {
  Locale _locale = const Locale('ar', 'AE');

  Locale get locale => _locale;

  void setLocale(Locale locale) {
    if (!['ar', 'en', 'fr'].contains(locale.languageCode)) return;
    _locale = locale;
    notifyListeners();
  }

  void clearLocale() {
    _locale = const Locale('ar', 'AE');
    notifyListeners();
  }

  String getLanguageName() {
    switch (_locale.languageCode) {
      case 'ar':
        return 'العربية';
      case 'en':
        return 'English';
      case 'fr':
        return 'Français';
      default:
        return 'العربية';
    }
  }

  TextDirection get textDirection {
    return _locale.languageCode == 'ar' ? TextDirection.rtl : TextDirection.ltr;
  }

  // دالة مساعدة للترجمة السريعة
  String translate(Map<String, String> translations) {
    return translations[_locale.languageCode] ?? translations['ar'] ?? '';
  }
}