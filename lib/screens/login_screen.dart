// ========== lib/screens/login_screen.dart (معدل بالكامل) ==========

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/theme_provider.dart';
import '../providers/locale_provider.dart';
import '../providers/auth_provider.dart';
import 'register_screen.dart';
import 'home_screen.dart';

// دالة مساعدة لعرض النص مع الإيموجي
Widget textWithFallback(String text, {double? fontSize, Color? color, FontWeight? fontWeight, TextAlign? textAlign}) {
  return Text(
    text,
    textAlign: textAlign,
    style: GoogleFonts.tajawal(
      fontSize: fontSize,
      color: color,
      fontWeight: fontWeight,
    ),
  );
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _obscurePassword = true;
  
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // ✅ متغير لتخزين LocaleProvider (تم الإصلاح)
  late LocaleProvider _localeProvider;

  // ترجمة النصوص
  final Map<String, Map<String, String>> translations = {
    'welcomeBack': {
      'ar': 'مرحباً بعودتك',
      'en': 'Welcome Back',
      'fr': 'Bon Retour',
    },
    'loginSubtitle': {
      'ar': 'سجل دخولك للمتابعة',
      'en': 'Login to continue',
      'fr': 'Connectez-vous pour continuer',
    },
    'email': {
      'ar': 'البريد الإلكتروني',
      'en': 'Email',
      'fr': 'Email',
    },
    'enterEmail': {
      'ar': 'أدخل بريدك الإلكتروني',
      'en': 'Enter your email',
      'fr': 'Entrez votre email',
    },
    'password': {
      'ar': 'كلمة المرور',
      'en': 'Password',
      'fr': 'Mot de passe',
    },
    'enterPassword': {
      'ar': 'أدخل كلمة المرور',
      'en': 'Enter your password',
      'fr': 'Entrez votre mot de passe',
    },
    'forgotPassword': {
      'ar': 'نسيت كلمة المرور؟',
      'en': 'Forgot Password?',
      'fr': 'Mot de passe oublié?',
    },
    'login': {
      'ar': 'تسجيل الدخول',
      'en': 'Login',
      'fr': 'Se connecter',
    },
    'noAccount': {
      'ar': 'ليس لديك حساب؟',
      'en': 'Don\'t have an account?',
      'fr': 'Vous n\'avez pas de compte?',
    },
    'register': {
      'ar': 'إنشاء حساب',
      'en': 'Register',
      'fr': 'S\'inscrire',
    },
    'orContinueWith': {
      'ar': 'أو المتابعة باستخدام',
      'en': 'Or continue with',
      'fr': 'Ou continuer avec',
    },
    'loginSuccess': {
      'ar': 'تم تسجيل الدخول بنجاح',
      'en': 'Login successful',
      'fr': 'Connexion réussie',
    },
    'loginFailed': {
      'ar': 'فشل تسجيل الدخول',
      'en': 'Login failed',
      'fr': 'Échec de la connexion',
    },
    'required': {
      'ar': 'هذا الحقل مطلوب',
      'en': 'This field is required',
      'fr': 'Ce champ est requis',
    },
    'invalidEmail': {
      'ar': 'بريد إلكتروني غير صالح',
      'en': 'Invalid email',
      'fr': 'Email invalide',
    },
    'passwordTooShort': {
      'ar': 'كلمة المرور يجب أن تكون 6 أحرف على الأقل',
      'en': 'Password must be at least 6 characters',
      'fr': 'Le mot de passe doit contenir au moins 6 caractères',
    },
    'googleLogin': {
      'ar': 'تسجيل الدخول بجوجل',
      'en': 'Login with Google',
      'fr': 'Se connecter avec Google',
    },
    'facebookLogin': {
      'ar': 'تسجيل الدخول بفيسبوك',
      'en': 'Login with Facebook',
      'fr': 'Se connecter avec Facebook',
    },
    'appleLogin': {
      'ar': 'تسجيل الدخول بأبل',
      'en': 'Login with Apple',
      'fr': 'Se connecter avec Apple',
    },
    'cannotOpenUrl': {
      'ar': 'لا يمكن فتح الرابط',
      'en': 'Cannot open link',
      'fr': 'Impossible d\'ouvrir le lien',
    },
  };

  // ✅ دالة الترجمة المعدلة (تستخدم _localeProvider)
  String t(String key) {
    return translations[key]?[_localeProvider.locale.languageCode] ?? 
           translations[key]?['ar'] ?? key;
  }

  @override
  void initState() {
    super.initState();
    // ✅ تخزين LocaleProvider في initState مع listen: false
    _localeProvider = Provider.of<LocaleProvider>(context, listen: false);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      
      bool success = await authProvider.login(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      if (!mounted) return;

      setState(() => _isLoading = false);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: textWithFallback(t('loginSuccess')),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
        
        // العودة إلى الصفحة الرئيسية
        Navigator.pop(context);
      } else {
        String errorMsg = authProvider.lastError ?? t('loginFailed');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: textWithFallback(errorMsg),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: textWithFallback('حدث خطأ: $e'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _launchSocialLogin(String url, String serviceName) async {
    final Uri uri = Uri.parse(url);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: textWithFallback('${t('cannotOpenUrl')} $serviceName'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _loginWithGoogle() {
    const String googleUrl = 'https://accounts.google.com/o/oauth2/v2/auth?'
        'client_id=YOUR_GOOGLE_CLIENT_ID&'
        'redirect_uri=YOUR_REDIRECT_URI&'
        'response_type=code&'
        'scope=email%20profile';
    _launchSocialLogin(googleUrl, 'Google');
  }

  void _loginWithFacebook() {
    const String facebookUrl = 'https://www.facebook.com/v12.0/dialog/oauth?'
        'client_id=YOUR_FACEBOOK_APP_ID&'
        'redirect_uri=YOUR_REDIRECT_URI&'
        'scope=email,public_profile';
    _launchSocialLogin(facebookUrl, 'Facebook');
  }

  void _loginWithApple() {
    const String appleUrl = 'https://appleid.apple.com/auth/authorize?'
        'client_id=YOUR_APPLE_SERVICE_ID&'
        'redirect_uri=YOUR_REDIRECT_URI&'
        'response_type=code&'
        'scope=name%20email';
    _launchSocialLogin(appleUrl, 'Apple');
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return Directionality(
      textDirection: _localeProvider.textDirection,
      child: Scaffold(
        backgroundColor: isDark ? const Color(0xFF1A1A1A) : Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // زر الرجوع
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                        color: isDark ? Colors.grey[800] : Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.arrow_back,
                        color: isDark ? Colors.white : const Color(0xFF1A5632),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // الشعار
                  Center(
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF1A5632), Color(0xFF0D3D20)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF1A5632).withOpacity(0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.account_balance,
                        color: Colors.white,
                        size: 50,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 30),
                  
                  // عنوان الترحيب
                  Center(
                    child: textWithFallback(
                      t('welcomeBack'),
                      fontSize: 28,
                      color: isDark ? Colors.white : const Color(0xFF1A5632),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  Center(
                    child: textWithFallback(
                      t('loginSubtitle'),
                      fontSize: 16,
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // نموذج تسجيل الدخول
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // حقل البريد الإلكتروني
                        _buildTextField(
                          controller: _emailController,
                          label: t('email'),
                          hint: t('enterEmail'),
                          icon: '📧',
                          isDark: isDark,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return t('required');
                            }
                            if (!value.contains('@') || !value.contains('.')) {
                              return t('invalidEmail');
                            }
                            return null;
                          },
                        ),
                        
                        const SizedBox(height: 20),
                        
                        // حقل كلمة المرور
                        _buildTextField(
                          controller: _passwordController,
                          label: t('password'),
                          hint: t('enterPassword'),
                          icon: '🔒',
                          isDark: isDark,
                          obscureText: _obscurePassword,
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
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return t('required');
                            }
                            if (value.length < 6) {
                              return t('passwordTooShort');
                            }
                            return null;
                          },
                        ),
                        
                        const SizedBox(height: 12),
                        
                        // نسيت كلمة المرور
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              // TODO: التنقل إلى صفحة استعادة كلمة المرور
                            },
                            child: textWithFallback(
                              t('forgotPassword'),
                              color: const Color(0xFF1A5632),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 20),
                        
                        // زر تسجيل الدخول
                        SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _login,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1A5632),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 3,
                                    ),
                                  )
                                : textWithFallback(
                                    t('login'),
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                          ),
                        ),
                        
                        const SizedBox(height: 20),
                        
                        // خط فاصل
                        Row(
                          children: [
                            Expanded(
                              child: Divider(
                                color: isDark ? Colors.grey[700] : Colors.grey[300],
                                thickness: 1,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: textWithFallback(
                                t('orContinueWith'),
                                fontSize: 14,
                                color: isDark ? Colors.grey[400] : Colors.grey[600],
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                color: isDark ? Colors.grey[700] : Colors.grey[300],
                                thickness: 1,
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 20),
                        
                        // أزرار تسجيل الدخول الاجتماعي
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildSocialButton(
                              icon: 'G',
                              label: 'Google',
                              color: Colors.red,
                              tooltip: t('googleLogin'),
                              onTap: _loginWithGoogle,
                            ),
                            _buildSocialButton(
                              icon: 'f',
                              label: 'Facebook',
                              color: Colors.blue,
                              tooltip: t('facebookLogin'),
                              onTap: _loginWithFacebook,
                            ),
                            _buildSocialButton(
                              icon: '🍎',
                              label: 'Apple',
                              color: isDark ? Colors.white : Colors.black,
                              tooltip: t('appleLogin'),
                              onTap: _loginWithApple,
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 30),
                        
                        // رابط إنشاء حساب
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            textWithFallback(
                              t('noAccount'),
                              color: isDark ? Colors.grey[400] : Colors.grey[600],
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const RegisterScreen(),
                                  ),
                                );
                              },
                              child: textWithFallback(
                                t('register'),
                                color: const Color(0xFF1A5632),
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required String icon,
    required bool isDark,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            textWithFallback(icon, fontSize: 20),
            const SizedBox(width: 8),
            textWithFallback(
              label,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : Colors.grey[800],
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          validator: validator,
          textAlign: _localeProvider.textDirection == TextDirection.rtl ? TextAlign.right : TextAlign.left,
          style: GoogleFonts.tajawal(
            color: isDark ? Colors.white : Colors.black,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.tajawal(
              color: isDark ? Colors.grey[500] : Colors.grey[400],
            ),
            prefixIcon: Container(
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF1A5632).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: textWithFallback(icon, fontSize: 20),
            ),
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: isDark ? Colors.grey[800] : Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF1A5632), width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildSocialButton({
    required String icon,
    required String label,
    required Color color,
    required String tooltip,
    required VoidCallback onTap,
  }) {
    final isDark = Provider.of<ThemeProvider>(context, listen: false).isDarkMode;
    
    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isDark ? Colors.grey[800] : Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              textWithFallback(icon, fontSize: 18, color: color),
              const SizedBox(width: 8),
              textWithFallback(
                label,
                fontSize: 14,
                color: isDark ? Colors.white : Colors.black,
              ),
            ],
          ),
        ),
      ),
    );
  }
}