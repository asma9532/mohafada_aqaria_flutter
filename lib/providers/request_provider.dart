// lib/providers/request_provider.dart

import 'dart:convert';
import 'package:flutter/material.dart';  // 👈 هذا مهم لـ Provider.of
import 'package:http/http.dart' as http;
import '../services/api_service.dart';
import '../models/request_model.dart';
import 'admin_provider.dart'; // 👈 هذا كاين
import 'package:provider/provider.dart';  // 👈 هذا هو المهم !!

class RequestProvider extends ChangeNotifier {
  List<RequestModel> _requests = [];
  bool _isLoading = false;
  String? _error;

  List<RequestModel> get requests => _requests;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // ✅ دالة جديدة بدون Context (للاختبار)
  Future<void> fetchUserRequestsDirect(int userId, String token) async {
    print('=' * 50);
    print('🚀 بدء تحميل طلبات المستخدم (مباشر): $userId');
    print('=' * 50);
    
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final url = '${ApiService.baseUrl}/users/$userId/requests';
      
      print('📡 URL: $url');
      
      final headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };
      
      print('📨 Headers: $headers');
      
      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );

      print('📨 Status Code: ${response.statusCode}');
      print('📨 Body: ${response.body}');
      
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        _requests = data.map((json) => RequestModel.fromJson(json)).toList();
        print('✅ تم تحميل ${_requests.length} طلب');
      } else {
        _error = 'خطأ في تحميل الطلبات (${response.statusCode})';
        print('❌ $_error');
      }
    } catch (e) {
      _error = e.toString();
      print('🔥 خطأ: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
      print('=' * 50);
    }
  }

  // ✅ الدالة القديمة مع Context (نخليها مؤقتاً)
  Future<void> fetchUserRequests(int userId, BuildContext context) async {
    print('=' * 50);
    print('🚀 بدء تحميل طلبات المستخدم: $userId');
    print('=' * 50);
    
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // ✅ نجيب التوكن من AdminProvider
      final adminProvider = Provider.of<AdminProvider>(context, listen: false);
      final token = adminProvider.adminToken;
      
      print('🔑 Admin Token موجود: ${token != null}');
      
      if (token == null) {
        print('❌ ماكاينش توكن الأدمن');
        _error = 'يرجى تسجيل الدخول أولاً';
        _isLoading = false;
        notifyListeners();
        return;
      }
      
      await fetchUserRequestsDirect(userId, token); // 👈 نستعمل الدالة الجديدة
      
    } catch (e) {
      _error = e.toString();
      print('🔥 خطأ: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
      print('=' * 50);
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}