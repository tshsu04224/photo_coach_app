// 整個app的整體主架構邏輯設計

import 'package:flutter/material.dart';
import 'package:photo_coach/views/chat_page.dart';
import 'package:provider/provider.dart';
import 'views/login_page.dart';
import 'views/home_page.dart';
import 'controllers/auth_controller.dart';
import 'themes/app_theme.dart';
import 'views/chat_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    final auth = Provider.of<AuthController>(context);

    return MaterialApp(
      title: 'PhotoCoach',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      // 根據登入狀態顯示不同畫面
      home: const ChatPage(),
    );
  }
}