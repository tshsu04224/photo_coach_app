import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/task_controller.dart';
import '../views/widgets/task_card.dart';

class GeneratedTasksPage extends StatelessWidget {
  const GeneratedTasksPage({super.key});

  @override
  Widget build(BuildContext context) {
    final taskController = Provider.of<TaskController>(context);
    final todayTasks = taskController.tasksForSelectedDate;

    if (todayTasks.isEmpty) {
      return const Scaffold(
        body: Center(child: Text("目前沒有任務")),
      );
    }

    final task = todayTasks.first;

    return Scaffold(
      appBar: AppBar(title: const Text('產生的拍攝任務')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              '您想拍攝「${task.title}」，以下提供一些子主題方向供您參考：',
              style: const TextStyle(fontSize: 16),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: TaskCard(task: task), // 直接顯示那一張主題卡片即可
          ),
        ],
      ),
    );
  }
}
