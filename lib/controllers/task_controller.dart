import 'package:flutter/material.dart';
import '../models/task_model.dart';

class TaskController extends ChangeNotifier {
  DateTime _selectedDate = DateTime.now();

  final Map<String, List<Task>> _mockTasks = {};  // 新增

  DateTime get selectedDate => _selectedDate;

  void setSelectedDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  List<Task> get tasksForSelectedDate {
    final formatted = _formatDate(_selectedDate);
    return _mockTasks[formatted] ?? [];
  }

  List<Task> get allTasks =>
      _mockTasks.values.expand((taskList) => taskList).toList();

  bool hasTaskOnDate(DateTime date) {
    final key = _formatDate(date);
    return _mockTasks.containsKey(key) && _mockTasks[key]!.isNotEmpty;
  }

  List<Task> tasksByCategory(String tag) {
    return _mockTasks.values
        .expand((taskList) => taskList)
        .where((task) => task.subTasks.any((sub) => sub.tag == tag))
        .toList();
  }

  void addTaskForDate(DateTime date, Task task) {
    final key = _formatDate(date);
    if (_mockTasks.containsKey(key)) {
      _mockTasks[key]!.add(task);
    } else {
      _mockTasks[key] = [task];
    }
    notifyListeners();
  }

  void removeTask(DateTime date, Task task) {
    final key = _formatDate(date);
    _mockTasks[key]?.remove(task);
    notifyListeners();
  }

  String _formatDate(DateTime date) =>
      "${date.year}-${_twoDigits(date.month)}-${_twoDigits(date.day)}";

  String _twoDigits(int n) => n.toString().padLeft(2, '0');
}
