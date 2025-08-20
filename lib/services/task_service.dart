import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/task.dart';

class TaskService {
  final String baseUrl;
  final String? token;

  TaskService({required this.baseUrl, required this.token});

  /// 建立基本 headers
  Map<String, String> _headers() {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  /// 取得所有任務
  Future<List<Task>> fetchAllTasks() async {
    final res = await http.get(
      Uri.parse('$baseUrl/tasks'),
      headers: _headers(),
    );
    _checkResponse(res);

    final List<dynamic> data = jsonDecode(utf8.decode(res.bodyBytes));
    return data.map((e) => Task.fromJson(e)).toList();
  }

  /// 取得指定日期任務（YYYY-MM-DD）
  Future<List<Task>> fetchTasksByDate(String date) async {
    final response = await http.get(
      Uri.parse('$baseUrl/tasks?date=$date'),
      headers: _headers(),
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Task.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load tasks');
    }
  }

  /// 新增任務
  Future<Task> createTask(String mainTopic, List<String> subTopics) async {
    final res = await http.post(
      Uri.parse('$baseUrl/tasks'),
      headers: _headers(),
      body: jsonEncode({
        'main_topic': mainTopic,
        'sub_topics': subTopics,
      }),
    );
    _checkResponse(res);
    return Task.fromJson(jsonDecode(utf8.decode(res.bodyBytes)));
  }

  /// 刪除任務
  Future<bool> deleteTask(int taskId) async {
    final res = await http.delete(
      Uri.parse('$baseUrl/tasks/$taskId'),
      headers: _headers(),
    );
    if (res.statusCode == 200 || res.statusCode == 204) {
      return true;
    }
    return false;
  }

  void _checkResponse(http.Response res) {
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception("HTTP ${res.statusCode}: ${res.body}");
    }
  }
}
