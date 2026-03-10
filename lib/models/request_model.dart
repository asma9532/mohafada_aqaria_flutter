import 'dart:convert';
import 'package:flutter/material.dart';

class RequestModel {
  final int id;
  final String type;
  final String status;
  final DateTime createdAt;
  final Map<String, dynamic> data;

  RequestModel({
    required this.id,
    required this.type,
    required this.status,
    required this.createdAt,
    required this.data,
  });

  factory RequestModel.fromJson(Map<String, dynamic> json) {
    return RequestModel(
      id: json['id'],
      type: json['type'] ?? 'unknown',
      status: json['status'] ?? 'pending',
      createdAt: DateTime.parse(json['created_at']),
      data: json['data'] is String 
          ? (jsonDecode(json['data']) as Map<String, dynamic>)
          : (json['data'] as Map<String, dynamic>? ?? {}),
    );
  }

  // ==================== الدعم بثلاث لغات ====================
  
  String get typeText {
    // العربية (إذا كان النوع مخزناً بالعربية مباشرة)
    if (type == 'شهادة سلبية') return 'شهادة سلبية';
    if (type == 'بطاقة عقارية') return 'بطاقة عقارية';
    if (type == 'مستخرج عقد') return 'مستخرج عقد';
    if (type == 'دفتر عقاري') return 'دفتر عقاري';
    if (type == 'نسخة دفتر عقاري') return 'نسخة دفتر عقاري';
    if (type == 'موعد') return 'موعد';
    if (type == 'رسالة اتصال') return 'رسالة اتصال';
    
    // الإنجليزية (المخزنة في قاعدة البيانات)
    switch (type) {
      case 'negative_certificate':
        return 'شهادة سلبية';
      case 'real_estate_card':
        return 'بطاقة عقارية';
      case 'contract_extract':
        return 'مستخرج عقد';
      case 'property_book':
        return 'دفتر عقاري';
      case 'property_book_copy':
        return 'نسخة دفتر عقاري';
      case 'property_book_with_files':
        return 'دفتر عقاري (مع ملفات)';
      case 'appointment':
        return 'موعد';
      case 'contact':
        return 'رسالة اتصال';
      default:
        return type;
    }
  }

  // ✅ دالة جديدة لنوع الطلب بالفرنسية
  String get typeTextFr {
    switch (type) {
      case 'negative_certificate':
        return 'Certificat Négatif';
      case 'real_estate_card':
        return 'Carte Foncière';
      case 'contract_extract':
        return 'Extrait de Contrat';
      case 'property_book':
        return 'Livre Foncier';
      case 'property_book_copy':
        return 'Copie de Livre Foncier';
      case 'property_book_with_files':
        return 'Livre Foncier (avec fichiers)';
      case 'appointment':
        return 'Rendez-vous';
      case 'contact':
        return 'Message de Contact';
      default:
        return type;
    }
  }

  // ✅ دالة جديدة لنوع الطلب بالإنجليزية
  String get typeTextEn {
    switch (type) {
      case 'negative_certificate':
        return 'Negative Certificate';
      case 'real_estate_card':
        return 'Real Estate Card';
      case 'contract_extract':
        return 'Contract Extract';
      case 'property_book':
        return 'Property Book';
      case 'property_book_copy':
        return 'Property Book Copy';
      case 'property_book_with_files':
        return 'Property Book (with files)';
      case 'appointment':
        return 'Appointment';
      case 'contact':
        return 'Contact Message';
      default:
        return type;
    }
  }

  // ✅ دالة اختيار اللغة حسب إعدادات التطبيق
  String getLocalizedType(String languageCode) {
    switch (languageCode) {
      case 'ar':
        return typeText;
      case 'en':
        return typeTextEn;
      case 'fr':
        return typeTextFr;
      default:
        return typeText; // العربية افتراضياً
    }
  }

  String get statusText {
    switch (status) {
      case 'pending':
        return 'قيد المراجعة';
      case 'approved':
        return 'مقبول';
      case 'rejected':
        return 'مرفوض';
      case 'completed':
        return 'مكتمل';
      default:
        return status;
    }
  }

  // ✅ حالة الطلب بالفرنسية
  String get statusTextFr {
    switch (status) {
      case 'pending':
        return 'En cours';
      case 'approved':
        return 'Approuvé';
      case 'rejected':
        return 'Rejeté';
      case 'completed':
        return 'Terminé';
      default:
        return status;
    }
  }

  // ✅ حالة الطلب بالإنجليزية
  String get statusTextEn {
    switch (status) {
      case 'pending':
        return 'Pending';
      case 'approved':
        return 'Approved';
      case 'rejected':
        return 'Rejected';
      case 'completed':
        return 'Completed';
      default:
        return status;
    }
  }

  // ✅ دالة اختيار حالة الطلب حسب اللغة
  String getLocalizedStatus(String languageCode) {
    switch (languageCode) {
      case 'ar':
        return statusText;
      case 'en':
        return statusTextEn;
      case 'fr':
        return statusTextFr;
      default:
        return statusText;
    }
  }

  Color get statusColor {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'completed':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  IconData get typeIcon {
    // دعم كل الحالات (عربية وإنجليزية)
    if (type == 'شهادة سلبية' || type == 'negative_certificate') 
      return Icons.description_rounded;
    if (type == 'بطاقة عقارية' || type == 'real_estate_card') 
      return Icons.credit_card_rounded;
    if (type == 'مستخرج عقد' || type == 'contract_extract') 
      return Icons.description_outlined;
    if (type == 'دفتر عقاري' || type == 'نسخة دفتر عقاري' || 
        type == 'property_book' || type == 'property_book_copy' || 
        type == 'property_book_with_files') 
      return Icons.menu_book_rounded;
    if (type == 'موعد' || type == 'appointment') 
      return Icons.calendar_today_rounded;
    if (type == 'رسالة اتصال' || type == 'contact') 
      return Icons.contact_page_rounded;
    
    return Icons.request_page_rounded;
  }
}