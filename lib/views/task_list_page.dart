import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'widgets/week_day_selector.dart';
import '../controllers/task_controller.dart';
import '../views/widgets/task_card.dart';
import '../views/widgets/bottom_nav_bar.dart';

class TaskListPage extends StatefulWidget {
  const TaskListPage({super.key});

  @override
  State<TaskListPage> createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  int? expandedIndex;

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskController>(
      builder: (context, taskController, _) {
        final tasks = taskController.tasksForSelectedDate;
        final selectedDate = taskController.selectedDate;

        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text('任務清單', style: TextStyle(fontWeight: FontWeight.bold)),
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 0,
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.grey),
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

              const WeekDaySelector(),
              const SizedBox(height: 4),

              Expanded(
                child: tasks.isEmpty
                    ? const Center(child: Text("今天沒有任務"))
                    : ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final task = tasks[index];
                    return TaskCard(
                      task: task,
                    );
                  },
                ),
              ),
            ],
          ),
          bottomNavigationBar: BottomNavBar(
            currentIndex: 0,
            onTap: (index) {
              // 導頁邏輯
            },
          ),
        );
      },
    );
  }
}

