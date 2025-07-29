import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
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
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildImageWithGridAndHeart(),
              const SizedBox(height: 16),
              const Text(
                '三分法構圖實作',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Row(
                children: const [
                  Text(
                    "AI的評分",
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  SizedBox(width: 4),
                  Icon(Icons.star, color: Colors.orange, size: 16),
                  Text(" 4.5", style: TextStyle(fontSize: 14)),
                ],
              ),
              const SizedBox(height: 12),
              _buildBulletPoints(),
              // TextButton(
              //   onPressed: () {}, // 可跳轉至完整內容頁
              //   child: const Text('查看完整內容'),
              // ),
              const SizedBox(height: 16),
              _buildTagButtons(),
              const SizedBox(height: 16),
              _buildApiTestButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageWithGridAndHeart() {
    final controller = context.watch<AnalyzeController>();
    final imageFile = controller.analyzedImage;
    return FutureBuilder(
      future: Future.delayed(const Duration(milliseconds: 100)), // 模擬非同步延遲
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
              // 主圖片
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: SizedBox(
                  height: 300,
                  child: SizedBox(
                    height: 300,
                    child: imageFile != null
                        ? Image.file(imageFile, fit: BoxFit.cover) // ✅ 使用使用者圖片
                        : Image.asset(
                            'assets/images/analysis_result_sample.png',
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
              ),
              // 左上角的返回鍵
              Positioned(
                top: 10,
                left: 10,
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.white,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () {
                      // Navigator.of(context).pop(); // 返回上一頁
                    },
                  ),
                ),
              ),
              // 右下角的愛心
              Positioned(
                bottom: 10,
                right: 10,
                child: GestureDetector(
                  onTap: () {
                    isFavoriteNotifier.value =
                        !isFavoriteNotifier.value; // 更新狀態
                  },
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

  Widget _buildBulletPoints() {
    final controller = context.watch<AnalyzeController>();
    if (controller.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("📸 拍攝亮點", style: TextStyle(fontWeight: FontWeight.bold)),
        Text(controller.highlight ?? '尚未分析'),

        SizedBox(height: 8),
        Text("🎯 改進建議", style: TextStyle(fontWeight: FontWeight.bold)),
        Text(controller.suggestion ?? '尚未分析'),

        SizedBox(height: 8),
        Text("🧠 學習提示", style: TextStyle(fontWeight: FontWeight.bold)),
        Text(controller.tip ?? '尚未分析'),

        SizedBox(height: 8),
        Text("💡 建議任務挑戰", style: TextStyle(fontWeight: FontWeight.bold)),
        Text(controller.challenge ?? '尚未分析'),
      ],
    );
  }

  Widget _buildTagButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: const [
        _TagButton(label: '三分法', icon: Icons.grid_3x3),
        _TagButton(label: '色彩對比', icon: Icons.palette),
        _TagButton(label: '多層構圖', icon: Icons.layers),
      ],
    );
  }

  // 按鈕觸發API測試
  Widget _buildApiTestButton() {
    return ElevatedButton(
      onPressed: () async {
        final controller = context.read<AnalyzeController>();
        final picker = ImagePicker();
        final picked = await picker.pickImage(source: ImageSource.gallery);

        if (picked != null) {
          final file = File(picked.path);
          controller.analyze(file);
        }
      },
      child: Text("分析照片"),
    );
  }
}

// class _BulletText extends StatelessWidget {
//   final String text;
//   const _BulletText(this.text);

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 5),
//       child: Text(text, style: TextStyle(fontSize: 15, height: 1.4)),
//     );
//   }
// }

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
        Text(label, style: TextStyle(fontSize: 12)),
      ],
    );
  }
}
