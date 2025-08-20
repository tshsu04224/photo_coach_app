// feedback_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:photo_coach/models/feedback_model.dart';

class FeedbackService {
  static Future<String> getFeedback(FeedbackInput input) async {
    final url = Uri.parse('http://10.0.2.2:8000/api/generate-feedback');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json; charset=utf-8'},
      body: jsonEncode(input.toJson()),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return json['feedback'] ?? '沒有回饋內容';
    } else {
      // 錯誤是啥
      try {
        final err = jsonDecode(utf8.decode(response.bodyBytes));
        throw Exception('後端回應失敗：${response.statusCode} => $err');
      } catch (_) {
        throw Exception('後端回應失敗：${response.statusCode} => ${response.body}');
      }
    }
  }
}
