// 控制登入狀態的邏輯

import 'package:flutter/material.dart';

class AuthController extends ChangeNotifier {
  bool _isLoggedIn = false; // 初始設定為未登入
  bool get isLoggedIn => _isLoggedIn;

  // 模擬登入
  void login() {
    _isLoggedIn = true;
    notifyListeners(); // 畫面更新
  }

  void logout() {
    _isLoggedIn = false;
    notifyListeners();
  }
}