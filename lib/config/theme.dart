import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // ==================== الألوان المشتركة ====================
  static const Color gold = Color(0xFFD4A574);
  static const Color lightGold = Color(0xFFE8D5B7);
  static const Color darkGold = Color(0xFFB8956A);
  
  // ==================== Light Mode ====================
  static const Color lightPrimaryGreen = Color(0xFF1B4D3E);
  static const Color lightDarkGreen = Color(0xFF0D3328);
  static const Color lightLightGreen = Color(0xFF2D6A4F);
  static const Color lightCream = Color(0xFFF5F1E8);
  static const Color lightWhite = Colors.white;
  static const Color lightDarkText = Color(0xFF1A1A1A);
  static const Color lightGreyText = Color(0xFF6B7280);

  // ==================== Dark Mode ====================
  static const Color darkPrimaryGreen = Color(0xFF2D6A4F);
  static const Color darkDarkGreen = Color(0xFF1B4D3E);
  static const Color darkDarkerGreen = Color(0xFF0D3328);
  static const Color darkSurface = Color(0xFF1E2A23);
  static const Color darkCard = Color(0xFF26362D);
  static const Color darkText = Color(0xFFE8E8E8);
  static const Color darkGreyText = Color(0xFF9CA3AF);

  // ==================== التدرجات ====================
  static const LinearGradient lightGradient = LinearGradient(
    colors: [lightPrimaryGreen, lightDarkGreen],
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
  );

  static const LinearGradient darkGradient = LinearGradient(
    colors: [darkPrimaryGreen, darkDarkGreen],
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
  );

  static const LinearGradient goldGradient = LinearGradient(
    colors: [gold, darkGold],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ==================== الظلال ====================
  static List<BoxShadow> lightShadow = [
    BoxShadow(
      color: lightPrimaryGreen.withOpacity(0.25),
      blurRadius: 20,
      offset: const Offset(0, 8),
    ),
  ];

  static List<BoxShadow> darkShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.4),
      blurRadius: 20,
      offset: const Offset(0, 8),
    ),
  ];

  // ==================== الثيمات ====================
  
  // Light Theme
  static ThemeData get lightTheme {
    return _buildTheme(
      isDark: false,
      primaryColor: lightPrimaryGreen,
      scaffoldColor: lightCream,
      cardColor: lightWhite,
      textColor: lightDarkText,
      greyColor: lightGreyText,
      gradient: lightGradient,
      shadow: lightShadow,
    );
  }

  // Dark Theme
  static ThemeData get darkTheme {
    return _buildTheme(
      isDark: true,
      primaryColor: darkPrimaryGreen,
      scaffoldColor: darkDarkerGreen,
      cardColor: darkCard,
      textColor: darkText,
      greyColor: darkGreyText,
      gradient: darkGradient,
      shadow: darkShadow,
    );
  }

  // بناء الثيم
  static ThemeData _buildTheme({
    required bool isDark,
    required Color primaryColor,
    required Color scaffoldColor,
    required Color cardColor,
    required Color textColor,
    required Color greyColor,
    required LinearGradient gradient,
    required List<BoxShadow> shadow,
  }) {
    return ThemeData(
      useMaterial3: true,
      brightness: isDark ? Brightness.dark : Brightness.light,
      scaffoldBackgroundColor: scaffoldColor,
      primaryColor: primaryColor,
      
      // الألوان
      colorScheme: ColorScheme(
        brightness: isDark ? Brightness.dark : Brightness.light,
        primary: primaryColor,
        onPrimary: Colors.white,
        secondary: gold,
        onSecondary: isDark ? Colors.black : lightDarkGreen,
        surface: cardColor,
        onSurface: textColor,
        error: Colors.red,
        onError: Colors.white,
      ),
      
      // الخط
      textTheme: GoogleFonts.cairoTextTheme(
        isDark ? ThemeData.dark().textTheme : ThemeData.light().textTheme,
      ).apply(
        bodyColor: textColor,
        displayColor: textColor,
      ),
      
      // AppBar
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: primaryColor,
        titleTextStyle: GoogleFonts.cairo(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      
      // البطاقات
      // ✅ صح
cardTheme: CardThemeData(
  elevation: isDark ? 0 : 2,
  color: cardColor,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(16),
  ),
),
      
      // الأزرار
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: gold,
          foregroundColor: isDark ? Colors.black : lightDarkGreen,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.cairo(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      
      // حقول النص
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? darkSurface : lightWhite,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: gold, width: 2),
        ),
      ),
      
      // الـ Drawer
      drawerTheme: DrawerThemeData(
        backgroundColor: isDark ? darkDarkGreen : lightPrimaryGreen,
      ),
      
      // Bottom Navigation
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: primaryColor,
        selectedItemColor: gold,
        unselectedItemColor: isDark ? darkGreyText : Colors.white70,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
    );
  }

  // ==================== دوال مساعدة ====================
  
  static bool isDark(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  static Color getPrimaryColor(BuildContext context) {
    return isDark(context) ? darkPrimaryGreen : lightPrimaryGreen;
  }

  static Color getScaffoldColor(BuildContext context) {
    return isDark(context) ? darkDarkerGreen : lightCream;
  }

  static Color getCardColor(BuildContext context) {
    return isDark(context) ? darkCard : lightWhite;
  }

  static Color getTextColor(BuildContext context) {
    return isDark(context) ? darkText : lightDarkText;
  }

  static Color getGreyColor(BuildContext context) {
    return isDark(context) ? darkGreyText : lightGreyText;
  }

  static LinearGradient getGradient(BuildContext context) {
    return isDark(context) ? darkGradient : lightGradient;
  }

  static List<BoxShadow> getShadow(BuildContext context) {
    return isDark(context) ? darkShadow : lightShadow;
  }
}