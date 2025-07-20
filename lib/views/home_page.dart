// 主頁面
// 這個頁面會顯示使用者的頭像、拍攝任務按鈕、功能目錄、今日任務與近期作品...
// 目前皆仍為假資料與沒有功能的按鈕(待實作)
import 'package:flutter/material.dart';
import 'widgets/bottom_nav_bar.dart';
import '../routes/routes.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  // Widget build(BuildContext context) {
  //   final auth = Provider.of<AuthController>(context);

  //   return Scaffold(
  //     appBar: AppBar(title: const Text('Home Page')),
  //     body: Center(
  //       child: ElevatedButton(
  //         onPressed: () {
  //           auth.logout(); // 按下登出 → 回到登入頁
  //         },
  //         child: const Text('Log Out'),
  //       ),
  //     ),
  //   );
  // }

  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
            // 你可以根據 index 導向其他頁面
          });
        },
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 頭像 & 啟動任務
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text("早安，用戶1", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                      SizedBox(height: 4),
                      Text("桃園，台灣", style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                  Row(
                    children: const [
                      Icon(Icons.notifications, color: Colors.black54),
                      SizedBox(width: 12),
                      CircleAvatar(radius: 18, backgroundColor: Colors.grey, child: Icon(Icons.person)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // 拍攝任務按鈕
              Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, Routes.chat);
                  },
                  icon: const Icon(Icons.camera_alt),
                  label: const Text("開始拍攝任務"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade200,
                    foregroundColor: Colors.black,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 100),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              const Text("功能目錄", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _functionIcon(Icons.upload, "上傳照片"),
                  _functionIcon(Icons.photo_library, "作品集"),
                  _functionIcon(Icons.settings, "設定"),
                  _functionIcon(Icons.more_horiz, "顯示更多"),
                ],
              ),
              const SizedBox(height: 24),

              // 本日任務
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text("本日任務  07/01", style: TextStyle(fontWeight: FontWeight.bold)),
                  Icon(Icons.edit_outlined, size: 18),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text("台灣街景", style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(height: 4),
                          Text("拍攝一張具有台灣感性的街景照。"),
                          SizedBox(height: 8),
                          OutlinedButton(onPressed: null, child: Text("前往拍攝")),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        "assets/images/street.jpg",
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // 近期作品
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text("近期作品", style: TextStyle(fontWeight: FontWeight.bold)),
                  Text("查看全部", style: TextStyle(color: Colors.blue)),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 160,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _photoCard(
                      "漂亮海邊",
                      "沙灘風",
                      true,
                      imagePath: "assets/images/beach.jpg",
                    ),
                    _photoCard(
                      "綠意盎然",
                      "自然風",
                      false,
                      imagePath: "assets/images/nature.jpg",
                    ),
                    _photoCard(
                      "很多畫",
                      "美術館",
                      false,
                      imagePath: "assets/images/gallery.jpg",
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _functionIcon(IconData icon, String label) {
    return Column(
      children: [
        CircleAvatar(
          radius: 28,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          child: Icon(icon, size: 28),
        ),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _photoCard(String title, String subtitle, bool liked, {required String imagePath}) {
    return Container(
      width: 120,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  imagePath,
                  width: double.infinity,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
              if (liked)
                const Positioned(
                  top: 6,
                  right: 6,
                  child: Icon(Icons.favorite, color: Colors.black),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }
}
