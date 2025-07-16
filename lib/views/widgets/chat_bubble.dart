import 'package:flutter/material.dart';
import 'dart:convert';

class ChatBubble extends StatelessWidget {
  final String text;
  final bool fromUser;
  final List<String>? subTopics;
  final String? moodboardUrl;
  final void Function(int index, String newValue)? onEditSubTopic;
  final void Function(int index)? onDeleteSubTopic;
  final VoidCallback? onGenerateMoodboardPressed;
  final VoidCallback? onUserDeclineMoodboard;

  const ChatBubble({
    required this.text,
    required this.fromUser,
    this.subTopics,
    this.moodboardUrl,
    this.onEditSubTopic,
    this.onDeleteSubTopic,
    this.onGenerateMoodboardPressed,
    this.onUserDeclineMoodboard,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final align = fromUser ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final bgColor = fromUser
        ? Theme.of(context).colorScheme.primary
        : Colors.grey.shade100;
    final textColor = fromUser ? Colors.white : Colors.black87;
    final radius = fromUser
        ? const BorderRadius.only(
      topLeft: Radius.circular(16),
      topRight: Radius.circular(16),
      bottomLeft: Radius.circular(16),
      bottomRight: Radius.circular(0),
    )
        : const BorderRadius.only(
      topLeft: Radius.circular(16),
      topRight: Radius.circular(16),
      bottomLeft: Radius.circular(0),
      bottomRight: Radius.circular(16),
    );

    if (!fromUser && text == "生成中...") {
      return Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: const [
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            SizedBox(width: 12),
            Text("生成中...", style: TextStyle(fontSize: 16)),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: align,
      children: [
        // 文字訊息泡泡
        Container(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.7,
          ),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: radius,
          ),
          child: Text(
            text,
            style: TextStyle(color: textColor, fontSize: 16),
          ),
        ),

        // 顯示 subTopics Chips
        if (!fromUser && subTopics != null && subTopics!.isNotEmpty)
          Container(
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.only(left: 12, right: 12, bottom: 6),
            child: Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                // 原本的 chips
                ...List.generate(subTopics!.length, (index) {
                  final topic = subTopics![index];
                  return GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (_) {
                          final controller = TextEditingController(text: topic);
                          return AlertDialog(
                            title: const Text('編輯主題'),
                            content: TextField(
                              controller: controller,
                              decoration: const InputDecoration(
                                hintText: '輸入新的主題內容',
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context); // 關閉 dialog
                                  if (onDeleteSubTopic != null) {
                                    onDeleteSubTopic!(index);
                                  }
                                },
                                child: const Text('刪除', style: TextStyle(color: Colors.red)),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context); // 關閉 dialog
                                  if (onEditSubTopic != null) {
                                    onEditSubTopic!(index, controller.text.trim());
                                  }
                                },
                                child: const Text('確定'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Chip(
                      label: Text(topic),
                      backgroundColor: Colors.teal.shade50,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  );
                }),

                // 新增主題 chip
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (_) {
                        final controller = TextEditingController();
                        return AlertDialog(
                          title: const Text('新增主題'),
                          content: TextField(
                            controller: controller,
                            decoration: const InputDecoration(
                              hintText: '輸入新的主題內容',
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('取消'),
                            ),
                            TextButton(
                              onPressed: () {
                                final newValue = controller.text.trim();
                                if (newValue.isNotEmpty && onEditSubTopic != null) {
                                  onEditSubTopic!(subTopics!.length, newValue); // 新增到最後
                                }
                                Navigator.pop(context);
                              },
                              child: const Text('新增'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Chip(
                    label: const Text('＋'),
                    backgroundColor: Colors.grey.shade200,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                )
              ],
            ),
          ),
        // 顯示 moodboard 並可放大預覽
        if (!fromUser && moodboardUrl != null)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 12),
            child: GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (_) => Dialog(
                    child: InteractiveViewer(
                      child: moodboardUrl!.startsWith('data:image')
                          ? Image.memory(
                        base64Decode(moodboardUrl!.split(',').last),
                      )
                          : Image.network(moodboardUrl!),
                    ),
                  ),
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: moodboardUrl!.startsWith('data:image')
                    ? Image.memory(
                  base64Decode(moodboardUrl!.split(',').last),
                  width: MediaQuery.of(context).size.width * 0.7,
                )
                    : Image.network(
                  moodboardUrl!,
                  width: MediaQuery.of(context).size.width * 0.7,
                ),
              ),
            ),
          ),

        if (!fromUser && onGenerateMoodboardPressed != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                if (onGenerateMoodboardPressed != null)
                  ElevatedButton(
                    onPressed: onGenerateMoodboardPressed,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      minimumSize: const Size(0, 36),
                      textStyle: const TextStyle(fontSize: 14),
                      backgroundColor: const Color(0xFF4A749E),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text("生成風格參考圖"),
                  ),
                if (onUserDeclineMoodboard != null) ...[
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: onUserDeclineMoodboard,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      minimumSize: const Size(0, 36),
                      textStyle: const TextStyle(fontSize: 14),
                      backgroundColor: Colors.grey,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text("這次不要"),
                  ),
                ],
              ],
            ),
          )
      ],
    );
  }
}