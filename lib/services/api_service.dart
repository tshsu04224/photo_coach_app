import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/ai_chat_response.dart';

class ApiService {
  static const String _baseUrl = 'http://127.0.0.1:8000';

  static Future<AIChatResponse> chat(String message) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/ai/chat'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'prompt': message}),
    );

    if (response.statusCode == 200) {
      return AIChatResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('AI 回覆失敗：${response.statusCode} ${response.body}');
    }
  }

  static Future<String> generateMoodboard(List<String> keywords) async {
    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/moodboard/generate'),
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

  static Future<List<String>> getVisualKeywords(List<String> subTopics) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/ai/keywords'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'sub_topics': subTopics}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List<String>.from(data['visual_keywords'] ?? []);
    } else {
      throw Exception('無法取得 visual keywords');
    }
  }
}