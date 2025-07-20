import 'package:flutter/material.dart';
import '../../models/task_model.dart';

class TaskCard extends StatelessWidget {
  final Task task;

  const TaskCard({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // title
            Row(
              children: [
                const Icon(Icons.camera_alt, size: 20),
                const SizedBox(width: 8),
                Text(task.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 12),

            // image
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                task.imageAssetPath,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 12),

            // description
            Text(task.description, style: TextStyle(color: Colors.grey[800], fontSize: 14)),
            const SizedBox(height: 16),

            // Checklist
            ...task.subTasks.map((subTask) => _buildSubTask(subTask)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildSubTask(SubTask subTask) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(
            subTask.isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
            color: subTask.isCompleted ? Colors.green : Colors.grey,
            size: 20,
          ),
          const SizedBox(width: 8),
          Icon(subTask.icon, size: 18),
          const SizedBox(width: 8),
          Expanded(child: Text(subTask.content)),
        ],
      ),
    );
  }
}
