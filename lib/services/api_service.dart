// lib/services/api_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  // 🔴 استخدم عنوان IP الخاص بك
static const String baseUrl = 'https://mohafadaaqaria-production-9f70.up.railway.app/api';

  // Endpoints
  static const String loginEndpoint = '$baseUrl/login';
  static const String registerEndpoint = '$baseUrl/register';
  static const String logoutEndpoint = '$baseUrl/logout';
  static const String clientEndpoint = '$baseUrl/user';

  // ✅ دالة جديدة لجلب CSRF Cookie (الحل السحري)
  static Future<bool> fetchCsrfCookie() async {
    try {
      print('🔄 جلب CSRF Cookie...');
      final response = await http.get(
        Uri.parse('$baseUrl/sanctum/csrf-cookie'),
        headers: {'Accept': 'application/json'},
      );
      print('✅ CSRF Cookie تم جلبه (${response.statusCode})');
      return response.statusCode == 204; // 204 يعني نجاح بدون محتوى
    } catch (e) {
      print('❌ خطأ في جلب CSRF Cookie: $e');
      return false;
    }
  }

  // حفظ التوكن
  static Future<void> saveToken(String token) async {
    print('💾 حفظ التوكين: $token');
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
    
    // نتحققو من الحفظ
    final saved = await getToken();
    print('✅ التوكين بعد الحفظ: ${saved != null ? 'موجود' : 'غير موجود'}');
  }

  // جلب التوكن
  static Future<String?> getToken() async {
    print('🔍 جلب التوكين من SharedPreferences...');
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    print('🔑 التوكين: ${token != null ? 'موجود' : 'غير موجود'}');
    if (token != null) {
      print('📝 قيمة التوكين: $token');
    }
    return token;
  }

  // حذف التوكن
  static Future<void> removeToken() async {
    print('🗑️ حذف التوكين');
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    
    // نتحققو من الحذف
    final afterDelete = await getToken();
    print('✅ بعد الحذف: ${afterDelete == null ? 'محذوف' : 'مازال كاين'}');
  }

  // ✅ للطلبات العامة (لا تحتاج توكن)
  static Future<Map<String, String>> _getPublicHeaders() async {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
  }

  // ✅ للطلبات المحمية (تحتاج توكن)
  static Future<Map<String, String>> _getAuthHeaders() async {
    final token = await getToken();
    print('🔑 _getAuthHeaders - التوكن: ${token != null ? 'موجود' : 'غير موجود'}');
    
    if (token == null) {
      print('⚠️ تنبيه: محاولة استخدام AuthHeaders بدون توكن');
      return {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };
    }
    
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  // ✅ دالة مساعدة لمعالجة الاستجابات
  static Future<Map<String, dynamic>> _handleResponse(http.Response response) async {
    try {
      print('📨 حالة الاستجابة: ${response.statusCode}');
      print('📨 المحتوى: ${response.body}');

      // التحقق من أن الاستجابة JSON وليست HTML
      if (response.body.trim().startsWith('<!doctype') || 
          response.body.trim().startsWith('<html')) {
        return {
          'success': false, 
          'message': 'السيرفر أعاد صفحة HTML بدلاً من JSON. تأكد من:'
              '\n1. أن السيرفر شغال (php artisan serve)'
              '\n2. أن الرابط صحيح: $baseUrl'
              '\n3. أن الـ route معرف في api.php'
        };
      }

      final data = jsonDecode(response.body);
      
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return {'success': true, ...data};
      } else {
        String errorMessage = data['message'] ?? 'حدث خطأ';
        
        // معالجة أخطاء التحقق (Validation Errors)
        if (data['errors'] != null && data['errors'] is Map) {
          final errors = data['errors'] as Map;
          if (errors.isNotEmpty) {
            final firstError = errors.values.first;
            if (firstError is List && firstError.isNotEmpty) {
              errorMessage = firstError[0];
            }
          }
        }
        
        return {'success': false, 'message': errorMessage};
      }
    } catch (e) {
      print('🔥 خطأ في تحليل JSON: $e');
      return {
        'success': false, 
        'message': 'خطأ في الاتصال بالخادم: $e'
      };
    }
  }

  // ========== AUTHENTICATION ==========

  static Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      print('🔄 محاولة تسجيل الدخول...');
      print('📤 البريد: $email');
      
      // ✅ الأهم: جلب CSRF Cookie أولاً
      await fetchCsrfCookie();
      
      final response = await http.post(
        Uri.parse(loginEndpoint),
        headers: await _getPublicHeaders(),
        body: jsonEncode({'email': email, 'password': password}),
      );

      final result = await _handleResponse(response);
      
      if (result['success'] == true) {
        if (result['token'] != null) {
          await saveToken(result['token']);
        }
        return result;
      } else {
        return result;
      }
    } catch (e) {
      print('🔥 خطأ في الاتصال: $e');
      return {'success': false, 'message': 'حدث خطأ في الاتصال بالخادم: $e'};
    }
  }

  static Future<Map<String, dynamic>> register({
    required String fullName,
    required String email,
    required String password,
    String? phone,
  }) async {
    try {
      print('🔄 محاولة إنشاء حساب...');
      print('📤 البيانات: fullName=$fullName, email=$email, phone=$phone');
      
      // ✅ جلب CSRF Cookie أولاً
      await fetchCsrfCookie();
      
      final response = await http.post(
        Uri.parse(registerEndpoint),
        headers: await _getPublicHeaders(),
        body: jsonEncode({
          'full_name': fullName,
          'email': email,
          'password': password,
          'password_confirmation': password,
          'phone': phone,
        }),
      );

      final result = await _handleResponse(response);
      
      if (result['success'] == true && result['token'] != null) {
        await saveToken(result['token']);
      }
      
      return result;
    } catch (e) {
      print('🔥 خطأ في الاتصال: $e');
      return {'success': false, 'message': 'حدث خطأ في الاتصال بالخادم: $e'};
    }
  }

  static Future<void> logout() async {
    try {
      final token = await getToken();
      if (token != null) {
        await http.post(
          Uri.parse(logoutEndpoint),
          headers: await _getAuthHeaders(),
        );
      }
    } catch (e) {
      print('🔥 خطأ في تسجيل الخروج: $e');
    } finally {
      await removeToken();
    }
  }

  static Future<Map<String, dynamic>> getClient() async {
    try {
      final response = await http.get(
        Uri.parse(clientEndpoint),
        headers: await _getAuthHeaders(),
      );

      return await _handleResponse(response);
    } catch (e) {
      print('🔥 خطأ: $e');
      return {'success': false, 'message': e.toString()};
    }
  }

  // ========== ADMIN ==========

  // ✅ دالة تسجيل دخول الأدمن مع CSRF
  static Future<Map<String, dynamic>> adminLogin(String email, String password) async {
    try {
      print('🔄 محاولة تسجيل دخول الأدمن...');
      print('📤 البريد: $email');
      
      // ✅ جلب CSRF Cookie أولاً
      await fetchCsrfCookie();
      
      final response = await http.post(
        Uri.parse('$baseUrl/admin/login'),
        headers: await _getPublicHeaders(),
        body: jsonEncode({'email': email, 'password': password}),
      );

      final result = await _handleResponse(response);
      
      if (result['success'] == true) {
        if (result['token'] != null) {
          await saveToken(result['token']);
        }
        return result;
      } else {
        return result;
      }
    } catch (e) {
      print('🔥 خطأ في الاتصال: $e');
      return {'success': false, 'message': 'حدث خطأ في الاتصال بالخادم: $e'};
    }
  }

  // ========== USERS (المستخدمين) ==========

  static Future<Map<String, dynamic>> getNewUsers(String filter) async {
    try {
      final token = await getToken();
      
      final response = await http.get(
        Uri.parse('$baseUrl/users/new?filter=$filter'),
        headers: await _getAuthHeaders(),
      );

      print('📨 getNewUsers Status: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        // ✅ البيانات ترجع مباشرة كـ array أو كـ {success, data}
        if (data is List) {
          return {'success': true, 'data': data};
        } else if (data['data'] != null) {
          return {'success': true, 'data': data['data']}; // ← مش data['data']['data']
        } else {
          return {'success': true, 'data': []};
        }
      } else {
        return {'success': false, 'message': 'خطأ: ${response.statusCode}'};
      }
    } catch (e) {
      print('🔥 خطأ في getNewUsers: $e');
      return {'success': false, 'message': e.toString()};
    }
  }

  static Future<Map<String, dynamic>> getUserStats() async {
    try {
      print('🔄 جلب إحصائيات المستخدمين...');
      
      final token = await getToken();
      print('🔑 التوكن في getUserStats: ${token != null ? 'موجود' : 'غير موجود'}');
      
      final response = await http.get(
        Uri.parse('$baseUrl/users/stats'),
        headers: await _getAuthHeaders(),
      );

      print('📨 getUserStats Status: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {'success': true, 'data': data};
      } else {
        return {'success': false, 'message': 'خطأ في تحميل الإحصائيات: ${response.statusCode}'};
      }
    } catch (e) {
      print('🔥 خطأ في getUserStats: $e');
      return {'success': false, 'message': e.toString()};
    }
  }
  
  // ========== NEGATIVE CERTIFICATE ==========
  static Future<Map<String, dynamic>> submitNegativeCertificate(Map<String, dynamic> data) async {
    try {
      print('🔄 إرسال طلب شهادة سلبية...');
      
      final token = await getToken();
      print('🔑 التوكن: $token');
      
      final response = await http.post(
        Uri.parse('$baseUrl/negative-certificate'),
        headers: await _getAuthHeaders(),
        body: jsonEncode(data),
      );

      return await _handleResponse(response);
    } catch (e) {
      print('🔥 خطأ: $e');
      return {'success': false, 'message': e.toString()};
    }
  }
  
  // ========== REAL ESTATE CARD REQUESTS ==========

  static Future<Map<String, dynamic>> submitRealEstateCardRequest(Map<String, dynamic> data) async {
    try {
      print('🔄 إرسال طلب بطاقة عقارية...');
      
      final token = await getToken();
      print('🔑 التوكن: $token');
      
      final response = await http.post(
        Uri.parse('$baseUrl/documents-request'),
        headers: await _getAuthHeaders(),
        body: jsonEncode(data),
      );

      return await _handleResponse(response);
    } catch (e) {
      print('🔥 خطأ: $e');
      return {'success': false, 'message': e.toString()};
    }
  }

  static Future<Map<String, dynamic>> getRealEstateCardRequests() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/documents-requests'),
        headers: await _getAuthHeaders(),
      );

      return await _handleResponse(response);
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }
  
  // ========== CONTRACT EXTRACTS (مستخرجات العقود) ==========

  static Future<Map<String, dynamic>> submitContractExtract(Map<String, dynamic> data) async {
    try {
      print('🔄 إرسال طلب مستخرج عقد...');
      print('📤 البيانات: $data');
      
      final token = await getToken();
      
      final response = await http.post(
        Uri.parse('$baseUrl/contract-extract'),
        headers: await _getAuthHeaders(),
        body: jsonEncode(data),
      );

      return await _handleResponse(response);
    } catch (e) {
      print('🔥 خطأ في الاتصال: $e');
      return {'success': false, 'message': 'حدث خطأ في الاتصال بالخادم: $e'};
    }
  }

  static Future<Map<String, dynamic>> getContractExtracts() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/contract-extracts'),
        headers: await _getAuthHeaders(),
      );

      return await _handleResponse(response);
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }
  
  // ========== PROPERTY BOOK (الدفتر العقاري) ==========

  static Future<Map<String, dynamic>> submitPropertyBookRequest(Map<String, dynamic> data) async {
    try {
      print('🔄 إرسال طلب إنشاء دفتر عقاري...');
      print('📤 البيانات: $data');
      
      final token = await getToken();
      
      final response = await http.post(
        Uri.parse('$baseUrl/property-book'),
        headers: await _getAuthHeaders(),
        body: jsonEncode(data),
      );

      return await _handleResponse(response);
    } catch (e) {
      print('🔥 خطأ في الاتصال: $e');
      return {'success': false, 'message': 'حدث خطأ في الاتصال بالخادم: $e'};
    }
  }

  static Future<Map<String, dynamic>> submitPropertyBookCopyRequest(Map<String, dynamic> data) async {
    try {
      print('🔄 إرسال طلب نسخة دفتر عقاري...');
      print('📤 البيانات: $data');
      
      final token = await getToken();
      
      final response = await http.post(
        Uri.parse('$baseUrl/property-book-copy'),
        headers: await _getAuthHeaders(),
        body: jsonEncode(data),
      );

      return await _handleResponse(response);
    } catch (e) {
      print('🔥 خطأ في الاتصال: $e');
      return {'success': false, 'message': 'حدث خطأ في الاتصال بالخادم: $e'};
    }
  }

  static Future<Map<String, dynamic>> getPropertyBooks() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/property-books'),
        headers: await _getAuthHeaders(),
      );

      return await _handleResponse(response);
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // ========== PROPERTY BOOK WITH FILES ==========

  static Future<Map<String, dynamic>> submitPropertyBookWithFiles(
    Map<String, dynamic> data,
    List<Map<String, dynamic>> files,
  ) async {
    try {
      print('🔄 إرسال طلب إنشاء دفتر عقاري مع ملفات...');
      
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/property-book-with-files'),
      );

      final token = await getToken();
      request.headers.addAll({
        'Accept': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      });

      // إضافة الحقول النصية
      data.forEach((key, value) {
        if (value != null) {
          request.fields[key] = value.toString();
        }
      });

      // إضافة الملفات
      for (var i = 0; i < files.length; i++) {
        final file = files[i];
        final bytes = file['bytes'] as List<int>;
        final name = file['name'] as String;
        
        var multipartFile = http.MultipartFile.fromBytes(
          'documents[$i]',
          bytes,
          filename: name,
        );
        request.files.add(multipartFile);
      }

      print('📤 إرسال طلب مع ${files.length} ملفات');

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      return await _handleResponse(response);
    } catch (e) {
      print('🔥 خطأ في الاتصال: $e');
      return {'success': false, 'message': 'حدث خطأ في الاتصال بالخادم: $e'};
    }
  }

  // ========== APPOINTMENT (حجز المواعيد) ==========

  static Future<Map<String, dynamic>> submitAppointment(Map<String, dynamic> data) async {
    try {
      print('🔄 إرسال طلب حجز موعد...');
      print('📤 البيانات: $data');
      
      final token = await getToken();
      
      final response = await http.post(
        Uri.parse('$baseUrl/appointment'),
        headers: await _getAuthHeaders(),
        body: jsonEncode(data),
      );

      return await _handleResponse(response);
    } catch (e) {
      print('🔥 خطأ في الاتصال: $e');
      return {'success': false, 'message': 'حدث خطأ في الاتصال بالخادم: $e'};
    }
  }

  // ========== CONTACT (اتصل بنا) ==========

  static Future<Map<String, dynamic>> submitContact(Map<String, dynamic> data) async {
    try {
      print('🔄 إرسال رسالة اتصال...');
      print('📤 البيانات: $data');
      
      final token = await getToken();
      
      final response = await http.post(
        Uri.parse('$baseUrl/contact'),
        headers: await _getAuthHeaders(),
        body: jsonEncode(data),
      );

      return await _handleResponse(response);
    } catch (e) {
      print('🔥 خطأ في الاتصال: $e');
      return {'success': false, 'message': 'حدث خطأ في الاتصال بالخادم: $e'};
    }
  }

  static Future<Map<String, dynamic>> getContacts() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/contacts'),
        headers: await _getAuthHeaders(),
      );

      return await _handleResponse(response);
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  static Future<Map<String, dynamic>> getContact(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/contact/$id'),
        headers: await _getAuthHeaders(),
      );

      return await _handleResponse(response);
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  static Future<Map<String, dynamic>> updateContactStatus(int id, String status) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/contact/$id/status'),
        headers: await _getAuthHeaders(),
        body: jsonEncode({'status': status}),
      );

      return await _handleResponse(response);
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  static Future<Map<String, dynamic>> deleteContact(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/contact/$id'),
        headers: await _getAuthHeaders(),
      );

      return await _handleResponse(response);
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  static Future<Map<String, dynamic>> searchContacts(Map<String, dynamic> searchParams) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/contact/search'),
        headers: await _getAuthHeaders(),
        body: jsonEncode(searchParams),
      );

      return await _handleResponse(response);
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  static Future<Map<String, dynamic>> getContactStatistics() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/contact-statistics'),
        headers: await _getAuthHeaders(),
      );

      return await _handleResponse(response);
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }
}