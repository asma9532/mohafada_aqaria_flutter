class UserModel {
  final int id;
  final String fullName;
  final String email;
  final String? phone;
  final DateTime createdAt;
  final String status;
  final int requestsCount;

  UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    this.phone,
    required this.createdAt,
    required this.status,
    this.requestsCount = 0,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      fullName: json['full_name'] ?? 'مستخدم',
      email: json['email'] ?? '',
      phone: json['phone'],
      createdAt: DateTime.parse(json['created_at']),
      status: json['status'] ?? 'active',
      requestsCount: json['requestsCount'] ?? 0,
    );
  }

  // ==================== دعم اللغات للتاريخ ====================
  
  String getLocalizedDate(String languageCode) {
    final now = DateTime.now();
    final difference = now.difference(createdAt);
    
    if (difference.inDays == 0) {
      switch (languageCode) {
        case 'ar': return 'اليوم';
        case 'en': return 'Today';
        case 'fr': return "Aujourd'hui";
        default: return 'اليوم';
      }
    }
    if (difference.inDays == 1) {
      switch (languageCode) {
        case 'ar': return 'أمس';
        case 'en': return 'Yesterday';
        case 'fr': return 'Hier';
        default: return 'أمس';
      }
    }
    if (difference.inDays < 7) {
      switch (languageCode) {
        case 'ar': return 'منذ ${difference.inDays} أيام';
        case 'en': return '${difference.inDays} days ago';
        case 'fr': return 'il y a ${difference.inDays} jours';
        default: return 'منذ ${difference.inDays} أيام';
      }
    }
    
    // تاريخ كامل
    switch (languageCode) {
      case 'ar': return '${createdAt.day}/${createdAt.month}/${createdAt.year}';
      case 'en': return '${createdAt.year}-${createdAt.month.toString().padLeft(2, '0')}-${createdAt.day.toString().padLeft(2, '0')}';
      case 'fr': return '${createdAt.day}/${createdAt.month}/${createdAt.year}';
      default: return '${createdAt.day}/${createdAt.month}/${createdAt.year}';
    }
  }

  // ==================== حالة المستخدم باللغات ====================
  
  String getLocalizedStatus(String languageCode) {
    if (status == 'active') {
      switch (languageCode) {
        case 'ar': return 'نشط';
        case 'en': return 'Active';
        case 'fr': return 'Actif';
        default: return 'نشط';
      }
    } else {
      switch (languageCode) {
        case 'ar': return 'غير نشط';
        case 'en': return 'Inactive';
        case 'fr': return 'Inactif';
        default: return 'غير نشط';
      }
    }
  }

  // ✅ الاحتفاظ بالدوال القديمة للتوافق
  String get formattedDate {
    return getLocalizedDate('ar');
  }

  bool get isActive => status == 'active';
}