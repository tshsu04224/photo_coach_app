import 'package:flutter/material.dart';
import '../../models/task_model.dart';
import 'capture_sheet.dart';

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
        : task.subTasks.where((sub) => filterTags!.contains(sub.tag)).toList();

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Colors.black87, width: 1.2),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: DefaultTextStyle(
        style: const TextStyle(color: Colors.black87), // 統一文字為黑色
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children:
              [
                const Icon(Icons.camera_alt_outlined, size: 20),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    task.title,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

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

            // 子任務列表
            Column(
              children: matchedSubTasks
                  .map((sub) => AnimatedSubTaskTile(subTask: sub))
                  .toList(),
            ),
          ],
        ),
        ),
      ),
    );
  }
}

class AnimatedSubTaskTile extends StatefulWidget {
  final SubTask subTask;

  const AnimatedSubTaskTile({super.key, required this.subTask});

  @override
  State<AnimatedSubTaskTile> createState() => _AnimatedSubTaskTileState();
}

class _AnimatedSubTaskTileState extends State<AnimatedSubTaskTile>
    with SingleTickerProviderStateMixin {
  bool isExpanded = false;
  late final AnimationController _controller;
  late final Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  void _toggleExpanded() {
    setState(() {
      isExpanded = !isExpanded;
      if (isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: _toggleExpanded,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                widget.subTask.isCompleted
                    ? Icons.check_circle
                    : Icons.radio_button_unchecked,
                color: widget.subTask.isCompleted
                    ? const Color(0xFF4A749E)
                    : Colors.grey,
                size: 20,
              ),
              const SizedBox(width: 8),

              Expanded(
                child: Text(
                  widget.subTask.content,
                  style: const TextStyle(fontSize: 14),
                ),
              ),

              const SizedBox(width: 8),

              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F1F1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      widget.subTask.tag,
                      style: const TextStyle(fontSize: 12, color: Colors.black87),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: Colors.grey,
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),

        // 展開內容
        SizeTransition(
          sizeFactor: _expandAnimation,
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.only(top: 6, bottom: 16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("📍 建議取景位置：${widget.subTask.suggestedPosition}"),
                Text("☀️ 理想光線條件：${widget.subTask.lightingCondition}"),
                Text("📷 推薦拍攝手法：${widget.subTask.shootingTechnique}"),
                Text("🕐 適合拍攝時段：${widget.subTask.recommendedTime}"),
                const SizedBox(height: 12),
                Center(
                  child: SizedBox(
                    width: 260,
                    height: 42,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) => const CaptureSheet(),
                        );
                      },
                      icon: const Icon(Icons.camera_alt, size: 18),
                      label: const Text(
                        "開始拍攝任務",
                        style: TextStyle(fontSize: 12),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4A749E),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 2,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
