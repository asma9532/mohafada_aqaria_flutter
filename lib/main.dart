import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'providers/theme_provider.dart';
import 'providers/locale_provider.dart';
import 'providers/auth_provider.dart';
import 'providers/admin_provider.dart';
import 'screens/home_screen.dart';
import 'screens/negative_certificate_screen.dart';
import 'screens/appointment_booking_screen.dart';
import 'screens/language_screen.dart';
import 'screens/admin_login_screen.dart';
import 'screens/admin_dashboard_screen.dart';
import 'screens/login_screen.dart'; // ✅ أضف هذا السطر
import 'screens/register_screen.dart'; // ✅ أضف هذا السطر
import 'providers/user_provider.dart';
import 'providers/request_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()), // ✅ للتسجيل والدخول
        ChangeNotifierProvider(create: (_) => AdminProvider()),
          ChangeNotifierProvider(create: (_) => UserProvider()), // 👈 ضيفي هذا
          ChangeNotifierProvider(create: (_) => RequestProvider()),
      ],
      child: Consumer3<ThemeProvider, LocaleProvider, AuthProvider>(
        builder: (context, themeProvider, localeProvider, authProvider, child) {
          return Directionality(
            textDirection: localeProvider.textDirection,
            child: MaterialApp(
              title: 'المحافظة العقارية - أولاد جلال',
              debugShowCheckedModeBanner: false,
              
              localizationsDelegates: const [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: const [
                Locale('ar', 'AE'),
                Locale('en', 'US'),
                Locale('fr', 'FR'),
              ],
              locale: localeProvider.locale,
              
              theme: ThemeData(
                brightness: Brightness.light,
                primaryColor: const Color(0xFF1A5632),
                scaffoldBackgroundColor: const Color(0xFFF8F6F1),
                textTheme: GoogleFonts.tajawalTextTheme(),
              ),
              
              darkTheme: ThemeData(
                brightness: Brightness.dark,
                primaryColor: const Color(0xFF2D6A4F),
                scaffoldBackgroundColor: const Color(0xFF1A1A1A),
                textTheme: GoogleFonts.tajawalTextTheme(ThemeData.dark().textTheme),
              ),
              
              themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
              
              home: const HomeScreen(),
              
              routes: {
                '/negative/new': (context) => const NegativeCertificateScreen(),
                '/language': (context) => const LanguageScreen(),
                '/admin/login': (context) => const AdminLoginScreen(),
                '/admin/dashboard': (context) => const AdminDashboardScreen(),
                '/login': (context) => const LoginScreen(), // ✅ صفحة تسجيل الدخول
                '/register': (context) => const RegisterScreen(), // ✅ صفحة إنشاء حساب
               
              },
            ),
          );
        },
      ),
    );
  }
}