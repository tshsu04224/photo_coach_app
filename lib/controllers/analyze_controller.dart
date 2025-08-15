import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:photo_coach/services/analytics_service.dart';
import 'package:photo_coach/utils/tag_icon_mapping.dart';

final _logger = Logger();

class AnalyzeController extends ChangeNotifier {
  bool isLoading = false;
  File? analyzedImage;

  // tech
  List<String> observations = []; // 對應 result['observation']
  Map<String, List<String>> techniquesByCategory = {
    '構圖技巧': [],
    '光線運用': [],
    '拍攝角度': [],
  };
  // 給UI顯示的小圖示標籤（只在availableTags出現的）
  List<String> techniques = [];

  void _updateTechniqueBadges() {
    final merged = <String>[
      ...?techniquesByCategory['構圖技巧'],
      ...?techniquesByCategory['光線運用'],
      ...?techniquesByCategory['拍攝角度'],
    ];
    // 只留下有圖示對應的項目
    final filtered = <String>{};
    for (final t in merged) {
      if (availableTags.containsKey(t)) filtered.add(t);
    }
    techniques = filtered.toList();
    notifyListeners();
  }
  // 外部給清單
  void updateTechniques(List<String> tags) {
    techniques = tags.where((t) => availableTags.containsKey(t)).toSet().toList();
    notifyListeners();
  }
  //
  void refreshBadges() => _updateTechniqueBadges();
  //tech end

  //
  Future<void> analyze(File file) async {
    isLoading = true;
    notifyListeners();

    try {
      analyzedImage = file;

      // 背景執行：把位元組丟進分析服務（請保持你原本的 AnalyzeService）
      final result = await compute(_analyzeInBackground, file.path);
      _logger.i("分析結果：$result");

      // 格式
      final obs = result['observation'];
      final tech = result['techniques'];

      if (obs is List) {
        observations = obs.map((e) => e.toString()).toList();
      } else {
        observations = [];
        _logger.w('observation 欄位缺失或格式不正確');
      }

      if (tech is Map) {
        techniquesByCategory = {
          '構圖技巧': (tech['構圖技巧'] as List?)?.map((e) => e.toString()).toList() ?? [],
          '光線運用': (tech['光線運用'] as List?)?.map((e) => e.toString()).toList() ?? [],
          '拍攝角度': (tech['拍攝角度'] as List?)?.map((e) => e.toString()).toList() ?? [],
        };
      } else {
        techniquesByCategory = {'構圖技巧': [], '光線運用': [], '拍攝角度': []};
        _logger.w('techniques 欄位缺失或格式不正確');
      }

      // 產生 UI 用的小圖示標籤
      _updateTechniqueBadges();
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
