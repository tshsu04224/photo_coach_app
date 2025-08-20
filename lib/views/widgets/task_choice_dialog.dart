import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:photo_coach/services/api_service.dart';
import 'package:photo_coach/views/widgets/spot_selection_dialog.dart';
import 'package:photo_coach/views/widgets/place_type_select_dialog.dart';
import 'package:photo_coach/views/chat_page.dart';
import 'package:photo_coach/constants/place_type_constants.dart';
import 'package:photo_coach/controllers/chat_controller.dart';
import 'package:photo_coach/controllers/task_controller.dart';
import 'package:provider/provider.dart';

class TaskChoiceDialog extends StatefulWidget {
  const TaskChoiceDialog({super.key});

  @override
  State<TaskChoiceDialog> createState() => _TaskChoiceDialogState();
}

class _TaskChoiceDialogState extends State<TaskChoiceDialog> {
  @override
  Widget build(BuildContext context) {
    final taskController = Provider.of<TaskController>(context, listen: false);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
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

            // 建立主題
            ElevatedButton.icon(
              onPressed: () {
                final navigator = Navigator.of(context); // 先抓住 NavigatorState
                navigator.pop(); // 關閉此 Dialog
                navigator.push(
                  MaterialPageRoute(
                    builder: (_) => ChangeNotifierProvider(
                      create: (_) => ChatController(
                        initialPrompt: '',
                        taskService: taskController.taskService,
                      ),
                      child: const ChatPage(),
                    ),
                  ),
                );
              },
              style: _buttonStyle(),
              icon: _iconBox(Icons.add),
              label: const Text("建立主題", style: TextStyle(fontSize: 14)),
            ),
            const SizedBox(height: 16),

            // GPS 推薦
            ElevatedButton.icon(
              onPressed: () async {
                final navigator = Navigator.of(context); // 先抓住 NavigatorState

                final selectedLabel = await showDialog<String>(
                  context: context,
                  builder: (_) => const PlaceTypeSelectDialog(),
                );
                if (selectedLabel == null) return;
                if (!mounted) return;

                try {
                  // （可選）先檢查系統定位是否啟用
                  final serviceEnabled = await Geolocator.isLocationServiceEnabled();
                  if (!serviceEnabled) {
                    if (!mounted) return;
                    _showAlert("定位未啟用", "請先開啟定位服務再試一次。");
                    return;
                  }

                  // 權限流程
                  LocationPermission permission = await Geolocator.checkPermission();
                  if (permission == LocationPermission.denied) {
                    permission = await Geolocator.requestPermission();
                    if (permission == LocationPermission.denied) {
                      if (!mounted) return;
                      _showAlert("定位權限被拒絕", "請允許定位以使用此功能。");
                      return;
                    }
                  }
                  if (permission == LocationPermission.deniedForever) {
                    if (!mounted) return;
                    _showAlert("無法存取定位", "定位權限已永久拒絕，請至設定中手動開啟。");
                    return;
                  }

                  // 取得定位
                  final position = await Geolocator.getCurrentPosition();
                  if (!mounted) return;

                  // 取得推薦景點
                  final type = placeTypeOptions[selectedLabel];
                  if (type == null) {
                    _showAlert("資料錯誤", "未知的地點類型：$selectedLabel");
                    return;
                  }

                  final spots = await ApiService.getRecommendedSpots(
                    position.latitude,
                    position.longitude,
                    type,
                  );
                  if (!mounted) return;

                  if (spots.isNotEmpty) {
                    // ✅ 用 navigator.context（避免跨 async gap 用原 context）
                    final selectedSpot = await showModalBottomSheet<Map<String, dynamic>>(
                      context: navigator.context,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                      builder: (_) => SpotSelectionDialog(spots: spots),
                    );
                    if (!mounted) return;

                    if (selectedSpot != null) {
                      final spotName = selectedSpot['spot'];
                      final placeType = selectedSpot['type'];

                      if (spotName == null || spotName is! String) {
                        _showAlert("資料錯誤", "找不到地點名稱。");
                        return;
                      }

                      // 關閉 TaskChoiceDialog 再導頁
                      navigator.pop();
                      navigator.push(
                        MaterialPageRoute(
                          builder: (_) => ChangeNotifierProvider(
                            create: (_) => ChatController(
                              initialPrompt: '我想在 $spotName 拍些照片',
                              taskService: taskController.taskService,
                              placeType: placeType,
                            ),
                            child: const ChatPage(),
                          ),
                        ),
                      );
                    }
                  } else {
                    if (!mounted) return;
                    _showAlert("找不到地點", "附近沒有可拍攝的 $selectedLabel。");
                  }
                } catch (e) {
                  if (!mounted) return;
                  _showAlert("錯誤", "無法取得定位或資料：${e.toString()}");
                }
              },
              style: _buttonStyle(),
              icon: _iconBox(Icons.place),
              label: const Text("GPS推薦", style: TextStyle(fontSize: 14)),
            ),
          ],
        ),
      ),
    );
  }

  ButtonStyle _buttonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      side: const BorderSide(color: Colors.black, width: 1),
      minimumSize: const Size(double.infinity, 50),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  Widget _iconBox(IconData icon) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF5B7DB1),
        shape: BoxShape.circle,
      ),
      padding: const EdgeInsets.all(6),
      child: Icon(icon, color: Colors.white, size: 20),
    );
  }

  // 不再傳 context；在 State 內用 context，並加 mounted 保護
  void _showAlert(String title, String message) {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }
}
