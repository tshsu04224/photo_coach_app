// 控制底部導覽列跳轉頁面
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'home_page.dart';
import 'task_category_page.dart';
import 'gallery_page.dart';
import 'settings_page.dart';
import 'widgets/bottom_nav_bar.dart';
import '../controllers/chat_controller.dart';
import '../views/widgets/place_type_select_dialog.dart';
import '../views/chat_page.dart';
import '../controllers/auth_controller.dart';
import '../controllers/task_controller.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  List<Widget> get _pages {
    final auth = Provider.of<AuthController>(context, listen: false);
    final userId = auth.currentUser?.id;

    return [
      const HomePage(),
      const TaskCategoryPage(),
      GalleryPage(userId: userId),
      const SettingsPage(),
    ];
  }

  void _onTabTapped(int index) {
    if (index == 2) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return _buildTaskChoiceDialog(context);
        },
      );
    } else {
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
              const Text(
                "今天我想要...",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 建立主題
          ElevatedButton.icon(
            onPressed: () async {
              Navigator.pop(context); // 關閉 dialog

              final selectedLabel = await showDialog<String>(
                context: context,
                builder: (_) => const PlaceTypeSelectDialog(),
              );

              if (selectedLabel != null) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (!context.mounted) return;
                  final taskController = Provider.of<TaskController>(context, listen: false);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChangeNotifierProvider(
                        create: (_) =>
                            ChatController(
                              initialPrompt: '我想拍 $selectedLabel', 
                              taskService: taskController.taskService
                              ),
                        child: const ChatPage(),
                      ),
                    ),
                  );
                });
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              side: const BorderSide(color: Colors.black, width: 1),
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
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

          // GPS推薦
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              side: const BorderSide(color: Colors.black, width: 1),
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
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
