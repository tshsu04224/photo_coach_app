import 'package:flutter/material.dart';

class ChatMessage {
  final String text;
  final bool fromUser; // true = 使用者, false = AI （誰發訊息）
  final List<String>? subTopics;
  final List<String>? visualKeywords;
  final String? moodboardUrl;
  final VoidCallback? onGenerateMoodboardPressed;
  final void Function(int index, String newValue)? onEditSubTopic;
  final void Function(int index)? onDeleteSubTopic;
  final VoidCallback? onUserDeclineMoodboard;

  ChatMessage({
    required this.text,
    required this.fromUser,
    this.subTopics,
    this.visualKeywords,
    this.moodboardUrl,
    this.onGenerateMoodboardPressed,
    this.onEditSubTopic,
    this.onDeleteSubTopic,
    this.onUserDeclineMoodboard,
  });
}