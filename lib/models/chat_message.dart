import 'package:flutter/material.dart';

class ChatMessage {
  final String text;
  final bool fromUser;
  final String? mainTopic;
  final List<String>? subTopics;
  final List<String>? visualKeywords;
  final String? moodboardUrl;
  final VoidCallback? onGenerateMoodboardPressed;
  final void Function(int index, String newValue)? onEditSubTopic;
  final void Function(int index)? onDeleteSubTopic;
  final VoidCallback? onUserDeclineMoodboard;
  final Map<String, dynamic>? taskGroup;
  final VoidCallback? onGenerateTasksPressed;
  final VoidCallback? onUserDeclineTasks;

  ChatMessage({
    required this.text,
    required this.fromUser,
    this.mainTopic,
    this.subTopics,
    this.visualKeywords,
    this.moodboardUrl,
    this.onGenerateMoodboardPressed,
    this.onEditSubTopic,
    this.onDeleteSubTopic,
    this.onUserDeclineMoodboard,
    this.taskGroup,
    this.onGenerateTasksPressed,
    this.onUserDeclineTasks,
  });
}
