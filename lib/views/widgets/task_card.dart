import 'package:flutter/material.dart';
import '../../models/task_model.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final Set<String>? filterTags;

  const TaskCard({
    super.key,
    required this.task,
    this.filterTags,
  });

  @override
  Widget build(BuildContext context) {
    final showAll = filterTags == null || filterTags!.isEmpty;

    final matchedSubTasks = showAll
        ? task.subTasks
        : task.subTasks
        .where((sub) => filterTags!.contains(sub.tag))
        .toList();

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 任務標題
            Text(
              task.title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            // 任務封面圖
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                task.imageUrl,
                height: 160,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 12),

            // 子任務區塊
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: matchedSubTasks.map((sub) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Icon(
                        sub.isCompleted
                            ? Icons.check_circle
                            : Icons.radio_button_unchecked,
                        color: sub.isCompleted
                            ? const Color(0xFF4A749E)
                            : Colors.grey,
                        size: 20,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(sub.content,
                            style: const TextStyle(fontSize: 14)),
                      ),
                      const SizedBox(width: 6),
                      Chip(
                        label: Text(sub.tag,
                            style: const TextStyle(fontSize: 12)),
                        backgroundColor: Colors.grey[200],
                        padding: EdgeInsets.zero,
                        visualDensity: VisualDensity.compact,
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
