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
  DateTime? _lastScrolledToDate;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final taskController = Provider.of<TaskController>(context);
    final selectedDate = taskController.selectedDate;

    // 從選取日期往前推7天開始
    final startDate = selectedDate.subtract(const Duration(days: 7));
    final dateList = List.generate(14, (i) => startDate.add(Duration(days: i)));

    // 只在選中日期改變時才滾動，避免重複執行
    if (_lastScrolledToDate == null ||
        !_isSameDay(_lastScrolledToDate!, selectedDate)) {
      _lastScrolledToDate = selectedDate;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final selectedIndex = dateList.indexWhere(
          (d) => _isSameDay(d, selectedDate),
        );
        if (selectedIndex != -1) {
          _scrollToCenter(selectedIndex);
        }
      });
    }

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
          final hasTask = taskController.hasTaskOnDate(day); // 使用快取判斷是否有任務

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
                  if (hasTask)
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.white
                            : const Color(0xFF4A749E),
                        shape: BoxShape.circle,
                      ),
                    )
                  else
                    const SizedBox(height: 6),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // 捲動畫面使某項目置中
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

  // 判斷是否同一天
  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  // 取得星期縮寫
  String _weekdayText(int weekday) {
    const weekDays = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    return weekDays[weekday % 7];
  }
}
