// 整個app的整體主架構邏輯設計

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'views/login_page.dart';
import 'views/home_page.dart';
import 'controllers/auth_controller.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    final auth = Provider.of<AuthController>(context);

    return MaterialApp(
      title: 'PhotoCoach',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // 根據登入狀態顯示不同畫面
      home: auth.isLoggedIn ? const HomePage() : const LoginPage(),
    );
  }
}