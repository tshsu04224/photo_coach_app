// controllers/task_controller.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/task.dart';
import '../services/task_service.dart';

class TaskController extends ChangeNotifier {
  TaskController({required this.taskService});
  final TaskService taskService;

  String? _token; // ← 存登入後的 token
  DateTime _selectedDate = DateUtils.dateOnly(DateTime.now());
  final Map<String, List<Task>> _tasksByDate = {};
  bool isLoading = false;
  String? error;

  DateTime get selectedDate => _selectedDate;
  List<Task> get tasksForSelectedDate => _tasksByDate[_formatDate(_selectedDate)] ?? [];
  List<Task> get allTasks { // 取得所有任務
    return _tasksByDate.values.expand((taskList) => taskList).toList();
  }

  /// 預先帶入 token（在 Page 的 initState 呼叫一次）
  Future<void> initialize(String? token) async {
    _token = token;
    if (_token == null || _token!.isEmpty) {
      error = '尚未登入（缺少 token）';
      notifyListeners();
      return;
    }
  }

  /// 切換日期
  Future<void> setSelectedDate(DateTime date) async {
    final normalized = DateUtils.dateOnly(date);
    if (_isSameDay(_selectedDate, normalized)) return;
    _selectedDate = normalized;
    notifyListeners(); // 先更新 UI

    // 若尚未載入該天資料就去抓
    final k = _formatDate(_selectedDate);
    if (!_tasksByDate.containsKey(k)) {
      await fetchTasksForDate(_selectedDate);
    }
  }

  Future<void> fetchTasksForDate(DateTime date) async {
    if (_token == null || _token!.isEmpty) {
      error = '缺少 token，無法取得任務';
      notifyListeners();
      return;
    }

    final key = _formatDate(date);
    try {
      final tasks = await taskService.fetchTasksByDate(key);
      _tasksByDate[key] = tasks;
    } catch (e) {
      error = '取得任務失敗：$e';
    } finally {
      notifyListeners();
    }
  }


  /// 進頁面時預抓前後各 7 天
  Future<void> loadTasksAroundSelectedDate() async {
    if (_token == null || _token!.isEmpty) return;

    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final start = _selectedDate.subtract(const Duration(days: 7));
      final dates = List.generate(14, (i) => start.add(Duration(days: i)));

      for (final d in dates) {
        final k = _formatDate(d);
        if (_tasksByDate.containsKey(k)) continue;
        await fetchTasksForDate(d);
      }
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // 判斷指定日期是否有任務（用於 WeekDaySelector 圓點）
  bool hasTaskOnDate(DateTime date) {
    final key = _formatDate(date);
    return _tasksByDate[key]?.isNotEmpty ?? false;
  }

  // 新增任務到某天
  void addTask(Task task) {
    final key = _formatDate(task.date);
    if (_tasksByDate.containsKey(key)) {
      _tasksByDate[key]!.add(task);
    } else {
      _tasksByDate[key] = [task];
    }
    notifyListeners();
  }

  //移除任務
  Future<void> removeTask(Task task) async {
    if (_token == null || _token!.isEmpty) return;

    isLoading = true;
    notifyListeners();

    try {
      final success = await taskService.deleteTask(task.id);
      if (success) {
        final k = _formatDate(task.date);
        _tasksByDate[k]?.remove(task);
        if (_tasksByDate[k]?.isEmpty ?? true) {
          _tasksByDate.remove(k);
        }
      } else {
        error = '刪除任務失敗';
      }
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  String _formatDate(DateTime d) => DateFormat('yyyy-MM-dd').format(d);
  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}
