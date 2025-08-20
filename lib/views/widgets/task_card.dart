import 'package:flutter/material.dart';
import '../../models/task.dart';
import 'capture_sheet.dart';
import 'confirm_dialog.dart';

class TaskCard extends StatefulWidget {
  final Task task;
  final Set<String>? filterTags;
  final VoidCallback? onDelete;

  const TaskCard({
    super.key,
    required this.task,
    this.filterTags,
    this.onDelete,
  });

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  bool isEditMode = false;
  late List<SubTask> editableSubTasks;

  @override
  void initState() {
    super.initState();
    editableSubTasks = List.from(widget.task.subTasks);
  }

  void _deleteSubTask(int index) async {
    final confirm = await showConfirmDialog(context, "確定要刪除這個子任務嗎？");
    if (confirm) {
      setState(() {
        editableSubTasks.removeAt(index);
      });
    }
  }

  void _saveChanges() async {
    final confirm = await showConfirmDialog(context, "是否儲存所有變更？", confirmText: "儲存");
    if (confirm) {
      if (editableSubTasks.isEmpty) {
        // 整張卡片刪除
        setState(() {
          widget.task.subTasks.clear();
        });
      } else {
        // 更新卡片內部狀態
        setState(() {
          widget.task.subTasks
            ..clear()
            ..addAll(editableSubTasks);
        });
      }
      setState(() => isEditMode = false);
    }
  }

  void _deleteTask() async {
    final confirm = await showConfirmDialog(context, "確定要刪除此拍攝主題嗎？");
    if (confirm) {
      if (widget.onDelete != null) {
        widget.onDelete!();
      } else {
        setState(() {
          widget.task.subTasks.clear();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final showAll = widget.filterTags == null || widget.filterTags!.isEmpty;
    final matchedSubTasks = showAll
        ? editableSubTasks
        : editableSubTasks.where((sub) => widget.filterTags!.contains(sub.tag)).toList();

    return widget.task.subTasks.isEmpty
        ? const SizedBox.shrink()
        : Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Colors.black87, width: 1.2),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: DefaultTextStyle(
          style: const TextStyle(color: Colors.black87),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.camera_alt_outlined, size: 20),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      widget.task.title,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 6),
                  isEditMode
                      ? IconButton(
                    icon: const Icon(Icons.save, color: Color(0xFF4A749E)),
                    onPressed: _saveChanges,
                  )
                      : PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert),
                    onSelected: (value) {
                      if (value == 'edit') {
                        setState(() {
                          isEditMode = true;
                        });
                      } else if (value == 'delete') {
                        _deleteTask();
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(value: 'edit', child: Text('編輯')),
                      const PopupMenuItem(value: 'delete', child: Text('刪除')),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  widget.task.imageUrl,
                  height: 160,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 12),
              Column(
                children: matchedSubTasks
                    .asMap()
                    .entries
                    .map((entry) => AnimatedSubTaskTile(
                  subTask: entry.value,
                  isEditMode: isEditMode,
                  onDelete: () => _deleteSubTask(entry.key),
                ))
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
  final bool isEditMode;
  final VoidCallback? onDelete;

  const AnimatedSubTaskTile({
    super.key,
    required this.subTask,
    this.isEditMode = false,
    this.onDelete,
  });

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
        Row(
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

            // 內容
            Expanded(
              child: Text(
                widget.subTask.content,
                style: const TextStyle(fontSize: 14),
              ),
            ),

            const SizedBox(width: 8),

            // tag + 展開箭頭 or ✕
            if (widget.isEditMode)
              IconButton(
                icon: const Icon(Icons.close, color: Colors.redAccent),
                onPressed: widget.onDelete,
                tooltip: '刪除子任務',
              )
            else
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
                  IconButton(
                    icon: Icon(
                      isExpanded ? Icons.expand_less : Icons.expand_more,
                      color: Colors.grey,
                    ),
                    onPressed: _toggleExpanded,
                  ),
                ],
              ),
          ],
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
                          builder: (context) => CaptureSheet(
                            subTaskId: widget.subTask.id
                          ),
                        );
                      },
                      icon: const Icon(Icons.camera_alt, size: 18),
                      label: const Text("開始拍攝任務", style: TextStyle(fontSize: 12)),
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

