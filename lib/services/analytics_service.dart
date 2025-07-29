// 學習紀錄、統計資料
import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

class AnalyzeService {
  static Future<Map<String, dynamic>> analyzeImageBytes(
    Uint8List imageBytes,
  ) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse("http://10.0.2.2:8000/analyze/feedback"),
    );
    request.files.add(
      http.MultipartFile.fromBytes('file', imageBytes, filename: 'image.jpg'),
    );
    final response = await request.send();

    final body = await response.stream.bytesToString();
    return json.decode(body);
  }
}
