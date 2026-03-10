import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import '../providers/theme_provider.dart';
import '../providers/locale_provider.dart';
import '../providers/auth_provider.dart'; // ✅ إضافة AuthProvider
import '../services/api_service.dart';

class PropertyBookRequestScreen extends StatefulWidget {
  const PropertyBookRequestScreen({super.key});

  @override
  State<PropertyBookRequestScreen> createState() =>
      _PropertyBookRequestScreenState();
}

class _PropertyBookRequestScreenState
    extends State<PropertyBookRequestScreen> {
  // ── الألوان ─────────────────────────────────────────────────
  static const Color primaryGreen  = Color(0xFF1A5632);
  static const Color primaryDark   = Color(0xFF0D3D20);
  static const Color secondaryGold = Color(0xFFC49B63);
  static const Color bgLight       = Color(0xFFF8F6F1);
  static const Color successColor  = Color(0xFF28A745);
  static const Color textDark      = Color(0xFF2D2D2D);
  static const Color textLight     = Color(0xFF6B6B6B);
  static const Color dangerColor   = Color(0xFFE74C3C);
  static const Color darkBg        = Color(0xFF1A1A1A);
  static const Color darkCard      = Color(0xFF2D2D2D);
  static const Color darkText      = Color(0xFFE8E8E8);

  // متغير للـ LocaleProvider لتجنب أخطاء Provider
  late LocaleProvider _localeProvider;

  // ترجمة النصوص
  Map<String, Map<String, String>> translations = {
    'pageTitle': {
      'ar': 'طلب إنشاء دفتر عقاري',
      'en': 'Property Book Creation Request',
      'fr': 'Demande de Création de Livre Foncier',
    },
    'pageSubtitle': {
      'ar': 'املأ البيانات بدقة للحصول على دفتر عقاري رسمي',
      'en': 'Fill in the data accurately to obtain an official property book',
      'fr': 'Remplissez les données avec précision pour obtenir un livre foncier officiel',
    },
    'step1Title': {
      'ar': 'المرحلة الأولى: بيانات الطالب',
      'en': 'Step 1: Applicant Information',
      'fr': 'Étape 1: Informations du Demandeur',
    },
    'step2Title': {
      'ar': 'المرحلة الثانية: تعيين العقار',
      'en': 'Step 2: Property Identification',
      'fr': 'Étape 2: Identification de la Propriété',
    },
    'step3Title': {
      'ar': 'المرحلة الثالثة: رفع الوثائق',
      'en': 'Step 3: Upload Documents',
      'fr': 'Étape 3: Téléchargement des Documents',
    },
    'step1': {
      'ar': 'بيانات الطالب',
      'en': 'Applicant Data',
      'fr': 'Données du Demandeur',
    },
    'step2': {
      'ar': 'تعيين العقار',
      'en': 'Property Assignment',
      'fr': 'Affectation de la Propriété',
    },
    'step3': {
      'ar': 'رفع الوثائق',
      'en': 'Upload Documents',
      'fr': 'Télécharger Documents',
    },
    'nationalId': {
      'ar': 'رقم التعريف الوطني',
      'en': 'National ID Number',
      'fr': 'Numéro d\'Identification National',
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
    'wilaya': {
      'ar': 'الولاية',
      'en': 'Wilaya',
      'fr': 'Wilaya',
    },
    'municipality': {
      'ar': 'البلدية',
      'en': 'Municipality',
      'fr': 'Municipalité',
    },
    // ترجمات البلديات
    'ouledDjellal': {
      'ar': 'أولاد جلال',
      'en': 'Ouled Djellal',
      'fr': 'Ouled Djellal',
    },
    'doucen': {
      'ar': 'الدوسن',
      'en': 'Doucen',
      'fr': 'Doucen',
    },
    'chaiba': {
      'ar': 'الشعيبة',
      'en': 'Chaïba',
      'fr': 'Chaïba',
    },
    'sidiKhaled': {
      'ar': 'سيدي خالد',
      'en': 'Sidi Khaled',
      'fr': 'Sidi Khaled',
    },
    'besbes': {
      'ar': 'البسباس',
      'en': 'Besbes',
      'fr': 'Besbes',
    },
    'rasElMiaad': {
      'ar': 'رأس الميعاد',
      'en': 'Ras El Miaad',
      'fr': 'Ras El Miaad',
    },
    'applicantType': {
      'ar': 'صفة الطالب',
      'en': 'Applicant Capacity',
      'fr': 'Qualité du Demandeur',
    },
    'owner': {
      'ar': 'مالك',
      'en': 'Owner',
      'fr': 'Propriétaire',
    },
    'heir': {
      'ar': 'وارث',
      'en': 'Heir',
      'fr': 'Héritier',
    },
    'agent': {
      'ar': 'وكيل',
      'en': 'Agent',
      'fr': 'Mandataire',
    },
    'requestType': {
      'ar': 'نوع الطلب',
      'en': 'Request Type',
      'fr': 'Type de Demande',
    },
    'newRequest': {
      'ar': 'طلب جديد',
      'en': 'New Request',
      'fr': 'Nouvelle Demande',
    },
    'copyRequest': {
      'ar': 'نسخة دفتر',
      'en': 'Book Copy',
      'fr': 'Copie du Livre',
    },
    'surveyStatus': {
      'ar': 'حالة مسح العقار',
      'en': 'Survey Status',
      'fr': 'Statut du Levé',
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
    'surveyedData': {
      'ar': 'بيانات العقار الممسوح',
      'en': 'Surveyed Property Data',
      'fr': 'Données de la Propriété Levée',
    },
    'notSurveyedData': {
      'ar': 'بيانات العقار غير الممسوح',
      'en': 'Not Surveyed Property Data',
      'fr': 'Données de la Propriété Non Levée',
    },
    'section': {
      'ar': 'القسم',
      'en': 'Section',
      'fr': 'Section',
    },
    'parcelNumber': {
      'ar': 'رقم القطعة',
      'en': 'Parcel Number',
      'fr': 'Numéro de Parcelle',
    },
    'area': {
      'ar': 'المساحة (م²)',
      'en': 'Area (m²)',
      'fr': 'Superficie (m²)',
    },
    'estimatedArea': {
      'ar': 'المساحة التقديرية (م²)',
      'en': 'Estimated Area (m²)',
      'fr': 'Superficie Estimée (m²)',
    },
    'subdivision': {
      'ar': 'التقسيم',
      'en': 'Subdivision',
      'fr': 'Subdivision',
    },
    'propertyType': {
      'ar': 'نوع العقار',
      'en': 'Property Type',
      'fr': 'Type de Propriété',
    },
    'cooperativeHousing': {
      'ar': 'سكن تساهمي',
      'en': 'Cooperative Housing',
      'fr': 'Logement Coopératif',
    },
    'buildingLand': {
      'ar': 'قطعة أرض صالحة للبناء',
      'en': 'Buildable Land',
      'fr': 'Terrain Constructible',
    },
    'agriculturalLand': {
      'ar': 'قطعة أرض فلاحية',
      'en': 'Agricultural Land',
      'fr': 'Terrain Agricole',
    },
    'industrial': {
      'ar': 'صناعي',
      'en': 'Industrial',
      'fr': 'Industriel',
    },
    'requiredDocs': {
      'ar': 'الوثائق المطلوبة',
      'en': 'Required Documents',
      'fr': 'Documents Requis',
    },
    'idCard': {
      'ar': 'صورة الهوية الوطنية',
      'en': 'National ID Copy',
      'fr': 'Copie de la Carte d\'Identité',
    },
    'ownershipDoc': {
      'ar': 'عقد الملكية أو الوكالة',
      'en': 'Ownership Deed or Power of Attorney',
      'fr': 'Titre de Propriété ou Mandat',
    },
    'birthCert': {
      'ar': 'شهادة الميلاد',
      'en': 'Birth Certificate',
      'fr': 'Acte de Naissance',
    },
    'additionalDocs': {
      'ar': 'وثائق إضافية تثبت الملكية',
      'en': 'Additional Ownership Documents',
      'fr': 'Documents Supplémentaires Prouvant la Propriété',
    },
    'addDocument': {
      'ar': 'إضافة وثيقة',
      'en': 'Add Document',
      'fr': 'Ajouter un Document',
    },
    'camera': {
      'ar': 'الكاميرا',
      'en': 'Camera',
      'fr': 'Caméra',
    },
    'gallery': {
      'ar': 'المعرض',
      'en': 'Gallery',
      'fr': 'Galerie',
    },
    'files': {
      'ar': 'ملفات',
      'en': 'Files',
      'fr': 'Fichiers',
    },
    'jpgPng': {
      'ar': 'JPG • PNG',
      'en': 'JPG • PNG',
      'fr': 'JPG • PNG',
    },
    'pdfImages': {
      'ar': 'PDF • صور',
      'en': 'PDF • Images',
      'fr': 'PDF • Images',
    },
    'uploadHint': {
      'ar': 'معرض • PDF — الحد الأقصى 5MB لكل ملف',
      'en': 'Gallery • PDF — Max 5MB per file',
      'fr': 'Galerie • PDF — Max 5MB par fichier',
    },
    'uploadHintWithCamera': {
      'ar': 'كاميرا • معرض • PDF — الحد الأقصى 5MB لكل ملف',
      'en': 'Camera • Gallery • PDF — Max 5MB per file',
      'fr': 'Caméra • Galerie • PDF — Max 5MB par fichier',
    },
    'uploadedFiles': {
      'ar': 'الملفات المرفوعة',
      'en': 'Uploaded Files',
      'fr': 'Fichiers Téléchargés',
    },
    'clickToAdd': {
      'ar': 'اضغط على "إضافة وثيقة" للبدء',
      'en': 'Click on "Add Document" to start',
      'fr': 'Cliquez sur "Ajouter un Document" pour commencer',
    },
    'cancel': {
      'ar': 'إلغاء',
      'en': 'Cancel',
      'fr': 'Annuler',
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
    'submit': {
      'ar': 'تقديم الطلب',
      'en': 'Submit Request',
      'fr': 'Soumettre la Demande',
    },
    'success': {
      'ar': '✅ تم تقديم الطلب بنجاح',
      'en': '✅ Request submitted successfully',
      'fr': '✅ Demande soumise avec succès',
    },
    'cameraUnavailable': {
      'ar': '📷 الكاميرا غير متاحة على المتصفح، استخدم "ملفات" أو "معرض"',
      'en': '📷 Camera is not available on browser, use "Files" or "Gallery"',
      'fr': '📷 La caméra n\'est pas disponible sur le navigateur, utilisez "Fichiers" ou "Galerie"',
    },
    'readError': {
      'ar': '❌ فشل قراءة الصورة',
      'en': '❌ Failed to read image',
      'fr': '❌ Échec de la lecture de l\'image',
    },
    'fileTooLarge': {
      'ar': '⚠️ الملف أكبر من 5MB',
      'en': '⚠️ File is larger than 5MB',
      'fr': '⚠️ Le fichier dépasse 5MB',
    },
    'cameraSuccess': {
      'ar': '✅ تم التقاط الصورة بنجاح',
      'en': '✅ Photo captured successfully',
      'fr': '✅ Photo prise avec succès',
    },
    'cameraPermissionDenied': {
      'ar': '❌ لا يوجد إذن للكاميرا. افتح إعدادات التطبيق وامنح الإذن.',
      'en': '❌ Camera permission denied. Open app settings and grant permission.',
      'fr': '❌ Autorisation de caméra refusée. Ouvrez les paramètres de l\'application et accordez l\'autorisation.',
    },
    'cameraError': {
      'ar': '❌ تعذّر فتح الكاميرا. تأكد من منح الإذن في الإعدادات.',
      'en': '❌ Could not open camera. Check permissions in settings.',
      'fr': '❌ Impossible d\'ouvrir la caméra. Vérifiez les autorisations dans les paramètres.',
    },
    'gallerySuccess': {
      'ar': '✅ تم إضافة الصورة بنجاح',
      'en': '✅ Image added successfully',
      'fr': '✅ Image ajoutée avec succès',
    },
    'galleryError': {
      'ar': '❌ خطأ في المعرض',
      'en': '❌ Gallery error',
      'fr': '❌ Erreur de galerie',
    },
    'filesSkipped': {
      'ar': '⚠️ "{name}" أكبر من 5MB، تم تخطيه',
      'en': '⚠️ "{name}" is larger than 5MB, skipped',
      'fr': '⚠️ "{name}" dépasse 5MB, ignoré',
    },
    'fileReadError': {
      'ar': '❌ تعذّر قراءة "{name}"',
      'en': '❌ Failed to read "{name}"',
      'fr': '❌ Échec de la lecture de "{name}"',
    },
    'filesAdded': {
      'ar': '✅ تم رفع {count} ملف بنجاح',
      'en': '✅ {count} file(s) uploaded successfully',
      'fr': '✅ {count} fichier(s) téléchargé(s) avec succès',
    },
    'filePickerError': {
      'ar': '❌ خطأ في رفع الملفات. حاول مرة أخرى.',
      'en': '❌ Error uploading files. Try again.',
      'fr': '❌ Erreur lors du téléchargement des fichiers. Réessayez.',
    },
    'addDocumentTitle': {
      'ar': 'إضافة وثيقة',
      'en': 'Add Document',
      'fr': 'Ajouter un Document',
    },
    'chooseMethod': {
      'ar': 'اختر طريقة إضافة الوثيقة',
      'en': 'Choose document addition method',
      'fr': 'Choisissez la méthode d\'ajout du document',
    },
    'nationalIdHint': {
      'ar': 'أدخل 18 رقماً',
      'en': 'Enter 18 digits',
      'fr': 'Entrez 18 chiffres',
    },
    'nationalIdError': {
      'ar': '⚠️ رقم التعريف الوطني يجب أن يكون 18 رقماً',
      'en': '⚠️ National ID must be 18 digits',
      'fr': '⚠️ Le numéro d\'identification national doit comporter 18 chiffres',
    },
    'requiredFields': {
      'ar': 'الرجاء ملء جميع الحقول المطلوبة',
      'en': 'Please fill all required fields',
      'fr': 'Veuillez remplir tous les champs requis',
    },
    'surveyStatusRequired': {
      'ar': 'الرجاء اختيار حالة مسح العقار',
      'en': 'Please select property survey status',
      'fr': 'Veuillez sélectionner le statut du levé de la propriété',
    },
    'surveyedFieldsRequired': {
      'ar': 'الرجاء ملء جميع حقول العقار الممسوح',
      'en': 'Please fill all surveyed property fields',
      'fr': 'Veuillez remplir tous les champs de la propriété levée',
    },
    'notSurveyedFieldsRequired': {
      'ar': 'الرجاء ملء جميع حقول العقار الغير ممسوح',
      'en': 'Please fill all non-surveyed property fields',
      'fr': 'Veuillez remplir tous les champs de la propriété non levée',
    },
    'propertyTypeRequired': {
      'ar': 'الرجاء اختيار نوع العقار',
      'en': 'Please select property type',
      'fr': 'Veuillez sélectionner le type de propriété',
    },
    'fileDeleted': {
      'ar': 'تم حذف الملف',
      'en': 'File deleted',
      'fr': 'Fichier supprimé',
    },
    'selectDate': {
      'ar': 'اختر التاريخ',
      'en': 'Select date',
      'fr': 'Sélectionnez la date',
    },
    'phoneHint': {
      'ar': '0XXX XX XX XX',
      'en': '0XXX XX XX XX',
      'fr': '0XXX XX XX XX',
    },
    'emailHint': {
      'ar': 'example@email.com',
      'en': 'example@email.com',
      'fr': 'example@email.com',
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
  };

  String t(String key, [List<String>? args]) {
    final locale = _localeProvider.locale.languageCode;
    String text = translations[key]?[locale] ?? translations[key]?['ar'] ?? key;
    
    if (args != null) {
      for (int i = 0; i < args.length; i++) {
        text = text.replaceAll('{${i}}', args[i]);
        text = text.replaceAll('{count}', args[i]);
        text = text.replaceAll('{name}', args[i]);
      }
    }
    return text;
  }

  // ── الحالة ──────────────────────────────────────────────────
  int  _currentStep = 1;
  bool _isLoading   = false;

  // المرحلة 1
  final _nationalIdController = TextEditingController();
  final _lastNameController   = TextEditingController();
  final _firstNameController  = TextEditingController();
  final _fatherNameController = TextEditingController();
  final _birthDateController  = TextEditingController();
  final _phoneController      = TextEditingController();
  final _emailController      = TextEditingController();
  String _selectedWilaya      = 'أولاد جلال';
  String _selectedMunicipality = '';
  String _applicantType       = '';

  // المرحلة 2 – ممسوح
  final _surveyedCommuneController = TextEditingController();
  final _sectionController         = TextEditingController();
  final _parcelNumberController    = TextEditingController();
  final _surveyedAreaController    = TextEditingController();

  // المرحلة 2 – غير ممسوح
  final _nonSurveyedCommuneController      = TextEditingController();
  final _subdivisionController             = TextEditingController();
  final _nonSurveyedSectionController      = TextEditingController();
  final _nonSurveyedParcelNumberController = TextEditingController();
  final _nonSurveyedAreaController         = TextEditingController();

  String _surveyStatus = '';
  String _propertyType = '';
  String _requestType  = 'طلب جديد';

  // المرحلة 3
  final List<Map<String, dynamic>> _uploadedFiles = [];

  // ── القوائم ──────────────────────────────────────────────────
  final _wilayas        = ['أولاد جلال'];
  
  final _municipalityKeys = [
    'ouledDjellal',
    'doucen',
    'chaiba',
    'sidiKhaled',
    'besbes',
    'rasElMiaad',
  ];
  
  final _applicantTypes = ['مالك','وارث','وكيل'];
  final _propertyTypes  = ['سكن تساهمي','قطعة أرض صالحة للبناء','قطعة أرض فلاحية','صناعي'];
  final _requestTypes   = ['طلب جديد','نسخة دفتر'];

  @override
  void initState() {
    super.initState();
    _localeProvider = Provider.of<LocaleProvider>(context, listen: false);
  }

  @override
  void dispose() {
    for (final c in [
      _nationalIdController, _lastNameController, _firstNameController,
      _fatherNameController, _birthDateController, _phoneController,
      _emailController, _surveyedCommuneController,
      _sectionController, _parcelNumberController, _surveyedAreaController,
      _nonSurveyedCommuneController, _subdivisionController,
      _nonSurveyedSectionController, _nonSurveyedParcelNumberController,
      _nonSurveyedAreaController,
    ]) { c.dispose(); }
    super.dispose();
  }

  // ════════════════════════════════════════════════════════════
  //  ✅ جديد: التحقق من تسجيل الدخول
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

  // ════════════════════════════════════════════════════════════
  //  دالة تحويل التاريخ
  // ════════════════════════════════════════════════════════════
  String _convertToIsoDate(String date) {
    if (date.isEmpty) return '';
    try {
      if (date.contains('/')) {
        var parts = date.split('/');
        if (parts.length == 3) {
          return '${parts[2]}-${parts[1].padLeft(2, '0')}-${parts[0].padLeft(2, '0')}';
        }
      }
      return date;
    } catch (e) {
      return date;
    }
  }

  // ════════════════════════════════════════════════════════════
  //  الكاميرا
  // ════════════════════════════════════════════════════════════
  Future<void> _pickFromCamera() async {
    if (kIsWeb) {
      _snack(t('cameraUnavailable'), dangerColor);
      return;
    }

    try {
      final picker = ImagePicker();
      final XFile? photo = await picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );
      if (photo == null) return;

      final bytes = await photo.readAsBytes();
      if (bytes.isEmpty) { _snack(t('readError'), dangerColor); return; }
      if (bytes.length > 5 * 1024 * 1024) { _snack(t('fileTooLarge'), dangerColor); return; }

      if (mounted) {
        setState(() => _uploadedFiles.add({
          'name' : '${t('camera')}_${DateTime.now().millisecondsSinceEpoch}.jpg',
          'size' : bytes.length,
          'type' : 'jpg',
          'bytes': bytes,
          'path' : photo.path,
        }));
        _snack(t('cameraSuccess'), successColor);
      }
    } catch (e) {
      debugPrint('Camera error: $e');
      final msg = e.toString().toLowerCase();
      if (msg.contains('permission') || msg.contains('denied')) {
        _snack(t('cameraPermissionDenied'), dangerColor);
      } else {
        _snack(t('cameraError'), dangerColor);
      }
    }
  }

  // ════════════════════════════════════════════════════════════
  //  المعرض
  // ════════════════════════════════════════════════════════════
  Future<void> _pickFromGallery() async {
    try {
      final picker = ImagePicker();
      final XFile? img = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );
      if (img == null) return;

      final bytes = await img.readAsBytes();
      if (bytes.length > 5 * 1024 * 1024) {
        _snack(t('fileTooLarge'), dangerColor);
        return;
      }

      if (mounted) {
        setState(() => _uploadedFiles.add({
          'name' : '${t('gallery')}_${DateTime.now().millisecondsSinceEpoch}.jpg',
          'size' : bytes.length,
          'type' : 'jpg',
          'bytes': bytes,
          'path' : kIsWeb ? '' : img.path,
        }));
        _snack(t('gallerySuccess'), successColor);
      }
    } catch (e) {
      debugPrint('Gallery error: $e');
      _snack('${t('galleryError')}: ${e.toString()}', dangerColor);
    }
  }

  // ════════════════════════════════════════════════════════════
  //  FilePicker
  // ════════════════════════════════════════════════════════════
  Future<void> _pickFiles() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
        allowMultiple: true,
        withData: true,
      );
      if (result == null || result.files.isEmpty) return;

      int added = 0;
      for (final pf in result.files) {
        if (pf.size > 5 * 1024 * 1024) {
          _snack(t('filesSkipped', [pf.name]), dangerColor);
          continue;
        }

        List<int>? bytes;
        if (pf.bytes != null && pf.bytes!.isNotEmpty) {
          bytes = pf.bytes!.toList();
        } else if (!kIsWeb && pf.path != null) {
          try {
            final f = File(pf.path!);
            if (await f.exists()) bytes = await f.readAsBytes();
          } catch (e) {
            debugPrint('Read from path error: $e');
          }
        }

        if (bytes == null || bytes.isEmpty) {
          _snack(t('fileReadError', [pf.name]), dangerColor);
          continue;
        }

        if (mounted) {
          setState(() => _uploadedFiles.add({
            'name' : pf.name,
            'size' : pf.size,
            'type' : pf.extension?.toLowerCase() ?? 'unknown',
            'bytes': bytes,
            'path' : kIsWeb ? '' : (pf.path ?? ''),
          }));
          added++;
        }
      }
      if (added > 0) _snack(t('filesAdded', [added.toString()]), successColor);
    } catch (e) {
      debugPrint('FilePicker error: $e');
      _snack(t('filePickerError'), dangerColor);
    }
  }

  // ════════════════════════════════════════════════════════════
  //  نافذة اختيار المصدر
  // ════════════════════════════════════════════════════════════
  void _showSourceSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Container(
              width: 40, height: 4,
              decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 20),
            Text(t('addDocumentTitle'), style: GoogleFonts.tajawal(
                fontSize: 18, fontWeight: FontWeight.bold, color: textDark)),
            const SizedBox(height: 4),
            Text(t('chooseMethod'),
                style: GoogleFonts.tajawal(color: textLight, fontSize: 13)),
            const SizedBox(height: 28),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              if (!kIsWeb)
                _srcBtn(
                  Icons.camera_alt_rounded, t('camera'), t('jpgPng'),
                  primaryGreen,
                  () { Navigator.pop(ctx); _pickFromCamera(); },
                ),
              _srcBtn(
                Icons.photo_library_rounded, t('gallery'), t('jpgPng'),
                secondaryGold,
                () { Navigator.pop(ctx); _pickFromGallery(); },
              ),
              _srcBtn(
                Icons.picture_as_pdf_rounded, t('files'), t('pdfImages'),
                dangerColor,
                () { Navigator.pop(ctx); _pickFiles(); },
              ),
            ]),
            const SizedBox(height: 8),
          ]),
        ),
      ),
    );
  }

  Widget _srcBtn(IconData icon, String label, String sub,
      Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(children: [
        Container(
          width: 76, height: 76,
          decoration: BoxDecoration(
            color: color.withOpacity(0.08), shape: BoxShape.circle,
            border: Border.all(color: color.withOpacity(0.25), width: 2)),
          child: Icon(icon, color: color, size: 34),
        ),
        const SizedBox(height: 8),
        Text(label, style: GoogleFonts.tajawal(
            color: textDark, fontSize: 14, fontWeight: FontWeight.w700)),
        Text(sub, style: GoogleFonts.tajawal(color: textLight, fontSize: 11)),
      ]),
    );
  }

  // ════════════════════════════════════════════════════════════
  //  مساعدات عامة
  // ════════════════════════════════════════════════════════════
  void _snack(String msg, Color color) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg, style: GoogleFonts.tajawal()),
      backgroundColor: color,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      duration: const Duration(seconds: 3),
    ));
  }

  void _removeFile(int i) {
    setState(() => _uploadedFiles.removeAt(i));
    _snack(t('fileDeleted'), textLight);
  }

  String _fmtSize(int b) {
    if (b < 1024)         return '$b B';
    if (b < 1024 * 1024)  return '${(b / 1024).toStringAsFixed(1)} KB';
    return '${(b / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  Color  _fileColor(String t) =>
      t == 'pdf' ? dangerColor
      : (t == 'jpg' || t == 'jpeg') ? const Color(0xFF3498DB)
      : t == 'png' ? const Color(0xFF9B59B6)
      : primaryGreen;

  String _fileIcon(String t) =>
      t == 'pdf' ? '📄'
      : (t == 'jpg' || t == 'jpeg' || t == 'png') ? '🖼️'
      : '📎';

  void _nextStep(int step) {
    if (!_validate()) return;
    setState(() => _isLoading = true);
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) setState(() { _currentStep = step; _isLoading = false; });
    });
  }

  void _prevStep(int step) => setState(() => _currentStep = step);

  bool _validate() {
    if (_currentStep == 1) {
      final id = _nationalIdController.text.replaceAll(' ', '');
      if (id.length != 18 || !RegExp(r'^\d{18}$').hasMatch(id)) {
        _snack(t('nationalIdError'), dangerColor);
        return false;
      }
      _nationalIdController.text = id;
      if ([_lastNameController, _firstNameController, _fatherNameController,
           _birthDateController, _phoneController, _emailController]
          .any((c) => c.text.isEmpty) ||
          _selectedWilaya.isEmpty || _selectedMunicipality.isEmpty || _applicantType.isEmpty) {
        _snack(t('requiredFields'), dangerColor);
        return false;
      }
    } else if (_currentStep == 2) {
      if (_surveyStatus.isEmpty) {
        _snack(t('surveyStatusRequired'), dangerColor);
        return false;
      }
      if (_surveyStatus == 'ممسوح') {
        if ([_surveyedCommuneController, _sectionController,
             _parcelNumberController, _surveyedAreaController]
            .any((c) => c.text.isEmpty)) {
          _snack(t('surveyedFieldsRequired'), dangerColor);
          return false;
        }
      } else {
        if ([_nonSurveyedCommuneController, _subdivisionController]
            .any((c) => c.text.isEmpty)) {
          _snack(t('notSurveyedFieldsRequired'), dangerColor);
          return false;
        }
      }
      if (_propertyType.isEmpty) {
        _snack(t('propertyTypeRequired'), dangerColor);
        return false;
      }
    }
    return true;
  }

  // ════════════════════════════════════════════════════════════
  //  ✅ تعديل: إضافة التحقق من تسجيل الدخول قبل الإرسال
  // ════════════════════════════════════════════════════════════
  Future<void> _submit() async {
    // ✅ التحقق من تسجيل الدخول أولاً
    final isLoggedIn = await _checkLoginStatus();
    if (!isLoggedIn) {
      print('❌ المستخدم غير مسجل الدخول، تم إيقاف الإرسال');
      return;
    }

    setState(() => _isLoading = true);

    Map<String, dynamic> data = {
      'national_id': _nationalIdController.text.replaceAll(' ', ''),
      'last_name': _lastNameController.text.trim(),
      'first_name': _firstNameController.text.trim(),
      'father_name': _fatherNameController.text.trim(),
      'birth_date': _convertToIsoDate(_birthDateController.text),
      'phone': _phoneController.text.trim(),
      'email': _emailController.text.trim(),
      'wilaya': _selectedWilaya,
      'commune': _selectedMunicipality,
      'applicant_type': _applicantType,
      'survey_status': _surveyStatus,
      'property_type': _propertyType,
      'request_type': _requestType,
    };

    if (_surveyStatus == 'ممسوح') {
      data.addAll({
        'surveyed_commune': _surveyedCommuneController.text.trim(),
        'section': _sectionController.text.trim(),
        'parcel_number': _parcelNumberController.text.trim(),
        'surveyed_area': double.tryParse(_surveyedAreaController.text) ?? 0,
      });
    } else {
      data.addAll({
        'non_surveyed_commune': _nonSurveyedCommuneController.text.trim(),
        'subdivision': _subdivisionController.text.trim(),
        'non_surveyed_section': _nonSurveyedSectionController.text.trim(),
        'non_surveyed_parcel_number': _nonSurveyedParcelNumberController.text.trim(),
        'non_surveyed_area': double.tryParse(_nonSurveyedAreaController.text) ?? 0,
      });
    }

    try {
      final result = await ApiService.submitPropertyBookWithFiles(data, _uploadedFiles);
      
      setState(() => _isLoading = false);

      if (result['success'] == true) {
        if (mounted) {
          _snack('✅ ${result['message']} - رقم الدفتر: ${result['register_number']}', successColor);
          
          Future.delayed(const Duration(seconds: 2), () {
            if (mounted) Navigator.pop(context, true);
          });
        }
      } else {
        // ✅ معالجة حالة needLogin من الـ API
        if (result['needLogin'] == true) {
          _showLoginRequiredDialog();
        } else {
          _snack('❌ ${result['message']}', dangerColor);
        }
      }
    } catch (e) {
      setState(() => _isLoading = false);
      _snack('حدث خطأ في الاتصال: $e', dangerColor);
    }
  }

  // ════════════════════════════════════════════════════════════
  //  build الرئيسي
  // ════════════════════════════════════════════════════════════
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final localeProvider = Provider.of<LocaleProvider>(context);
    _localeProvider = localeProvider;
    final isDark = themeProvider.isDarkMode;
    final lang = localeProvider.locale.languageCode;

    return Directionality(
      textDirection: localeProvider.textDirection,
      child: Scaffold(
        backgroundColor: isDark ? darkBg : primaryGreen,
        body: Container(
          decoration: BoxDecoration(
            gradient: isDark ? null : const LinearGradient(
              colors: [primaryGreen, primaryDark],
              begin: Alignment.topRight, end: Alignment.bottomLeft,
            ),
          ),
          child: SafeArea(child: Stack(children: [
            CustomScrollView(slivers: [SliverToBoxAdapter(child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(children: [
                const SizedBox(height: 20),
                _header(lang),
                const SizedBox(height: 24),
                _card(isDark),
                const SizedBox(height: 32),
              ]),
            ))]),
            if (_isLoading)
              Container(
                color: Colors.black.withOpacity(0.6),
                child: const Center(child: CircularProgressIndicator(
                    color: Colors.white, strokeWidth: 5))),
          ])),
        ),
      ),
    );
  }

  // ── Header ──────────────────────────────────────────────────
  Widget _header(String lang) => Column(children: [
    Align(
      alignment: lang == 'ar' ? Alignment.centerRight : Alignment.centerLeft,
      child: GestureDetector(
        onTap: () => _currentStep > 1
            ? _prevStep(_currentStep - 1)
            : Navigator.pop(context),
        child: Container(
          width: 50, height: 50,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15), shape: BoxShape.circle,
            border: Border.all(color: Colors.white.withOpacity(0.3), width: 2)),
          child: const Icon(Icons.arrow_back, color: Colors.white, size: 24)),
      ),
    ),
    const SizedBox(height: 20),
    Container(
      width: 90, height: 90,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15), shape: BoxShape.circle,
        border: Border.all(color: secondaryGold.withOpacity(0.5), width: 2)),
      child: const Center(child: Text('📝', style: TextStyle(fontSize: 40))),
    ),
    const SizedBox(height: 16),
    Text(t('pageTitle'), style: GoogleFonts.amiri(
        color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
    const SizedBox(height: 8),
    Text(t('pageSubtitle'),
        style: GoogleFonts.tajawal(
            color: Colors.white.withOpacity(0.9), fontSize: 16)),
  ]);

  // ── Card ─────────────────────────────────────────────────────
  Widget _card(bool isDark) => Container(
    decoration: BoxDecoration(
      color: isDark ? darkCard : Colors.white,
      borderRadius: BorderRadius.circular(25),
      boxShadow: [BoxShadow(
          color: Colors.black.withOpacity(0.4),
          blurRadius: 70, offset: const Offset(0, 25))],
    ),
    child: Column(children: [
      _progressBar(),
      AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        transitionBuilder: (c, a) => FadeTransition(opacity: a, child: c),
        child: _currentStep == 1 ? _step1(isDark)
             : _currentStep == 2 ? _step2(isDark)
             : _step3(isDark),
      ),
    ]),
  );

  // ── شريط التقدم ──────────────────────────────────────────────
  Widget _progressBar() => Container(
    padding: const EdgeInsets.all(24),
    decoration: BoxDecoration(
      color: Colors.grey.shade50,
      borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25), topRight: Radius.circular(25))),
    child: Row(children: [
      _stepDot(1, t('step1')),
      _stepLine(1),
      _stepDot(2, t('step2')),
      _stepLine(2),
      _stepDot(3, t('step3')),
    ]),
  );

  Widget _stepDot(int n, String label) {
    final active  = _currentStep >= n;
    final current = _currentStep == n;
    return Expanded(child: Column(children: [
      Container(
        width: 50, height: 50,
        decoration: BoxDecoration(
          gradient: active ? const LinearGradient(
            colors: [primaryGreen, successColor],
            begin: Alignment.topLeft, end: Alignment.bottomRight) : null,
          color: active ? null : Colors.grey.shade300,
          shape: BoxShape.circle,
          boxShadow: current ? [BoxShadow(
            color: primaryGreen.withOpacity(0.4),
            blurRadius: 10, spreadRadius: 2)] : null,
        ),
        child: Center(child: Text('$n', style: GoogleFonts.tajawal(
            color: active ? Colors.white : Colors.grey,
            fontSize: 18, fontWeight: FontWeight.bold))),
      ),
      const SizedBox(height: 8),
      Text(label, textAlign: TextAlign.center, style: GoogleFonts.tajawal(
          color: active ? primaryGreen : Colors.grey, fontSize: 12,
          fontWeight: current ? FontWeight.bold : FontWeight.normal)),
    ]));
  }

  Widget _stepLine(int n) => Expanded(child: Container(
      height: 4,
      color: _currentStep > n ? primaryGreen : Colors.grey.shade300));

  // ════════════════════════════════════════════════════════════
  //  المرحلة 1 – بيانات الطالب
  // ════════════════════════════════════════════════════════════
  Widget _step1(bool isDark) => Container(
    key: const ValueKey(1),
    padding: const EdgeInsets.all(24),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _secHdr('👤', t('step1Title')),
      const SizedBox(height: 24),

      _tf(_nationalIdController, t('nationalId'), isDark,
          req: true, kb: TextInputType.number, hint: t('nationalIdHint')),
      Padding(padding: const EdgeInsets.only(top: 4, right: 8),
        child: Text('⚠️ ${t('nationalIdHint')}',
            style: GoogleFonts.tajawal(color: textLight, fontSize: 12))),
      const SizedBox(height: 16),

      _row2(_tf(_lastNameController,  t('lastName'), isDark, req: true),
            _tf(_firstNameController, t('firstName'), isDark, req: true)),
      const SizedBox(height: 16),

      _row2(_tf(_fatherNameController, t('fatherName'), isDark, req: true),
            _dtf(_birthDateController, t('birthDate'), isDark, req: true)),
      const SizedBox(height: 16),

      _row2(
        _tf(_phoneController, t('phone'), isDark,
            req: true, kb: TextInputType.phone, hint: t('phoneHint')),
        _tf(_emailController, t('email'), isDark,
            req: true, kb: TextInputType.emailAddress, hint: t('emailHint')),
      ),
      const SizedBox(height: 16),

      _row2(
        _dd(t('wilaya'), isDark, _wilayas,
            _selectedWilaya.isEmpty ? null : _selectedWilaya,
            (v) => setState(() => _selectedWilaya = v ?? ''), req: true),
        _municipalityDropdown(isDark),
      ),
      const SizedBox(height: 24),

      Text('${t('applicantType')} *', style: GoogleFonts.tajawal(
          color: isDark ? darkText : textDark,
          fontSize: 14, fontWeight: FontWeight.w600)),
      const SizedBox(height: 8),
      Wrap(spacing: 12, runSpacing: 8, children: _applicantTypes.map((tVal) {
        final sel = _applicantType == tVal;
        String label = '';
        if (tVal == 'مالك') label = t('owner');
        else if (tVal == 'وارث') label = t('heir');
        else if (tVal == 'وكيل') label = t('agent');
        
        return ChoiceChip(
          label: Text(label, style: GoogleFonts.tajawal(
              color: sel ? Colors.white : textDark)),
          selected: sel,
          onSelected: (s) => setState(() => _applicantType = s ? tVal : ''),
          selectedColor: primaryGreen, backgroundColor: bgLight,
        );
      }).toList()),
      const SizedBox(height: 32),

      _navRow(() => Navigator.pop(context), t('cancel'), () => _nextStep(2),
          nextLabel: t('next')),
    ]),
  );

  // قائمة البلديات المترجمة
  Widget _municipalityDropdown(bool isDark) {
    final locale = Provider.of<LocaleProvider>(context).locale.languageCode;
    
    // تحويل المفاتيح إلى نصوص مترجمة للعرض
    final translatedItems = _municipalityKeys.map((key) => t(key)).toList();
    
    // العثور على النص المترجم للقيمة المختارة
    String? currentValue;
    if (_selectedMunicipality.isNotEmpty) {
      // البحث عن المفتاح المطابق للقيمة المختارة
      for (var key in _municipalityKeys) {
        if (t(key) == _selectedMunicipality) {
          currentValue = t(key);
          break;
        }
      }
    }
    
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('${t('municipality')} *', style: GoogleFonts.tajawal(
          color: isDark ? darkText : textDark,
          fontSize: 14, fontWeight: FontWeight.w600)),
      const SizedBox(height: 8),
      Container(
        decoration: BoxDecoration(
            color: isDark ? darkBg : bgLight,
            borderRadius: BorderRadius.circular(12)),
        child: DropdownButtonFormField<String>(
          value: currentValue,
          items: translatedItems.map((item) => DropdownMenuItem(
            value: item,
            child: Text(item, style: GoogleFonts.tajawal(
                color: isDark ? darkText : textDark)))).toList(),
          onChanged: (v) => setState(() => _selectedMunicipality = v ?? ''),
          decoration: _dec(isDark),
          dropdownColor: isDark ? darkCard : Colors.white,
          icon: const Icon(Icons.arrow_drop_down, color: primaryGreen),
        ),
      ),
    ]);
  }

  // ════════════════════════════════════════════════════════════
  //  المرحلة 2 – تعيين العقار
  // ════════════════════════════════════════════════════════════
  Widget _step2(bool isDark) => Container(
    key: const ValueKey(2),
    padding: const EdgeInsets.all(24),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _secHdr('🏠', t('step2Title')),
      const SizedBox(height: 24),

      Text('${t('requestType')} *', style: GoogleFonts.tajawal(
          color: isDark ? darkText : textDark,
          fontSize: 14, fontWeight: FontWeight.w600)),
      const SizedBox(height: 8),
      Wrap(spacing: 12, runSpacing: 8, children: _requestTypes.map((tVal) {
        final sel = _requestType == tVal;
        String label = tVal == 'طلب جديد' ? t('newRequest') : t('copyRequest');
        
        return ChoiceChip(
          label: Text(label, style: GoogleFonts.tajawal(
              color: sel ? Colors.white : textDark)),
          selected: sel,
          onSelected: (s) => setState(() => _requestType = s ? tVal : 'طلب جديد'),
          selectedColor: primaryGreen, backgroundColor: bgLight,
        );
      }).toList()),
      const SizedBox(height: 24),

      Text('${t('surveyStatus')} *', style: GoogleFonts.tajawal(
          color: isDark ? darkText : textDark,
          fontSize: 14, fontWeight: FontWeight.w600)),
      Row(children: [
        Expanded(child: RadioListTile<String>(
          title: Text(t('surveyed'), style: GoogleFonts.tajawal()),
          value: 'ممسوح', groupValue: _surveyStatus,
          onChanged: (v) => setState(() => _surveyStatus = v!),
          activeColor: primaryGreen,
        )),
        Expanded(child: RadioListTile<String>(
          title: Text(t('notSurveyed'), style: GoogleFonts.tajawal()),
          value: 'غير ممسوح', groupValue: _surveyStatus,
          onChanged: (v) => setState(() => _surveyStatus = v!),
          activeColor: primaryGreen,
        )),
      ]),
      const SizedBox(height: 8),

      if (_surveyStatus == 'ممسوح') ...[
        Text(t('surveyedData'), style: GoogleFonts.tajawal(
            color: primaryGreen, fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        _tf(_surveyedCommuneController, t('municipality'), isDark, req: true),
        const SizedBox(height: 16),
        _row2(_tf(_sectionController,       t('section'),       isDark, req: true),
              _tf(_parcelNumberController,  t('parcelNumber'),  isDark, req: true)),
        const SizedBox(height: 16),
        _tf(_surveyedAreaController, t('area'), isDark,
            req: true, kb: TextInputType.number),
      ],

      if (_surveyStatus == 'غير ممسوح') ...[
        Text(t('notSurveyedData'), style: GoogleFonts.tajawal(
            color: primaryGreen, fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        _tf(_nonSurveyedCommuneController, t('municipality'),  isDark, req: true),
        const SizedBox(height: 16),
        _tf(_subdivisionController,        t('subdivision'),  isDark, req: true),
        const SizedBox(height: 16),
        _row2(_tf(_nonSurveyedSectionController,      t('section'),       isDark),
              _tf(_nonSurveyedParcelNumberController, t('parcelNumber'),  isDark)),
        const SizedBox(height: 16),
        _tf(_nonSurveyedAreaController, t('estimatedArea'),
            isDark, kb: TextInputType.number),
      ],

      const SizedBox(height: 24),
      Text('${t('propertyType')} *', style: GoogleFonts.tajawal(
          color: isDark ? darkText : textDark,
          fontSize: 14, fontWeight: FontWeight.w600)),
      const SizedBox(height: 8),
      Wrap(spacing: 12, runSpacing: 8, children: _propertyTypes.map((tVal) {
        final sel = _propertyType == tVal;
        String label = '';
        if (tVal == 'سكن تساهمي') label = t('cooperativeHousing');
        else if (tVal == 'قطعة أرض صالحة للبناء') label = t('buildingLand');
        else if (tVal == 'قطعة أرض فلاحية') label = t('agriculturalLand');
        else if (tVal == 'صناعي') label = t('industrial');
        
        return ChoiceChip(
          label: Text(label, style: GoogleFonts.tajawal(
              color: sel ? Colors.white : textDark)),
          selected: sel,
          onSelected: (s) => setState(() => _propertyType = s ? tVal : ''),
          selectedColor: primaryGreen, backgroundColor: bgLight,
        );
      }).toList()),
      const SizedBox(height: 32),

      _navRow(() => _prevStep(1), t('previous'), () => _nextStep(3),
          nextLabel: t('next')),
    ]),
  );

  // ════════════════════════════════════════════════════════════
  //  المرحلة 3 – رفع الوثائق
  // ════════════════════════════════════════════════════════════
  Widget _step3(bool isDark) {
    return Container(
      key: const ValueKey(3),
      padding: const EdgeInsets.all(24),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _secHdr('📎', t('step3Title')),
        const SizedBox(height: 24),

        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: primaryGreen.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: primaryGreen.withOpacity(0.2))),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              const Icon(Icons.info_outline, color: primaryGreen, size: 20),
              const SizedBox(width: 8),
              Text(t('requiredDocs'), style: GoogleFonts.tajawal(
                  color: primaryGreen, fontSize: 14, fontWeight: FontWeight.bold)),
            ]),
            const SizedBox(height: 10),
            ...[t('idCard'), t('ownershipDoc'), t('birthCert'), t('additionalDocs')].map((doc) =>
              Padding(padding: const EdgeInsets.only(bottom: 4),
                child: Row(children: [
                  const Icon(Icons.check_circle_outline,
                      color: primaryGreen, size: 16),
                  const SizedBox(width: 8),
                  Text(doc, style: GoogleFonts.tajawal(
                      color: textLight, fontSize: 13)),
                ])),
            ),
          ]),
        ),
        const SizedBox(height: 20),

        Row(children: [
          Icon(Icons.upload_file, color: primaryGreen, size: 18),
          const SizedBox(width: 8),
          Text('${_uploadedFiles.length} ${t('uploadedFiles')}',
              style: GoogleFonts.tajawal(
                  color: primaryGreen,
                  fontSize: 13, fontWeight: FontWeight.w600)),
        ]),
        const SizedBox(height: 20),

        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _showSourceSheet,
            icon: const Icon(Icons.add_circle_outline, size: 22),
            label: Text(t('addDocument'), style: GoogleFonts.tajawal(
                fontSize: 16, fontWeight: FontWeight.bold)),
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryGreen, foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 18),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Center(child: Text(
          kIsWeb ? t('uploadHint') : t('uploadHintWithCamera'),
          style: GoogleFonts.tajawal(color: textLight, fontSize: 12))),
        const SizedBox(height: 24),

        if (_uploadedFiles.isNotEmpty) ...[
          Text('${t('uploadedFiles')} (${_uploadedFiles.length}):',
              style: GoogleFonts.tajawal(
                  color: isDark ? darkText : textDark,
                  fontSize: 14, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _uploadedFiles.length,
            itemBuilder: (ctx, i) {
              final file = _uploadedFiles[i];
              final type = (file['type'] as String?) ?? 'unknown';
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                elevation: 1,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                color: isDark ? darkCard : Colors.white,
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 4),
                  leading: Container(
                    width: 44, height: 44,
                    decoration: BoxDecoration(
                      color: _fileColor(type).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10)),
                    child: Center(child: Text(_fileIcon(type),
                        style: const TextStyle(fontSize: 22))),
                  ),
                  title: Text(file['name'] as String? ?? t('files'),
                      style: GoogleFonts.tajawal(
                          color: isDark ? darkText : textDark,
                          fontSize: 13, fontWeight: FontWeight.w600),
                      maxLines: 1, overflow: TextOverflow.ellipsis),
                  subtitle: Text(_fmtSize(file['size'] as int? ?? 0),
                      style: GoogleFonts.tajawal(
                          color: textLight, fontSize: 11)),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline, color: dangerColor),
                    onPressed: () => _removeFile(i)),
                ),
              );
            },
          ),
        ] else
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 36),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200)),
            child: Column(children: [
              Icon(Icons.upload_file_outlined,
                  size: 48, color: Colors.grey.shade400),
              const SizedBox(height: 12),
              Text(t('clickToAdd'),
                  style: GoogleFonts.tajawal(color: textLight, fontSize: 14)),
            ]),
          ),

        const SizedBox(height: 32),
        _navRow(
          () => _prevStep(2), t('previous'),
          _submit, nextLabel: t('submit'),
          nextColor: primaryGreen,
          nextIcon: Icons.check_circle_outline,
        ),
      ]),
    );
  }

  // ════════════════════════════════════════════════════════════
  //  Widgets مساعدة
  // ════════════════════════════════════════════════════════════
  Widget _secHdr(String emoji, String title) => Container(
    padding: const EdgeInsets.only(bottom: 12),
    decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: primaryGreen, width: 3))),
    child: Row(children: [
      Text(emoji, style: const TextStyle(fontSize: 24)),
      const SizedBox(width: 8),
      Expanded(child: Text(title, style: GoogleFonts.amiri(
          color: primaryGreen, fontSize: 20, fontWeight: FontWeight.bold))),
    ]),
  );

  Widget _row2(Widget c1, Widget c2) => LayoutBuilder(
    builder: (ctx, box) => box.maxWidth > 600
      ? Row(crossAxisAlignment: CrossAxisAlignment.start,
          children: [Expanded(child: c1), const SizedBox(width: 16), Expanded(child: c2)])
      : Column(children: [c1, const SizedBox(height: 16), c2]),
  );

  Widget _navRow(
    VoidCallback onBack, String backLabel,
    VoidCallback onNext, {
    String nextLabel = 'التالي',
    Color  nextColor = primaryGreen,
    IconData nextIcon = Icons.arrow_forward,
  }) {
    final locale = Provider.of<LocaleProvider>(context).locale.languageCode;
    
    return Row(children: [
      Expanded(child: OutlinedButton.icon(
        onPressed: onBack,
        icon: const Icon(Icons.arrow_back),
        label: Text(backLabel, style: GoogleFonts.tajawal()),
        style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            side: BorderSide(color: Colors.grey.shade300)),
      )),
      const SizedBox(width: 12),
      Expanded(flex: 2, child: ElevatedButton.icon(
        onPressed: onNext,
        icon: Icon(locale == 'ar' && nextIcon == Icons.arrow_forward 
            ? Icons.arrow_forward : nextIcon),
        label: Text(nextLabel,
            style: GoogleFonts.tajawal(fontWeight: FontWeight.bold)),
        style: ElevatedButton.styleFrom(
            backgroundColor: nextColor, foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16)),
      )),
    ]);
  }

  // ── حقل نص ────────────────────────────────────────────────
  Widget _tf(
    TextEditingController ctrl, String label, bool isDark, {
    bool req = false,
    TextInputType kb = TextInputType.text,
    String? hint,
  }) {
    final locale = Provider.of<LocaleProvider>(context).locale.languageCode;
    
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('$label${req ? ' *' : ''}', style: GoogleFonts.tajawal(
          color: isDark ? darkText : textDark,
          fontSize: 14, fontWeight: FontWeight.w600)),
      const SizedBox(height: 8),
      TextFormField(
        controller: ctrl, keyboardType: kb,
        textAlign: locale == 'ar' ? TextAlign.right : TextAlign.left,
        style: GoogleFonts.tajawal(color: isDark ? darkText : textDark),
        decoration: _dec(isDark, hint: hint),
      ),
    ]);
  }

  // ── حقل تاريخ ─────────────────────────────────────────────
  Widget _dtf(
    TextEditingController ctrl, String label, bool isDark, {bool req = false}
  ) {
    final locale = Provider.of<LocaleProvider>(context).locale.languageCode;
    
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('$label${req ? ' *' : ''}', style: GoogleFonts.tajawal(
          color: isDark ? darkText : textDark,
          fontSize: 14, fontWeight: FontWeight.w600)),
      const SizedBox(height: 8),
      TextFormField(
        controller: ctrl, readOnly: true,
        textAlign: locale == 'ar' ? TextAlign.right : TextAlign.left,
        style: GoogleFonts.tajawal(color: isDark ? darkText : textDark),
        decoration: _dec(isDark, hint: t('selectDate'),
            suffix: const Icon(Icons.calendar_today, color: primaryGreen)),
        onTap: () async {
          final p = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1900), lastDate: DateTime.now(),
            builder: (ctx, child) => Theme(
              data: Theme.of(ctx).copyWith(
                  colorScheme: const ColorScheme.light(primary: primaryGreen)),
              child: child!),
          );
          if (p != null) {
            ctrl.text = locale == 'ar'
                ? '${p.day.toString().padLeft(2,'0')}/${p.month.toString().padLeft(2,'0')}/${p.year}'
                : '${p.year}-${p.month.toString().padLeft(2,'0')}-${p.day.toString().padLeft(2,'0')}';
          }
        },
      ),
    ]);
  }

  // ── قائمة منسدلة ──────────────────────────────────────────
  Widget _dd(
    String label, bool isDark,
    List<String> items, String? value,
    ValueChanged<String?> onChanged, {bool req = false}
  ) {
    final locale = Provider.of<LocaleProvider>(context).locale.languageCode;
    
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('$label${req ? ' *' : ''}', style: GoogleFonts.tajawal(
          color: isDark ? darkText : textDark,
          fontSize: 14, fontWeight: FontWeight.w600)),
      const SizedBox(height: 8),
      Container(
        decoration: BoxDecoration(
            color: isDark ? darkBg : bgLight,
            borderRadius: BorderRadius.circular(12)),
        child: DropdownButtonFormField<String>(
          value: value,
          items: items.map((i) => DropdownMenuItem(value: i,
            child: Text(i, style: GoogleFonts.tajawal(
                color: isDark ? darkText : textDark)))).toList(),
          onChanged: onChanged,
          decoration: _dec(isDark),
          dropdownColor: isDark ? darkCard : Colors.white,
          icon: const Icon(Icons.arrow_drop_down, color: primaryGreen),
        ),
      ),
    ]);
  }

  // ── مساعد InputDecoration ─────────────────────────────────
  InputDecoration _dec(bool isDark, {String? hint, Widget? suffix}) =>
    InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.tajawal(color: textLight, fontSize: 12),
      suffixIcon: suffix,
      filled: true, fillColor: isDark ? darkBg : bgLight,
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryGreen, width: 2)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
}