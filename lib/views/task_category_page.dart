import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/task_controller.dart';
import 'widgets/task_card.dart';

class TaskCategoryPage extends StatefulWidget {
  const TaskCategoryPage({super.key});

  @override
  State<TaskCategoryPage> createState() => _TaskCategoryPageState();
}

class _TaskCategoryPageState extends State<TaskCategoryPage> {
  final List<String> allTags = ['人像', '食物', '街拍', '風景', '靜物', '建築', '動物', '旅拍'];
  final Set<String> selectedTags = {};

  @override
  Widget build(BuildContext context) {
    final taskController = Provider.of<TaskController>(context);
    final allTasks = taskController.allTasks; // 所有任務展平

    // 篩選任務：任務中有任一子任務標籤符合選中分類
    final filteredTasks = selectedTags.isEmpty
        ? allTasks
        : allTasks.where((task) {
      return task.subTasks.any((sub) => selectedTags.contains(sub.tag));
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('主題分類', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // 分類選單
          SizedBox(
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: allTags.length,
              itemBuilder: (context, index) {
                final tag = allTags[index];
                final isSelected = selectedTags.contains(tag);
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: FilterChip(
                    label: Text(tag),
                    selected: isSelected,
                    selectedColor: const Color(0xFF4A749E),
                    checkmarkColor: Colors.white,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          selectedTags.add(tag);
                        } else {
                          selectedTags.remove(tag);
                        }
                      });
                    },
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 8),

          // 小標題
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                selectedTags.isEmpty
                    ? '顯示所有子任務'
                    : '符合主題：${selectedTags.join("、")}',
                style: const TextStyle(fontSize: 13, color: Colors.grey),
              ),
            ),
          ),

          const SizedBox(height: 8),


          // 任務卡片清單
          Expanded(
            child: filteredTasks.isEmpty
                ? const Center(child: Text('沒有符合的任務'))
                : ListView.builder(
              itemCount: filteredTasks.length,
              itemBuilder: (context, index) {
                return TaskCard(
                  task: filteredTasks[index],
                  filterTags: selectedTags,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}