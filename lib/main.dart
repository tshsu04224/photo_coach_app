// 這裡是app的進入點

import 'package:flutter/material.dart';
import 'package:photo_coach/views/analysis_result_page.dart';
import 'package:provider/provider.dart';
import 'controllers/auth_controller.dart';
import 'controllers/task_controller.dart';
import 'controllers/analyze_controller.dart';
import 'controllers/feedback_controller.dart';
import 'app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthController()),
        ChangeNotifierProvider(create: (_) => TaskController()),
        ChangeNotifierProvider(create: (_) => AnalyzeController()),
        ChangeNotifierProvider(create: (_) => FeedbackController()),
      ],
      child: const MaterialApp(
        home: AnalysisResultPage(), // 臨時用這個當首頁
      ),
    ),
  );
}