// 控制底部導覽列跳轉頁面
import 'package:flutter/material.dart';
import 'home_page.dart';
import 'task_page.dart';
import 'gallery_page.dart';
import 'settings_page.dart';
import 'widgets/bottom_nav_bar.dart';
import '../routes/routes.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    HomePage(),
    TaskPage(),
    GalleryPage(userId: 123), // 替換為實際的 userId
    SettingsPage(),
  ];

  void _onTabTapped(int index) {
    if (index == 2) {
      // 相機 → 彈出拍攝任務選擇框
      showDialog(
                context: context,
                builder: (BuildContext context) {
                  return _buildTaskChoiceDialog(context);
                },
      );
    }else{
      setState(() {
        _selectedIndex = index >= 2 ? index - 1 : index; // 跳過中間相機按鈕
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onTabTapped,
      ),
    );
  }
}

  // 拍攝任務選擇框
  Widget _buildTaskChoiceDialog(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 24),
                const Text("今天我想要...", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 建立主題按鈕
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context); // 關閉 dialog
                Navigator.pushNamed(context, Routes.chat); // 導向聊天室
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                side: const BorderSide(color: Colors.black, width: 1),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              icon: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFF5B7DB1),
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(6),
                child: const Icon(Icons.add, color: Colors.white, size: 20),
              ),
              label: const Text("建立主題", style: TextStyle(fontSize: 14)),
            ),
            const SizedBox(height: 16),

            // GPS推薦按鈕
            ElevatedButton.icon(
              onPressed: () {
                // TODO: 導向 GPS 推薦
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                side: const BorderSide(color: Colors.black, width: 1),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              icon: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFF5B7DB1),
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(6),
                child: const Icon(Icons.place, color: Colors.white, size: 20),
              ),
              label: const Text("GPS推薦", style: TextStyle(fontSize: 14)),
            ),
          ],
        ),
      ),
    );
  }