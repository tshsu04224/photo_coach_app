// 學習紀錄、統計資料
import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

class AnalyzeService {
  final String baseUrl;
  final String? token;

  AnalyzeService({required this.baseUrl, required this.token});

  Future<Map<String, dynamic>> analyzeImageBytes(
    Uint8List imageBytes,
    int subtaskId,
  ) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse("http://10.0.2.2:8000/analyze/feedback"),
    );
    request.headers['Authorization'] = 'Bearer $token';
    request.headers['Accept'] = 'application/json';
    request.files.add(
      http.MultipartFile.fromBytes('file', imageBytes, filename: 'image.jpg'),
    );
    request.fields['subtask_id'] = subtaskId.toString();

    final response = await request.send();

    final body = await response.stream.bytesToString();

    if (response.statusCode != 200) {
      throw Exception('分析失敗：${response.statusCode} $body');
    }
    return json.decode(body);
  }
}
