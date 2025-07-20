import 'package:flutter/material.dart';
import 'package:photo_coach/views/home_page.dart';

class AnalysisResultPage extends StatefulWidget {
  final String imagePath;
  final List<String> feedback;
  final List<Map<String, dynamic>> techniques;

  const AnalysisResultPage({
    super.key,
    required this.imagePath,
    required this.feedback,
    required this.techniques,
  });

  factory AnalysisResultPage.mock() {
    return AnalysisResultPage(
      imagePath: 'https://picsum.photos/600/400',
      feedback: [
        '📷 構圖整體穩定，主體清晰、層次分明。',
        '🎨 色彩搭配自然，畫面氛圍和諧。',
        '💡 光線處理良好，主體與背景對比適中。',
        '📐 拍攝角度選擇得當，成功引導觀者視線。',
        '🖼️ 畫面整潔無干擾元素，呈現主題完整性。'
      ],
      techniques: [
        {'icon': Icons.grid_on, 'label': '基礎構圖'},
        {'icon': Icons.light_mode, 'label': '自然光'},
        {'icon': Icons.center_focus_strong, 'label': '主體明確'},
      ],
    );
  }

  @override
  State<AnalysisResultPage> createState() => _AnalysisResultPageState();
}

class _AnalysisResultPageState extends State<AnalysisResultPage> {
  final ValueNotifier<bool> isFavoriteNotifier = ValueNotifier(false);
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        Navigator.push(context, MaterialPageRoute(builder: (_) => const HomePage()));
        break;
      case 1:
      case 2:
      case 3:
        Navigator.push(context, MaterialPageRoute(builder: (_) => const Placeholder()));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        child: BottomAppBar(
          color: Colors.black,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: const Icon(Icons.home),
                color: _selectedIndex == 0 ? Colors.white : Colors.grey,
                onPressed: () => _onItemTapped(0),
              ),
              IconButton(
                icon: const Icon(Icons.calendar_today),
                color: _selectedIndex == 1 ? Colors.white : Colors.grey,
                onPressed: () => _onItemTapped(1),
              ),
              const SizedBox(width: 48),
              IconButton(
                icon: const Icon(Icons.image),
                color: _selectedIndex == 2 ? Colors.white : Colors.grey,
                onPressed: () => _onItemTapped(2),
              ),
              IconButton(
                icon: const Icon(Icons.settings),
                color: _selectedIndex == 3 ? Colors.white : Colors.grey,
                onPressed: () => _onItemTapped(3),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const Placeholder()));
        },
        child: const Icon(Icons.camera_alt),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildImageWithHeart(widget.imagePath),
              const SizedBox(height: 12),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  '三分法構圖實作',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                child: Row(
                  children: [
                    Text("AI 的評分", style: TextStyle(fontSize: 14)),
                    SizedBox(width: 6),
                    Icon(Icons.star, size: 16, color: Colors.amber),
                    Text(" 4.5", style: TextStyle(fontSize: 14)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (final line in widget.feedback)
                      _BulletText(line),
                    const SizedBox(height: 8),
                    const Text("查看完整內容", style: TextStyle(color: Colors.blue)),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: widget.techniques
                      .map((tech) => Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: _TagButton(icon: tech['icon'], label: tech['label']),
                  ))
                      .toList(),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageWithHeart(String imageUrl) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.network(
              imageUrl,
              width: double.infinity,
              height: 300,
              fit: BoxFit.cover,
            ),
          ),
          ValueListenableBuilder<bool>(
            valueListenable: isFavoriteNotifier,
            builder: (context, isFavorite, child) {
              return GestureDetector(
                onTap: () => isFavoriteNotifier.value = !isFavoriteNotifier.value,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: Colors.pinkAccent,
                    size: 28,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _BulletText extends StatelessWidget {
  final String text;
  const _BulletText(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Text(text, style: const TextStyle(fontSize: 15, height: 1.4)),
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
          backgroundColor: Colors.grey.shade200,
          radius: 24,
          child: Icon(icon, color: Colors.black),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
