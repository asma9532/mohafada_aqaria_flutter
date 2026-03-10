// lib/providers/auth_provider.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoggedIn = false;
  bool _isLoading = false;
  String? _token;
  Map<String, dynamic>? _client;
  String? _lastError;

  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;
  String? get token => _token;
  Map<String, dynamic>? get client => _client;
  String? get lastError => _lastError;
  String get displayName => _client?['full_name'] ?? _client?['name'] ?? 'زائر';
  String get displayEmail => _client?['email'] ?? '';

  AuthProvider() {
    _loadSavedData();
  }

  Future<void> _loadSavedData() async {
    _token = await ApiService.getToken();
    if (_token != null) {
      _isLoggedIn = true;
      await getUserData();
    }
    notifyListeners();
  }

  // ✅ دالة جديدة لجلب التوكن
  Future<String?> getToken() async {
    return await ApiService.getToken();
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _lastError = null;
    notifyListeners();

    try {
      final result = await ApiService.login(email, password);
      
      if (result['success'] == true) {
        _isLoggedIn = true;
        _client = result['client'];
        _token = await ApiService.getToken();
        
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _lastError = result['message'];
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _lastError = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register({
    required String fullName,
    required String email,
    required String password,
    String? phone,
  }) async {
    _isLoading = true;
    _lastError = null;
    notifyListeners();

    try {
      final result = await ApiService.register(
        fullName: fullName,
        email: email,
        password: password,
        phone: phone,
      );
      
      if (result['success'] == true) {
        _isLoggedIn = true;
        _client = result['client'];
        _token = await ApiService.getToken();
        
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _lastError = result['message'];
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _lastError = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      await ApiService.logout();
    } catch (e) {
      print('🔥 خطأ في تسجيل الخروج: $e');
    }

    _isLoggedIn = false;
    _token = null;
    _client = null;
    _lastError = null;
    _isLoading = false;
    notifyListeners();
  }

  Future<void> getUserData() async {
    if (_token == null) return;

    try {
      final result = await ApiService.getClient();
      if (result['success'] == true) {
        _client = result['client'];
        notifyListeners();
      }
    } catch (e) {
      print('🔥 خطأ في تحميل بيانات المستخدم: $e');
    }
  }

  void clearError() {
    _lastError = null;
    notifyListeners();
  }
}