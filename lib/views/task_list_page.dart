import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'widgets/week_day_selector.dart';
import '../controllers/task_controller.dart';
import '../controllers/auth_controller.dart';
import '../views/widgets/task_card.dart';
import 'task_category_page.dart';

class TaskListPage extends StatefulWidget {
  const TaskListPage({super.key});

  @override
  State<TaskListPage> createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  @override
  void initState() {
    super.initState();
    // 延遲初始化並預先載入任務
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final taskController = Provider.of<TaskController>(context, listen: false);
      final auth = context.read<AuthController>();
      taskController.initialize(auth.token);
      taskController.loadTasksAroundSelectedDate();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskController>(
      builder: (context, taskController, _) {
        final tasks = taskController.tasksForSelectedDate;
        final selectedDate = taskController.selectedDate;
        final isLoading = taskController.isLoading;

        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: PopupMenuButton<String>(
              onSelected: (value) {
                if (value == '主題分類') {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const TaskCategoryPage()),
                  );
                }
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text('任務清單', style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(width: 4),
                  Icon(Icons.arrow_drop_down, size: 20),
                ],
              ),
              itemBuilder: (context) => const [
                PopupMenuItem(value: '任務清單', child: Text('任務清單')),
                PopupMenuItem(value: '主題分類', child: Text('主題分類')),
              ],
            ),
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 0,
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 日期切換區（← 日期 →）
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios),
                      onPressed: () {
                        taskController.setSelectedDate(
                          selectedDate.subtract(const Duration(days: 1)),
                        );
                      },
                    ),
                    Expanded(
                      child: Center(
                        child: GestureDetector(
                          onTap: () async {
                            final DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: selectedDate,
                              firstDate: DateTime(2020),
                              lastDate: DateTime(2030),
                              builder: (context, child) {
                                return Theme(
                                  data: Theme.of(context).copyWith(
                                    colorScheme: const ColorScheme.light(
                                      primary: Color(0xFF4A749E),
                                      onPrimary: Colors.white,
                                      onSurface: Colors.black,
                                    ),
                                  ),
                                  child: child!,
                                );
                              },
                            );

                            if (picked != null) {
                              taskController.setSelectedDate(picked);
                            }
                          },
                          child: Text(
                            "${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward_ios),
                      onPressed: () {
                        taskController.setSelectedDate(
                          selectedDate.add(const Duration(days: 1)),
                        );
                      },
                    ),
                  ],
                ),
              ),

              // 日期選擇條
              const WeekDaySelector(),
              const SizedBox(height: 4),

              // 任務清單區域
              Expanded(
                child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : tasks.isEmpty
                ? const Center(child: Text("今天沒有任務"))
                : ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      final task = tasks[index];
                      return TaskCard(
                        task: task,
                        filterTags: null,
                      );
                    },
                  ),
              ),
            ],
          ),
        );
      },
    );
  }
}
