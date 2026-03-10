import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../providers/locale_provider.dart';
import '../providers/auth_provider.dart';
import '../services/api_service.dart';

class PropertyBookCopyRequestScreen extends StatefulWidget {
  const PropertyBookCopyRequestScreen({super.key});

  @override
  State<PropertyBookCopyRequestScreen> createState() =>
      _PropertyBookCopyRequestScreenState();
}

class _PropertyBookCopyRequestScreenState
    extends State<PropertyBookCopyRequestScreen> {
  // ── الألوان ────────────────────────────────────
  static const Color primary      = Color(0xFF1A5632);
  static const Color primaryDark  = Color(0xFF0D3D20);
  static const Color primaryLight = Color(0xFF2D7A4D);
  static const Color secondary    = Color(0xFFC9A063);
  static const Color bgLight      = Color(0xFFF8F6F1);
  static const Color danger       = Color(0xFFE74C3C);
  static const Color textDark     = Color(0xFF2D2D2D);
  static const Color textGrey     = Color(0xFF6B6B6B);
  static const Color darkBg       = Color(0xFF1A1A1A);
  static const Color darkCard     = Color(0xFF2D2D2D);
  static const Color darkText     = Color(0xFFE8E8E8);

  // ترجمة النصوص
  Map<String, Map<String, String>> translations = {
    'pageTitle': {
      'ar': 'طلب نسخة دفتر عقاري',
      'en': 'Property Book Copy Request',
      'fr': 'Demande de Copie du Livre Foncier',
    },
    'pageSubtitle': {
      'ar': 'محافظة العقارية أولاد جلال',
      'en': 'Real Estate Conservation Ouled Djellal',
      'fr': 'Conservation Foncière Ouled Djellal',
    },
    'personalInfo': {
      'ar': 'المعلومات الشخصية',
      'en': 'Personal Information',
      'fr': 'Informations Personnelles',
    },
    'propertyInfo': {
      'ar': 'معلومات العقار',
      'en': 'Property Information',
      'fr': 'Informations sur la Propriété',
    },
    'fullName': {
      'ar': 'الاسم الكامل',
      'en': 'Full Name',
      'fr': 'Nom Complet',
    },
    'nationalId': {
      'ar': 'رقم التعريف الوطني',
      'en': 'National ID Number',
      'fr': 'Numéro d\'Identification National',
    },
    'phone': {
      'ar': 'رقم الهاتف',
      'en': 'Phone Number',
      'fr': 'Téléphone',
    },
    'email': {
      'ar': 'البريد الإلكتروني',
      'en': 'Email',
      'fr': 'Email',
    },
    'section': {
      'ar': 'القسم',
      'en': 'Section',
      'fr': 'Section',
    },
    'propertyGroup': {
      'ar': 'رقم مجموعة الملكية',
      'en': 'Property Group Number',
      'fr': 'Numéro de Groupe de Propriété',
    },
    'registerNumber': {
      'ar': 'رقم الدفتر العقاري',
      'en': 'Property Book Number',
      'fr': 'Numéro du Livre Foncier',
    },
    'submit': {
      'ar': 'تقديم الطلب',
      'en': 'Submit Request',
      'fr': 'Soumettre la Demande',
    },
    'back': {
      'ar': 'العودة',
      'en': 'Back',
      'fr': 'Retour',
    },
    'processing': {
      'ar': 'جاري معالجة طلبك...',
      'en': 'Processing your request...',
      'fr': 'Traitement de votre demande...',
    },
    'successMessage': {
      'ar': '✅ تم تقديم طلب نسخة الدفتر بنجاح',
      'en': '✅ Property book copy request submitted successfully',
      'fr': '✅ Demande de copie du livre foncier soumise avec succès',
    },
    'errorMessage': {
      'ar': '❌ فشل إرسال الطلب',
      'en': '❌ Failed to submit request',
      'fr': '❌ Échec de l\'envoi de la demande',
    },
    'infoNote': {
      'ar': 'إذا كنت لا تعلم رقم الدفتر العقاري، يمكنك تركه فارغاً',
      'en': 'If you don\'t know the property book number, you can leave it empty',
      'fr': 'Si vous ne connaissez pas le numéro du livre foncier, vous pouvez le laisser vide',
    },
    'optional': {
      'ar': 'اختياري',
      'en': 'Optional',
      'fr': 'Optionnel',
    },
    'required': {
      'ar': 'هذا الحقل مطلوب',
      'en': 'This field is required',
      'fr': 'Ce champ est requis',
    },
    'invalidEmail': {
      'ar': 'بريد إلكتروني غير صالح',
      'en': 'Invalid email address',
      'fr': 'Adresse email invalide',
    },
    'enterEmail': {
      'ar': 'example@email.com',
      'en': 'example@email.com',
      'fr': 'example@email.com',
    },
    'ok': {
      'ar': 'حسناً',
      'en': 'OK',
      'fr': 'D\'accord',
    },
    'loginRequired': {
      'ar': 'يجب تسجيل الدخول أولاً',
      'en': 'You must login first',
      'fr': 'Vous devez vous connecter d\'abord',
    },
    'loginRequiredMessage': {
      'ar': 'يرجى تسجيل الدخول لإتمام عملية إرسال الطلب',
      'en': 'Please login to complete the submission process',
      'fr': 'Veuillez vous connecter pour terminer le processus d\'envoi',
    },
    'goToLogin': {
      'ar': 'الذهاب لتسجيل الدخول',
      'en': 'Go to Login',
      'fr': 'Aller à la connexion',
    },
    'cancel': {
      'ar': 'إلغاء',
      'en': 'Cancel',
      'fr': 'Annuler',
    },
  };

  String t(String key) {
    final locale = Provider.of<LocaleProvider>(context, listen: false).locale.languageCode;
    return translations[key]?[locale] ?? translations[key]?['ar'] ?? key;
  }

  final _formKey   = GlobalKey<FormState>();
  bool _isLoading  = false;

  // ── Controllers ───────────────────
  final _fullNameController        = TextEditingController();
  final _nationalIdController      = TextEditingController();
  final _phoneController           = TextEditingController();
  final _emailController           = TextEditingController();
  final _sectionController         = TextEditingController();
  final _propertyGroupController   = TextEditingController();
  final _registerNumberController  = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _nationalIdController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _sectionController.dispose();
    _propertyGroupController.dispose();
    _registerNumberController.dispose();
    super.dispose();
  }

  // ════════════════════════════════════════════════════════════
  //  التحقق من تسجيل الدخول
  // ════════════════════════════════════════════════════════════
  Future<bool> _checkLoginStatus() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final token = await authProvider.getToken();
    
    print('🔍 التحقق من حالة تسجيل الدخول...');
    print('🔑 التوكن: ${token != null ? "موجود" : "غير موجود"}');
    
    if (token == null || token.isEmpty) {
      _showLoginRequiredDialog();
      return false;
    }
    return true;
  }

  void _showLoginRequiredDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            const Icon(Icons.lock_outline, color: primary, size: 28),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                t('loginRequired'),
                style: GoogleFonts.tajawal(
                  fontWeight: FontWeight.bold,
                  color: primary,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
        content: Text(
          t('loginRequiredMessage'),
          style: GoogleFonts.tajawal(
            color: textDark,
            fontSize: 15,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              t('cancel'),
              style: GoogleFonts.tajawal(color: textGrey),
            ),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              _goToLogin();
            },
            icon: const Icon(Icons.login, size: 18),
            label: Text(
              t('goToLogin'),
              style: GoogleFonts.tajawal(fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _goToLogin() {
    Navigator.pushNamed(context, '/login');
  }

  // ── تقديم الطلب ─────────────────────────────────────────
  Future<void> _submitForm() async {
    final isLoggedIn = await _checkLoginStatus();
    if (!isLoggedIn) {
      print('❌ المستخدم غير مسجل الدخول، تم إيقاف الإرسال');
      return;
    }

    if (!_formKey.currentState!.validate()) return;
    
    setState(() => _isLoading = true);

    Map<String, dynamic> data = {
      'full_name': _fullNameController.text.trim(),
      'national_id': _nationalIdController.text.replaceAll(' ', ''),
      'phone': _phoneController.text.trim(),
      'email': _emailController.text.trim(),
      'section': _sectionController.text.trim(),
      'property_group': _propertyGroupController.text.trim(),
    };

    if (_registerNumberController.text.isNotEmpty) {
      data['register_number'] = _registerNumberController.text.trim();
    }

    print('📤 إرسال طلب نسخة دفتر: $data');

    try {
      final result = await ApiService.submitPropertyBookCopyRequest(data);
      
      setState(() => _isLoading = false);

      if (result['success'] == true) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    result['message'] ?? t('successMessage'),
                    style: GoogleFonts.tajawal(color: Colors.white),
                  ),
                ),
              ],
            ),
            backgroundColor: primary,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.all(16),
          ));
          
          Future.delayed(const Duration(seconds: 1), () {
            if (mounted) Navigator.pop(context, true);
          });
        }
      } else {
        if (result['needLogin'] == true) {
          _showLoginRequiredDialog();
        } else {
          _showErrorDialog(result['message'] ?? t('errorMessage'));
        }
      }
    } catch (e) {
      setState(() => _isLoading = false);
      _showErrorDialog('حدث خطأ في الاتصال: $e');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('خطأ', style: GoogleFonts.tajawal(fontWeight: FontWeight.bold)),
        content: Text(message, style: GoogleFonts.tajawal()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(t('ok'), style: GoogleFonts.tajawal(color: primary)),
          ),
        ],
      ),
    );
  }

  // ════════════════════════════════════════════════════════
  //  build
  // ════════════════════════════════════════════════════════
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final localeProvider = Provider.of<LocaleProvider>(context);
    final isDark = themeProvider.isDarkMode;
    final lang = localeProvider.locale.languageCode;

    return Directionality(
      textDirection: localeProvider.textDirection,
      child: Scaffold(
        backgroundColor: isDark ? darkBg : primaryDark,
        body: Container(
          decoration: BoxDecoration(
            gradient: isDark
                ? null
                : const LinearGradient(
                    colors: [primaryDark, primary, primaryLight],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                  ),
          ),
          child: Stack(children: [
            const _Particles(),
            SafeArea(
              child: CustomScrollView(slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(children: [
                      const SizedBox(height: 20),
                      _buildPageHeader(lang),
                      const SizedBox(height: 24),
                      _buildFormWrapper(isDark),
                      const SizedBox(height: 32),
                    ]),
                  ),
                ),
              ]),
            ),
            if (_isLoading)
              Container(
                color: primaryDark.withOpacity(0.95),
                child: Center(child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      width: 60, height: 60,
                      child: CircularProgressIndicator(
                          color: secondary, strokeWidth: 4),
                    ),
                    const SizedBox(height: 20),
                    Text(t('processing'),
                        style: GoogleFonts.tajawal(
                            color: Colors.white, fontSize: 18)),
                  ],
                )),
              ),
          ]),
        ),
      ),
    );
  }

  Widget _buildPageHeader(String lang) {
    return Column(children: [
      Align(
        alignment: lang == 'ar' ? Alignment.centerRight : Alignment.centerLeft,
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            width: 50, height: 50,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              shape: BoxShape.circle,
              border: Border.all(
                  color: Colors.white.withOpacity(0.3), width: 2),
            ),
            child: const Icon(Icons.arrow_back,
                color: Colors.white, size: 24),
          ),
        ),
      ),
      const SizedBox(height: 20),
      Container(
        width: 90, height: 90,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          shape: BoxShape.circle,
          border: Border.all(
              color: secondary.withOpacity(0.5), width: 2),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.2),
                blurRadius: 20, offset: const Offset(0, 10)),
          ],
        ),
        child: const Center(
            child: Text('📖', style: TextStyle(fontSize: 40))),
      ),
      const SizedBox(height: 16),
      Text(t('pageTitle'),
          style: GoogleFonts.amiri(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold)),
      const SizedBox(height: 8),
      Text(t('pageSubtitle'),
          style: GoogleFonts.tajawal(
              color: Colors.white.withOpacity(0.9), fontSize: 16)),
    ]);
  }

  Widget _buildFormWrapper(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? darkCard : Colors.white.withOpacity(0.98),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.4),
              blurRadius: 70, offset: const Offset(0, 25)),
        ],
      ),
      child: Form(
        key: _formKey,
        child: _buildFormBody(isDark), // ✅ مباشرة بدون _buildFormHeader
      ),
    );
  }

  Widget _buildFormBody(bool isDark) {
    final locale = Provider.of<LocaleProvider>(context).locale.languageCode;
    
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _sectionDivider('👤', t('personalInfo')),
        const SizedBox(height: 16),

        _field(
          ctrl: _fullNameController,
          label: t('fullName'),
          isDark: isDark, req: true,
          validator: (v) => (v?.trim().isEmpty ?? true) ? t('required') : null,
        ),
        const SizedBox(height: 16),

        _row2(
          _field(
            ctrl: _nationalIdController,
            label: t('nationalId'),
            isDark: isDark, req: true,
            kb: TextInputType.number, maxLen: 18,
            validator: (v) {
              if (v?.trim().isEmpty ?? true) return t('required');
              final id = v!.replaceAll(' ', '');
              if (id.length != 18 || !RegExp(r'^\d+$').hasMatch(id)) {
                return 'رقم التعريف يجب أن يكون 18 رقماً';
              }
              return null;
            },
          ),
          _field(
            ctrl: _phoneController,
            label: t('phone'),
            isDark: isDark, req: true,
            kb: TextInputType.phone,
            validator: (v) => (v?.trim().isEmpty ?? true) ? t('required') : null,
          ),
        ),
        const SizedBox(height: 16),

        _field(
          ctrl: _emailController,
          label: t('email'),
          isDark: isDark, req: true,
          kb: TextInputType.emailAddress,
          validator: (v) {
            if (v?.trim().isEmpty ?? true) return t('required');
            if (!v!.contains('@')) return t('invalidEmail');
            return null;
          },
        ),

        const SizedBox(height: 28),
        _sectionDivider('🏛️', t('propertyInfo')),
        const SizedBox(height: 16),

        _infoNote(),
        const SizedBox(height: 16),

        _row2(
          _field(
            ctrl: _sectionController,
            label: t('section'),
            isDark: isDark, req: true,
            validator: (v) => (v?.trim().isEmpty ?? true) ? t('required') : null,
          ),
          _field(
            ctrl: _propertyGroupController,
            label: t('propertyGroup'),
            isDark: isDark, req: true,
            kb: TextInputType.number,
            validator: (v) => (v?.trim().isEmpty ?? true) ? t('required') : null,
          ),
        ),
        const SizedBox(height: 16),

        _optionalField(
          ctrl: _registerNumberController,
          label: t('registerNumber'),
          isDark: isDark,
        ),

        const SizedBox(height: 32),
        _buildButtons(),
      ]),
    );
  }

  Widget _sectionDivider(String icon, String title) {
    return Row(children: [
      Expanded(child: Container(height: 2,
        decoration: BoxDecoration(gradient: LinearGradient(colors: [
          Colors.transparent, secondary.withOpacity(0.5), Colors.transparent,
        ])))),
      Container(
        width: 35, height: 35,
        margin: const EdgeInsets.symmetric(horizontal: 12),
        decoration: const BoxDecoration(color: primary, shape: BoxShape.circle),
        child: Center(child: Text(icon,
            style: const TextStyle(fontSize: 16))),
      ),
      Text(title, style: GoogleFonts.tajawal(
          color: primary, fontSize: 16, fontWeight: FontWeight.bold)),
      Expanded(child: Container(height: 2,
        decoration: BoxDecoration(gradient: LinearGradient(colors: [
          Colors.transparent, secondary.withOpacity(0.5), Colors.transparent,
        ])))),
    ]);
  }

  Widget _infoNote() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: secondary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: const Border(right: BorderSide(color: secondary, width: 4)),
      ),
      child: Row(children: [
        const Text('ℹ️', style: TextStyle(fontSize: 20)),
        const SizedBox(width: 8),
        Expanded(child: Text(
          t('infoNote'),
          style: GoogleFonts.tajawal(color: primary, fontSize: 14),
        )),
      ]),
    );
  }

  Widget _buildButtons() {
    return Row(children: [
      Expanded(
        child: ElevatedButton.icon(
          onPressed: _isLoading ? null : _submitForm,
          icon: _isLoading
              ? const SizedBox(width: 20, height: 20,
                  child: CircularProgressIndicator(
                      color: Colors.white, strokeWidth: 2))
              : const Icon(Icons.send),
          label: Text(t('submit'),
              style: GoogleFonts.tajawal(
                  fontSize: 16, fontWeight: FontWeight.bold)),
          style: ElevatedButton.styleFrom(
            backgroundColor: primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            elevation: 8,
            shadowColor: primary.withOpacity(0.4),
          ),
        ),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: OutlinedButton.icon(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
          label: Text(t('back'),
              style: GoogleFonts.tajawal(
                  fontSize: 16, fontWeight: FontWeight.bold)),
          style: OutlinedButton.styleFrom(
            foregroundColor: textGrey,
            side: BorderSide(color: Colors.grey.shade300, width: 2),
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ),
    ]);
  }

  Widget _row2(Widget c1, Widget c2) => LayoutBuilder(
    builder: (ctx, box) => box.maxWidth > 560
        ? Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(child: c1), const SizedBox(width: 16), Expanded(child: c2)])
        : Column(children: [c1, const SizedBox(height: 16), c2]),
  );

  Widget _field({
    required TextEditingController ctrl,
    required String label,
    required bool isDark,
    bool req = false,
    TextInputType kb = TextInputType.text,
    int? maxLen,
    String? Function(String?)? validator,
  }) {
    final locale = Provider.of<LocaleProvider>(context).locale.languageCode;
    
    return TextFormField(
      controller: ctrl,
      keyboardType: kb,
      maxLength: maxLen,
      validator: validator,
      textAlign: locale == 'ar' ? TextAlign.right : TextAlign.left,
      style: GoogleFonts.tajawal(
          color: isDark ? darkText : textDark, fontSize: 16),
      decoration: _inputDec(isDark, label, req: req),
    );
  }

  Widget _optionalField({
    required TextEditingController ctrl,
    required String label,
    required bool isDark,
  }) {
    final locale = Provider.of<LocaleProvider>(context).locale.languageCode;
    
    return Stack(
      alignment: locale == 'ar' ? Alignment.centerRight : Alignment.centerLeft,
      children: [
        TextFormField(
          controller: ctrl,
          textAlign: locale == 'ar' ? TextAlign.right : TextAlign.left,
          style: GoogleFonts.tajawal(
              color: isDark ? darkText : textDark, fontSize: 16),
          decoration: _inputDec(isDark, label),
        ),
        Positioned(
          left: locale == 'ar' ? null : 12,
          right: locale == 'ar' ? 12 : null,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: secondary.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(t('optional'),
                style: GoogleFonts.tajawal(
                    color: primary, fontSize: 10, fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }

  InputDecoration _inputDec(bool isDark, String label,
      {bool req = false, bool alignHint = false}) {
    return InputDecoration(
      labelText: req ? '$label *' : label,
      labelStyle: GoogleFonts.tajawal(color: textGrey, fontSize: 14),
      floatingLabelStyle: GoogleFonts.tajawal(
          color: primary, fontSize: 13, fontWeight: FontWeight.bold),
      alignLabelWithHint: alignHint,
      counterText: '',
      filled: true,
      fillColor: isDark ? darkBg : Colors.white,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300, width: 2)),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300, width: 2)),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primary, width: 2)),
      errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: danger, width: 2)),
      focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: danger, width: 2)),
    );
  }
}

class _Particles extends StatefulWidget {
  const _Particles();
  @override
  State<_Particles> createState() => _ParticlesState();
}

class _ParticlesState extends State<_Particles>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  final List<_Particle> _particles = List.generate(25, (i) => _Particle(i));

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(seconds: 18))
      ..repeat();
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) => CustomPaint(
        size: Size.infinite,
        painter: _ParticlePainter(_particles, _ctrl.value),
      ),
    );
  }
}

class _Particle {
  final double x;
  final double delay;
  final double speed;
  _Particle(int i)
      : x     = (i * 37 % 100) / 100,
        delay  = (i * 71 % 180) / 100,
        speed  = 0.6 + (i % 5) * 0.1;
}

class _ParticlePainter extends CustomPainter {
  final List<_Particle> particles;
  final double t;
  _ParticlePainter(this.particles, this.t);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFC9A063).withOpacity(0.5)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
    for (final p in particles) {
      final progress = ((t * p.speed + p.delay) % 1.0);
      final y = size.height * (1 - progress);
      final opacity = progress < 0.1 ? progress / 0.1
          : progress > 0.9 ? (1 - progress) / 0.1 : 1.0;
      canvas.drawCircle(
        Offset(p.x * size.width, y),
        3,
        paint..color = const Color(0xFFC9A063).withOpacity(opacity * 0.5),
      );
    }
  }

  @override
  bool shouldRepaint(_ParticlePainter old) => true;
}