import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../providers/locale_provider.dart';
import '../services/api_service.dart';
import '../providers/auth_provider.dart';

class ContractExtractRequestScreen extends StatefulWidget {
  final String? selectedType;
  const ContractExtractRequestScreen({super.key, this.selectedType});

  @override
  State<ContractExtractRequestScreen> createState() => _ContractExtractRequestScreenState();
}

class _ContractExtractRequestScreenState extends State<ContractExtractRequestScreen>
    with SingleTickerProviderStateMixin {
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
  static const Color infoColor = Color(0xFF17A2B8);
  static const Color infoDark = Color(0xFF0277BD);
  static const Color warningColor = Color(0xFFFFC107);
  static const Color errorColor = Color(0xFFDC3545);

  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _showForm = false;
  late AnimationController _animCtrl;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  final Map<String, Map<String, String>> translations = {
    'title': {
      'ar': 'مستخرجات العقود',
      'en': 'Contract Extracts',
      'fr': 'Extraits de Contrats',
    },
    'subtitleSelect': {
      'ar': 'اختر نوع المستخرج المطلوب',
      'en': 'Select the required extract type',
      'fr': 'Sélectionnez le type d\'extrait requis',
    },
    'subtitleForm': {
      'ar': 'أكمل البيانات المطلوبة للمستخرج',
      'en': 'Complete the required data for the extract',
      'fr': 'Complétez les données requises pour l\'extrait',
    },
    'selectContractType': {
      'ar': 'اختر نوع العقد',
      'en': 'Select Contract Type',
      'fr': 'Sélectionnez le Type de Contrat',
    },
    'requestExtract': {
      'ar': 'طلب مستخرج',
      'en': 'Extract Request',
      'fr': 'Demande d\'Extrait',
    },
    'requiredFields': {
      'ar': 'الحقول التي تحمل (*) إجبارية',
      'en': 'Fields marked (*) are required',
      'fr': 'Les champs marqués (*) sont obligatoires',
    },
    'importantTips': {
      'ar': 'نصائح هامة',
      'en': 'Important Tips',
      'fr': 'Conseils Importants',
    },
    'tipsMessage': {
      'ar': 'تأكد من إدخال جميع البيانات بدقة. يمكنك استخدام رقم المجلد ورقم النشر للبحث عن الوثيقة المطلوبة.',
      'en': 'Make sure to enter all data accurately. You can use the volume number and publication number to search for the required document.',
      'fr': 'Assurez-vous de saisir toutes les données avec précision. Vous pouvez utiliser le numéro de volume et le numéro de publication pour rechercher le document requis.',
    },
    'applicantInfo': {
      'ar': 'معلومات مقدم الطلب',
      'en': 'Applicant Information',
      'fr': 'Informations du Demandeur',
    },
    'nin': {'ar': 'رقم التعريف الوطني (NIN)', 'en': 'National Identification Number (NIN)', 'fr': 'Numéro d\'Identification National (NIN)'},
    'enterNin': {'ar': 'أدخل رقم التعريف الوطني', 'en': 'Enter NIN', 'fr': 'Entrez le NIN'},
    'lastName': {'ar': 'اللقب', 'en': 'Last Name', 'fr': 'Nom'},
    'enterLastName': {'ar': 'أدخل اللقب', 'en': 'Enter last name', 'fr': 'Entrez le nom'},
    'firstName': {'ar': 'الاسم', 'en': 'First Name', 'fr': 'Prénom'},
    'enterFirstName': {'ar': 'أدخل الاسم', 'en': 'Enter first name', 'fr': 'Entrez le prénom'},
    'fatherName': {'ar': 'اسم الأب', 'en': 'Father\'s Name', 'fr': 'Nom du Père'},
    'enterFatherName': {'ar': 'أدخل اسم الأب', 'en': 'Enter father\'s name', 'fr': 'Entrez le nom du père'},
    'email': {'ar': 'البريد الإلكتروني', 'en': 'Email', 'fr': 'Email'},
    'enterEmail': {'ar': 'example@email.com', 'en': 'example@email.com', 'fr': 'example@email.com'},
    'phone': {'ar': 'رقم الهاتف', 'en': 'Phone Number', 'fr': 'Téléphone'},
    'enterPhone': {'ar': '0XXX XX XX XX', 'en': '0XXX XX XX XX', 'fr': '0XXX XX XX XX'},
    'documentInfo': {
      'ar': 'معلومات الوثيقة العقارية',
      'en': 'Real Estate Document Information',
      'fr': 'Informations du Document Foncier',
    },
    'volumeNumber': {'ar': 'رقم المجلد', 'en': 'Volume Number', 'fr': 'Numéro de Volume'},
    'enterVolume': {'ar': 'أدخل رقم المجلد', 'en': 'Enter volume number', 'fr': 'Entrez le numéro de volume'},
    'publicationNumber': {'ar': 'رقم النشر', 'en': 'Publication Number', 'fr': 'Numéro de Publication'},
    'enterPublication': {'ar': 'أدخل رقم النشر', 'en': 'Enter publication number', 'fr': 'Entrez le numéro de publication'},
    'publicationDate': {'ar': 'تاريخ النشر', 'en': 'Publication Date', 'fr': 'Date de Publication'},
    'selectDate': {'ar': 'اختر التاريخ', 'en': 'Select date', 'fr': 'Sélectionnez la date'},
    'submitRequest': {'ar': 'تقديم الطلب', 'en': 'Submit Request', 'fr': 'Soumettre la Demande'},
    'successMessage': {'ar': 'تم إرسال الطلب بنجاح', 'en': 'Request submitted successfully', 'fr': 'Demande soumise avec succès'},
    'errorMessage': {'ar': 'فشل إرسال الطلب', 'en': 'Failed to submit request', 'fr': 'Échec de l\'envoi de la demande'},
    'required': {'ar': 'مطلوب', 'en': 'Required', 'fr': 'Requis'},
    'ok': {'ar': 'حسناً', 'en': 'OK', 'fr': 'D\'accord'},
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

  String getContractTypeLabel(String typeValue, String langCode) {
    switch (langCode) {
      case 'ar':
        switch (typeValue) {
          case 'حجز': return 'حجز';
          case 'بيع': return 'عقد بيع';
          case 'هبة': return 'عقد هبة';
          case 'رهن_او_امتياز': return 'رهن أو امتياز';
          case 'تشطيب': return 'تشطيب';
          case 'عريضة': return 'عريضة';
          case 'وثيقة_ناقلة_للملكية': return 'وثيقة ناقلة للملكية';
          default: return typeValue;
        }
      case 'en':
        switch (typeValue) {
          case 'حجز': return 'Seizure';
          case 'بيع': return 'Sale Contract';
          case 'هبة': return 'Gift Contract';
          case 'رهن_او_امتياز': return 'Mortgage or Lien';
          case 'تشطيب': return 'Termination';
          case 'عريضة': return 'Petition';
          case 'وثيقة_ناقلة_للملكية': return 'Title Deed';
          default: return typeValue;
        }
      case 'fr':
        switch (typeValue) {
          case 'حجز': return 'Saisie';
          case 'بيع': return 'Contrat de Vente';
          case 'هبة': return 'Contrat de Donation';
          case 'رهن_او_امتياز': return 'Hypothèque ou Privilège';
          case 'تشطيب': return 'Annulation';
          case 'عريضة': return 'Pétition';
          case 'وثيقة_ناقلة_للملكية': return 'Titre de Propriété';
          default: return typeValue;
        }
      default: return typeValue;
    }
  }

  String t(String key) {
    final locale = Provider.of<LocaleProvider>(context, listen: false).locale.languageCode;
    return translations[key]?[locale] ?? translations[key]?['ar'] ?? key;
  }

  final List<Map<String, dynamic>> _extractTypes = [
    {'value': 'حجز', 'label': 'حجز', 'icon': Icons.lock_outline, 'color': Color(0xFF6C63FF)},
    {'value': 'بيع', 'label': 'عقد بيع', 'icon': Icons.sell_outlined, 'color': Color(0xFF2ECC71)},
    {'value': 'هبة', 'label': 'عقد هبة', 'icon': Icons.card_giftcard_outlined, 'color': Color(0xFFE91E63)},
    {'value': 'رهن_او_امتياز', 'label': 'رهن أو امتياز', 'icon': Icons.account_balance_outlined, 'color': Color(0xFF17A2B8)},
    {'value': 'تشطيب', 'label': 'تشطيب', 'icon': Icons.content_cut, 'color': Color(0xFFFF5722)},
    {'value': 'عريضة', 'label': 'عريضة', 'icon': Icons.edit_document, 'color': Color(0xFF795548)},
    {'value': 'وثيقة_ناقلة_للملكية', 'label': 'وثيقة ناقلة للملكية', 'icon': Icons.home_work_outlined, 'color': Color(0xFF1A5632)},
  ];

  String _selectedExtractType = '';

  final _applicantNinController = TextEditingController();
  final _applicantLastnameController = TextEditingController();
  final _applicantFirstnameController = TextEditingController();
  final _applicantFatherController = TextEditingController();
  final _applicantEmailController = TextEditingController();
  final _applicantPhoneController = TextEditingController();
  final _volumeNumberController = TextEditingController();
  final _publicationNumberController = TextEditingController();
  final _publicationDateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    _fadeAnim = CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero)
        .animate(CurvedAnimation(parent: _animCtrl, curve: Curves.easeOutCubic));

    if (widget.selectedType != null && widget.selectedType!.isNotEmpty) {
      _selectedExtractType = widget.selectedType!;
      _showForm = true;
    }

    _animCtrl.forward();
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    _applicantNinController.dispose();
    _applicantLastnameController.dispose();
    _applicantFirstnameController.dispose();
    _applicantFatherController.dispose();
    _applicantEmailController.dispose();
    _applicantPhoneController.dispose();
    _volumeNumberController.dispose();
    _publicationNumberController.dispose();
    _publicationDateController.dispose();
    super.dispose();
  }

  void _selectContractType(String typeValue) {
    setState(() {
      _selectedExtractType = typeValue;
      _showForm = true;
    });
    _animCtrl.reset();
    _animCtrl.forward();
  }

  void _backToContractTypes() {
    setState(() {
      _showForm = false;
      _selectedExtractType = '';
    });
    _animCtrl.reset();
    _animCtrl.forward();
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

    Map<String, dynamic> data = {
      'extract_type': _selectedExtractType,
      'applicant_nin': _applicantNinController.text,
      'applicant_lastname': _applicantLastnameController.text,
      'applicant_firstname': _applicantFirstnameController.text,
      'applicant_father': _applicantFatherController.text,
      'applicant_email': _applicantEmailController.text,
      'applicant_phone': _applicantPhoneController.text,
      'volume_number': _volumeNumberController.text,
      'publication_number': _publicationNumberController.text,
      'publication_date': _publicationDateController.text.isNotEmpty 
          ? _publicationDateController.text 
          : null,
    };

    print('📤 إرسال البيانات: $data');

    try {
      final result = await ApiService.submitContractExtract(data);
      
      setState(() => _isLoading = false);

      if (result['success'] == true) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
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
              backgroundColor: primaryGreen,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              margin: const EdgeInsets.all(16),
            ),
          );
          
          Future.delayed(const Duration(seconds: 1), () {
            if (mounted) Navigator.pop(context, true);
          });
        }
      } else if (result['needLogin'] == true) {
        _showLoginRequiredDialog();
      } else {
        _showErrorDialog(result['message'] ?? t('errorMessage'));
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
              t('ok'), 
              style: GoogleFonts.tajawal(color: primaryGreen),
            ),
          ),
        ],
      ),
    );
  }

  Map<String, dynamic> get _selectedTypeData =>
      _extractTypes.firstWhere((t) => t['value'] == _selectedExtractType,
          orElse: () => _extractTypes.first);

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
        body: Column(
          children: [
            _buildHeader(isDark, lang),
            Expanded(
              child: FadeTransition(
                opacity: _fadeAnim,
                child: SlideTransition(
                  position: _slideAnim,
                  child: _showForm
                      ? _buildFormContent(isDark, lang)
                      : _buildTypeSelection(isDark, lang),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDark, String lang) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [primaryGreen, primaryDark],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x441A5632),
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: Column(
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      if (_showForm) {
                        _backToContractTypes();
                      } else {
                        Navigator.pop(context);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(9),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Icon(
                        _showForm ? Icons.arrow_back : Icons.arrow_back,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: secondaryGold.withOpacity(0.25),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.description_outlined, color: secondaryGold, size: 16),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        t('title'),
                        style: GoogleFonts.tajawal(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  const SizedBox(width: 40),
                ],
              ),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 18),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: secondaryGold.withOpacity(0.4), width: 1),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(width: 6, height: 6,
                        decoration: const BoxDecoration(color: secondaryGold, shape: BoxShape.circle)),
                    const SizedBox(width: 8),
                    Text(
                      _showForm ? t('subtitleForm') : t('subtitleSelect'),
                      style: GoogleFonts.tajawal(
                        fontSize: 13,
                        color: Colors.white.withOpacity(0.92),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(width: 6, height: 6,
                        decoration: const BoxDecoration(color: secondaryGold, shape: BoxShape.circle)),
                  ],
                ),
              ),
              if (_showForm) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 14),
                  decoration: BoxDecoration(
                    color: (_selectedTypeData['color'] as Color).withOpacity(0.25),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: (_selectedTypeData['color'] as Color).withOpacity(0.5),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(_selectedTypeData['icon'] as IconData, color: Colors.white, size: 16),
                      const SizedBox(width: 6),
                      Text(
                        getContractTypeLabel(_selectedExtractType, lang),
                        style: GoogleFonts.tajawal(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypeSelection(bool isDark, String lang) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: primaryGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: const Icon(Icons.touch_app_outlined, color: primaryGreen, size: 18),
              ),
              const SizedBox(width: 10),
              Text(
                t('selectContractType'),
                style: GoogleFonts.tajawal(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : textDark,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  height: 1.5,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [primaryGreen.withOpacity(0.3), Colors.transparent],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...List.generate(_extractTypes.length, (index) {
            final type = _extractTypes[index];
            final color = type['color'] as Color;
            final label = getContractTypeLabel(type['value'] as String, lang);
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildTypeButton(
                isDark: isDark,
                icon: type['icon'] as IconData,
                label: label,
                color: color,
                index: index,
                onTap: () => _selectContractType(type['value'] as String),
              ),
            );
          }),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildTypeButton({
    required bool isDark,
    required IconData icon,
    required String label,
    required Color color,
    required int index,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isDark ? darkCard : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.25), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.10),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [color.withOpacity(0.18), color.withOpacity(0.06)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(13),
                border: Border.all(color: color.withOpacity(0.2), width: 1),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: GoogleFonts.tajawal(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : textDark,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Container(
                    width: 32,
                    height: 3,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
                border: Border.all(color: color.withOpacity(0.3), width: 1),
              ),
              child: Icon(Icons.arrow_forward_ios_rounded, color: color, size: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormContent(bool isDark, String lang) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            _buildInfoBanner(isDark),
            const SizedBox(height: 20),
            _buildSectionCard(
              isDark: isDark,
              icon: Icons.person_outline_rounded,
              title: t('applicantInfo'),
              color: primaryGreen,
              child: Column(
                children: [
                  _buildFormField(
                    controller: _applicantNinController,
                    label: t('nin'),
                    hint: t('enterNin'),
                    isDark: isDark,
                    icon: Icons.badge_outlined,
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: _buildFormField(
                          controller: _applicantLastnameController,
                          label: t('lastName'),
                          hint: t('enterLastName'),
                          isDark: isDark,
                          isRequired: true,
                          icon: Icons.person,
                          validator: (v) => v?.isEmpty ?? true ? t('required') : null,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildFormField(
                          controller: _applicantFirstnameController,
                          label: t('firstName'),
                          hint: t('enterFirstName'),
                          isDark: isDark,
                          isRequired: true,
                          icon: Icons.person_outline,
                          validator: (v) => v?.isEmpty ?? true ? t('required') : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  _buildFormField(
                    controller: _applicantFatherController,
                    label: t('fatherName'),
                    hint: t('enterFatherName'),
                    isDark: isDark,
                    isRequired: true,
                    icon: Icons.family_restroom,
                    validator: (v) => v?.isEmpty ?? true ? t('required') : null,
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: _buildFormField(
                          controller: _applicantEmailController,
                          label: t('email'),
                          hint: t('enterEmail'),
                          isDark: isDark,
                          icon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildFormField(
                          controller: _applicantPhoneController,
                          label: t('phone'),
                          hint: t('enterPhone'),
                          isDark: isDark,
                          icon: Icons.phone_outlined,
                          keyboardType: TextInputType.phone,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _buildSectionCard(
              isDark: isDark,
              icon: Icons.description_outlined,
              title: t('documentInfo'),
              color: infoColor,
              child: Column(
                children: [
                  _buildFormField(
                    controller: _volumeNumberController,
                    label: t('volumeNumber'),
                    hint: t('enterVolume'),
                    isDark: isDark,
                    isRequired: true,
                    icon: Icons.menu_book_outlined,
                    validator: (v) => v?.isEmpty ?? true ? t('required') : null,
                  ),
                  const SizedBox(height: 14),
                  _buildFormField(
                    controller: _publicationNumberController,
                    label: t('publicationNumber'),
                    hint: t('enterPublication'),
                    isDark: isDark,
                    isRequired: true,
                    icon: Icons.numbers,
                    validator: (v) => v?.isEmpty ?? true ? t('required') : null,
                  ),
                  const SizedBox(height: 14),
                  _buildDateField(isDark),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _buildSubmitButton(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required bool isDark,
    required IconData icon,
    required String title,
    required Color color,
    required Widget child,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? darkCard : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: color.withOpacity(0.15), width: 1),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            decoration: BoxDecoration(
              color: color.withOpacity(isDark ? 0.2 : 0.06),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: Icon(icon, color: color, size: 18),
                ),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: GoogleFonts.tajawal(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : color,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: child,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBanner(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2A2200) : const Color(0xFFFFFBEB),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: warningColor.withOpacity(0.4), width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: warningColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.lightbulb_outline, color: warningColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  t('importantTips'),
                  style: GoogleFonts.tajawal(
                    color: const Color(0xFFB45309),
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  t('tipsMessage'),
                  style: GoogleFonts.tajawal(
                    color: const Color(0xFF92400E),
                    fontSize: 12,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required bool isDark,
    required IconData icon,
    bool isRequired = false,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    final locale = Provider.of<LocaleProvider>(context, listen: false).locale.languageCode;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: GoogleFonts.tajawal(
                color: isDark ? darkText.withOpacity(0.8) : textLight,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (isRequired)
              Text(' *', style: GoogleFonts.tajawal(color: errorColor, fontSize: 13, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          style: GoogleFonts.tajawal(
            color: isDark ? darkText : textDark,
            fontSize: 14,
          ),
          textAlign: locale == 'ar' ? TextAlign.right : TextAlign.left,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.tajawal(color: Colors.grey.shade400, fontSize: 13),
            prefixIcon: Icon(icon, color: primaryGreen.withOpacity(0.6), size: 20),
            filled: true,
            fillColor: isDark ? Colors.white.withOpacity(0.05) : Colors.grey.shade50,
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade200, width: 1.5),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: isDark ? Colors.white12 : Colors.grey.shade200, width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: primaryGreen, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: errorColor, width: 1.5),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: errorColor, width: 2),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateField(bool isDark) {
    final locale = Provider.of<LocaleProvider>(context, listen: false).locale.languageCode;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          t('publicationDate'),
          style: GoogleFonts.tajawal(
            color: isDark ? darkText.withOpacity(0.8) : textLight,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: _publicationDateController,
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
                      primary: infoColor,
                      onPrimary: Colors.white,
                    ),
                  ),
                  child: child!,
                );
              },
            );
            if (date != null) {
              _publicationDateController.text =
                  '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
            }
          },
          style: GoogleFonts.tajawal(color: isDark ? darkText : textDark, fontSize: 14),
          textAlign: locale == 'ar' ? TextAlign.right : TextAlign.left,
          decoration: InputDecoration(
            hintText: t('selectDate'),
            hintStyle: GoogleFonts.tajawal(color: Colors.grey.shade400, fontSize: 13),
            prefixIcon: const Icon(Icons.calendar_today_outlined, color: infoColor, size: 20),
            filled: true,
            fillColor: isDark ? Colors.white.withOpacity(0.05) : Colors.grey.shade50,
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade200, width: 1.5),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: isDark ? Colors.white12 : Colors.grey.shade200, width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: infoColor, width: 2),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _submitForm,
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryGreen,
          foregroundColor: Colors.white,
          disabledBackgroundColor: primaryGreen.withOpacity(0.5),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          elevation: 4,
          shadowColor: primaryGreen.withOpacity(0.4),
        ),
        child: _isLoading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.send_rounded, size: 20),
                  const SizedBox(width: 10),
                  Text(
                    t('submitRequest'),
                    style: GoogleFonts.tajawal(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}