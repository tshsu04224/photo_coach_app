import 'dart:io';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import '../services/analytics_service.dart';

class AnalyzeController extends ChangeNotifier {
  final Logger _logger = Logger();
  bool isLoading = false;
  File? analyzedImage;
  String? highlight, suggestion, tip, challenge;

  Future<void> analyze(File file) async {
    isLoading = true;
    notifyListeners();

    try {
      analyzedImage = file;
      // 直接讀取圖片的 bytes
      final imageBytes = await file.readAsBytes();

      // 分析圖片
      final result = await AnalyzeService.analyzeImageBytes(imageBytes);
      _logger.i("分析結果：$result");
      if (result['status'] == 'success') {
        final data = result['data'];
        highlight = data['highlight'];
        challenge = data['challenge'];
        tip = data['tip'];
        suggestion = data['suggestion'];
      } else {
        _logger.w("分析失敗：${result['message']}");
      }
    } catch (e) {
      _logger.e("錯誤：$e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
