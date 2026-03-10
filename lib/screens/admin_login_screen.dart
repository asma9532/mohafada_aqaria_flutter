// lib/screens/admin_login_screen.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../providers/locale_provider.dart';
import '../providers/admin_provider.dart';
import 'admin_dashboard_screen.dart';

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final _emailController = TextEditingController(); // 👈 نضيف حقل البريد
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  final Map<String, Map<String, String>> translations = {
    'adminLogin': {
      'ar': 'دخول الإدارة',
      'en': 'Admin Login',
      'fr': 'Connexion Admin',
    },
    'email': {
      'ar': 'البريد الإلكتروني',
      'en': 'Email',
      'fr': 'Email',
    },
    'emailHint': {
      'ar': 'admin@example.com',
      'en': 'admin@example.com',
      'fr': 'admin@example.com',
    },
    'password': {
      'ar': 'كلمة المرور',
      'en': 'Password',
      'fr': 'Mot de passe',
    },
    'login': {
      'ar': 'تسجيل الدخول',
      'en': 'Login',
      'fr': 'Se connecter',
    },
    'wrongCredentials': {
      'ar': 'البريد أو كلمة المرور غير صحيحة',
      'en': 'Wrong email or password',
      'fr': 'Email ou mot de passe incorrect',
    },
  };

  String t(String key) {
    final locale = Provider.of<LocaleProvider>(context, listen: false).locale.languageCode;
    return translations[key]?[locale] ?? translations[key]?['ar'] ?? key;
  }

  Future<void> _login() async {
    setState(() => _isLoading = true);

    final adminProvider = Provider.of<AdminProvider>(context, listen: false);
    
    // ✅ نستعمل الدالة الحقيقية
    final success = await adminProvider.loginAsAdmin(
      _emailController.text.trim(),
      _passwordController.text,
    );

    if (success && mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AdminDashboardScreen()),
      );
    } else if (mounted) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(t('wrongCredentials'), style: GoogleFonts.tajawal()),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final localeProvider = Provider.of<LocaleProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return Directionality(
      textDirection: localeProvider.textDirection,
      child: Scaffold(
        backgroundColor: isDark ? const Color(0xFF1A1A1A) : Colors.white,
        appBar: AppBar(
          title: Text(t('adminLogin'), style: GoogleFonts.tajawal()),
          backgroundColor: const Color(0xFF1A5632),
          foregroundColor: Colors.white,
        ),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // أيقونة الإدارة
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: const Color(0xFF1A5632).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.admin_panel_settings,
                  color: Color(0xFF1A5632),
                  size: 50,
                ),
              ),
              
              const SizedBox(height: 40),
              
              // ✅ حقل البريد الإلكتروني
              TextField(
                controller: _emailController,
                style: GoogleFonts.tajawal(),
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: t('email'),
                  hintText: t('emailHint'),
                  prefixIcon: const Icon(Icons.email, color: Color(0xFF1A5632)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // حقل كلمة المرور
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                style: GoogleFonts.tajawal(),
                decoration: InputDecoration(
                  labelText: t('password'),
                  prefixIcon: const Icon(Icons.lock, color: Color(0xFF1A5632)),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_off : Icons.visibility,
                      color: const Color(0xFF1A5632),
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // زر تسجيل الدخول
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1A5632),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          t('login'),
                          style: GoogleFonts.tajawal(fontSize: 18),
                        ),
                ),
              ),
              
              // ✅ للاختبار فقط (نقدر نشيلو بعدين)
              const SizedBox(height: 16),
              Text(
                'للاختبار: admin@example.com / admin123',
                style: GoogleFonts.tajawal(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}