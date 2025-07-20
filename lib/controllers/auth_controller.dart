// 控制登入狀態的邏輯

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AuthController extends ChangeNotifier {
  bool _isLoggedIn = false; // 不想每次重開都要登入的話，先把這裡改成 true
  bool get isLoggedIn => _isLoggedIn;

  String? _userEmail;
  String? get userEmail => _userEmail;

  // 模擬登入驗證
  Future<bool> login(String email, String password) async {
    // 模擬延遲與登入成功
    await Future.delayed(const Duration(seconds: 1));

    if (email == 'test@gmail.com' && password == '87654321') {  // 假設這是正確的帳號密碼(待修改)
      _isLoggedIn = true;
      _userEmail = email;
      notifyListeners();
      return true;
    } else {
      return false;
    }
  }

  void logout() {
    _isLoggedIn = false;
    _userEmail = null;
    notifyListeners();
  }
}
