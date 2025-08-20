import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/task_controller.dart';
import '../views/widgets/task_card.dart';

class GeneratedTasksPage extends StatefulWidget {
  const GeneratedTasksPage({super.key});

  @override
  State<GeneratedTasksPage> createState() => _GeneratedTasksPageState();
}

class _GeneratedTasksPageState extends State<GeneratedTasksPage> {

  @override
  Widget build(BuildContext context) {
    final taskController = context.watch<TaskController>();
    final allTasks = taskController.allTasks;

    if (allTasks.isEmpty) {
      return const Scaffold(
        body: Center(child: Text("目前沒有任務")),
      );
    }

    // 顯示最新的任務（最後添加的）
    final task = allTasks.last;

    return Scaffold(
      appBar: AppBar(
        title: const Text('產生的拍攝任務'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 24),
        child: Column(
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
            TaskCard(
              task: task,
              filterTags: null,
              onDelete: () {
                // 執行刪除，TaskController.removeTask 會自動通知 UI 更新
                taskController.removeTask(task);
              },
            ),
          ],
        ),
      ),
    );
  }
}
