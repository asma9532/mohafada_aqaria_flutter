import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../services/api_service.dart';
import '../models/user_model.dart';

class UserProvider extends ChangeNotifier {
  List<UserModel> _users = [];
  bool _isLoading = false;
  String? _error;
  Map<String, int> _stats = {
    'today': 0,
    'week': 0,
    'month': 0,
    'total': 0,
  };

  List<UserModel> get users => _users;
  bool get isLoading => _isLoading;
  String? get error => _error;
  Map<String, int> get stats => _stats;

  Future<void> fetchNewUsers(String filter) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      print('🔄 fetchNewUsers: بدأ التحميل... فلتر: $filter');
      final result = await ApiService.getNewUsers(filter);
      print('🔄 النتيجة: $result');
      
 final data = result['data'] ?? result['users'] ?? result;
if (data is List) {
    _users = (data as List)
        .map((json) => UserModel.fromJson(json))
        .toList();
        
        print('✅ تم تحميل ${_users.length} مستخدم');
        _users.forEach((user) => print('👤 ${user.fullName} - ${user.email}'));
      } else {
        _error = result['message'];
        print('❌ خطأ: $_error');
      }
    } catch (e) {
      _error = e.toString();
      print('🔥 استثناء: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchStats() async {
    try {
      print('📊 fetchStats: بدأ التحميل...');
      final result = await ApiService.getUserStats();
      print('📊 fetchStats: النتيجة = $result');
      
      if (result['success'] == true) {
        _stats = Map<String, int>.from(result['data']);
        print('✅ الإحصائيات: $_stats');
        notifyListeners();
      }
    } catch (e) {
      print('🔥 خطأ في الإحصائيات: $e');
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}