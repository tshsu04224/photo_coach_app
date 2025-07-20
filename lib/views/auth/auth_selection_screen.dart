// 這個頁面是用來讓使用者選擇登入或註冊的
import 'package:flutter/material.dart';
import 'package:photo_coach/routes/routes.dart';

class AuthSelectionScreen extends StatelessWidget {
  const AuthSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 背景圖
          Image.asset(
            'assets/images/auth_background.png',
            fit: BoxFit.cover,
          ),

          Column(
            children: [
              const SizedBox(height: 100),

              // Logo
              Image.asset(
                'assets/images/logo_with_title.png',
                width: 130,
                height: 130,
              ),

              const Spacer(),

              // 登入
              SizedBox(
                width: 180,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, Routes.login);
                  },
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white, width: 1.5),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "登入",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // 註冊
              SizedBox(
                width: 180,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, Routes.register);
                  },
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white, width: 1.5),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "註冊",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 80),
            ],
          ),
        ],
      ),
    );
  }
}
