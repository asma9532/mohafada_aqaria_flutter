import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/locale_provider.dart';
import '../providers/theme_provider.dart';
import '../services/api_service.dart';
import '../providers/auth_provider.dart';

class RealEstateCardRequestScreen extends StatefulWidget {
  final String? cardType;
  
  const RealEstateCardRequestScreen({
    super.key,
    this.cardType,
  });

  @override
  State<RealEstateCardRequestScreen> createState() => _RealEstateCardRequestScreenState();
}

class _RealEstateCardRequestScreenState extends State<RealEstateCardRequestScreen> with SingleTickerProviderStateMixin {
  // الألوان
  static const Color primaryGreen = Color(0xFF1A5632);
  static const Color primaryDark = Color(0xFF0D3D20);
  static const Color secondaryGold = Color(0xFFC49B63);
  static const Color accentBrown = Color(0xFF8B6F47);
  static const Color bgLight = Color(0xFFF8F6F1);
  static const Color textDark = Color(0xFF2D2D2D);
  static const Color textLight = Color(0xFF6B6B6B);
  static const Color darkBg = Color(0xFF1A1A1A);
  static const Color darkCard = Color(0xFF2D2D2D);
  static const Color darkText = Color(0xFFE8E8E8);
  static const Color errorColor = Color(0xFFDC3545);

  // ترجمة النصوص
  final Map<String, Map<String, String>> translations = {
    'pageTitle': {
      'ar': 'طلب بطاقة عقارية',
      'en': 'Real Estate Card Request',
      'fr': 'Demande de Carte Foncière',
    },
    'pageSubtitle': {
      'ar': 'يرجى ملء جميع الحقول المطلوبة',
      'en': 'Please fill all required fields',
      'fr': 'Veuillez remplir tous les champs requis',
    },
    'applicantInfo': {
      'ar': 'معلومات مقدم الطلب',
      'en': 'Applicant Information',
      'fr': 'Informations du Demandeur',
    },
    'ownerInfo': {
      'ar': 'معلومات صاحب الملكية',
      'en': 'Owner Information',
      'fr': 'Informations du Propriétaire',
    },
    'propertyInfo': {
      'ar': 'معلومات العقار',
      'en': 'Property Information',
      'fr': 'Informations sur la Propriété',
    },
    'person': {
      'ar': 'شخص',
      'en': 'Person',
      'fr': 'Personne',
    },
    'company': {
      'ar': 'مؤسسة',
      'en': 'Company',
      'fr': 'Entreprise',
    },
    'nationalId': {
      'ar': 'رقم التعريف الوطني',
      'en': 'National ID Number',
      'fr': 'Numéro d\'Identification National',
    },
    'nationalCardId': {
      'ar': 'رقم بطاقة التعريف الوطنية',
      'en': 'National ID Card Number',
      'fr': 'Numéro de Carte d\'Identité Nationale',
    },
    'companyTaxId': {
      'ar': 'رقم التعريف الضريبي للمؤسسة',
      'en': 'Company Tax ID',
      'fr': 'Numéro d\'Identification Fiscale de l\'Entreprise',
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
    'companyName': {
      'ar': 'اسم المؤسسة',
      'en': 'Company Name',
      'fr': 'Nom de l\'Entreprise',
    },
    'companyRepresentative': {
      'ar': 'ممثل المؤسسة',
      'en': 'Company Representative',
      'fr': 'Représentant de l\'Entreprise',
    },
    'companyEmail': {
      'ar': 'البريد الإلكتروني للمؤسسة',
      'en': 'Company Email',
      'fr': 'Email de l\'Entreprise',
    },
    'companyPhone': {
      'ar': 'هاتف المؤسسة',
      'en': 'Company Phone',
      'fr': 'Téléphone de l\'Entreprise',
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
    'surveyed': {
      'ar': 'ممسوح',
      'en': 'Surveyed',
      'fr': 'Levé',
    },
    'notSurveyed': {
      'ar': 'غير ممسوح',
      'en': 'Not Surveyed',
      'fr': 'Non Levé',
    },
    'section': {
      'ar': 'القسم',
      'en': 'Section',
      'fr': 'Section',
    },
    'municipality': {
      'ar': 'البلدية',
      'en': 'Municipality',
      'fr': 'Municipalité',
    },
    'planNumber': {
      'ar': 'رقم المخطط',
      'en': 'Plan Number',
      'fr': 'Numéro de Plan',
    },
    'parcelNumber': {
      'ar': 'رقم القطعة',
      'en': 'Parcel Number',
      'fr': 'Numéro de Parcelle',
    },
    'subdivisionNumber': {
      'ar': 'رقم التجزئة',
      'en': 'Subdivision Number',
      'fr': 'Numéro de Subdivision',
    },
    'stepApplicant': {
      'ar': 'الطالب',
      'en': 'Applicant',
      'fr': 'Demandeur',
    },
    'stepOwner': {
      'ar': 'المالك',
      'en': 'Owner',
      'fr': 'Propriétaire',
    },
    'stepProperty': {
      'ar': 'العقار',
      'en': 'Property',
      'fr': 'Propriété',
    },
    'previous': {
      'ar': 'السابق',
      'en': 'Previous',
      'fr': 'Précédent',
    },
    'next': {
      'ar': 'التالي',
      'en': 'Next',
      'fr': 'Suivant',
    },
    'submit': {
      'ar': 'إرسال الطلب',
      'en': 'Submit Request',
      'fr': 'Soumettre la Demande',
    },
    'successMessage': {
      'ar': 'تم إرسال الطلب بنجاح',
      'en': 'Request submitted successfully',
      'fr': 'Demande soumise avec succès',
    },
    'required': {
      'ar': 'مطلوب',
      'en': 'Required',
      'fr': 'Requis',
    },
    'fillRequiredFields': {
      'ar': 'يرجى ملء جميع الحقول المطلوبة',
      'en': 'Please fill all required fields',
      'fr': 'Veuillez remplir tous les champs requis',
    },
    // ✅ جديد: رسائل تسجيل الدخول
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

  // دالة الترجمة المعدلة
  String t(String key) {
    final locale = Provider.of<LocaleProvider>(context, listen: false).locale.languageCode;
    return translations[key]?[locale] ?? translations[key]?['ar'] ?? key;
  }

  // Controllers
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  late AnimationController _animationController;
  late PageController _pageController;

  // Current Step
  int _currentStep = 0;
  final int _totalSteps = 3;

  // أنواع الطالب والمالك
  String _applicantType = 'person';
  String _ownerType = 'person';
  String _propertyStatus = 'surveyed';

  // Controllers for Applicant (Person)
  final _applicantNinController = TextEditingController();
  final _applicantLastnameController = TextEditingController();
  final _applicantFirstnameController = TextEditingController();
  final _applicantFatherController = TextEditingController();
  final _applicantEmailController = TextEditingController();
  final _applicantPhoneController = TextEditingController();

  // Controllers for Applicant (Company)
  final _companyNameController = TextEditingController();
  final _companyNinController = TextEditingController();
  final _companyRepresentativeController = TextEditingController();
  final _companyEmailController = TextEditingController();
  final _companyPhoneController = TextEditingController();

  // Controllers for Owner (Person)
  final _ownerNinController = TextEditingController();
  final _ownerLastnameController = TextEditingController();
  final _ownerFirstnameController = TextEditingController();
  final _ownerFatherController = TextEditingController();
  final _ownerBirthdateController = TextEditingController();
  final _ownerBirthplaceController = TextEditingController();

  // Controllers for Owner (Company)
  final _ownerCompanyNameController = TextEditingController();
  final _ownerCompanyNinController = TextEditingController();
  final _ownerCompanyRepresentativeController = TextEditingController();
  final _ownerCompanyEmailController = TextEditingController();
  final _ownerCompanyPhoneController = TextEditingController();

  // Controllers for Property (Surveyed)
  final _sectionController = TextEditingController();
  final _municipalityController = TextEditingController();
  final _planNumberController = TextEditingController();
  final _parcelNumberController = TextEditingController();

  // Controllers for Property (Not Surveyed)
  final _municipalityNsController = TextEditingController();
  final _subdivisionNumberController = TextEditingController();
  final _parcelNumberNsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _pageController = PageController();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pageController.dispose();
    // Dispose all controllers
    _applicantNinController.dispose();
    _applicantLastnameController.dispose();
    _applicantFirstnameController.dispose();
    _applicantFatherController.dispose();
    _applicantEmailController.dispose();
    _applicantPhoneController.dispose();
    _companyNameController.dispose();
    _companyNinController.dispose();
    _companyRepresentativeController.dispose();
    _companyEmailController.dispose();
    _companyPhoneController.dispose();
    _ownerNinController.dispose();
    _ownerLastnameController.dispose();
    _ownerFirstnameController.dispose();
    _ownerFatherController.dispose();
    _ownerBirthdateController.dispose();
    _ownerBirthplaceController.dispose();
    _ownerCompanyNameController.dispose();
    _ownerCompanyNinController.dispose();
    _ownerCompanyRepresentativeController.dispose();
    _ownerCompanyEmailController.dispose();
    _ownerCompanyPhoneController.dispose();
    _sectionController.dispose();
    _municipalityController.dispose();
    _planNumberController.dispose();
    _parcelNumberController.dispose();
    _municipalityNsController.dispose();
    _subdivisionNumberController.dispose();
    _parcelNumberNsController.dispose();
    super.dispose();
  }

  // ✅ جديد: التحقق من تسجيل الدخول
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

  // ✅ جديد: عرض رسالة تسجيل الدخول
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
            const Icon(Icons.lock_outline, color: primaryGreen, size: 28),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                t('loginRequired'),
                style: GoogleFonts.tajawal(
                  fontWeight: FontWeight.bold,
                  color: primaryGreen,
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
              t('goToLogin'),
              style: GoogleFonts.tajawal(fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryGreen,
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

  // ✅ جديد: الانتقال لشاشة تسجيل الدخول
  void _goToLogin() {
    Navigator.pushNamed(context, '/login');
  }

  Future<void> _submitForm() async {
    // ✅ التحقق من تسجيل الدخول أولاً
    final isLoggedIn = await _checkLoginStatus();
    if (!isLoggedIn) {
      print('❌ المستخدم غير مسجل الدخول، تم إيقاف الإرسال');
      return;
    }

    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // تجميع البيانات حسب نوع الطالب والمالك
    Map<String, dynamic> data = {
      'applicant_type': _applicantType,
      'owner_type': _ownerType,
      'card_type': widget.cardType ?? '',
      'property_status': _propertyStatus,
      
      // معلومات العقار
      'section': _sectionController.text,
      'municipality': _municipalityController.text,
      'plan_number': _planNumberController.text,
      'parcel_number': _parcelNumberController.text,
      'municipality_ns': _municipalityNsController.text,
      'subdivision_number': _subdivisionNumberController.text,
      'parcel_number_ns': _parcelNumberNsController.text,
    };

    // إضافة بيانات مقدم الطلب حسب نوعه
    if (_applicantType == 'person') {
      data.addAll({
        'applicant_nin': _applicantNinController.text,
        'applicant_lastname': _applicantLastnameController.text,
        'applicant_firstname': _applicantFirstnameController.text,
        'applicant_father': _applicantFatherController.text,
        'applicant_email': _applicantEmailController.text,
        'applicant_phone': _applicantPhoneController.text,
      });
    } else {
      data.addAll({
        'company_name': _companyNameController.text,
        'company_nin': _companyNinController.text,
        'company_representative': _companyRepresentativeController.text,
        'company_email': _companyEmailController.text,
        'company_phone': _companyPhoneController.text,
      });
    }

    // إضافة بيانات صاحب الملكية حسب نوعه
    if (_ownerType == 'person') {
      data.addAll({
        'owner_nin': _ownerNinController.text,
        'owner_lastname': _ownerLastnameController.text,
        'owner_firstname': _ownerFirstnameController.text,
        'owner_father': _ownerFatherController.text,
        'owner_birthdate': _ownerBirthdateController.text,
        'owner_birthplace': _ownerBirthplaceController.text,
      });
    } else {
      data.addAll({
        'owner_company_name': _ownerCompanyNameController.text,
        'owner_company_nin': _ownerCompanyNinController.text,
        'owner_company_representative': _ownerCompanyRepresentativeController.text,
        'owner_company_email': _ownerCompanyEmailController.text,
        'owner_company_phone': _ownerCompanyPhoneController.text,
      });
    }

    print('📤 بيانات الطلب: $data');

    try {
      // إرسال البيانات للـ API
      final result = await ApiService.submitRealEstateCardRequest(data);
      
      setState(() => _isLoading = false);

      if (result['success'] == true) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                t('successMessage'),
                style: GoogleFonts.tajawal(),
              ),
              backgroundColor: primaryGreen,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          );
          Navigator.pop(context, true);
        }
      } else if (result['needLogin'] == true) {
        // ✅ إذا رجع الخادم 401، اعرض رسالة تسجيل الدخول
        _showLoginRequiredDialog();
      } else {
        _showErrorDialog(result['message'] ?? 'فشل إرسال الطلب');
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
        title: Text(
          'خطأ', 
          style: GoogleFonts.tajawal(fontWeight: FontWeight.bold)
        ),
        content: Text(
          message, 
          style: GoogleFonts.tajawal()
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'حسناً', 
              style: GoogleFonts.tajawal(),
            ),
          ),
        ],
      ),
    );
  }

  void _nextStep() {
    if (_currentStep < _totalSteps - 1) {
      _pageController.animateToPage(
        _currentStep + 1,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
      setState(() => _currentStep++);
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      _pageController.animateToPage(
        _currentStep - 1,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
      setState(() => _currentStep--);
    }
  }

  bool _validateCurrentStep() {
    if (_currentStep == 0) {
      if (_applicantType == 'person') {
        return _applicantLastnameController.text.isNotEmpty &&
               _applicantFirstnameController.text.isNotEmpty &&
               _applicantEmailController.text.isNotEmpty &&
               _applicantPhoneController.text.isNotEmpty &&
               _applicantEmailController.text.contains('@') &&
               !_applicantEmailController.text.contains(' ');
      } else {
        return _companyNameController.text.isNotEmpty &&
               _companyRepresentativeController.text.isNotEmpty &&
               _companyEmailController.text.isNotEmpty &&
               _companyPhoneController.text.isNotEmpty &&
               _companyEmailController.text.contains('@') &&
               !_companyEmailController.text.contains(' ');
      }
    } else if (_currentStep == 1) {
      if (_ownerType == 'person') {
        return _ownerLastnameController.text.isNotEmpty &&
               _ownerFirstnameController.text.isNotEmpty;
      } else {
        return _ownerCompanyNameController.text.isNotEmpty &&
               _ownerCompanyRepresentativeController.text.isNotEmpty &&
               _ownerCompanyEmailController.text.isNotEmpty &&
               _ownerCompanyPhoneController.text.isNotEmpty &&
               _ownerCompanyEmailController.text.contains('@') &&
               !_ownerCompanyEmailController.text.contains(' ');
      }
    } else if (_currentStep == 2) {
      if (_propertyStatus == 'surveyed') {
        return _sectionController.text.isNotEmpty &&
               _municipalityController.text.isNotEmpty &&
               _planNumberController.text.isNotEmpty &&
               _parcelNumberController.text.isNotEmpty;
      } else {
        return _municipalityNsController.text.isNotEmpty &&
               _subdivisionNumberController.text.isNotEmpty &&
               _parcelNumberNsController.text.isNotEmpty;
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final localeProvider = Provider.of<LocaleProvider>(context);
    final isDark = themeProvider.isDarkMode;
    final lang = localeProvider.locale.languageCode;

    return Directionality(
      textDirection: localeProvider.textDirection,
      child: Scaffold(
        backgroundColor: isDark ? darkBg : bgLight,
        body: Stack(
          children: [
            // Background Gradient Header
            Container(
              height: 280,
              decoration: BoxDecoration(
                gradient: isDark
                    ? null
                    : const LinearGradient(
                        colors: [primaryGreen, primaryDark],
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                      ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
            ),
            
            SafeArea(
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  // App Bar
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              // Back Button
                              GestureDetector(
                                onTap: () => Navigator.pop(context),
                                child: Container(
                                  width: 45,
                                  height: 45,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.3),
                                      width: 1.5,
                                    ),
                                  ),
                                  child: Icon(
                                    localeProvider.textDirection == TextDirection.rtl 
                                        ? Icons.arrow_forward 
                                        : Icons.arrow_back,
                                    color: Colors.white,
                                    size: 22,
                                  ),
                                ),
                              ),
                              const Spacer(),
                              // Title
                              Text(
                                t('pageTitle'),
                                style: GoogleFonts.tajawal(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Spacer(),
                              const SizedBox(width: 45),
                            ],
                          ),
                          const SizedBox(height: 30),
                          
                          // Card Type Display
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.3),
                                width: 2,
                              ),
                            ),
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(15),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.description,
                                    color: primaryGreen,
                                    size: 35,
                                  ),
                                ),
                                const SizedBox(height: 15),
                                Text(
                                  widget.cardType ?? t('pageTitle'),
                                  style: GoogleFonts.tajawal(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  t('pageSubtitle'),
                                  style: GoogleFonts.tajawal(
                                    fontSize: 14,
                                    color: Colors.white.withOpacity(0.9),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Form Content
                  SliverToBoxAdapter(
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                      decoration: BoxDecoration(
                        color: isDark ? darkCard : Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: (isDark ? Colors.white : primaryGreen).withOpacity(0.1),
                            blurRadius: 30,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            const SizedBox(height: 20),
                            
                            // Step Indicator
                            _buildStepIndicator(),
                            
                            const SizedBox(height: 20),
                            
                            // PageView for Steps
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.6,
                              child: PageView(
                                controller: _pageController,
                                physics: const NeverScrollableScrollPhysics(),
                                children: [
                                  _buildApplicantSection(isDark),
                                  _buildOwnerSection(isDark),
                                  _buildPropertySection(isDark),
                                ],
                              ),
                            ),
                            
                            const SizedBox(height: 20),
                            
                            // Navigation Buttons
                            _buildNavigationButtons(),
                            
                            const SizedBox(height: 30),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Loading overlay
            if (_isLoading)
              Container(
                color: Colors.black.withOpacity(0.5),
                child: const Center(
                  child: CircularProgressIndicator(
                    color: primaryGreen,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildApplicantSection(bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          _buildSectionHeader(
            icon: Icons.person_outline,
            title: t('applicantInfo'),
            color: primaryGreen,
          ),
          
          const SizedBox(height: 15),
          
          // Type Selector
          _buildTypeSelector(
            value: _applicantType,
            onChanged: (value) => setState(() => _applicantType = value),
            options: [
              {'value': 'person', 'label': t('person'), 'icon': Icons.person},
              {'value': 'company', 'label': t('company'), 'icon': Icons.business},
            ],
          ),
          
          const SizedBox(height: 15),
          
          // Person Fields
          if (_applicantType == 'person') ...[
            _buildModernTextField(
              controller: _applicantNinController,
              label: t('nationalCardId'),
              icon: Icons.badge_outlined,
              isDark: isDark,
            ),
            _buildModernTextField(
              controller: _applicantLastnameController,
              label: t('lastName'),
              icon: Icons.person_outline,
              isRequired: true,
              validator: (v) => v?.isEmpty ?? true ? t('required') : null,
              isDark: isDark,
            ),
            _buildModernTextField(
              controller: _applicantFirstnameController,
              label: t('firstName'),
              icon: Icons.person,
              isRequired: true,
              validator: (v) => v?.isEmpty ?? true ? t('required') : null,
              isDark: isDark,
            ),
            _buildModernTextField(
              controller: _applicantFatherController,
              label: t('fatherName'),
              icon: Icons.family_restroom,
              isDark: isDark,
            ),
            _buildModernTextField(
              controller: _applicantEmailController,
              label: t('email'),
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              isRequired: true,
              validator: (v) {
                if (v?.isEmpty ?? true) return t('required');
                if (!v!.contains('@') || !v.contains('.')) {
                  return 'البريد الإلكتروني غير صالح';
                }
                if (v.contains(' ')) {
                  return 'البريد الإلكتروني لا يجب أن يحتوي على مسافات';
                }
                return null;
              },
              isDark: isDark,
            ),
            _buildModernTextField(
              controller: _applicantPhoneController,
              label: t('phone'),
              icon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
              isRequired: true,
              validator: (v) => v?.isEmpty ?? true ? t('required') : null,
              isDark: isDark,
            ),
          ],
          
          // Company Fields
          if (_applicantType == 'company') ...[
            _buildModernTextField(
              controller: _companyNameController,
              label: t('companyName'),
              icon: Icons.business,
              isRequired: true,
              validator: (v) => v?.isEmpty ?? true ? t('required') : null,
              isDark: isDark,
            ),
            _buildModernTextField(
              controller: _companyNinController,
              label: t('companyTaxId'),
              icon: Icons.numbers,
              isDark: isDark,
            ),
            _buildModernTextField(
              controller: _companyRepresentativeController,
              label: t('companyRepresentative'),
              icon: Icons.person_outline,
              isRequired: true,
              validator: (v) => v?.isEmpty ?? true ? t('required') : null,
              isDark: isDark,
            ),
            _buildModernTextField(
              controller: _companyEmailController,
              label: t('companyEmail'),
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              isRequired: true,
              validator: (v) {
                if (v?.isEmpty ?? true) return t('required');
                if (!v!.contains('@') || !v.contains('.')) {
                  return 'البريد الإلكتروني غير صالح';
                }
                if (v.contains(' ')) {
                  return 'البريد الإلكتروني لا يجب أن يحتوي على مسافات';
                }
                return null;
              },
              isDark: isDark,
            ),
            _buildModernTextField(
              controller: _companyPhoneController,
              label: t('companyPhone'),
              icon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
              isRequired: true,
              validator: (v) => v?.isEmpty ?? true ? t('required') : null,
              isDark: isDark,
            ),
          ],
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildOwnerSection(bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          _buildSectionHeader(
            icon: Icons.home_outlined,
            title: t('ownerInfo'),
            color: secondaryGold,
          ),
          
          const SizedBox(height: 15),
          
          // Type Selector
          _buildTypeSelector(
            value: _ownerType,
            onChanged: (value) => setState(() => _ownerType = value),
            options: [
              {'value': 'person', 'label': t('person'), 'icon': Icons.person},
              {'value': 'company', 'label': t('company'), 'icon': Icons.business},
            ],
          ),
          
          const SizedBox(height: 15),
          
          // Person Fields
          if (_ownerType == 'person') ...[
            _buildModernTextField(
              controller: _ownerNinController,
              label: t('nationalId'),
              icon: Icons.badge_outlined,
              isDark: isDark,
            ),
            _buildModernTextField(
              controller: _ownerLastnameController,
              label: t('lastName'),
              icon: Icons.person_outline,
              isRequired: true,
              validator: (v) => v?.isEmpty ?? true ? t('required') : null,
              isDark: isDark,
            ),
            _buildModernTextField(
              controller: _ownerFirstnameController,
              label: t('firstName'),
              icon: Icons.person,
              isRequired: true,
              validator: (v) => v?.isEmpty ?? true ? t('required') : null,
              isDark: isDark,
            ),
            _buildModernTextField(
              controller: _ownerFatherController,
              label: t('fatherName'),
              icon: Icons.family_restroom,
              isDark: isDark,
            ),
            _buildDateField(
              controller: _ownerBirthdateController,
              label: t('birthDate'),
              icon: Icons.calendar_today,
              isDark: isDark,
            ),
            _buildModernTextField(
              controller: _ownerBirthplaceController,
              label: t('birthPlace'),
              icon: Icons.location_on_outlined,
              isDark: isDark,
            ),
          ],
          
          // Company Fields
          if (_ownerType == 'company') ...[
            _buildModernTextField(
              controller: _ownerCompanyNameController,
              label: t('companyName'),
              icon: Icons.business,
              isRequired: true,
              validator: (v) => v?.isEmpty ?? true ? t('required') : null,
              isDark: isDark,
            ),
            _buildModernTextField(
              controller: _ownerCompanyNinController,
              label: t('companyTaxId'),
              icon: Icons.numbers,
              isDark: isDark,
            ),
            _buildModernTextField(
              controller: _ownerCompanyRepresentativeController,
              label: t('companyRepresentative'),
              icon: Icons.person_outline,
              isRequired: true,
              validator: (v) => v?.isEmpty ?? true ? t('required') : null,
              isDark: isDark,
            ),
            _buildModernTextField(
              controller: _ownerCompanyEmailController,
              label: t('companyEmail'),
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              isRequired: true,
              validator: (v) {
                if (v?.isEmpty ?? true) return t('required');
                if (!v!.contains('@') || !v.contains('.')) {
                  return 'البريد الإلكتروني غير صالح';
                }
                if (v.contains(' ')) {
                  return 'البريد الإلكتروني لا يجب أن يحتوي على مسافات';
                }
                return null;
              },
              isDark: isDark,
            ),
            _buildModernTextField(
              controller: _ownerCompanyPhoneController,
              label: t('companyPhone'),
              icon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
              isRequired: true,
              validator: (v) => v?.isEmpty ?? true ? t('required') : null,
              isDark: isDark,
            ),
          ],
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildPropertySection(bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          _buildSectionHeader(
            icon: Icons.location_on_outlined,
            title: t('propertyInfo'),
            color: accentBrown,
          ),
          
          const SizedBox(height: 15),
          
          // Status Selector
          _buildTypeSelector(
            value: _propertyStatus,
            onChanged: (value) => setState(() => _propertyStatus = value),
            options: [
              {'value': 'surveyed', 'label': t('surveyed'), 'icon': Icons.check_circle},
              {'value': 'not_surveyed', 'label': t('notSurveyed'), 'icon': Icons.cancel},
            ],
          ),
          
          const SizedBox(height: 15),
          
          // Surveyed Fields
          if (_propertyStatus == 'surveyed') ...[
            _buildModernTextField(
              controller: _sectionController,
              label: t('section'),
              icon: Icons.apps,
              isRequired: true,
              validator: (v) => v?.isEmpty ?? true ? t('required') : null,
              isDark: isDark,
            ),
            _buildModernTextField(
              controller: _municipalityController,
              label: t('municipality'),
              icon: Icons.location_city,
              isRequired: true,
              validator: (v) => v?.isEmpty ?? true ? t('required') : null,
              isDark: isDark,
            ),
            _buildModernTextField(
              controller: _planNumberController,
              label: t('planNumber'),
              icon: Icons.map_outlined,
              isRequired: true,
              validator: (v) => v?.isEmpty ?? true ? t('required') : null,
              isDark: isDark,
            ),
            _buildModernTextField(
              controller: _parcelNumberController,
              label: t('parcelNumber'),
              icon: Icons.pin_outlined,
              isRequired: true,
              validator: (v) => v?.isEmpty ?? true ? t('required') : null,
              isDark: isDark,
            ),
          ],
          
          // Not Surveyed Fields
          if (_propertyStatus == 'not_surveyed') ...[
            _buildModernTextField(
              controller: _municipalityNsController,
              label: t('municipality'),
              icon: Icons.location_city,
              isRequired: true,
              validator: (v) => v?.isEmpty ?? true ? t('required') : null,
              isDark: isDark,
            ),
            _buildModernTextField(
              controller: _subdivisionNumberController,
              label: t('subdivisionNumber'),
              icon: Icons.grid_view,
              isRequired: true,
              validator: (v) => v?.isEmpty ?? true ? t('required') : null,
              isDark: isDark,
            ),
            _buildModernTextField(
              controller: _parcelNumberNsController,
              label: t('parcelNumber'),
              icon: Icons.pin_outlined,
              isRequired: true,
              validator: (v) => v?.isEmpty ?? true ? t('required') : null,
              isDark: isDark,
            ),
          ],
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSectionHeader({
    required IconData icon,
    required String title,
    required Color color,
  }) {
    final isDark = Provider.of<ThemeProvider>(context, listen: false).isDarkMode;
    
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color, color.withOpacity(0.7)],
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(icon, color: Colors.white, size: 24),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            style: GoogleFonts.tajawal(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? darkText : textDark,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTypeSelector({
    required String value,
    required Function(String) onChanged,
    required List<Map<String, dynamic>> options,
  }) {
    final isDark = Provider.of<ThemeProvider>(context, listen: false).isDarkMode;
    
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: isDark ? darkCard.withOpacity(0.5) : bgLight,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: primaryGreen.withOpacity(0.2), width: 2),
      ),
      child: Row(
        children: options.map((option) {
          final isSelected = value == option['value'];
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(option['value'] as String),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  gradient: isSelected
                      ? const LinearGradient(
                          colors: [primaryGreen, primaryDark],
                        )
                      : null,
                  color: isSelected ? null : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      option['icon'] as IconData,
                      color: isSelected ? Colors.white : (isDark ? darkText.withOpacity(0.7) : textLight),
                      size: 20,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      option['label'] as String,
                      style: GoogleFonts.tajawal(
                        color: isSelected ? Colors.white : (isDark ? darkText : textDark),
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildModernTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    bool isRequired = false,
    required bool isDark,
  }) {
    final locale = Provider.of<LocaleProvider>(context, listen: false).locale.languageCode;
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                label,
                style: GoogleFonts.tajawal(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isDark ? darkText : textDark,
                ),
              ),
              if (isRequired) ...[
                const SizedBox(width: 4),
                const Text(
                  '*',
                  style: TextStyle(color: Colors.red, fontSize: 16),
                ),
              ],
            ],
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: isDark ? darkBg : Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: isDark ? [] : [
                BoxShadow(
                  color: primaryGreen.withOpacity(0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: TextFormField(
              controller: controller,
              keyboardType: keyboardType,
              validator: validator,
              textAlign: locale == 'ar' ? TextAlign.right : TextAlign.left,
              style: GoogleFonts.tajawal(
                color: isDark ? darkText : textDark,
                fontSize: 15,
              ),
              decoration: InputDecoration(
                hintText: label,
                hintStyle: GoogleFonts.tajawal(
                  color: isDark ? Colors.grey.shade500 : textLight.withOpacity(0.6),
                  fontSize: 14,
                ),
                prefixIcon: Container(
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [primaryGreen, primaryDark],
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: Colors.white, size: 20),
                ),
                filled: true,
                fillColor: isDark ? Colors.grey.shade800 : bgLight.withOpacity(0.5),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(
                    color: primaryGreen.withOpacity(0.1),
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(
                    color: primaryGreen,
                    width: 2,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(
                    color: Colors.red,
                    width: 1.5,
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(
                    color: Colors.red,
                    width: 2,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required bool isDark,
  }) {
    final locale = Provider.of<LocaleProvider>(context, listen: false).locale.languageCode;
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.tajawal(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isDark ? darkText : textDark,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: isDark ? darkBg : Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: isDark ? [] : [
                BoxShadow(
                  color: primaryGreen.withOpacity(0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: TextFormField(
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
                          primary: primaryGreen,
                          onPrimary: Colors.white,
                          surface: Colors.white,
                          onSurface: textDark,
                        ),
                      ),
                      child: child!,
                    );
                  },
                );
                if (date != null) {
                  controller.text = locale == 'ar'
                      ? '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}'
                      : '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
                }
              },
              style: GoogleFonts.tajawal(
                color: isDark ? darkText : textDark,
                fontSize: 15,
              ),
              textAlign: locale == 'ar' ? TextAlign.right : TextAlign.left,
              decoration: InputDecoration(
                hintText: label,
                hintStyle: GoogleFonts.tajawal(
                  color: isDark ? Colors.grey.shade500 : textLight.withOpacity(0.6),
                  fontSize: 14,
                ),
                prefixIcon: Container(
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [primaryGreen, primaryDark],
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: Colors.white, size: 20),
                ),
                suffixIcon: const Icon(Icons.calendar_today, color: primaryGreen),
                filled: true,
                fillColor: isDark ? Colors.grey.shade800 : bgLight.withOpacity(0.5),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(
                    color: primaryGreen.withOpacity(0.1),
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(
                    color: primaryGreen,
                    width: 2,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepIndicator() {
    final isDark = Provider.of<ThemeProvider>(context, listen: false).isDarkMode;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          _buildStepCircle(0, t('stepApplicant'), Icons.person, isDark),
          _buildStepLine(0, isDark),
          _buildStepCircle(1, t('stepOwner'), Icons.home, isDark),
          _buildStepLine(1, isDark),
          _buildStepCircle(2, t('stepProperty'), Icons.location_on, isDark),
        ],
      ),
    );
  }

  Widget _buildStepCircle(int step, String label, IconData icon, bool isDark) {
    final isActive = _currentStep == step;
    final isCompleted = _currentStep > step;
    
    return Expanded(
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              gradient: isActive || isCompleted
                  ? const LinearGradient(
                      colors: [primaryGreen, primaryDark],
                    )
                  : null,
              color: isActive || isCompleted ? null : Colors.grey.shade300,
              shape: BoxShape.circle,
              boxShadow: isActive
                  ? [
                      BoxShadow(
                        color: primaryGreen.withOpacity(0.4),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ]
                  : null,
            ),
            child: Icon(
              isCompleted ? Icons.check : icon,
              color: isActive || isCompleted ? Colors.white : Colors.grey.shade600,
              size: 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: GoogleFonts.tajawal(
              fontSize: 12,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              color: isDark ? Colors.white : (isActive ? primaryGreen : textLight),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepLine(int step, bool isDark) {
    final isCompleted = _currentStep > step;
    
    return Expanded(
      child: Container(
        height: 3,
        margin: const EdgeInsets.only(bottom: 30),
        decoration: BoxDecoration(
          gradient: isCompleted
              ? const LinearGradient(
                  colors: [primaryGreen, primaryDark],
                )
              : null,
          color: isCompleted ? null : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }

  Widget _buildNavigationButtons() {
    final locale = Provider.of<LocaleProvider>(context, listen: false).locale.languageCode;
    final isDark = Provider.of<ThemeProvider>(context, listen: false).isDarkMode;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          // Previous Button
          if (_currentStep > 0)
            Expanded(
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  border: Border.all(color: primaryGreen, width: 2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: _previousStep,
                    borderRadius: BorderRadius.circular(12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          locale == 'ar' ? Icons.arrow_forward : Icons.arrow_back,
                          color: primaryGreen,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          t('previous'),
                          style: GoogleFonts.tajawal(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: primaryGreen,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          
          if (_currentStep > 0) const SizedBox(width: 12),
          
          // Next/Submit Button
          Expanded(
            flex: _currentStep == 0 ? 1 : 1,
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [primaryGreen, primaryDark],
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: primaryGreen.withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    if (_currentStep < _totalSteps - 1) {
                      if (_validateCurrentStep()) {
                        _nextStep();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              t('fillRequiredFields'),
                              style: GoogleFonts.tajawal(),
                            ),
                            backgroundColor: errorColor,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        );
                      }
                    } else {
                      _submitForm();
                    }
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _currentStep < _totalSteps - 1 ? t('next') : t('submit'),
                        style: GoogleFonts.tajawal(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        _currentStep < _totalSteps - 1
                            ? (locale == 'ar' ? Icons.arrow_back : Icons.arrow_forward)
                            : Icons.send,
                        color: Colors.white,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}