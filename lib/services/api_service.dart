import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/ai_chat_response.dart';
import '../models/task_model.dart';

class ApiService {
  static const String _baseUrl = 'http://127.0.0.1:8000';

  static Future<AIChatResponse> chat(String message) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/ai/chat'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'prompt': message}),
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

      final List<SubTask> subTasks = (data['tasks'] as List).map((e) {
        return SubTask(
          content: e['task']?.toString() ?? '',
          tag: e['tag']?.toString() ?? '',
          icon: Icons.circle, // 或之後根據 tag 判斷 icon
          suggestedPosition: e['suggested_position']?.toString() ?? '',
          lightingCondition: e['lighting_condition']?.toString() ?? '',
          shootingTechnique: e['shooting_technique']?.toString() ?? '',
          recommendedTime: e['recommended_time']?.toString() ?? '',
        );
      }).toList();

      return Task(
        title: mainTopic,
        imageUrl: 'assets/images/example.webp', // 可根據主題生成對應圖
        subTasks: subTasks,
      );
    } else {
      throw Exception('無法產生任務：${response.statusCode} ${response.body}');
    }
  }

}