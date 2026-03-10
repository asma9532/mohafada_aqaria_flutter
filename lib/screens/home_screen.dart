// lib/screens/home_screen.dart - النسخة الكاملة المصححة

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'dart:math' as math;
import '../providers/theme_provider.dart';
import '../providers/locale_provider.dart';
import '../providers/auth_provider.dart';
import '../providers/admin_provider.dart';
import '../widgets/translatable_text.dart';
import '../widgets/admin_edit_button.dart';
import 'negative_certificate_screen.dart';
import 'card_type_selection_screen.dart';
import 'property_book_selection_screen.dart';
import 'appointment_booking_screen.dart';
import 'language_screen.dart';
import 'login_screen.dart';
import 'admin_login_screen.dart';
import 'admin_dashboard_screen.dart';
import 'contact_us_screen.dart';
import 'new_users_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  static const Color primaryGreen = Color(0xFF1A5632);
  static const Color primaryDark = Color(0xFF0D3D20);
  static const Color secondaryGold = Color(0xFFC49B63);
  static const Color accentBrown = Color(0xFF8B6F47);
  static const Color textDark = Color(0xFF2D2D2D);
  static const Color textLight = Color(0xFF6B6B6B);
  static const Color darkBg = Color(0xFF1A1A1A);
  static const Color darkCard = Color(0xFF2D2D2D);
  static const Color darkText = Color(0xFFE8E8E8);

  int _selectedIndex = 0;

  late AnimationController _fadeCtrl;
  late Animation<double> _fadeAnim;
  late AnimationController _heroCtrl;
  late Animation<double> _heroAnim;
  late AnimationController _pulseCtrl;

  late PageController _svcPageCtrl;
  int _svcPage = 0;
  Timer? _svcTimer;
  bool _isPageViewReady = false;

  final List<Map<String, dynamic>> _navItems = [
    {'icon': Icons.home_rounded, 'key': 'home'},
    {'icon': Icons.description_rounded, 'key': 'certificate'},
    {'icon': Icons.folder_open_rounded, 'key': 'documents'},
    {'icon': Icons.menu_book_rounded, 'key': 'property_book'},
    {'icon': Icons.calendar_today_rounded, 'key': 'appointment'},
    {'icon': Icons.contact_page_rounded, 'key': 'contact'},
  ];

  final List<Map<String, dynamic>> _services = [
    {
      'icon': Icons.description_rounded,
      'key': 'negative_certificate',
      'navIndex': 1,
    },
    {
      'icon': Icons.folder_open_rounded,
      'key': 'real_estate_docs',
      'navIndex': 2,
    },
    {
      'icon': Icons.menu_book_rounded,
      'key': 'property_book_service',
      'navIndex': 3,
    },
    {
      'icon': Icons.calendar_today_rounded,
      'key': 'appointment_service',
      'navIndex': 4,
    },
    {
      'icon': Icons.contact_page_rounded,
      'key': 'contact_service',
      'navIndex': 5,
    },
  ];

  final Map<String, Map<String, String>> _tr = {
    'home': {'ar': 'الرئيسية', 'en': 'Home', 'fr': 'Accueil'},
    'certificate': {'ar': 'الشهادة', 'en': 'Certificate', 'fr': 'Certificat'},
    'documents': {'ar': 'الوثائق', 'en': 'Documents', 'fr': 'Documents'},
    'property_book': {'ar': 'الدفتر', 'en': 'Property Book', 'fr': 'Livre Foncier'},
    'appointment': {'ar': 'الموعد', 'en': 'Appointment', 'fr': 'Rendez-vous'},
    'contact': {'ar': 'اتصل بنا', 'en': 'Contact Us', 'fr': 'Contactez-nous'},

    'negative_certificate': {
      'ar': 'شهادة سلبية',
      'en': 'Negative Certificate',
      'fr': 'Certificat Négatif'
    },
    'real_estate_docs': {
      'ar': 'الوثائق العقارية',
      'en': 'Real Estate Documents',
      'fr': 'Documents Fonciers'
    },
    'property_book_service': {
      'ar': 'الدفتر العقاري',
      'en': 'Property Book',
      'fr': 'Livre Foncier'
    },
    'appointment_service': {
      'ar': 'حجز موعد',
      'en': 'Book Appointment',
      'fr': 'Rendez-vous'
    },
    'contact_service': {
      'ar': 'اتصل بنا',
      'en': 'Contact Us',
      'fr': 'Contactez-nous'
    },

    'electronicServices': {
      'ar': 'الخدمات الإلكترونية',
      'en': 'Electronic Services',
      'fr': 'Services Électroniques'
    },
    'requests': {'ar': 'طلب', 'en': 'Requests', 'fr': 'Demandes'},
    'satisfaction': {'ar': 'رضا', 'en': 'Satisfaction', 'fr': 'Satisfaction'},
    'support': {'ar': 'دعم', 'en': 'Support', 'fr': 'Support'},
    'services': {'ar': 'خدماتنا', 'en': 'Our Services', 'fr': 'Nos Services'},
    'guest': {'ar': 'زائر', 'en': 'Guest', 'fr': 'Invité'},
    'login': {'ar': 'تسجيل الدخول', 'en': 'Login', 'fr': 'Se connecter'},
    'logout': {'ar': 'تسجيل الخروج', 'en': 'Logout', 'fr': 'Déconnexion'},
    'logoutConfirmation': {
      'ar': 'هل أنت متأكد من تسجيل الخروج؟',
      'en': 'Are you sure you want to logout?',
      'fr': 'Êtes-vous sûr de vouloir vous déconnecter?'
    },
    'cancel': {'ar': 'إلغاء', 'en': 'Cancel', 'fr': 'Annuler'},
    'logoutSuccess': {
      'ar': 'تم تسجيل الخروج بنجاح',
      'en': 'Logged out successfully',
      'fr': 'Déconnexion réussie'
    },
    'darkMode': {'ar': 'الوضع المظلم', 'en': 'Dark Mode', 'fr': 'Mode Sombre'},
    'lightMode': {'ar': 'الوضع الفاتح', 'en': 'Light Mode', 'fr': 'Mode Clair'},
    'language': {'ar': 'اللغة', 'en': 'Language', 'fr': 'Langue'},
    'contactUs': {'ar': 'اتصل بنا', 'en': 'Contact Us', 'fr': 'Contactez-nous'},


    'propertyManagementSystem': {
      'ar': 'نظام تسيير المعاملات العقارية',
      'en': 'Real Estate Transactions Management System',
      'fr': 'Système de Gestion des Transactions Immobilières'
    },
    'integrated_solution': {
      'ar': 'حل متكامل لإدارة ومتابعة جميع المعاملات العقارية بكفاءة وشفافية',
      'en': 'Integrated solution for managing and tracking all real estate transactions efficiently and transparently',
      'fr': 'Solution intégrée pour gérer et suivre toutes les transactions immobilières efficacement et en transparence'
    },
    'browse_services': {
      'ar': 'استعرض خدماتنا',
      'en': 'Browse Our Services',
      'fr': 'Parcourir nos services'
    },
  };

  String t(String key) {
    final lang = Provider.of<LocaleProvider>(context, listen: false).locale.languageCode;
    return _tr[key]?[lang] ?? _tr[key]?['ar'] ?? key;
  }

  Widget _txt(String text,
      {double? fs, Color? c, FontWeight? fw, TextAlign? ta, double? h}) {
    return Text(
      text,
      textAlign: ta,
      style: GoogleFonts.tajawal(
        fontSize: fs,
        color: c,
        fontWeight: fw,
        height: h,
      ).copyWith(fontFamilyFallback: ['NotoSansArabic', 'Arial']),
    );
  }

  @override
  void initState() {
    super.initState();

    _fadeCtrl = AnimationController(duration: const Duration(milliseconds: 500), vsync: this);
    _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);
    _fadeCtrl.forward();

    _heroCtrl = AnimationController(duration: const Duration(milliseconds: 900), vsync: this);
    _heroAnim = CurvedAnimation(parent: _heroCtrl, curve: Curves.easeOutCubic);
    _heroCtrl.forward();

    _pulseCtrl = AnimationController(duration: const Duration(milliseconds: 2000), vsync: this)
      ..repeat(reverse: true);

    _svcPageCtrl = PageController(viewportFraction: 0.72, initialPage: 0);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _isPageViewReady = true;
      });
      _startTimer();
    });
  }

  void _startTimer() {
    _svcTimer?.cancel();
    _svcTimer = Timer.periodic(const Duration(milliseconds: 2800), (timer) {
      if (!mounted || !_isPageViewReady) return;
      try {
        final next = (_svcPage + 1) % _services.length;
        _svcPageCtrl.animateToPage(
          next,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      } catch (e) {
        print('⚠️ خطأ في التمرير التلقائي: $e');
      }
    });
  }

  @override
  void dispose() {
    _svcTimer?.cancel();
    _svcTimer = null;
    _svcPageCtrl.dispose();
    _fadeCtrl.dispose();
    _heroCtrl.dispose();
    _pulseCtrl.dispose();
    super.dispose();
  }

  Widget _buildBody(String lang, bool isAdmin) {
    switch (_selectedIndex) {
      case 1:
        return const NegativeCertificateScreen();
      case 2:
        return const CardTypeSelectionScreen();
      case 3:
        return const PropertyBookSelectionScreen();
      case 4:
        return const AppointmentBookingScreen();
      case 5:
        return const ContactUsScreen();
      default:
        return _buildHomePage(isAdmin);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    final locale = Provider.of<LocaleProvider>(context);
    final auth = Provider.of<AuthProvider>(context);
    final admin = Provider.of<AdminProvider>(context);
    final isDark = theme.isDarkMode;
    final lang = locale.locale.languageCode;
    final isAdmin = admin.isAdmin;

    return Directionality(
      textDirection: locale.textDirection,
      child: Scaffold(
        backgroundColor: isDark ? darkBg : const Color(0xFFF4F8F5),
        extendBodyBehindAppBar: true,
        appBar: _appBar(isDark, locale, auth, admin, isAdmin),
        drawer: _drawer(lang, locale, auth, admin, isAdmin, isDark),
        body: Stack(children: [
          Positioned.fill(child: CustomPaint(painter: _BgPainter(isDark: isDark))),
          FadeTransition(opacity: _fadeAnim, child: _buildBody(lang, isAdmin)),
          if (isAdmin) ...[
            const Positioned(
                top: 45, right: 150, child: AdminEditButton(contentKey: 'home_hero_title')),
            const Positioned(
                top: 280, right: 30, child: AdminEditButton(contentKey: 'landManagement')),
          ],
        ]),
        bottomNavigationBar: _bottomNav(isDark),
      ),
    );
  }

  PreferredSizeWidget _appBar(bool isDark, LocaleProvider loc, AuthProvider auth,
      AdminProvider admin, bool isAdmin) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(70),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? darkCard.withOpacity(0.97) : Colors.white.withOpacity(0.97),
          border: Border(
            bottom: BorderSide(
              color: isDark ? Colors.white.withOpacity(0.06) : primaryGreen.withOpacity(0.08),
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.3 : 0.06),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            child: Row(children: [
              Builder(
                builder: (ctx) => _iconBtn(
                  Icons.menu_rounded,
                  isDark ? secondaryGold : primaryGreen,
                  () => Scaffold.of(ctx).openDrawer(),
                  isDark,
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _ministryLogo(isDark),
                  ],
                ),
              ),
              _iconBtn(
                Icons.admin_panel_settings_rounded,
                isDark ? secondaryGold : primaryGreen,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => admin.isAdmin
                          ? const AdminDashboardScreen()
                          : const AdminLoginScreen(),
                    ),
                  );
                },
                isDark,
              ),
              if (isAdmin)
                Container(
                  margin: const EdgeInsets.only(left: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(12)),
                  child: const Text(
                    'ADMIN',
                    style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
            ]),
          ),
        ),
      ),
    );
  }

  Widget _ministryLogo(bool isDark) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFF2E8B8B), width: 2.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2E8B8B).withOpacity(0.3),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      child: ClipOval(
        child: Image.asset(
          'assets/images/ministry_logo.png',
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _iconBtn(IconData icon, Color color, VoidCallback onTap, bool isDark) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: color, size: 22),
      ),
    );
  }

  Widget _drawer(String lang, LocaleProvider loc, AuthProvider auth,
      AdminProvider admin, bool isAdmin, bool isDark) {
    final theme = Provider.of<ThemeProvider>(context);
    final isLogged = auth.isLoggedIn;
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.82,
      child: Container(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        child: Column(children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(24, 60, 24, 32),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [primaryDark, primaryGreen],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(children: [
              Container(
                width: 86,
                height: 86,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: secondaryGold, width: 2.5),
                  boxShadow: [
                    BoxShadow(
                      color: secondaryGold.withOpacity(0.25),
                      blurRadius: 16,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: CircleAvatar(
                  backgroundColor: Colors.white.withOpacity(0.12),
                  child: Icon(
                    isLogged ? Icons.person_rounded : Icons.person_outline_rounded,
                    color: secondaryGold,
                    size: 42,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              _txt(
                isLogged ? auth.displayName : t('guest'),
                fs: 20,
                c: Colors.white,
                fw: FontWeight.bold,
              ),
              const SizedBox(height: 4),
              _txt(
                isLogged ? auth.displayEmail : 'guest@email.com',
                fs: 13,
                c: Colors.white60,
              ),
              const SizedBox(height: 18),
              // ✅ زر تسجيل الدخول/الخروج يبقى هنا فقط تحت اسم المستخدم
              _drawerBtn(
                icon: isLogged ? Icons.logout_rounded : Icons.login_rounded,
                label: isLogged ? t('logout') : t('login'),
                bg: isLogged ? Colors.red.shade400 : secondaryGold,
                fg: isLogged ? Colors.white : primaryDark,
                onTap: () {
                  Navigator.pop(context);
                  if (isLogged) {
                    _logoutDialog(auth, lang);
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                    );
                  }
                },
              ),
            ]),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              children: [
                const SizedBox(height: 8),
                _drawerTile(
                  isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                  isDark ? t('lightMode') : t('darkMode'),
                  isDark,
                  () {
                    theme.toggleTheme();
                    Navigator.pop(context);
                  },
                ),
                Divider(
                  height: 16,
                  color: isDark ? Colors.white10 : Colors.black.withOpacity(0.06),
                ),
                _drawerTile(
                  Icons.language_rounded,
                  '${t('language')} (${loc.getLanguageName()})',
                  isDark,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LanguageScreen()),
                    );
                  },
                ),
                // ✅ اتصل بنا تفتح صفحة ContactUsScreen مباشرة
                _drawerTile(
                  Icons.contact_page_rounded,
                  t('contactUs'),
                  isDark,
                  () {
                    Navigator.pop(context);
                    setState(() => _selectedIndex = 5);
                  },
                ),
                
                // ✅ حُذف زر تسجيل الخروج من القائمة - يوجد فقط في الهيدر أعلاه
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: _txt(
              '© 2026 المحافظة العقارية',
              fs: 11,
              c: isDark ? Colors.white24 : textLight.withOpacity(0.5),
            ),
          ),
        ]),
      ),
    );
  }

  Widget _drawerBtn({
    required IconData icon,
    required String label,
    required Color bg,
    required Color fg,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: bg.withOpacity(0.35),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: fg, size: 18),
            const SizedBox(width: 8),
            _txt(
              label,
              c: fg,
              fw: FontWeight.bold,
              fs: 15,
            ),
          ],
        ),
      ),
    );
  }

  Widget _drawerTile(IconData icon, String title, bool isDark, VoidCallback onTap,
      {Color? color}) {
    final c = color ?? (isDark ? secondaryGold : primaryGreen);
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        tileColor: c.withOpacity(0.06),
        leading: Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: c.withOpacity(0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: c, size: 20),
        ),
        title: _txt(
          title,
          fs: 15,
          c: isDark ? darkText : textDark,
          fw: FontWeight.w600,
        ),
        trailing: Icon(
          Icons.chevron_right_rounded,
          color: isDark ? Colors.white24 : Colors.black12,
          size: 18,
        ),
        onTap: onTap,
      ),
    );
  }

  void _logoutDialog(AuthProvider auth, String lang) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: _txt(t('logout'), fw: FontWeight.bold),
        content: _txt(t('logoutConfirmation')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: _txt(t('cancel'), c: Colors.grey),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              auth.logout();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: _txt(t('logoutSuccess')),
                  backgroundColor: Colors.green,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              );
            },
            child: _txt(t('logout')),
          ),
        ],
      ),
    );
  }

  Widget _buildHomePage(bool isAdmin) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(children: [
        _heroSection(),
        _servicesSlider(),
        const SizedBox(height: 32),
      ]),
    );
  }

  Widget _heroSection() {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    return AnimatedBuilder(
      animation: _heroAnim,
      builder: (context, child) => Opacity(
        opacity: _heroAnim.value.clamp(0.0, 1.0),
        child: Transform.translate(
          offset: Offset(0, 28 * (1 - _heroAnim.value)),
          child: child,
        ),
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(24, 104, 24, 40),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [darkCard, const Color(0xFF1E2B24)]
                : [Colors.white, const Color(0xFFEDF5F0)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
            decoration: BoxDecoration(
              color: primaryGreen.withOpacity(0.08),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: primaryGreen.withOpacity(0.25)),
            ),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              AnimatedBuilder(
                animation: _pulseCtrl,
                builder: (context, child) => Container(
                  width: 7,
                  height: 7,
                  decoration: BoxDecoration(
                    color: primaryGreen,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: primaryGreen.withOpacity(0.3 + _pulseCtrl.value * 0.3),
                        blurRadius: 4 + _pulseCtrl.value * 4,
                        spreadRadius: 0.5,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              _txt(
                t('electronicServices'),
                fs: 12,
                c: primaryGreen,
                fw: FontWeight.w700,
              ),
            ]),
          ),
          const SizedBox(height: 22),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [primaryDark, primaryGreen, const Color(0xFF2A7040)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: const [0.1, 0.6, 0.9],
              ),
              borderRadius: BorderRadius.circular(32),
              boxShadow: [
                BoxShadow(
                  color: primaryGreen.withOpacity(0.4),
                  blurRadius: 30,
                  offset: const Offset(0, 15),
                  spreadRadius: -5,
                ),
                BoxShadow(
                  color: primaryDark.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 5),
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Stack(
              children: [
                Positioned(
                  top: -20,
                  right: -20,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.05),
                    ),
                  ),
                ),
                Positioned(
                  bottom: -30,
                  left: -30,
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.03),
                    ),
                  ),
                ),
                Positioned(
                  top: 30,
                  left: 20,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: secondaryGold.withOpacity(0.15),
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: const Icon(
                        Icons.account_balance_rounded,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const TranslatableText(
                      'propertyManagementSystem',
                      fallback: 'نظام تسيير المعاملات العقارية',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        height: 1.3,
                        letterSpacing: 0.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Container(
                      width: 80,
                      height: 3,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [secondaryGold, Colors.white, secondaryGold],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                          width: 0.5,
                        ),
                      ),
                      child: const TranslatableText(
                        'integrated_solution',
                        fallback: 'حل متكامل لإدارة ومتابعة جميع المعاملات العقارية بكفاءة وشفافية',
                        style: TextStyle(
                          fontSize: 15,
                          color: Color(0xCCFFFFFF),
                          height: 1.6,
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 24),
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [secondaryGold, accentBrown, secondaryGold],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(50),
                          boxShadow: [
                            BoxShadow(
                              color: secondaryGold.withOpacity(0.4),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                              spreadRadius: -2,
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.grid_view_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                            const SizedBox(width: 10),
                            const TranslatableText(
                              'browse_services',
                              fallback: 'استعرض خدماتنا',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                fontFamily: 'Tajawal',
                              ),
                            ),
                            const SizedBox(width: 10),
                            Container(
                              width: 26,
                              height: 26,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.25),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.arrow_downward_rounded,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            decoration: BoxDecoration(
              color: isDark ? darkCard : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: primaryGreen.withOpacity(0.12)),
              boxShadow: [
                BoxShadow(
                  color: primaryGreen.withOpacity(0.07),
                  blurRadius: 14,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _stat('1200+', t('requests'), isDark),
                Container(width: 1, height: 36, color: primaryGreen.withOpacity(0.15)),
                _stat('98%', t('satisfaction'), isDark),
                Container(width: 1, height: 36, color: primaryGreen.withOpacity(0.15)),
                _stat('24/7', t('support'), isDark),
              ],
            ),
          ),
        ]),
      ),
    );
  }

  Widget _stat(String value, String label, bool isDark) {
    return Column(children: [
      _txt(value, fs: 22, c: primaryGreen, fw: FontWeight.bold),
      const SizedBox(height: 3),
      _txt(label, fs: 11, c: isDark ? darkText.withOpacity(0.6) : textLight),
    ]);
  }

  Widget _servicesSlider() {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    final locale = Provider.of<LocaleProvider>(context);
    final currentLang = locale.locale.languageCode;

    return Column(children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
        child: Row(children: [
          Container(
            width: 4,
            height: 22,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [primaryGreen, secondaryGold],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 10),
          _txt(t('services'), fs: 22, fw: FontWeight.bold, c: isDark ? darkText : textDark),
        ]),
      ),
      const SizedBox(height: 18),
      SizedBox(
        height: 160,
        child: PageView.builder(
          controller: _svcPageCtrl,
          onPageChanged: (i) {
            if (mounted) setState(() => _svcPage = i);
          },
          itemCount: _services.length,
          itemBuilder: (ctx, i) {
            final svc = _services[i];
            final isActive = _svcPage == i;
            final bgOpacity = isActive ? 0.88 : 0.52;

            String mainText = '';
            String subText = '';

            if (currentLang == 'ar') {
              mainText = _tr[svc['key']]?['ar'] ?? svc['key']!;
              subText = _tr[svc['key']]?['fr'] ?? _tr[svc['key']]?['en'] ?? svc['key']!;
            } else if (currentLang == 'fr') {
              mainText = _tr[svc['key']]?['fr'] ?? svc['key']!;
              subText = _tr[svc['key']]?['ar'] ?? _tr[svc['key']]?['en'] ?? svc['key']!;
            } else {
              mainText = _tr[svc['key']]?['en'] ?? svc['key']!;
              subText = _tr[svc['key']]?['fr'] ?? _tr[svc['key']]?['ar'] ?? svc['key']!;
            }

            return AnimatedContainer(
              duration: const Duration(milliseconds: 350),
              curve: Curves.easeOut,
              margin: EdgeInsets.symmetric(horizontal: 8, vertical: isActive ? 0 : 14),
              child: GestureDetector(
                onTap: () => setState(() {
                  _selectedIndex = svc['navIndex'] as int;
                  _fadeCtrl.reset();
                  _fadeCtrl.forward();
                }),
                child: Container(
                  decoration: BoxDecoration(
                    color: primaryGreen.withOpacity(bgOpacity),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: isActive
                        ? [
                            BoxShadow(
                              color: primaryGreen.withOpacity(0.40),
                              blurRadius: 22,
                              offset: const Offset(0, 10),
                            ),
                            BoxShadow(
                              color: primaryGreen.withOpacity(0.18),
                              blurRadius: 40,
                              offset: const Offset(0, 16),
                            ),
                          ]
                        : [
                            BoxShadow(
                              color: primaryGreen.withOpacity(0.12),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        top: -15,
                        right: -15,
                        child: Container(
                          width: 90,
                          height: 90,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.07),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: -10,
                        left: -10,
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.04),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.18),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Icon(svc['icon'] as IconData, color: Colors.white, size: 26),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _txt(mainText, fs: 15, c: Colors.white, fw: FontWeight.bold),
                                const SizedBox(height: 2),
                                _txt(subText, fs: 10, c: Colors.white.withOpacity(0.72)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: 16,
                        right: 16,
                        child: Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.18),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 15),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
      const SizedBox(height: 14),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(_services.length, (i) {
          final active = _svcPage == i;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: active ? 22 : 7,
            height: 7,
            decoration: BoxDecoration(
              color: active ? primaryGreen : primaryGreen.withOpacity(0.25),
              borderRadius: BorderRadius.circular(4),
            ),
          );
        }),
      ),
    ]);
  }

  Widget _bottomNav(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? darkCard : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 24,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(_navItems.length, (i) => _navItem(i, isDark)),
          ),
        ),
      ),
    );
  }

  Widget _navItem(int index, bool isDark) {
    final isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => setState(() {
        _selectedIndex = index;
        _fadeCtrl.reset();
        _fadeCtrl.forward();
      }),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        padding: EdgeInsets.symmetric(horizontal: isSelected ? 16 : 10, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? primaryGreen.withOpacity(0.12) : Colors.transparent,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _navItems[index]['icon'] as IconData,
              color: isSelected ? primaryGreen : (isDark ? Colors.grey[500] : textLight),
              size: isSelected ? 24 : 22,
            ),
            if (isSelected) ...[
              const SizedBox(width: 6),
              _txt(
                t(_navItems[index]['key'] as String),
                fs: 12,
                c: primaryGreen,
                fw: FontWeight.bold,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _BgPainter extends CustomPainter {
  final bool isDark;
  _BgPainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final lp = Paint()
      ..color = const Color(0xFF1A5632).withOpacity(isDark ? 0.03 : 0.05)
      ..strokeWidth = 0.7;
    for (int i = 0; i <= 10; i++) {
      canvas.drawLine(
        Offset(size.width * i / 10, 0),
        Offset(size.width * i / 10, size.height),
        lp,
      );
    }
    for (int i = 0; i <= 18; i++) {
      canvas.drawLine(
        Offset(0, size.height * i / 18),
        Offset(size.width, size.height * i / 18),
        lp,
      );
    }

    final cp = Paint();
    final circles = [
      [0.9, 0.04, 0.22, 0.04],
      [0.04, 0.1, 0.15, 0.03],
      [0.8, 0.4, 0.1, 0.035],
      [0.05, 0.55, 0.18, 0.025],
      [0.88, 0.72, 0.12, 0.032],
      [0.15, 0.85, 0.24, 0.038],
      [0.55, 0.95, 0.14, 0.03],
    ];
    for (final c in circles) {
      cp.color = const Color(0xFF1A5632).withOpacity(c[3] * (isDark ? 0.5 : 1.0));
      canvas.drawCircle(
        Offset(size.width * c[0], size.height * c[1]),
        size.width * c[2],
        cp,
      );
    }
  }

  @override
  bool shouldRepaint(_BgPainter oldDelegate) => oldDelegate.isDark != isDark;
}