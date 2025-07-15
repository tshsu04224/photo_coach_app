import 'package:flutter/material.dart';
import 'dart:convert';

class ChatBubble extends StatelessWidget {
  final String text;
  final bool fromUser;
  final List<String>? subTopics;
  final String? moodboardUrl;

  const ChatBubble({
    required this.text,
    required this.fromUser,
    this.subTopics,
    this.moodboardUrl,
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

    return Column(
      crossAxisAlignment: align,
      children: [
        // ⬛ 文字訊息泡泡
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

        // 🟦 顯示 subTopics Chips
        if (!fromUser && subTopics != null && subTopics!.isNotEmpty)
          Container(
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.only(left: 12, right: 12, bottom: 6),
            child: Wrap(
              spacing: 8,
              runSpacing: 4,
              children: subTopics!
                  .map((topic) => Chip(
                label: Text(topic),
                backgroundColor: Colors.teal.shade50,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ))
                  .toList(),
            ),
          ),

        if (!fromUser && moodboardUrl != null)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 12),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: moodboardUrl!.startsWith('data:image')
                  ? Image.memory(
                // decode base64 string (移除前綴)
                base64Decode(moodboardUrl!.split(',').last),
                width: MediaQuery.of(context).size.width * 0.7,
              )
                  : Image.network(
                moodboardUrl!,
                width: MediaQuery.of(context).size.width * 0.7,
              ),
            ),
          ),
      ],
    );
  }
}