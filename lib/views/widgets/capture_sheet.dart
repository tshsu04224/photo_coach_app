// lib/views/widgets/capture_sheet.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../image_preview_page.dart';

class CaptureSheet extends StatelessWidget {
  final int subTaskId;
  const CaptureSheet({super.key, required this.subTaskId});

  Future<void> _pickImage(BuildContext context, ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile == null) return;

    if (!context.mounted) return; // widget 可能已經被移除
    final image = File(pickedFile.path);

    Navigator.pop(context); // 關閉 bottom sheet

    Future.microtask(() {
      if (!context.mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>
              ImagePreviewPage(imageFile: image, subTaskId: subTaskId),
        ),
      );
    });
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
