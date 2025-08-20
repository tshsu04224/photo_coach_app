import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import '../models/ai_chat_response.dart';
import '../models/task.dart';

class ApiService {
  static final _logger = Logger();
  static const String _baseUrl = 'http://10.0.2.2:8000';

  static Future<AIChatResponse> chat(String message, {String? type}) async {
    _logger.d('[ApiService.chat] prompt="$message", type="$type"');
    final response = await http.post(
      Uri.parse('$_baseUrl/ai/chat'), 
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'prompt': message,
        if (type != null) 'place_type': type,
      }),
    );

    if (response.statusCode == 200) {
      final decoded = utf8.decode(response.bodyBytes);
      return AIChatResponse.fromJson(jsonDecode(decoded));
    } else {
      throw Exception('AI 回覆失敗：${response.statusCode} ${response.body}');
    }
  }

  static Future<String> generateMoodboard(List<String> keywords) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/moodboard/generate'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'keywords': keywords}),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return json['image_url'];
    } else {
      throw Exception('Moodboard 生成失敗：${response.statusCode} ${response.body}');
    }
  }

  static Future<List<String>> getVisualKeywords(String mainTopic, List<String> subTopics) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/ai/keywords'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "main_topic": mainTopic,
        "sub_topics": subTopics,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List<String>.from(data['visual_keywords'] ?? []);
    } else {
      throw Exception('無法取得 visual keywords');
    }
  }

  static Future<Task> generateTasks(String mainTopic, List<String> subTopics) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/ai/tasks'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "main_topic": mainTopic,
        "sub_topics": subTopics,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      _logger.d('後端返回的完整數據結構:');
      _logger.d(jsonEncode(data)); // 格式化輸出
      
      final List<SubTask> subTasks = (data['subtasks'] as List).map((e) {
        return SubTask(
          id: e['id'],
          content: e['content'] ?? '',
          tag: e['tag'] ?? '',
          icon: Icons.circle, // 根據 tag 替換也可
          suggestedPosition: e['suggested_position'] ?? '',
          lightingCondition: e['lighting_condition'] ?? '',
          shootingTechnique: e['shooting_technique'] ?? '',
          recommendedTime: e['recommended_time'] ?? '',
          isCompleted: e['is_completed'] ?? false,
        );
      }).toList();

      return Task(
        id: data['id'],
        title: mainTopic,
        imageUrl: 'assets/images/example.webp',
        subTasks: subTasks,
        date: DateTime.parse(data['created_at']),
      );
    } else {
      throw Exception('無法產生任務：${response.statusCode} ${response.body}');
    }
  }

  static Future<List<Map<String, dynamic>>> getRecommendedSpots(
      double lat,
      double lng,
      String placeType,
      ) async {
    _logger.d('Calling API with lat=$lat, lon=$lng, type=$placeType');
    final response = await http.get(Uri.parse(
      '$_baseUrl/recommend_spots?lat=$lat&lng=$lng&place_type=$placeType',
    ));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(data['spots']);
    } else {
      return [];
    }
  }
}