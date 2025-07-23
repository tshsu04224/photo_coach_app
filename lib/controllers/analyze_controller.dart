import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:photo_coach/services/analytics_service.dart';
import 'package:logger/logger.dart';

final _logger = Logger();

class AnalyzeController extends ChangeNotifier {
  bool isLoading = false;
  File? analyzedImage;
  String? highlight, suggestion, tip, challenge, ai_score;

  Future<void> analyze(File file) async {
    isLoading = true;
    notifyListeners();

    try {
      analyzedImage = file;

      // 將耗時操作移至 compute 中執行
      final result = await compute(_analyzeInBackground, file.path);

      _logger.i("分析結果：$result");

      if (result['content_analysis'] != null) {
        final data = result['content_analysis'];
        highlight = data['highlight'] ?? '未提供';
        challenge = data['challenge'] ?? '未提供';
        tip = data['tip'] ?? '未提供';
        suggestion = data['suggestion'] ?? '未提供';
        ai_score = data['ai_score'] ?? '0.0';
      } else {
        _logger.w("分析結果格式錯誤：$result");
      }
    } catch (e) {
      _logger.e("分析過程發生錯誤：$e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}

Future<Map<String, dynamic>> _analyzeInBackground(String filePath) async {
  final file = File(filePath);
  final imageBytes = await file.readAsBytes();
  final result = await AnalyzeService.analyzeImageBytes(imageBytes);
  return result;
}
