// lib/providers/admin_provider.dart

import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';

class AdminProvider extends ChangeNotifier {
  bool _isAdmin = false;
  String? _adminToken;
  late Map<String, Map<String, String>> _pageContents;
  late Map<String, Color> _buttonColors;
  List<String> _deletedFields = [];
  late Map<String, Map<String, String>> _fieldDescriptions;
  
  // المتغيرات الجديدة المفقودة
  bool _isSaving = false;
  DateTime? _lastSaveTime;
  final _changesController = StreamController<Map<String, dynamic>>.broadcast();

  bool get isAdmin => _isAdmin;
  String? get adminToken => _adminToken;
  Map<String, Map<String, String>> get pageContents => _pageContents;
  Map<String, Color> get buttonColors => _buttonColors;
  List<String> get deletedFields => _deletedFields;
  bool get isSaving => _isSaving;
  DateTime? get lastSaveTime => _lastSaveTime;
  Stream<Map<String, dynamic>> get changesStream => _changesController.stream;

  AdminProvider() {
    _loadDefaultContent();
    _loadDefaultColors();
    _loadDefaultDescriptions();
    _loadSavedAdminData();
  }

  // ✅ تحميل بيانات الأدمن المحفوظة
  Future<void> _loadSavedAdminData() async {
    _adminToken = await ApiService.getToken();
    if (_adminToken != null) {
      _isAdmin = true;
      print('✅ تم تحميل بيانات الأدمن المحفوظة');
    }
  }

  // ✅ دالة تسجيل الدخول الحقيقية (تستخدم API خاصة بالأدمن)
  Future<bool> loginAsAdmin(String email, String password) async {
    try {
      print('🚀 محاولة تسجيل دخول الأدمن: $email');
      
      // ✅ نستعمل الدالة الجديدة adminLogin مش login العادية
      final result = await ApiService.adminLogin(email, password);
      print('📨 نتيجة تسجيل الدخول: $result');
      
      if (result['success'] == true) {
        _isAdmin = true;
        _adminToken = await ApiService.getToken();
        print('✅ تم تسجيل دخول الأدمن بنجاح');
        print('🔑 توكن الأدمن الحقيقي: $_adminToken');
        notifyListeners();
        return true;
      } else {
        print('❌ فشل تسجيل الدخول: ${result['message']}');
        return false;
      }
    } catch (e) {
      print('🔥 خطأ في تسجيل دخول الأدمن: $e');
      return false;
    }
  }

  // ✅ للاختبار فقط
  Future<bool> loginAsAdminWithPassword(String password) async {
    if (password == 'admin123') {
      _isAdmin = true;
      _adminToken = 'fake_admin_token_123';
      print('⚠️ تحذير: تستخدم توكن وهمي للاختبار');
      notifyListeners();
      return true;
    }
    return false;
  }

  // تسجيل الخروج
  Future<void> logoutAdmin() async {
    _isAdmin = false;
    _adminToken = null;
    await ApiService.removeToken();
    notifyListeners();
  }

  // إعادة تعيين المحتوى الافتراضي
  void resetToDefault() {
    _loadDefaultContent();
    _loadDefaultColors();
    _loadDefaultDescriptions();
    _deletedFields.clear();
    notifyListeners();
  }

  // تحميل الألوان الافتراضية
  void _loadDefaultColors() {
    _buttonColors = {
      'primary': const Color(0xFF1A5632),
      'secondary': const Color(0xFFC49B63),
      'accent': const Color(0xFF8B6F47),
      'danger': const Color(0xFFDC3545),
      'success': const Color(0xFF28A745),
      'info': const Color(0xFF17A2B8),
      'warning': const Color(0xFFFFC107),
      'background': const Color(0xFFF8F6F1),
      'text': const Color(0xFF2D2D2D),
      'textLight': const Color(0xFF6B6B6B),
    };
  }

  // تحديث لون زر معين
  void updateButtonColor(String key, Color color) {
    _buttonColors[key] = color;
    notifyListeners();
  }

  // الحصول على لون زر
  Color getButtonColor(String key) {
    return _buttonColors[key] ?? const Color(0xFF1A5632);
  }

  // تحميل الأوصاف الافتراضية
  void _loadDefaultDescriptions() {
    _fieldDescriptions = {
      // الصفحة الرئيسية
      'home_hero_title': {
        'ar': 'عنوان الصفحة الرئيسية',
        'en': 'Home page title',
        'fr': 'Titre de la page d\'accueil',
      },
      'home_hero_subtitle': {
        'ar': 'العنوان الفرعي (أولاد جلال)',
        'en': 'Subtitle (Ouled Djellal)',
        'fr': 'Sous-titre (Ouled Djellal)',
      },
      'home_hero_description': {
        'ar': 'وصف الصفحة الرئيسية',
        'en': 'Home page description',
        'fr': 'Description de la page d\'accueil',
      },
      
      // الشهادة السلبية
      'negative_certificate_title': {
        'ar': 'عنوان صفحة الشهادة السلبية',
        'en': 'Negative certificate page title',
        'fr': 'Titre de la page de certificat négatif',
      },
      'negative_certificate_owner_info': {
        'ar': 'نص "معلومات صاحب الملكية"',
        'en': '"Owner Information" text',
        'fr': 'Texte "Informations du propriétaire"',
      },
      'negative_certificate_applicant_info': {
        'ar': 'نص "معلومات مقدم الطلب"',
        'en': '"Applicant Information" text',
        'fr': 'Texte "Informations du demandeur"',
      },
      'negative_certificate_lastname': {
        'ar': 'نص "اللقب"',
        'en': '"Last Name" text',
        'fr': 'Texte "Nom"',
      },
      'negative_certificate_firstname': {
        'ar': 'نص "الاسم"',
        'en': '"First Name" text',
        'fr': 'Texte "Prénom"',
      },
      'negative_certificate_fathername': {
        'ar': 'نص "اسم الأب"',
        'en': '"Father\'s Name" text',
        'fr': 'Texte "Nom du père"',
      },
      'negative_certificate_birthdate': {
        'ar': 'نص "تاريخ الميلاد"',
        'en': '"Birth Date" text',
        'fr': 'Texte "Date de naissance"',
      },
      'negative_certificate_birthplace': {
        'ar': 'نص "مكان الميلاد"',
        'en': '"Birth Place" text',
        'fr': 'Texte "Lieu de naissance"',
      },
      'negative_certificate_email': {
        'ar': 'نص "البريد الإلكتروني"',
        'en': '"Email" text',
        'fr': 'Texte "Email"',
      },
      'negative_certificate_phone': {
        'ar': 'نص "رقم الهاتف"',
        'en': '"Phone Number" text',
        'fr': 'Texte "Téléphone"',
      },
      'negative_certificate_submit': {
        'ar': 'نص زر "إرسال الطلب"',
        'en': '"Submit Request" button text',
        'fr': 'Texte du bouton "Soumettre"',
      },
      'negative_certificate_success': {
        'ar': 'رسالة النجاح',
        'en': 'Success message',
        'fr': 'Message de succès',
      },

      // الوثائق العقارية
      'real_estate_docs_title': {
        'ar': 'عنوان صفحة الوثائق العقارية',
        'en': 'Real estate documents page title',
        'fr': 'Titre de la page des documents fonciers',
      },
      'real_estate_docs_subtitle': {
        'ar': 'العنوان الفرعي',
        'en': 'Subtitle',
        'fr': 'Sous-titre',
      },
      'real_estate_cards': {
        'ar': 'نص "البطاقات العقارية"',
        'en': '"Real Estate Cards" text',
        'fr': 'Texte "Cartes foncières"',
      },
      'contract_extracts': {
        'ar': 'نص "مستخرجات العقود"',
        'en': '"Contract Extracts" text',
        'fr': 'Texte "Extraits de contrats"',
      },
      'personal_card': {
        'ar': 'نص "البطاقة الشخصية"',
        'en': '"Personal Card" text',
        'fr': 'Texte "Carte personnelle"',
      },
      'urban_card': {
        'ar': 'نص "البطاقة الحضرية"',
        'en': '"Urban Card" text',
        'fr': 'Texte "Carte urbaine"',
      },
      'rural_card': {
        'ar': 'نص "البطاقة الريفية"',
        'en': '"Rural Card" text',
        'fr': 'Texte "Carte rurale"',
      },

      // مستخرجات العقود
      'contract_extracts_title': {
        'ar': 'عنوان صفحة مستخرجات العقود',
        'en': 'Contract extracts page title',
        'fr': 'Titre de la page des extraits de contrats',
      },
      'contract_extracts_select': {
        'ar': 'نص "اختر نوع العقد"',
        'en': '"Select Contract Type" text',
        'fr': 'Texte "Sélectionnez le type de contrat"',
      },
      'contract_sale': {
        'ar': 'نص "عقد بيع"',
        'en': '"Sale Contract" text',
        'fr': 'Texte "Contrat de vente"',
      },
      'contract_gift': {
        'ar': 'نص "عقد هبة"',
        'en': '"Gift Contract" text',
        'fr': 'Texte "Contrat de donation"',
      },
      'contract_mortgage': {
        'ar': 'نص "رهن أو امتياز"',
        'en': '"Mortgage or Lien" text',
        'fr': 'Texte "Hypothèque ou privilège"',
      },
      'contract_termination': {
        'ar': 'نص "تشطيب"',
        'en': '"Termination" text',
        'fr': 'Texte "Annulation"',
      },
      'contract_petition': {
        'ar': 'نص "عريضة"',
        'en': '"Petition" text',
        'fr': 'Texte "Pétition"',
      },
      'contract_title_deed': {
        'ar': 'نص "وثيقة ناقلة للملكية"',
        'en': '"Title Deed" text',
        'fr': 'Texte "Titre de propriété"',
      },

      // الدفتر العقاري
      'property_book_title': {
        'ar': 'عنوان صفحة الدفتر العقاري',
        'en': 'Property book page title',
        'fr': 'Titre de la page du livre foncier',
      },
      'property_book_new': {
        'ar': 'نص "طلب دفتر جديد"',
        'en': '"New Book Request" text',
        'fr': 'Texte "Nouvelle demande de livre"',
      },
      'property_book_copy': {
        'ar': 'نص "نسخة من دفتر"',
        'en': '"Book Copy" text',
        'fr': 'Texte "Copie du livre"',
      },
      'property_book_section': {
        'ar': 'نص "القسم"',
        'en': '"Section" text',
        'fr': 'Texte "Section"',
      },
      'property_book_parcel': {
        'ar': 'نص "رقم القطعة"',
        'en': '"Parcel Number" text',
        'fr': 'Texte "Numéro de parcelle"',
      },
      'property_book_area': {
        'ar': 'نص "المساحة"',
        'en': '"Area" text',
        'fr': 'Texte "Superficie"',
      },

      // حجز موعد
      'appointment_title': {
        'ar': 'عنوان صفحة حجز موعد',
        'en': 'Appointment page title',
        'fr': 'Titre de la page de rendez-vous',
      },
      'appointment_subtitle': {
        'ar': 'العنوان الفرعي',
        'en': 'Subtitle',
        'fr': 'Sous-titre',
      },
      'appointment_date': {
        'ar': 'نص "تاريخ الموعد"',
        'en': '"Appointment Date" text',
        'fr': 'Texte "Date du rendez-vous"',
      },
      'appointment_service': {
        'ar': 'نص "نوع الخدمة"',
        'en': '"Service Type" text',
        'fr': 'Texte "Type de service"',
      },
      'appointment_notes': {
        'ar': 'نص "ملاحظات إضافية"',
        'en': '"Additional Notes" text',
        'fr': 'Texte "Notes supplémentaires"',
      },
      'appointment_confirm': {
        'ar': 'نص زر "تأكيد الحجز"',
        'en': '"Confirm Booking" button text',
        'fr': 'Texte du bouton "Confirmer"',
      },
      'appointment_success': {
        'ar': 'رسالة النجاح',
        'en': 'Success message',
        'fr': 'Message de succès',
      },
      'appointment_details': {
        'ar': 'تفاصيل الحجز',
        'en': 'Booking details',
        'fr': 'Détails du rendez-vous',
      },

      // معلومات الاتصال
      'contact_address': {
        'ar': 'العنوان',
        'en': 'Address',
        'fr': 'Adresse',
      },
      'contact_phone': {
        'ar': 'رقم الهاتف',
        'en': 'Phone number',
        'fr': 'Numéro de téléphone',
      },
      'contact_email': {
        'ar': 'البريد الإلكتروني',
        'en': 'Email',
        'fr': 'Email',
      },
      'working_hours': {
        'ar': 'أوقات العمل',
        'en': 'Working hours',
        'fr': 'Heures de travail',
      },
    };
  }

  // تحميل المحتوى الافتراضي لجميع الصفحات
  void _loadDefaultContent() {
    _pageContents = {
      // ========== الصفحة الرئيسية ==========
     
  'home_hero_title': {
      'ar': 'المحافظة العقارية',
      'en': 'Real Estate Conservation',
      'fr': 'Conservation Foncière',
    },
    'home_hero_subtitle': {
      'ar': 'أولاد جلال',
      'en': 'Ouled Djellal',
      'fr': 'Ouled Djellal',
    },
    
    // ✅ أضف هذه المفاتيح الجديدة هنا
    'propertyManagementSystem': {
      'ar': 'نظام تسيير المعاملات العقارية',
      'en': 'Real Estate Transactions Management System',
      'fr': 'Système de Gestion des Transactions Immobilières'
    },
    'integrated_solution': {
      'ar': 'حل متكامل لإدارة ومتابعة جميع المعاملات العقارية بكفاءة وشفافية',
      'en': 'Integrated solution for managing and tracking all real estate transactions efficiently and transparently',
      'fr': 'Solution intégrée pour gérer et suivre toutes les transactions immobilières efficacement et en transparence'
    },
    'browse_services': {
      'ar': 'استعرض خدماتنا',
      'en': 'Browse Our Services',
      'fr': 'Parcourir nos services'
    },
      'stats_requests': {
        'ar': 'طلب',
        'en': 'Requests',
        'fr': 'Demandes',
      },
      'stats_satisfaction': {
        'ar': 'رضا',
        'en': 'Satisfaction',
        'fr': 'Satisfaction',
      },
      'stats_support': {
        'ar': 'دعم',
        'en': 'Support',
        'fr': 'Support',
      },

      // ========== الشهادة السلبية ==========
      'negative_certificate_title': {
        'ar': 'طلب شهادة سلبية جديدة',
        'en': 'New Negative Certificate Request',
        'fr': 'Nouvelle Demande de Certificat Négatif',
      },
      'negative_certificate_owner_info': {
        'ar': 'معلومات صاحب الملكية',
        'en': 'Owner Information',
        'fr': 'Informations du Propriétaire',
      },
      'negative_certificate_applicant_info': {
        'ar': 'معلومات مقدم الطلب',
        'en': 'Applicant Information',
        'fr': 'Informations du Demandeur',
      },
      'negative_certificate_lastname': {
        'ar': 'اللقب',
        'en': 'Last Name',
        'fr': 'Nom',
      },
      'negative_certificate_firstname': {
        'ar': 'الاسم',
        'en': 'First Name',
        'fr': 'Prénom',
      },
      'negative_certificate_fathername': {
        'ar': 'اسم الأب',
        'en': 'Father\'s Name',
        'fr': 'Nom du Père',
      },
      'negative_certificate_birthdate': {
        'ar': 'تاريخ الميلاد',
        'en': 'Birth Date',
        'fr': 'Date de Naissance',
      },
      'negative_certificate_birthplace': {
        'ar': 'مكان الميلاد',
        'en': 'Birth Place',
        'fr': 'Lieu de Naissance',
      },
      'negative_certificate_email': {
        'ar': 'البريد الإلكتروني',
        'en': 'Email',
        'fr': 'Email',
      },
      'negative_certificate_phone': {
        'ar': 'رقم الهاتف',
        'en': 'Phone Number',
        'fr': 'Téléphone',
      },
      'negative_certificate_submit': {
        'ar': 'إرسال الطلب',
        'en': 'Submit Request',
        'fr': 'Soumettre la Demande',
      },
      'negative_certificate_success': {
        'ar': 'تم إرسال طلب الشهادة السلبية بنجاح',
        'en': 'Negative certificate request submitted successfully',
        'fr': 'Demande de certificat négatif envoyée avec succès',
      },

      // ========== الوثائق العقارية ==========
      'real_estate_docs_title': {
        'ar': 'الوثائق العقارية',
        'en': 'Real Estate Documents',
        'fr': 'Documents Fonciers',
      },
      'real_estate_docs_subtitle': {
        'ar': 'اختر نوع الوثيقة المطلوبة',
        'en': 'Select the required document type',
        'fr': 'Sélectionnez le type de document requis',
      },
      'real_estate_cards': {
        'ar': 'البطاقات العقارية',
        'en': 'Real Estate Cards',
        'fr': 'Cartes Foncières',
      },
      'contract_extracts': {
        'ar': 'مستخرجات العقود',
        'en': 'Contract Extracts',
        'fr': 'Extraits de Contrats',
      },
      'personal_card': {
        'ar': 'البطاقة الشخصية',
        'en': 'Personal Card',
        'fr': 'Carte Personnelle',
      },
      'urban_card': {
        'ar': 'البطاقة الحضرية',
        'en': 'Urban Card',
        'fr': 'Carte Urbaine',
      },
      'rural_card': {
        'ar': 'البطاقة الريفية',
        'en': 'Rural Card',
        'fr': 'Carte Rurale',
      },

      // ========== مستخرجات العقود ==========
      'contract_extracts_title': {
        'ar': 'مستخرجات العقود',
        'en': 'Contract Extracts',
        'fr': 'Extraits de Contrats',
      },
      'contract_extracts_select': {
        'ar': 'اختر نوع العقد',
        'en': 'Select Contract Type',
        'fr': 'Sélectionnez le Type de Contrat',
      },
      'contract_sale': {
        'ar': 'عقد بيع',
        'en': 'Sale Contract',
        'fr': 'Contrat de Vente',
      },
      'contract_gift': {
        'ar': 'عقد هبة',
        'en': 'Gift Contract',
        'fr': 'Contrat de Donation',
      },
      'contract_mortgage': {
        'ar': 'رهن أو امتياز',
        'en': 'Mortgage or Lien',
        'fr': 'Hypothèque ou Privilège',
      },
      'contract_termination': {
        'ar': 'تشطيب',
        'en': 'Termination',
        'fr': 'Annulation',
      },
      'contract_petition': {
        'ar': 'عريضة',
        'en': 'Petition',
        'fr': 'Pétition',
      },
      'contract_title_deed': {
        'ar': 'وثيقة ناقلة للملكية',
        'en': 'Title Deed',
        'fr': 'Titre de Propriété',
      },

      // ========== الدفتر العقاري ==========
      'property_book_title': {
        'ar': 'الدفتر العقاري',
        'en': 'Property Book',
        'fr': 'Livre Foncier',
      },
      'property_book_new': {
        'ar': 'طلب دفتر جديد',
        'en': 'New Book Request',
        'fr': 'Nouvelle Demande de Livre',
      },
      'property_book_copy': {
        'ar': 'نسخة من دفتر',
        'en': 'Book Copy',
        'fr': 'Copie du Livre',
      },
      'property_book_section': {
        'ar': 'القسم',
        'en': 'Section',
        'fr': 'Section',
      },
      'property_book_parcel': {
        'ar': 'رقم القطعة',
        'en': 'Parcel Number',
        'fr': 'Numéro de Parcelle',
      },
      'property_book_area': {
        'ar': 'المساحة',
        'en': 'Area',
        'fr': 'Superficie',
      },

      // ========== حجز موعد ==========
      'appointment_title': {
        'ar': 'حجز موعد',
        'en': 'Book Appointment',
        'fr': 'Prendre Rendez-vous',
      },
      'appointment_subtitle': {
        'ar': 'المحافظة العقارية – أولاد جلال',
        'en': 'Real Estate Conservation – Ouled Djellal',
        'fr': 'Conservation Foncière – Ouled Djellal',
      },
      'appointment_date': {
        'ar': 'تاريخ الموعد',
        'en': 'Appointment Date',
        'fr': 'Date du Rendez-vous',
      },
      'appointment_service': {
        'ar': 'نوع الخدمة',
        'en': 'Service Type',
        'fr': 'Type de Service',
      },
      'appointment_notes': {
        'ar': 'ملاحظات إضافية',
        'en': 'Additional Notes',
        'fr': 'Notes Supplémentaires',
      },
      'appointment_confirm': {
        'ar': 'تأكيد الحجز',
        'en': 'Confirm Booking',
        'fr': 'Confirmer le Rendez-vous',
      },
      'appointment_success': {
        'ar': 'تم الحجز بنجاح!',
        'en': 'Booking Successful!',
        'fr': 'Rendez-vous Confirmé!',
      },
      'appointment_details': {
        'ar': 'تم تسجيل موعدك بنجاح. سيتم إرسال تفاصيل الموعد إلى بريدك الإلكتروني.',
        'en': 'Your appointment has been registered successfully. Details will be sent to your email.',
        'fr': 'Votre rendez-vous a été enregistré avec succès. Les détails seront envoyés à votre email.',
      },

      // ========== معلومات الاتصال ==========
      'contact_address': {
        'ar': 'شارع الاستقلال، أولاد جلال، الجزائر',
        'en': 'Independence Street, Ouled Djellal, Algeria',
        'fr': 'Rue de l\'Indépendance, Ouled Djellal, Algérie',
      },
      'contact_phone': {
        'ar': '033 12 34 56',
        'en': '+213 33 12 34 56',
        'fr': '+213 33 12 34 56',
      },
      'contact_email': {
        'ar': 'contact@mohafada.dz',
        'en': 'contact@mohafada.dz',
        'fr': 'contact@mohafada.dz',
      },
      'working_hours': {
        'ar': 'الاثنين - الأربعاء: 08:00 - 12:00',
        'en': 'Monday - Wednesday: 08:00 - 12:00',
        'fr': 'Lundi - Mercredi: 08:00 - 12:00',
      },
    };
  }

  // ✅ دالة تحديث المحتوى (نسخة واحدة فقط)
  void updateContent(String key, String language, String value) {
    if (_pageContents.containsKey(key)) {
      if (_pageContents[key]?[language] != value) {
        _pageContents[key]?[language] = value;
        
        // انشر التغيير للمستمعين
        _changesController.add({
          'key': key,
          'language': language,
          'value': value,
        });
        
        notifyListeners();
      }
    }
  }

  // حذف خانة معينة
  void deleteField(String key) {
    if (!_deletedFields.contains(key)) {
      _deletedFields.add(key);
      notifyListeners();
    }
  }

  // استعادة خانة محذوفة
  void restoreField(String key) {
    _deletedFields.remove(key);
    notifyListeners();
  }

  // التحقق مما إذا كانت خانة محذوفة
  bool isFieldDeleted(String key) {
    return _deletedFields.contains(key);
  }

  // الحصول على محتوى
  String getContent(String key, String lang) {
    if (isFieldDeleted(key)) return '';
    return _pageContents[key]?[lang] ?? _pageContents[key]?['ar'] ?? key;
  }

  // ✅ دالة حفظ التغييرات (نسخة واحدة فقط)
  Future<void> saveAllChanges() async {
    _isSaving = true;
    notifyListeners();
    
    try {
      // حفظ في SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('admin_content', jsonEncode(_pageContents));
      
      // انشر حدث الحفظ الكامل
      _changesController.add({'type': 'bulk_save', 'data': _pageContents});
      
      _lastSaveTime = DateTime.now();
      print('✅ تم حفظ جميع التغييرات بنجاح');
    } catch (e) {
      print('❌ خطأ في حفظ التغييرات: $e');
      rethrow;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  // قائمة بجميع المفاتيح القابلة للتعديل
  List<String> getEditableKeys() {
    return _pageContents.keys.toList();
  }

  // الحصول على المفاتيح حسب القسم
  List<String> getKeysBySection(String section) {
    return _pageContents.keys.where((key) => key.startsWith(section)).toList();
  }

  // الحصول على وصف المفتاح
  String getKeyDescription(String key, String lang) {
    return _fieldDescriptions[key]?[lang] ?? _fieldDescriptions[key]?['ar'] ?? key;
  }

  // إضافة خانة جديدة
  void addNewField(String section, String fieldKey, Map<String, String> defaultValues) {
    final fullKey = '${section}_$fieldKey';
    if (!_pageContents.containsKey(fullKey)) {
      _pageContents[fullKey] = defaultValues;
      
      // إضافة وصف افتراضي للمفتاح الجديد
      _fieldDescriptions[fullKey] = {
        'ar': 'حقل مخصص جديد',
        'en': 'New custom field',
        'fr': 'Nouveau champ personnalisé',
      };
      
      notifyListeners();
    }
  }

  // الحصول على قائمة الأقسام المتاحة
  List<String> getAvailableSections() {
    return [
      'home',
      'negative_certificate',
      'real_estate_docs',
      'contract_extracts',
      'property_book',
      'appointment',
      'contact',
    ];
  }

  // الحصول على اسم القسم حسب اللغة
  String getSectionName(String section, String lang) {
    final Map<String, Map<String, String>> sectionNames = {
      'home': {
        'ar': 'الصفحة الرئيسية',
        'en': 'Home Page',
        'fr': 'Page d\'accueil',
      },
      'negative_certificate': {
        'ar': 'الشهادة السلبية',
        'en': 'Negative Certificate',
        'fr': 'Certificat Négatif',
      },
      'real_estate_docs': {
        'ar': 'الوثائق العقارية',
        'en': 'Real Estate Documents',
        'fr': 'Documents Fonciers',
      },
      'contract_extracts': {
        'ar': 'مستخرجات العقود',
        'en': 'Contract Extracts',
        'fr': 'Extraits de Contrats',
      },
      'property_book': {
        'ar': 'الدفتر العقاري',
        'en': 'Property Book',
        'fr': 'Livre Foncier',
      },
      'appointment': {
        'ar': 'حجز موعد',
        'en': 'Appointment',
        'fr': 'Rendez-vous',
      },
      'contact': {
        'ar': 'معلومات الاتصال',
        'en': 'Contact Information',
        'fr': 'Informations de Contact',
      },
    };
    return sectionNames[section]?[lang] ?? section;
  }
  
  @override
  void dispose() {
    _changesController.close();
    super.dispose();
  }
}