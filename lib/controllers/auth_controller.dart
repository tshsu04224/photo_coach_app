import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_service.dart';
import '../models/user.dart';

class AuthController extends ChangeNotifier {
  final AuthService authService;

  AuthController({required this.authService});

  bool isLoading = false;
  String? token;
  String? error;
  User? currentUser; 

  bool get isLoggedIn => token != null && currentUser != null;

  // 登入並取得使用者資訊
  Future<bool> login(String email, String password) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final result = await authService.login(email, password);
      if (result != null) {
        token = result;
        await _saveToken(result);

        currentUser = await authService.getMe(result); // 從 token 拿到 user 資訊
        return currentUser != null;
      } else {
        error = '登入失敗，帳密錯誤';
        return false;
      }
    } catch (e) {
      error = '登入錯誤：$e';
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // 註冊後自動登入 + 取得使用者資訊
  Future<bool> register(String username, String email, String password) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final result = await authService.register(username, email, password);
      if (result != null) {
        token = result;
        await _saveToken(result);

        currentUser = await authService.getMe(result);
        return currentUser != null;
      } else {
        error = '註冊失敗，帳號可能已存在';
        return false;
      }
    } catch (e) {
      error = '註冊錯誤：$e';
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // 自動登入（啟動 App 時）
  Future<void> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final storedToken = prefs.getString('access_token');
    if (storedToken != null) {
      token = storedToken;
      currentUser = await authService.getMe(storedToken);
      notifyListeners();
    }
  }

  Future<void> logout() async {
    token = null;
    currentUser = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    notifyListeners();
  }

  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', token);
  }
}
