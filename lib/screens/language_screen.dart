import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../providers/locale_provider.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  static const Color primary = Color(0xFF1A5632);
  static const Color primaryDark = Color(0xFF0D3D20);
  static const Color secondary = Color(0xFFC49B63);
  static const Color darkCard = Color(0xFF2D2D2D);
  static const Color darkBg = Color(0xFF1A1A1A);

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    final List<Map<String, dynamic>> languages = [
      {'code': 'ar', 'name': 'العربية', 'flag': '🇸🇦', 'locale': const Locale('ar', 'AE')},
      {'code': 'en', 'name': 'English', 'flag': '🇬🇧', 'locale': const Locale('en', 'US')},
      {'code': 'fr', 'name': 'Français', 'flag': '🇫🇷', 'locale': const Locale('fr', 'FR')},
    ];

    // ترجمات العنوان
    final Map<String, String> titles = {
      'ar': 'اختر اللغة',
      'en': 'Select Language',
      'fr': 'Choisir la langue',
    };

    return Directionality(
      textDirection: localeProvider.textDirection,
      child: Scaffold(
        backgroundColor: isDark ? darkBg : primary,
        body: SafeArea(
          child: Column(
            children: [
              // زر الرجوع
              Padding(
                padding: const EdgeInsets.all(16),
                child: Align(
                  alignment: localeProvider.locale.languageCode == 'ar' 
                      ? Alignment.topRight 
                      : Alignment.topLeft,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 1.5,
                        ),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              
              // العنوان
              Text(
                titles[localeProvider.locale.languageCode] ?? 'اختر اللغة',
                style: GoogleFonts.tajawal(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 32),
              
              // قائمة اللغات
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: isDark ? darkCard : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: languages.length,
                    itemBuilder: (context, index) {
                      final Map<String, dynamic> lang = languages[index];
                      final bool isSelected = localeProvider.locale.languageCode == lang['code'];
                      
                      return GestureDetector(
                        onTap: () {
                          localeProvider.setLocale(lang['locale'] as Locale);
                          Navigator.pop(context);
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: isSelected 
                                ? primary.withOpacity(0.1) 
                                : (isDark ? Colors.grey[800] : Colors.grey[100]),
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: isSelected ? primary : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          child: Row(
                            children: [
                              Text(
                                lang['flag'] as String,
                                style: const TextStyle(fontSize: 32),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  lang['name'] as String,
                                  style: GoogleFonts.tajawal(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: isDark ? Colors.white : Colors.black,
                                  ),
                                ),
                              ),
                              if (isSelected)
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: const BoxDecoration(
                                    color: primary,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}