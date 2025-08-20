// 所有的provider都統一在這裡管理

import 'package:photo_coach/services/analyze_service.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import '../controllers/auth_controller.dart';
import 'package:photo_coach/controllers/feedback_controller.dart';
import '../controllers/analyze_controller.dart';
import '../controllers/task_controller.dart';
import '../controllers/chat_controller.dart';
import '../services/task_service.dart';
import '../services/auth_service.dart';
import 'package:flutter/material.dart';

const String _baseUrl = 'http://10.0.2.2:8000';

final List<SingleChildWidget> appProviders = [
  ChangeNotifierProvider(create: (_) => FeedbackController()),
  // 1. 提供 AuthController（有 token）
  ChangeNotifierProvider<AuthController>(
    create: (_) => AuthController(authService: AuthService(baseUrl: _baseUrl)),
  ),

  // 2. 使用 ProxyProvider 把 AuthController 的 token 傳給 AnalyzeService，再傳給 AnalyzeController
  ChangeNotifierProxyProvider<AuthController, AnalyzeController>(
    create: (_) => AnalyzeController(
      analyzeService: AnalyzeService(baseUrl: _baseUrl, token: '')
    ),
    update: (_, auth, previous) => AnalyzeController(
      analyzeService: AnalyzeService(baseUrl: _baseUrl, token: auth.token ?? ''),
    ),
  ),

  // 3. 使用 ProxyProvider 把 AuthController 的 token 傳給 TaskService，再傳給 TaskController
  ChangeNotifierProxyProvider<AuthController, TaskController>(
    create: (_) => TaskController(
      taskService: TaskService(baseUrl: _baseUrl, token: ''),
    ),
    update: (_, auth, previous) => TaskController(
      taskService: TaskService(baseUrl: _baseUrl, token: auth.token ?? ''),
    ),
  ),

  ChangeNotifierProxyProvider<AuthController, ChatController>(
    create: (_) => ChatController(
      taskService: TaskService(baseUrl: _baseUrl, token: ''),
    ),
    update: (_, auth, previous) => ChatController(
      initialPrompt: previous?.initialPrompt,
      placeType: previous?.placeType,
      taskService: TaskService(baseUrl: _baseUrl, token: auth.token ?? ''),
    ),
  ),
];
