import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../providers/locale_provider.dart';
import '../services/api_service.dart';
import 'home_screen.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({super.key});

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen>
    with SingleTickerProviderStateMixin {
  static const Color primary = Color(0xFF1A5632);
  static const Color primaryDark = Color(0xFF0D3D20);
  static const Color secondary = Color(0xFFC49B63);
  static const Color bgLight = Color(0xFFF8F6F1);
  static const Color textDark = Color(0xFF2D2D2D);
  static const Color textLight = Color(0xFF6B6B6B);
  static const Color danger = Color(0xFFE74C3C);
  static const Color success = Color(0xFF28A745);
  static const Color darkBg = Color(0xFF1A1A1A);
  static const Color darkCard = Color(0xFF2D2D2D);
  static const Color darkText = Color(0xFFE8E8E8);

  late AnimationController _particleController;
  final List<_Particle> _particles = List.generate(20, (i) => _Particle(i));

  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String? _successMessage;
  String? _errorMessage;

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _messageController = TextEditingController();

  String? _selectedSubject;

  final List<Map<String, String>> _subjects = [
    {'value': 'inquiry', 'label': 'استفسار عام'},
    {'value': 'complaint', 'label': 'شكوى'},
    {'value': 'suggestion', 'label': 'اقتراح'},
    {'value': 'support', 'label': 'دعم فني'},
    {'value': 'other', 'label': 'أخرى'},
  ];

  final Map<String, String> _contactInfo = {
    'address': 'المحافظة العقارية، أولاد جلال، الجزائر',
    'phone': '0795858484',
    'email': 'info@conservation.dz',
    'working_hours': 'الأحد - الخميس: 8:00 - 16:00',
  };

  final Map<String, Map<String, String>> translations = {
    'pageTitle': {'ar': 'اتصل بنا', 'en': 'Contact Us', 'fr': 'Contactez-nous'},
    'pageSubtitle': {'ar': 'نحن هنا للإجابة عن جميع استفساراتكم', 'en': 'We are here to answer all your inquiries', 'fr': 'Nous sommes là pour répondre à toutes vos questions'},
    'contactInfo': {'ar': 'معلومات التواصل', 'en': 'Contact Information', 'fr': 'Informations de Contact'},
    'address': {'ar': 'العنوان', 'en': 'Address', 'fr': 'Adresse'},
    'phone': {'ar': 'الهاتف', 'en': 'Phone', 'fr': 'Téléphone'},
    'email': {'ar': 'البريد الإلكتروني', 'en': 'Email', 'fr': 'Email'},
    'workingHours': {'ar': 'أوقات العمل', 'en': 'Working Hours', 'fr': 'Heures de Travail'},
    'sendMessage': {'ar': 'أرسل لنا رسالة', 'en': 'Send us a Message', 'fr': 'Envoyez-nous un Message'},
    'formSubtitle': {'ar': 'املأ النموذج وسنتواصل معك قريباً', 'en': 'Fill the form and we will contact you soon', 'fr': 'Remplissez le formulaire et nous vous contacterons bientôt'},
    'fullName': {'ar': 'الاسم الكامل', 'en': 'Full Name', 'fr': 'Nom Complet'},
    'emailLabel': {'ar': 'البريد الإلكتروني', 'en': 'Email', 'fr': 'Email'},
    'phoneLabel': {'ar': 'رقم الهاتف', 'en': 'Phone Number', 'fr': 'Téléphone'},
    'subject': {'ar': 'الموضوع', 'en': 'Subject', 'fr': 'Sujet'},
    'message': {'ar': 'الرسالة', 'en': 'Message', 'fr': 'Message'},
    'sendButton': {'ar': 'إرسال الرسالة', 'en': 'Send Message', 'fr': 'Envoyer le Message'},
    'selectSubject': {'ar': 'اختر الموضوع', 'en': 'Select Subject', 'fr': 'Choisir le Sujet'},
    'inquiry': {'ar': 'استفسار عام', 'en': 'General Inquiry', 'fr': 'Demande Générale'},
    'complaint': {'ar': 'شكوى', 'en': 'Complaint', 'fr': 'Réclamation'},
    'suggestion': {'ar': 'اقتراح', 'en': 'Suggestion', 'fr': 'Suggestion'},
    'support': {'ar': 'دعم فني', 'en': 'Technical Support', 'fr': 'Support Technique'},
    'other': {'ar': 'أخرى', 'en': 'Other', 'fr': 'Autre'},
    'enterName': {'ar': 'أدخل اسمك الكامل', 'en': 'Enter your full name', 'fr': 'Entrez votre nom complet'},
    'enterEmail': {'ar': 'example@email.com', 'en': 'example@email.com', 'fr': 'example@email.com'},
    'enterPhone': {'ar': '0XXX XX XX XX', 'en': '0XXX XX XX XX', 'fr': '0XXX XX XX XX'},
    'enterMessage': {'ar': 'اكتب رسالتك هنا...', 'en': 'Write your message here...', 'fr': 'Écrivez votre message ici...'},
    'thisFieldRequired': {'ar': 'هذا الحقل مطلوب', 'en': 'This field is required', 'fr': 'Ce champ est requis'},
    'invalidEmail': {'ar': 'بريد إلكتروني غير صالح', 'en': 'Invalid email address', 'fr': 'Adresse email invalide'},
    'successMessage': {'ar': 'تم إرسال رسالتك بنجاح. سنتواصل معك قريباً', 'en': 'Your message has been sent successfully. We will contact you soon', 'fr': 'Votre message a été envoyé avec succès. Nous vous contacterons bientôt'},
    'connectionError': {'ar': 'حدث خطأ في الاتصال، يرجى المحاولة مرة أخرى', 'en': 'Connection error, please try again', 'fr': 'Erreur de connexion, veuillez réessayer'},
    'ok': {'ar': 'حسناً', 'en': 'OK', 'fr': 'D\'accord'},
    'back': {'ar': 'رجوع', 'en': 'Back', 'fr': 'Retour'},
    'loginRequired': {'ar': 'يجب تسجيل الدخول أولاً', 'en': 'Login Required', 'fr': 'Connexion Requise'},
    'loginRequiredMessage': {'ar': 'يجب تسجيل الدخول أولاً لإرسال رسالة', 'en': 'You must login first to send a message', 'fr': 'Vous devez d\'abord vous connecter pour envoyer un message'},
    'login': {'ar': 'تسجيل الدخول', 'en': 'Login', 'fr': 'Connexion'},
  };

  String t(String key) {
    final locale = Provider.of<LocaleProvider>(context, listen: false).locale.languageCode;
    return translations[key]?[locale] ?? translations[key]?['ar'] ?? key;
  }

  @override
  void initState() {
    super.initState();
    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    )..repeat();
  }

  @override
  void dispose() {
    _particleController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _goBack() {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
  }

  void _showLoginRequiredDialog() {
    final isDark = Provider.of<ThemeProvider>(context, listen: false).isDarkMode;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: isDark ? darkCard : Colors.white,
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: secondary.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.lock_outline, color: secondary, size: 28),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  t('loginRequired'),
                  style: GoogleFonts.tajawal(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark ? darkText : textDark,
                  ),
                ),
              ),
            ],
          ),
          content: Text(
            t('loginRequiredMessage'),
            style: GoogleFonts.tajawal(
              fontSize: 16,
              color: isDark ? darkText.withOpacity(0.8) : textLight,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(
                t('back'),
                style: GoogleFonts.tajawal(color: textLight, fontWeight: FontWeight.bold),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                Navigator.of(context).pushNamed('/login');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: Text(
                t('login'),
                style: GoogleFonts.tajawal(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _successMessage = null;
      _errorMessage = null;
    });

    Map<String, dynamic> data = {
      'name': _nameController.text.trim(),
      'email': _emailController.text.trim(),
      'phone': _phoneController.text.trim(),
      'subject': _selectedSubject,
      'message': _messageController.text.trim(),
    };

    try {
      final result = await ApiService.submitContact(data);

      setState(() => _isLoading = false);

      if (result['code'] == 401 ||
          result['status'] == 401 ||
          result['message']?.toString().contains('Unauthenticated') == true ||
          result['message']?.toString().contains('unauthenticated') == true ||
          result['message']?.toString().contains('يجب تسجيل الدخول') == true) {
        _showLoginRequiredDialog();
        return;
      }

      if (result['success'] == true) {
        setState(() => _successMessage = result['message'] ?? t('successMessage'));

        _formKey.currentState!.reset();
        _nameController.clear();
        _emailController.clear();
        _phoneController.clear();
        _messageController.clear();
        setState(() => _selectedSubject = null);

        Future.delayed(const Duration(seconds: 5), () {
          if (mounted) setState(() => _successMessage = null);
        });
      } else {
        setState(() => _errorMessage = result['message'] ?? t('connectionError'));
      }
    } catch (e) {
      setState(() {
        _isLoading = false;

        if (e.toString().contains('401') ||
            e.toString().contains('Unauthenticated') ||
            e.toString().contains('unauthenticated')) {
          _showLoginRequiredDialog();
        } else {
          _errorMessage = t('connectionError');
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    final locale = Provider.of<LocaleProvider>(context).locale.languageCode;

    return Directionality(
      textDirection: locale == 'ar' ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: isDark ? darkBg : primaryDark,
        body: Stack(
          children: [
            _buildParticles(),
            SafeArea(
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          _buildBackButton(isDark, locale),
                          const SizedBox(height: 30),
                          _buildHeader(),
                          const SizedBox(height: 30),
                          _buildTwoColumnLayout(isDark),
                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildParticles() {
    return AnimatedBuilder(
      animation: _particleController,
      builder: (_, __) => CustomPaint(
        size: Size.infinite,
        painter: _ParticlePainter(_particles, _particleController.value),
      ),
    );
  }

  Widget _buildBackButton(bool isDark, String locale) {
    return Align(
      alignment: locale == 'ar' ? Alignment.centerRight : Alignment.centerLeft,
      child: GestureDetector(
        onTap: _goBack,
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: isDark ? darkCard : Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: isDark ? secondary.withOpacity(0.3) : Colors.white.withOpacity(0.3),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.white.withOpacity(0.2),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Center(
            child: Icon(
              Icons.arrow_back,
              color: isDark ? darkText : Colors.white,
              size: 24,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Text(
          '📞 ${t('pageTitle')}',
          style: GoogleFonts.amiri(
            color: Colors.white,
            fontSize: 48,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(color: Colors.white.withOpacity(0.3), blurRadius: 30),
            ],
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        Text(
          t('pageSubtitle'),
          style: GoogleFonts.tajawal(
            color: Colors.white.withOpacity(0.95),
            fontSize: 22,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildTwoColumnLayout(bool isDark) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 900) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildContactInfoCard(isDark)),
              const SizedBox(width: 15),
              Expanded(child: _buildContactFormCard(isDark)),
            ],
          );
        } else {
          return Column(
            children: [
              _buildContactInfoCard(isDark),
              const SizedBox(height: 15),
              _buildContactFormCard(isDark),
            ],
          );
        }
      },
    );
  }

  Widget _buildContactInfoCard(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? darkCard : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 40,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text('📍', style: TextStyle(fontSize: 24)),
                const SizedBox(width: 8),
                Text(
                  t('contactInfo'),
                  style: GoogleFonts.tajawal(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            _buildInfoItem(icon: '📍', title: t('address'), content: _contactInfo['address']!, isDark: isDark),
            _buildInfoItem(icon: '📞', title: t('phone'), content: _contactInfo['phone']!, isDark: isDark, isLink: true, linkPrefix: 'tel:'),
            _buildInfoItem(icon: '✉️', title: t('email'), content: _contactInfo['email']!, isDark: isDark, isLink: true, linkPrefix: 'mailto:'),
            _buildInfoItem(icon: '🕐', title: t('workingHours'), content: _contactInfo['working_hours']!, isDark: isDark),
            const SizedBox(height: 15),
            // ✅ تم إزالة استدعاء _buildSocialLinks
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem({
    required String icon,
    required String title,
    required String content,
    required bool isDark,
    bool isLink = false,
    String linkPrefix = '',
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isDark ? darkBg : bgLight,
        borderRadius: BorderRadius.circular(10),
        border: const Border(right: BorderSide(color: secondary, width: 3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [primary, primary.withOpacity(0.7)]),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                icon, 
                style: const TextStyle(
                  fontSize: 22,
                  color: Colors.white
                )
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title, 
                  style: GoogleFonts.tajawal(
                    fontSize: 15,
                    fontWeight: FontWeight.bold, 
                    color: isDark ? darkText : textDark
                  )
                ),
                const SizedBox(height: 3),
                if (isLink)
                  InkWell(
                    onTap: () {},
                    child: Text(
                      content, 
                      style: GoogleFonts.tajawal(
                        fontSize: 12,
                        color: secondary, 
                        decoration: TextDecoration.underline
                      )
                    ),
                  )
                else
                  Text(
                    content, 
                    style: GoogleFonts.tajawal(
                      fontSize: 12,
                      color: isDark ? darkText.withOpacity(0.7) : textLight
                    )
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactFormCard(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? darkCard : Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.4), blurRadius: 70, offset: const Offset(0, 25))],
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [primary, primaryDark], begin: Alignment.topLeft, end: Alignment.bottomRight),
              borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
            ),
            child: Column(
              children: [
                Text('📝 ${t('sendMessage')}', style: GoogleFonts.amiri(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                const SizedBox(height: 5),
                Text(t('formSubtitle'), style: GoogleFonts.tajawal(color: Colors.white.withOpacity(0.9), fontSize: 16)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  if (_successMessage != null) _buildSuccessMessage(),
                  if (_errorMessage != null) _buildErrorMessage(),
                  _buildFormRow(children: [
                    _buildTextField(controller: _nameController, label: t('fullName'), hint: t('enterName'), isDark: isDark, required: true),
                    _buildTextField(
                      controller: _emailController,
                      label: t('emailLabel'),
                      hint: t('enterEmail'),
                      isDark: isDark,
                      required: true,
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) {
                        if (v?.isEmpty ?? true) return t('thisFieldRequired');
                        if (!v!.contains('@')) return t('invalidEmail');
                        return null;
                      },
                    ),
                  ]),
                  _buildFormRow(children: [
                    _buildTextField(controller: _phoneController, label: t('phoneLabel'), hint: t('enterPhone'), isDark: isDark, required: false, keyboardType: TextInputType.phone),
                    _buildSubjectField(isDark),
                  ]),
                  _buildMessageField(isDark),
                  const SizedBox(height: 30),
                  _buildSubmitButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormRow({required List<Widget> children}) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 600) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children.map((child) => Expanded(child: child)).toList(),
            ),
          );
        } else {
          return Column(children: children);
        }
      },
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required bool isDark,
    bool required = false,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(label, style: GoogleFonts.tajawal(color: isDark ? darkText : textDark, fontSize: 16, fontWeight: FontWeight.bold)),
              if (required) Text(' *', style: GoogleFonts.tajawal(color: danger, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            validator: validator ?? (required ? (v) => (v?.isEmpty ?? true) ? t('thisFieldRequired') : null : null),
            style: GoogleFonts.tajawal(color: isDark ? darkText : textDark, fontSize: 16),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: GoogleFonts.tajawal(color: Colors.grey.shade400, fontSize: 14),
              filled: true,
              fillColor: isDark ? darkBg : Colors.white,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300, width: 2)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300, width: 2)),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: primary, width: 2)),
              errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: danger, width: 2)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectField(bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(t('subject'), style: GoogleFonts.tajawal(color: isDark ? darkText : textDark, fontSize: 16, fontWeight: FontWeight.bold)),
              const Text(' *', style: TextStyle(color: danger, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: _selectedSubject,
            validator: (v) => (v == null || v.isEmpty) ? t('thisFieldRequired') : null,
            decoration: InputDecoration(
              filled: true,
              fillColor: isDark ? darkBg : Colors.white,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300, width: 2)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300, width: 2)),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: primary, width: 2)),
              errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: danger, width: 2)),
            ),
            icon: const Icon(Icons.keyboard_arrow_down, color: primary),
            isExpanded: true,
            dropdownColor: isDark ? darkCard : Colors.white,
            items: [
              DropdownMenuItem(
                value: null,
                child: Text(t('selectSubject'), style: GoogleFonts.tajawal(color: isDark ? darkText.withOpacity(0.5) : textLight, fontSize: 14)),
              ),
              ..._subjects.map((s) => DropdownMenuItem(
                    value: s['value'],
                    child: Text(s['label']!, style: GoogleFonts.tajawal(color: isDark ? darkText : textDark, fontSize: 14)),
                  )),
            ],
            onChanged: (v) => setState(() => _selectedSubject = v),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageField(bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                t('message'), 
                style: GoogleFonts.tajawal(
                  color: isDark ? darkText : textDark, 
                  fontSize: 15,
                  fontWeight: FontWeight.bold
                )
              ),
              const Text(' *', style: TextStyle(color: danger, fontWeight: FontWeight.bold, fontSize: 15)),
            ],
          ),
          const SizedBox(height: 5),
          TextFormField(
            controller: _messageController,
            maxLines: 2,
            validator: (v) => (v?.isEmpty ?? true) ? t('thisFieldRequired') : null,
            style: GoogleFonts.tajawal(color: isDark ? darkText : textDark, fontSize: 13),
            decoration: InputDecoration(
              hintText: t('enterMessage'),
              hintStyle: GoogleFonts.tajawal(color: Colors.grey.shade400, fontSize: 12),
              filled: true,
              fillColor: isDark ? darkBg : Colors.white,
              contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8), 
                borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8), 
                borderSide: const BorderSide(color: primary, width: 1.5),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessMessage() {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFFD4EDDA), Color(0xFFC3E6CB)]),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: success, width: 1.5),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(5),
            decoration: const BoxDecoration(color: success, shape: BoxShape.circle),
            child: const Icon(Icons.check, color: Colors.white, size: 14),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _successMessage!,
              style: GoogleFonts.tajawal(color: const Color(0xFF155724), fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorMessage() {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFFF8D7DA), Color(0xFFF5C6CB)]),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: danger, width: 1.5),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(5),
            decoration: const BoxDecoration(color: danger, shape: BoxShape.circle),
            child: const Icon(Icons.warning, color: Colors.white, size: 14),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _errorMessage!,
              style: GoogleFonts.tajawal(color: const Color(0xFF721C24), fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 20),
      child: ElevatedButton(
        onPressed: _isLoading ? null : _submitForm,
        style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, shadowColor: Colors.transparent, padding: EdgeInsets.zero),
        child: Ink(
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [secondary, Color(0xFF8B6F47)]),
            borderRadius: BorderRadius.circular(50),
            boxShadow: [BoxShadow(color: secondary.withOpacity(0.4), blurRadius: 20, offset: const Offset(0, 8))],
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 20),
            alignment: Alignment.center,
            child: _isLoading
                ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3))
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('✉️ ', style: TextStyle(fontSize: 24)),
                      Text(t('sendButton'), style: GoogleFonts.tajawal(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

class _Particle {
  final double x;
  final double delay;
  final double speed;
  final double size;

  _Particle(int i)
      : x = (i * 37 % 100) / 100,
        delay = (i * 71 % 180) / 100,
        speed = 0.5 + (i % 5) * 0.1,
        size = 5 + (i % 10).toDouble();
}

class _ParticlePainter extends CustomPainter {
  final List<_Particle> particles;
  final double t;

  _ParticlePainter(this.particles, this.t);

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      final progress = ((t * p.speed + p.delay) % 1.0);
      final y = size.height * (1 - progress);
      final opacity = progress < 0.1 ? progress / 0.1 : progress > 0.9 ? (1 - progress) / 0.1 : 1.0;

      final paint = Paint()
        ..color = Colors.white.withOpacity(opacity * 0.3)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

      canvas.drawCircle(Offset(p.x * size.width, y), p.size, paint);
    }
  }

  @override
  bool shouldRepaint(_ParticlePainter old) => true;
}