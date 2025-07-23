// 整個app的整體主架構邏輯設計
import 'package:flutter/material.dart';
import 'package:photo_coach/views/main_page.dart';
import 'package:provider/provider.dart';
import 'controllers/auth_controller.dart';
import 'routes/routes.dart'; // Make sure this file exports a 'Routes' class or object with the required route names
import 'state_management/providers.dart';
import 'views/home_page.dart';
import 'views/auth/auth_selection_screen.dart';
import 'views/auth/login_page.dart';
import 'views/auth/register_page.dart';
import 'views/auth/register_preference_page.dart';
import 'package:photo_coach/views/chat_page.dart';
import 'themes/app_theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: appProviders,
      child: Consumer<AuthController>(
        builder: (context, auth, _) {
          return MaterialApp(
            title: 'PhotoCoach',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
            initialRoute: auth.isLoggedIn ? Routes.home : Routes.authSelection,
            routes: {
              Routes.authSelection: (_) => const AuthSelectionScreen(),
              Routes.login: (_) => const LoginPage(),
              Routes.register: (_) => const RegisterPage(),
              Routes.registerPreferences: (_) => const RegisterPreferencePage(),
              Routes.home: (_) => const MainPage(),
              Routes.chat: (_) => const ChatPage(),
            },
          );
        },
      ),
    );
  }
}
