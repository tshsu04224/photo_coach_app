import 'package:flutter/material.dart';
import 'package:photo_coach/controllers/analyze_controller.dart';
import 'package:provider/provider.dart';

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
                      '三分法構圖實作',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildRatingRow(controller),
                    const SizedBox(height: 12),
                    _buildBulletPoints(controller),
                    const SizedBox(height: 16),
                    _buildTagButtons(),
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

  Widget _buildRatingRow(AnalyzeController controller) {
    return Row(
      children: [
        const Text("AI的評分", style: TextStyle(fontSize: 14, color: Colors.grey)),
        const SizedBox(width: 4),
        const Icon(Icons.star, color: Colors.orange, size: 16),
        Text(controller.score ?? '', style: const TextStyle(fontSize: 14)),
      ],
    );
  }

  Widget _buildBulletPoints(AnalyzeController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildBullet("📸 拍攝亮點", controller.highlight),
        _buildBullet("🎯 改進建議", controller.suggestion),
        _buildBullet("🧠 學習提示", controller.tip),
        _buildBullet("💡 建議任務挑戰", controller.challenge),
      ],
    );
  }

  Widget _buildBullet(String title, String? content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(content ?? '尚未分析'),
        ],
      ),
    );
  }

  Widget _buildTagButtons() {
    const tags = [
      {'label': '三分法', 'icon': Icons.grid_3x3},
      {'label': '色彩對比', 'icon': Icons.palette},
      {'label': '多層構圖', 'icon': Icons.layers},
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: tags
          .map(
            (tag) => _TagButton(
              label: tag['label'] as String,
              icon: tag['icon'] as IconData,
            ),
          )
          .toList(),
    );
  }
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
