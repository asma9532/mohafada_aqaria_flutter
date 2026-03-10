import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/locale_provider.dart';
import '../providers/theme_provider.dart';
import '../services/api_service.dart';
import '../providers/auth_provider.dart';
import 'home_screen.dart';

class NegativeCertificateScreen extends StatefulWidget {
  const NegativeCertificateScreen({super.key});

  @override
  State<NegativeCertificateScreen> createState() => _NegativeCertificateScreenState();
}

class _NegativeCertificateScreenState extends State<NegativeCertificateScreen> {
  // الألوان
  static const Color primary = Color(0xFF1A5632);
  static const Color primaryDark = Color(0xFF0D3D20);
  static const Color secondary = Color(0xFFC49B63);
  static const Color accent = Color(0xFF8B6F47);
  static const Color bgLight = Color(0xFFF8F6F1);
  static const Color textDark = Color(0xFF2D2D2D);
  static const Color textLight = Color(0xFF6B6B6B);
  static const Color success = Color(0xFF28A745);
  static const Color error = Color(0xFFDC3545);
  static const Color darkBg = Color(0xFF1A1A1A);
  static const Color darkCard = Color(0xFF2D2D2D);
  static const Color darkText = Color(0xFFE8E8E8);

  int _currentStep = 1;

  final Map<String, Map<String, String>> translations = {
    'title': {
      'ar': 'طلب شهادة سلبية جديدة',
      'en': 'New Negative Certificate Request',
      'fr': 'Nouvelle Demande de Certificat Négatif',
    },
    'backButton': {
      'ar': 'رجوع',
      'en': 'Back',
      'fr': 'Retour',
    },
    'step1Title': {
      'ar': 'المرحلة الأولى: معلومات مقدم الطلب',
      'en': 'Step 1: Applicant Information',
      'fr': 'Étape 1: Informations du Demandeur',
    },
    'step2Title': {
      'ar': 'المرحلة الثانية: معلومات صاحب الملكية',
      'en': 'Step 2: Owner Information',
      'fr': 'Étape 2: Informations du Propriétaire',
    },
    'step1': {
      'ar': 'مقدم الطلب',
      'en': 'Applicant',
      'fr': 'Demandeur',
    },
    'step2': {
      'ar': 'صاحب الملكية',
      'en': 'Owner',
      'fr': 'Propriétaire',
    },
    'importantInfo': {
      'ar': 'معلومات مهمة',
      'en': 'Important Information',
      'fr': 'Informations Importantes',
    },
    'importantInfoMessage': {
      'ar': 'يرجى ملء جميع البيانات بدقة',
      'en': 'Please fill all data accurately',
      'fr': 'Veuillez remplir toutes les données avec précision',
    },
    'ownerInfo': {
      'ar': 'معلومات صاحب الملكية',
      'en': 'Owner Information',
      'fr': 'Informations du Propriétaire',
    },
    'applicantInfo': {
      'ar': 'معلومات مقدم الطلب',
      'en': 'Applicant Information',
      'fr': 'Informations du Demandeur',
    },
    'lastName': {
      'ar': 'اللقب',
      'en': 'Last Name',
      'fr': 'Nom',
    },
    'firstName': {
      'ar': 'الاسم',
      'en': 'First Name',
      'fr': 'Prénom',
    },
    'fatherName': {
      'ar': 'اسم الأب',
      'en': 'Father\'s Name',
      'fr': 'Nom du Père',
    },
    'birthDate': {
      'ar': 'تاريخ الميلاد',
      'en': 'Birth Date',
      'fr': 'Date de Naissance',
    },
    'birthPlace': {
      'ar': 'مكان الميلاد',
      'en': 'Birth Place',
      'fr': 'Lieu de Naissance',
    },
    'email': {
      'ar': 'البريد الإلكتروني',
      'en': 'Email',
      'fr': 'Email',
    },
    'phone': {
      'ar': 'رقم الهاتف',
      'en': 'Phone Number',
      'fr': 'Téléphone',
    },
    'next': {
      'ar': 'التالي',
      'en': 'Next',
      'fr': 'Suivant',
    },
    'previous': {
      'ar': 'السابق',
      'en': 'Previous',
      'fr': 'Précédent',
    },
    'submitRequest': {
      'ar': 'إرسال الطلب',
      'en': 'Submit Request',
      'fr': 'Soumettre la Demande',
    },
    'required': {
      'ar': 'مطلوب',
      'en': 'Required',
      'fr': 'Requis',
    },
    'enterEmail': {
      'ar': 'example@email.com',
      'en': 'example@email.com',
      'fr': 'example@email.com',
    },
    'enterPhone': {
      'ar': '0XXX XX XX XX',
      'en': '0XXX XX XX XX',
      'fr': '0XXX XX XX XX',
    },
    'successTitle': {
      'ar': 'تم الإرسال',
      'en': 'Sent',
      'fr': 'Envoyé',
    },
    'successMessage': {
      'ar': 'تم إرسال طلب الشهادة السلبية بنجاح',
      'en': 'Negative certificate request submitted successfully',
      'fr': 'Demande de certificat négatif envoyée avec succès',
    },
    'errorMessage': {
      'ar': 'فشل إرسال الطلب. حاول مرة أخرى',
      'en': 'Failed to submit request. Try again',
      'fr': 'Échec de l\'envoi de la demande. Réessayez',
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
    'ok': {
      'ar': 'حسناً',
      'en': 'OK',
      'fr': 'D\'accord',
    },
    'requiredFields': {
      'ar': 'الرجاء ملء جميع الحقول المطلوبة',
      'en': 'Please fill all required fields',
      'fr': 'Veuillez remplir tous les champs requis',
    },
  };

  String t(String key, BuildContext context) {
    final locale = Provider.of<LocaleProvider>(context, listen: false).locale.languageCode;
    return translations[key]?[locale] ?? translations[key]?['ar'] ?? key;
  }

  // Controllers
  final _ownerLastnameController = TextEditingController();
  final _ownerFirstnameController = TextEditingController();
  final _ownerFatherController = TextEditingController();
  final _ownerBirthdateController = TextEditingController();
  final _ownerBirthplaceController = TextEditingController();

  final _applicantLastnameController = TextEditingController();
  final _applicantFirstnameController = TextEditingController();
  final _applicantFatherController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _ownerLastnameController.dispose();
    _ownerFirstnameController.dispose();
    _ownerFatherController.dispose();
    _ownerBirthdateController.dispose();
    _ownerBirthplaceController.dispose();
    _applicantLastnameController.dispose();
    _applicantFirstnameController.dispose();
    _applicantFatherController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  bool _validateStep1() {
    if (_applicantLastnameController.text.isEmpty ||
        _applicantFirstnameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _phoneController.text.isEmpty) {
      _showDialog(
        context,
        title: t('importantInfo', context),
        message: t('requiredFields', context),
        isError: true,
      );
      return false;
    }
    return true;
  }

  bool _validateStep2() {
    if (_ownerLastnameController.text.isEmpty ||
        _ownerFirstnameController.text.isEmpty) {
      _showDialog(
        context,
        title: t('importantInfo', context),
        message: t('requiredFields', context),
        isError: true,
      );
      return false;
    }
    return true;
  }

  void _nextStep() {
    if (_currentStep == 1 && _validateStep1()) {
      setState(() => _currentStep = 2);
    }
  }

  void _prevStep() {
    if (_currentStep == 2) {
      setState(() => _currentStep = 1);
    }
  }

  Future<bool> _checkLoginStatus() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final token = await authProvider.getToken();

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
                t('loginRequired', context),
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
          t('loginRequiredMessage', context),
          style: GoogleFonts.tajawal(
            color: textDark,
            fontSize: 15,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              t('cancel', context),
              style: GoogleFonts.tajawal(color: textLight),
            ),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              _goToLogin();
            },
            icon: const Icon(Icons.login, size: 18),
            label: Text(
              t('goToLogin', context),
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

  Future<void> _submitForm(BuildContext context) async {
    final isLoggedIn = await _checkLoginStatus();
    if (!isLoggedIn) return;

    if (!_validateStep2()) return;

    setState(() => _isLoading = true);

    final data = {
      'owner_lastname': _ownerLastnameController.text,
      'owner_firstname': _ownerFirstnameController.text,
      'owner_father': _ownerFatherController.text,
      'owner_birthdate': _ownerBirthdateController.text,
      'owner_birthplace': _ownerBirthplaceController.text,
      'applicant_lastname': _applicantLastnameController.text,
      'applicant_firstname': _applicantFirstnameController.text,
      'applicant_father': _applicantFatherController.text,
      'email': _emailController.text,
      'phone': _phoneController.text,
    };

    try {
      final result = await ApiService.submitNegativeCertificate(data);

      setState(() => _isLoading = false);

      if (result['success']) {
        _showDialog(
          context,
          title: t('successTitle', context),
          message: t('successMessage', context),
          isError: false,
        );
        _clearForm();
      } else if (result['needLogin'] == true) {
        _showLoginRequiredDialog();
      } else {
        _showDialog(
          context,
          title: 'خطأ',
          message: result['message'] ?? t('errorMessage', context),
          isError: true,
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      _showDialog(
        context,
        title: 'خطأ',
        message: 'حدث خطأ: $e',
        isError: true,
      );
    }
  }

  void _showDialog(BuildContext context,
      {required String title,
      required String message,
      required bool isError}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          title,
          style: GoogleFonts.tajawal(
            fontWeight: FontWeight.bold,
            color: isError ? error : success,
          ),
        ),
        content: Text(
          message,
          style: GoogleFonts.tajawal(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              t('ok', context),
              style: GoogleFonts.tajawal(color: primary),
            ),
          ),
        ],
      ),
    );
  }

  void _clearForm() {
    _ownerLastnameController.clear();
    _ownerFirstnameController.clear();
    _ownerFatherController.clear();
    _ownerBirthdateController.clear();
    _ownerBirthplaceController.clear();
    _applicantLastnameController.clear();
    _applicantFirstnameController.clear();
    _applicantFatherController.clear();
    _emailController.clear();
    _phoneController.clear();
    setState(() => _currentStep = 1);
  }

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;
    final lang = localeProvider.locale.languageCode;

    return Directionality(
      textDirection: localeProvider.textDirection,
      child: Scaffold(
        backgroundColor: primary,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildBackButton(lang),
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      color: isDark ? darkCard : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 60,
                          offset: const Offset(0, 20),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _buildHeader(context),
                        _buildProgressBar(context),
                        Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            children: [
                              AnimatedSwitcher(
                                duration: const Duration(milliseconds: 400),
                                transitionBuilder: (child, animation) =>
                                    FadeTransition(
                                  opacity: animation,
                                  child: child,
                                ),
                                child: _currentStep == 1
                                    ? _buildStep1(context, isDark)
                                    : _buildStep2(context, isDark),
                              ),
                            ],
                          ),
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

  // ✅ زر الرجوع المُصلَح
  Widget _buildBackButton(String lang) {
    return Align(
      alignment: lang == 'ar' ? Alignment.topRight : Alignment.topLeft,
      child: GestureDetector(
        onTap: () {
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          } else {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          }
        },
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
    );
  }

  Widget _buildProgressBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: Row(
        children: [
          _buildStepDot(1, t('step1', context)),
          _buildStepLine(1),
          _buildStepDot(2, t('step2', context)),
        ],
      ),
    );
  }

  Widget _buildStepDot(int step, String label) {
    final isActive = _currentStep >= step;
    final isCurrent = _currentStep == step;

    return Expanded(
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              gradient: isActive
                  ? const LinearGradient(
                      colors: [primary, success],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : null,
              color: isActive ? null : Colors.grey.shade300,
              shape: BoxShape.circle,
              boxShadow: isCurrent
                  ? [
                      BoxShadow(
                        color: primary.withOpacity(0.4),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ]
                  : null,
            ),
            child: Center(
              child: Text(
                '$step',
                style: GoogleFonts.tajawal(
                  color: isActive ? Colors.white : Colors.grey,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.tajawal(
              color: isActive ? primary : Colors.grey,
              fontSize: 12,
              fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepLine(int step) {
    return Expanded(
      child: Container(
        height: 4,
        color: _currentStep > step ? primary : Colors.grey.shade300,
      ),
    );
  }

  Widget _buildStep1(BuildContext context, bool isDark) {
    return Container(
      key: const ValueKey(1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoNotice(context),
          const SizedBox(height: 24),
          _buildApplicantCard(context, isDark),
          const SizedBox(height: 24),
          _buildNextButton(),
        ],
      ),
    );
  }

  Widget _buildStep2(BuildContext context, bool isDark) {
    return Container(
      key: const ValueKey(2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoNotice(context),
          const SizedBox(height: 24),
          _buildOwnerCard(context, isDark),
          const SizedBox(height: 24),
          _buildNavigationButtons(),
        ],
      ),
    );
  }

  Widget _buildNextButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _nextStep,
        icon: const Icon(Icons.arrow_forward),
        label: Text(
          t('next', context),
          style: GoogleFonts.tajawal(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: _prevStep,
            icon: const Icon(Icons.arrow_back),
            label: Text(
              t('previous', context),
              style: GoogleFonts.tajawal(),
            ),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              side: BorderSide(color: Colors.grey.shade300),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: primary,
                    strokeWidth: 3,
                  ),
                )
              : ElevatedButton.icon(
                  onPressed: () => _submitForm(context),
                  icon: const Icon(Icons.send),
                  label: Text(
                    t('submitRequest', context),
                    style: GoogleFonts.tajawal(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [primary, primaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.edit_document, color: Colors.white, size: 28),
          const SizedBox(width: 12),
          Text(
            t('title', context),
            style: GoogleFonts.tajawal(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoNotice(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFE3F2FD), Color(0xFFBBDEFB)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(10),
        border: const Border(
          right: BorderSide(color: Color(0xFF2196F3), width: 4),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info, color: Color(0xFF2196F3), size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  t('importantInfo', context),
                  style: GoogleFonts.tajawal(
                    color: const Color(0xFF1565C0),
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  t('importantInfoMessage', context),
                  style: GoogleFonts.tajawal(
                    color: const Color(0xFF0D47A1),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOwnerCard(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? darkCard : bgLight,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: primary.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.push_pin, color: primary),
              const SizedBox(width: 8),
              Text(
                t('ownerInfo', context),
                style: GoogleFonts.tajawal(
                  color: primary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const Divider(color: secondary, thickness: 2, height: 24),
          _buildTextField(
            context,
            label: t('lastName', context),
            required: true,
            controller: _ownerLastnameController,
            isDark: isDark,
          ),
          _buildTextField(
            context,
            label: t('firstName', context),
            required: true,
            controller: _ownerFirstnameController,
            isDark: isDark,
          ),
          _buildTextField(
            context,
            label: t('fatherName', context),
            controller: _ownerFatherController,
            isDark: isDark,
          ),
          _buildDateField(
            context,
            label: t('birthDate', context),
            controller: _ownerBirthdateController,
            isDark: isDark,
          ),
          _buildTextField(
            context,
            label: t('birthPlace', context),
            controller: _ownerBirthplaceController,
            isDark: isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildApplicantCard(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? darkCard : bgLight,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: primary.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.person, color: primary),
              const SizedBox(width: 8),
              Text(
                t('applicantInfo', context),
                style: GoogleFonts.tajawal(
                  color: primary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const Divider(color: secondary, thickness: 2, height: 24),
          _buildTextField(
            context,
            label: t('lastName', context),
            required: true,
            controller: _applicantLastnameController,
            isDark: isDark,
          ),
          _buildTextField(
            context,
            label: t('firstName', context),
            required: true,
            controller: _applicantFirstnameController,
            isDark: isDark,
          ),
          _buildTextField(
            context,
            label: t('fatherName', context),
            controller: _applicantFatherController,
            isDark: isDark,
          ),
          _buildTextField(
            context,
            label: t('email', context),
            required: true,
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            hint: t('enterEmail', context),
            isDark: isDark,
          ),
          _buildTextField(
            context,
            label: t('phone', context),
            required: true,
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            hint: t('enterPhone', context),
            isDark: isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    BuildContext context, {
    required String label,
    bool required = false,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    String? hint,
    bool enabled = true,
    void Function(String)? onChanged,
    required bool isDark,
  }) {
    final locale = Provider.of<LocaleProvider>(context).locale.languageCode;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                label,
                style: GoogleFonts.tajawal(
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : textDark,
                  fontSize: 14,
                ),
              ),
              if (required)
                Text(
                  ' *',
                  style: GoogleFonts.tajawal(color: error),
                ),
            ],
          ),
          const SizedBox(height: 6),
          TextField(
            controller: controller,
            keyboardType: keyboardType,
            enabled: enabled,
            onChanged: onChanged,
            textAlign: locale == 'ar' ? TextAlign.right : TextAlign.left,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: GoogleFonts.tajawal(color: textLight),
              filled: true,
              fillColor: enabled
                  ? (isDark ? Colors.grey[800] : Colors.white)
                  : (isDark ? Colors.grey[700] : Colors.grey[200]),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide:
                    const BorderSide(color: Color(0xFFE0E0E0), width: 2),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide:
                    const BorderSide(color: Color(0xFFE0E0E0), width: 2),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: primary, width: 2),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
            style:
                GoogleFonts.tajawal(color: isDark ? Colors.white : textDark),
          ),
        ],
      ),
    );
  }

  Widget _buildDateField(
    BuildContext context, {
    required String label,
    required TextEditingController controller,
    required bool isDark,
  }) {
    final locale = Provider.of<LocaleProvider>(context).locale.languageCode;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.tajawal(
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : textDark,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: controller,
            readOnly: true,
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
                builder: (context, child) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: const ColorScheme.light(
                        primary: primary,
                      ),
                    ),
                    child: child!,
                  );
                },
              );
              if (date != null) {
                controller.text =
                    '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
              }
            },
            textAlign: locale == 'ar' ? TextAlign.right : TextAlign.left,
            decoration: InputDecoration(
              suffixIcon: const Icon(Icons.calendar_today, color: primary),
              filled: true,
              fillColor: isDark ? Colors.grey[800] : Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide:
                    const BorderSide(color: Color(0xFFE0E0E0), width: 2),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide:
                    const BorderSide(color: Color(0xFFE0E0E0), width: 2),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: primary, width: 2),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
            style:
                GoogleFonts.tajawal(color: isDark ? Colors.white : textDark),
          ),
        ],
      ),
    );
  }
}