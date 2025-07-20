import 'package:flutter/material.dart';
import '../models/task_model.dart';

class TaskController extends ChangeNotifier {

  DateTime _selectedDate = DateTime.now(); ///default

  DateTime get selectedDate => _selectedDate;

  /// switch date
  void setSelectedDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  List<Task> get tasksForSelectedDate {
    final formatted = _formatDate(_selectedDate);
    return _mockTasks[formatted] ?? [];
  }

  String _formatDate(DateTime date) {
    return "${date.year}-${_twoDigits(date.month)}-${_twoDigits(date.day)}";
  }

  String _twoDigits(int n) => n.toString().padLeft(2, '0');

  /// mock data
  final Map<String, List<Task>> _mockTasks = {
    "2025-05-07": [
      Task(
        title: '日本街景',
        description: '拍攝一張帶有濃厚日系氛圍的街道畫面…',
        imageAssetPath: 'assets/images/japan_street.jpeg',
        subTasks: [
          SubTask(icon: Icons.electrical_services, content: '拍攝電線桿與交錯的電線構成的畫面', isCompleted: false),
          SubTask(icon: Icons.local_convenience_store, content: '捕捉便利商店或自動販賣機所在的街角', isCompleted: true),
          SubTask(icon: Icons.straighten, content: '使用對角線或引導線構圖呈現街道延伸感', isCompleted: true),
        ],
      ),
    ],
    "2025-05-08": [
      Task(
        title: '咖啡店角落',
        description: '捕捉一張充滿氛圍的咖啡店畫面',
        imageAssetPath: 'assets/images/cafe_corner.jpeg',
        subTasks: [
          SubTask(icon: Icons.local_cafe, content: '拍攝咖啡與桌面擺設', isCompleted: false),
          SubTask(icon: Icons.wb_sunny, content: '利用自然光拍攝窗邊座位', isCompleted: false),
        ],
      ),
    ],
  };
}