import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String text;
  final bool fromUser;

  const ChatBubble({required this.text, required this.fromUser, super.key});

  @override
  Widget build(BuildContext context) {
    final align = fromUser ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final bgColor = fromUser
        ? Theme
        .of(context)
        .colorScheme
        .primary
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
        Container(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          constraints: BoxConstraints(
            maxWidth: MediaQuery
                .of(context)
                .size
                .width * 0.7,
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
      ],
    );
  }
}