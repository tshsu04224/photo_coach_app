import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:photo_coach/controllers/analyze_controller.dart';
import 'package:photo_coach/controllers/feedback_controller.dart';
import 'package:provider/provider.dart';
import 'package:photo_coach/models/feedback_model.dart';
import 'package:photo_coach/utils/tag_icon_mapping.dart';

class AnalysisResultPage extends StatefulWidget {
  const AnalysisResultPage({super.key});
  @override
  State<AnalysisResultPage> createState() => _AnalysisResultPageState();
}

class _AnalysisResultPageState extends State<AnalysisResultPage> {
  final ValueNotifier<bool> isFavoriteNotifier = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<AnalyzeController>();
    final feedbackController = context.watch<FeedbackController>();

    return Scaffold(
      body: SafeArea(
        child: controller.isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildImageSection(controller),
              const SizedBox(height: 16),
              const Text(
                '分析結果',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              _buildAnalysisSummaryRow(controller),
              const SizedBox(height: 12),
              _buildFeedbackSection(feedbackController),
              const SizedBox(height: 16),
              _buildTagButtons(controller.techniques),
              const SizedBox(height: 16),
              _buildAnalyzeButton(controller),
              _buildFakeTestButton(context, controller),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection(AnalyzeController controller) {
    final imageFile = controller.analyzedImage;
    return FutureBuilder(
      future: Future.delayed(const Duration(milliseconds: 100)),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const SizedBox(
            height: 250,
            child: Center(child: CircularProgressIndicator()),
          );
        }
        return Center(
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: SizedBox(
                  height: 300,
                  child: imageFile != null
                      ? Image.file(imageFile, fit: BoxFit.cover)
                      : Container(
                    height: 300,
                    color: Colors.grey[200],
                    child: const Center(child: Text("尚未選擇照片")),
                  ),
                ),
              ),
              Positioned(
                top: 10,
                left: 10,
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.white,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
              ),
              Positioned(
                bottom: 10,
                right: 10,
                child: GestureDetector(
                  onTap: () =>
                  isFavoriteNotifier.value = !isFavoriteNotifier.value,
                  child: ValueListenableBuilder<bool>(
                    valueListenable: isFavoriteNotifier,
                    builder: (context, isFavorite, child) {
                      return CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.white,
                        child: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: Colors.red,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// 以新格式顯示一行摘要（例如：觀察敘述的數量）
  Widget _buildAnalysisSummaryRow(AnalyzeController controller) {
    final obsCount = controller.observations.length;
    final hasObs = obsCount > 0;
    return Row(
      children: [
        const Icon(Icons.insights, color: Colors.blueGrey, size: 16),
        const SizedBox(width: 6),
        Text(
          hasObs ? '已產出回饋' : '尚未有分析觀察',
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildTagButtons(List<String> tagsFromAnalysis) {
    final List<Widget> tagWidgets = [];

    for (final tag in tagsFromAnalysis) {
      if (availableTags.containsKey(tag)) {
        tagWidgets.add(
          _TagButton(
            label: tag,
            icon: availableTags[tag]!,
          ),
        );
      }
    }

    return tagWidgets.isNotEmpty
        ? Wrap(
      spacing: 16,
      runSpacing: 12,
      alignment: WrapAlignment.start,
      children: tagWidgets,
    )
        : const Text("未偵測到攝影技巧", style: TextStyle(color: Colors.grey));
  }

  Widget _buildFeedbackSection(FeedbackController controller) {
    final String? content = controller.feedback;

    return content != null && content.isNotEmpty
        ? Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "回饋建議",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(content),
        const SizedBox(height: 16),
      ],
    )
        : const SizedBox(); // 若沒有內容就不顯示
  }

  Widget _buildAnalyzeButton(AnalyzeController analyzeController) {
    return ElevatedButton(
      onPressed: () async {
        // 提前取得 context 相關內容，避免 async gap 警告
        final picker = ImagePicker();
        final feedbackController = context.read<FeedbackController>();

        final picked = await picker.pickImage(source: ImageSource.gallery);
        if (picked != null) {
          final file = File(picked.path);

          // 1) 進行分析（AnalyzeController 會以新格式填入 observations / techniquesByCategory / techniques）
          await analyzeController.analyze(file);

          // 2) 以「新格式」建立 FeedbackInput
          final feedbackInput = FeedbackInput(
            observation: analyzeController.observations,
            techniques: analyzeController.techniquesByCategory,
          );

          // 3) 呼叫回饋 API
          await feedbackController.fetchFeedback(feedbackInput);
        }
      },
      child: const Text("分析照片"),
    );
  }
}

/// 測試用：用新格式模擬分析結果
Widget _buildFakeTestButton(BuildContext context, AnalyzeController c) {
  return ElevatedButton(
    onPressed: () async {
      final feedbackController = context.read<FeedbackController>();

      // 模擬資料
      c.observations = [
        "主體是一隻貓，位於畫面右側，佔畫面約 35%",
        "光線從左上角進入",
        "拍攝視角略為仰角"
      ];
      c.techniquesByCategory = {
        '構圖技巧': ['三分法', '對角線構圖'],
        '光線運用': ['側光'],
        '拍攝角度': ['仰角'],
      };

      //
      c.refreshBadges();

      // 呼叫回饋 API（新格式）
      final input = FeedbackInput(
        observation: c.observations,
        techniques: c.techniquesByCategory,
      );
      await feedbackController.fetchFeedback(input);
    },
    child: const Text("測試"),
  );
}



class _TagButton extends StatelessWidget {
  final String label;
  final IconData icon;

  const _TagButton({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: Colors.grey[200],
          child: Icon(icon, color: Colors.black),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
