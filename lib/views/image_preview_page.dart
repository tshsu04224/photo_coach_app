// lib/views/image_preview_page.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/analyze_controller.dart';
import 'analysis_result_page.dart';

class ImagePreviewPage extends StatefulWidget {
  final File imageFile;
  final int subTaskId;

  const ImagePreviewPage({
    super.key,
    required this.imageFile,
    required this.subTaskId,
  });

  @override
  State<ImagePreviewPage> createState() => _ImagePreviewPageState();
}

class _ImagePreviewPageState extends State<ImagePreviewPage> {
  bool _isAnalyzing = false;

  Future<void> _analyze() async {
    if (_isAnalyzing) return;
    setState(() => _isAnalyzing = true);

    try {
      final analyzeController = context.read<AnalyzeController>();
      await analyzeController.analyze(widget.imageFile, widget.subTaskId);

      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const AnalysisResultPage()),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('分析失敗：$e')),
      );
    } finally {
      if (mounted) setState(() => _isAnalyzing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("預覽照片")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(child: Center(child: Image.file(widget.imageFile))),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.refresh),
                    label: const Text("重新選擇"),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isAnalyzing ? null : _analyze,
                    icon: _isAnalyzing
                        ? const SizedBox(
                            width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                        : const Icon(Icons.analytics),
                    label: Text(_isAnalyzing ? "分析中..." : "分析照片"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
