import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/locale_provider.dart';
import '../providers/theme_provider.dart';
import 'property_book_request_screen.dart';
import 'property_book_copy_request_screen.dart';
import 'home_screen.dart';

class PropertyBookSelectionScreen extends StatelessWidget {
  const PropertyBookSelectionScreen({super.key});

  static const Color primaryGreen = Color(0xFF1A5632);
  static const Color primaryDark = Color(0xFF0D3D20);
  static const Color secondaryGold = Color(0xFFC49B63);
  static const Color accentBrown = Color(0xFF8B6F47);
  static const Color bgLight = Color(0xFFF8F6F1);
  static const Color darkBg = Color(0xFF1A1A1A);
  static const Color darkCard = Color(0xFF2D2D2D);

  static const Map<String, Map<String, String>> translations = {
    'title': {'ar': 'الدفتر العقاري', 'en': 'Property Book', 'fr': 'Livre Foncier'},
    'subtitle': {'ar': 'اختر نوع الخدمة', 'en': 'Select Service', 'fr': 'Choisir le Service'},
    'create': {'ar': 'إنشاء دفتر', 'en': 'Create Book', 'fr': 'Créer un Livre'},
    'copy': {'ar': 'نسخة دفتر', 'en': 'Book Copy', 'fr': 'Copie du Livre'},
    'createDesc': {'ar': 'طلب إنشاء دفتر عقاري جديد', 'en': 'Request new property book', 'fr': 'Demander un nouveau livre'},
    'copyDesc': {'ar': 'طلب نسخة من دفتر موجود', 'en': 'Request copy of existing book', 'fr': 'Demander une copie d\'un livre existant'},
  };

  String t(String key, BuildContext context) {
    final locale = Provider.of<LocaleProvider>(context).locale.languageCode;
    return translations[key]?[locale] ?? translations[key]?['ar'] ?? key;
  }

  void _goBack(BuildContext context) {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    final locale = Provider.of<LocaleProvider>(context).locale.languageCode;

    return Scaffold(
      backgroundColor: isDark ? darkBg : bgLight,
      body: Stack(
        children: [
          Container(
            height: 200,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [primaryGreen, primaryDark],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => _goBack(context),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            locale == 'ar' ? Icons.arrow_forward : Icons.arrow_back,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        t('title', context),
                        style: GoogleFonts.tajawal(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      const SizedBox(width: 40),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(
                    t('subtitle', context),
                    style: GoogleFonts.tajawal(fontSize: 16, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 40),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        Expanded(
                          child: _buildOption(
                            context,
                            icon: Icons.note_add,
                            title: t('create', context),
                            description: t('createDesc', context),
                            color: primaryGreen,
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const PropertyBookRequestScreen()),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Expanded(
                          child: _buildOption(
                            context,
                            icon: Icons.copy,
                            title: t('copy', context),
                            description: t('copyDesc', context),
                            // ✅ تغيير اللون من secondaryGold إلى primaryGreen
                            color: primaryGreen,
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const PropertyBookCopyRequestScreen()),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required Color color,
    required VoidCallback onTap,
  }) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    final locale = Provider.of<LocaleProvider>(context).locale.languageCode;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color, color.withOpacity(0.7)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.4),
              blurRadius: 15,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(icon, color: Colors.white, size: 30),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.tajawal(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: GoogleFonts.tajawal(
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              locale == 'ar' ? Icons.arrow_back_ios : Icons.arrow_forward_ios,
              color: Colors.white,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}