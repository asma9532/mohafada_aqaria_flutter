import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../providers/locale_provider.dart';
import '../providers/auth_provider.dart';
import 'login_screen.dart';

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

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _acceptTerms = false;
  
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // متغير لحفظ LocaleProvider
  late LocaleProvider _localeProvider;

  final Map<String, Map<String, String>> translations = {
    'createAccount': {
      'ar': 'إنشاء حساب جديد',
      'en': 'Create New Account',
      'fr': 'Créer un Nouveau Compte',
    },
    'registerSubtitle': {
      'ar': 'أدخل بياناتك للتسجيل',
      'en': 'Enter your details to register',
      'fr': 'Entrez vos informations pour vous inscrire',
    },
    'fullName': {
      'ar': 'الاسم الكامل',
      'en': 'Full Name',
      'fr': 'Nom Complet',
    },
    'enterFullName': {
      'ar': 'أدخل اسمك الكامل',
      'en': 'Enter your full name',
      'fr': 'Entrez votre nom complet',
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
    'phone': {
      'ar': 'رقم الهاتف',
      'en': 'Phone Number',
      'fr': 'Numéro de téléphone',
    },
    'enterPhone': {
      'ar': 'أدخل رقم هاتفك',
      'en': 'Enter your phone number',
      'fr': 'Entrez votre numéro de téléphone',
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
    'confirmPassword': {
      'ar': 'تأكيد كلمة المرور',
      'en': 'Confirm Password',
      'fr': 'Confirmer le mot de passe',
    },
    'enterConfirmPassword': {
      'ar': 'أعد إدخال كلمة المرور',
      'en': 'Re-enter your password',
      'fr': 'Ressaisissez votre mot de passe',
    },
    'acceptTerms': {
      'ar': 'أوافق على الشروط والأحكام',
      'en': 'I accept the terms and conditions',
      'fr': 'J\'accepte les termes et conditions',
    },
    'register': {
      'ar': 'إنشاء حساب',
      'en': 'Register',
      'fr': 'S\'inscrire',
    },
    'haveAccount': {
      'ar': 'لديك حساب بالفعل؟',
      'en': 'Already have an account?',
      'fr': 'Vous avez déjà un compte?',
    },
    'login': {
      'ar': 'تسجيل الدخول',
      'en': 'Login',
      'fr': 'Se connecter',
    },
    'registerSuccess': {
      'ar': 'تم إنشاء الحساب بنجاح',
      'en': 'Account created successfully',
      'fr': 'Compte créé avec succès',
    },
    'registerFailed': {
      'ar': 'فشل إنشاء الحساب: ',
      'en': 'Account creation failed: ',
      'fr': 'Échec de la création du compte: ',
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
    'fullNameTooShort': {
      'ar': 'الاسم يجب أن يكون 3 أحرف على الأقل',
      'en': 'Name must be at least 3 characters',
      'fr': 'Le nom doit contenir au moins 3 caractères',
    },
    'passwordTooShort': {
      'ar': 'كلمة المرور يجب أن تكون 8 أحرف على الأقل',
      'en': 'Password must be at least 8 characters',
      'fr': 'Le mot de passe doit contenir au moins 8 caractères',
    },
    'passwordsNotMatch': {
      'ar': 'كلمتا المرور غير متطابقتين',
      'en': 'Passwords do not match',
      'fr': 'Les mots de passe ne correspondent pas',
    },
    'acceptTermsRequired': {
      'ar': 'يجب الموافقة على الشروط',
      'en': 'You must accept the terms',
      'fr': 'Vous devez accepter les conditions',
    },
  };

  String t(String key) {
    return translations[key]?[_localeProvider.locale.languageCode] ?? translations[key]?['ar'] ?? key;
  }

  @override
  void initState() {
    super.initState();
    _localeProvider = Provider.of<LocaleProvider>(context, listen: false);
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: textWithFallback(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    
    if (!_acceptTerms) {
      _showError(t('acceptTermsRequired'));
      return;
    }

    setState(() => _isLoading = true);

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      
      bool success = await authProvider.register(
        fullName: _fullNameController.text,
        email: _emailController.text,
        password: _passwordController.text,
        phone: _phoneController.text.isNotEmpty ? _phoneController.text : null,
      );

      setState(() => _isLoading = false);

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: textWithFallback(t('registerSuccess')),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
        Navigator.pop(context);
      } else if (mounted) {
        // عرض رسالة الخطأ من authProvider
        final errorMsg = authProvider.lastError ?? t('registerFailed');
        _showError('${t('registerFailed')}$errorMsg');
      }
    } catch (e) {
      setState(() => _isLoading = false);
      _showError('حدث خطأ: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return Directionality(
      textDirection: _localeProvider.textDirection,
      child: Scaffold(
        backgroundColor: isDark ? const Color(0xFF1A1A1A) : Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: isDark ? Colors.white : const Color(0xFF1A5632),
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF1A5632), Color(0xFF0D3D20)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF1A5632).withOpacity(0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.person_add,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  Center(
                    child: textWithFallback(
                      t('createAccount'),
                      fontSize: 24,
                      color: isDark ? Colors.white : const Color(0xFF1A5632),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  Center(
                    child: textWithFallback(
                      t('registerSubtitle'),
                      fontSize: 14,
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ),
                  
                  const SizedBox(height: 30),
                  
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _buildTextField(
                          controller: _fullNameController,
                          label: t('fullName'),
                          hint: t('enterFullName'),
                          icon: '👤',
                          isDark: isDark,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return t('required');
                            }
                            if (value.length < 3) {
                              return t('fullNameTooShort');
                            }
                            return null;
                          },
                        ),
                        
                        const SizedBox(height: 16),
                        
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
                        
                        const SizedBox(height: 16),
                        
                        _buildTextField(
                          controller: _phoneController,
                          label: t('phone'),
                          hint: t('enterPhone'),
                          icon: '📱',
                          isDark: isDark,
                          keyboardType: TextInputType.phone,
                        ),
                        
                        const SizedBox(height: 16),
                        
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
                            if (value.length < 8) {
                              return t('passwordTooShort');
                            }
                            return null;
                          },
                        ),
                        
                        const SizedBox(height: 16),
                        
                        _buildTextField(
                          controller: _confirmPasswordController,
                          label: t('confirmPassword'),
                          hint: t('enterConfirmPassword'),
                          icon: '🔒',
                          isDark: isDark,
                          obscureText: _obscureConfirmPassword,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                              color: const Color(0xFF1A5632),
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureConfirmPassword = !_obscureConfirmPassword;
                              });
                            },
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return t('required');
                            }
                            if (value != _passwordController.text) {
                              return t('passwordsNotMatch');
                            }
                            return null;
                          },
                        ),
                        
                        const SizedBox(height: 16),
                        
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            color: isDark ? Colors.grey[800] : Colors.grey[50],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: CheckboxListTile(
                            value: _acceptTerms,
                            onChanged: (value) {
                              setState(() {
                                _acceptTerms = value ?? false;
                              });
                            },
                            title: textWithFallback(
                              t('acceptTerms'),
                              fontSize: 13,
                              color: isDark ? Colors.white : Colors.black,
                            ),
                            controlAffinity: ListTileControlAffinity.leading,
                            activeColor: const Color(0xFF1A5632),
                            checkboxShape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                        
                        const SizedBox(height: 20),
                        
                        SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _register,
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
                                    t('register'),
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                          ),
                        ),
                        
                        const SizedBox(height: 20),
                        
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            textWithFallback(
                              t('haveAccount'),
                              color: isDark ? Colors.grey[400] : Colors.grey[600],
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const LoginScreen(),
                                  ),
                                );
                              },
                              child: textWithFallback(
                                t('login'),
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
}