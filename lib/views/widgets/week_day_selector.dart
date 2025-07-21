import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/task_controller.dart';

class WeekDaySelector extends StatefulWidget {
  const WeekDaySelector({super.key});

  @override
  State<WeekDaySelector> createState() => _WeekDaySelectorState();
}

class _WeekDaySelectorState extends State<WeekDaySelector> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final taskController = Provider.of<TaskController>(context);
    final selectedDate = taskController.selectedDate;

    // 中心為 selectedDate，左右各 7 天，共 14 天
    final startDate = selectedDate.subtract(const Duration(days: 7));
    final dateList = List.generate(14, (i) => startDate.add(Duration(days: i)));

    return SizedBox(
      height: 80,
      child: ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        itemCount: dateList.length,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemBuilder: (context, index) {
          final day = dateList[index];
          final isSelected = _isSameDay(day, selectedDate);

          if (isSelected) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _scrollToCenter(index);
            });
          }

          return GestureDetector(
            onTap: () {
              taskController.setSelectedDate(day);
              _scrollToCenter(index);
            },
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
                  const SizedBox(height: 4),

                  taskController.hasTaskOnDate(day)
                      ? Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.white : const Color(0xFF4A749E),
                      shape: BoxShape.circle,
                    ),
                  )
                      : const SizedBox(height: 6),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _scrollToCenter(int index) {
    const itemWidth = 60 + 12;
    final screenWidth = MediaQuery.of(context).size.width;
    final targetOffset = index * itemWidth - (screenWidth / 2 - itemWidth / 2);
    _scrollController.animateTo(
      targetOffset,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
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
