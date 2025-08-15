// 所有的provider都統一在這裡管理

import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import '../controllers/auth_controller.dart';
import '../controllers/analyze_controller.dart';
import 'package:photo_coach/controllers/feedback_controller.dart';
import 'package:flutter/material.dart';

final List<SingleChildWidget> appProviders = [
  ChangeNotifierProvider<AuthController>(create: (_) => AuthController()),
  ChangeNotifierProvider<AnalyzeController>(create: (_) => AnalyzeController()),
  ChangeNotifierProvider(create: (_) => FeedbackController()),
];
