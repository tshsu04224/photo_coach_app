import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/task_controller.dart';

class WeekDaySelector extends StatelessWidget {
  const WeekDaySelector({super.key});

  @override
  Widget build(BuildContext context) {
    final taskController = Provider.of<TaskController>(context);
    final selectedDate = taskController.selectedDate;

    final startOfWeek = selectedDate.subtract(Duration(days: selectedDate.weekday % 7));

    return SizedBox(
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 7,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemBuilder: (context, index) {
          final day = startOfWeek.add(Duration(days: index));
          final isSelected = _isSameDay(day, selectedDate);

          return GestureDetector(
            onTap: () => taskController.setSelectedDate(day),
            child: Container(
              width: 60,
              margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF4A749E) : Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _weekdayText(day.weekday),
                    style: TextStyle(
                      fontSize: 14,
                      color: isSelected ? Colors.white : Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${day.day}',
                    style: TextStyle(
                      fontSize: 16,
                      color: isSelected ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  String _weekdayText(int weekday) {
    const weekDays = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    return weekDays[weekday % 7];
  }
}
