import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';

class CaptureSheet extends StatelessWidget {
  const CaptureSheet({super.key});

  Future<void> _pickImage(BuildContext context, ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      final image = File(pickedFile.path);

      Navigator.pop(context); // 關閉 bottom sheet

      // 跳轉到預覽頁或儲存頁
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ImagePreviewPage(imageFile: image),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Wrap(
        children: [
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text('拍照'),
            onTap: () => _pickImage(context, ImageSource.camera),
          ),
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: const Text('從相簿選擇'),
            onTap: () => _pickImage(context, ImageSource.gallery),
          ),
        ],
      ),
    );
  }
}

class ImagePreviewPage extends StatefulWidget {
  final File imageFile;

  const ImagePreviewPage({super.key, required this.imageFile});

  @override
  State<ImagePreviewPage> createState() => _ImagePreviewPageState();
  
}

class _ImagePreviewPageState extends State<ImagePreviewPage> {
  bool _isUploading = false;
  final int userId = 123; // 替換 userId
  final String topic = "建築"; // 替換真實主題
  final String uploadUrl = "http://172.20.10.5:8000/api/photo/upload"; // 替換實際網址

  Future<void> _uploadImage() async {
    setState(() {
      _isUploading = true;
    });

    final request = http.MultipartRequest('POST', Uri.parse(uploadUrl))
      ..fields['user_id'] = userId.toString()
      ..fields['topic'] = topic
      ..files.add(
        await http.MultipartFile.fromPath(
          'file',
          widget.imageFile.path,
          contentType: MediaType.parse(lookupMimeType(widget.imageFile.path) ?? 'image/jpeg'),
        ),
      );

    final response = await request.send();
    final responseBody = await response.stream.bytesToString();

    setState(() {
      _isUploading = false;
    });

    if (response.statusCode == 200) {
      print('上傳成功: $responseBody');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('照片儲存成功')));
        Navigator.pop(context); // 回上一頁
      }
    } else {
      print('上傳失敗: $responseBody');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('上傳失敗')));
      }
    }
  }

    @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("預覽照片")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.file(widget.imageFile),
          const SizedBox(height: 24),
          _isUploading
          ? const CircularProgressIndicator()
          : ElevatedButton.icon(
              onPressed: _uploadImage,
              icon: const Icon(Icons.save),
              label: const Text("儲存"),
            ),
          ],
        ),
      );
    }
  }
