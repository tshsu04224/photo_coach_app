import 'package:flutter/material.dart';

class SubTask {
  final String content;
  final String tag;
  final IconData icon;
  bool isCompleted;

  SubTask({
    required this.content,
    required this.tag,
    required this.icon,
    this.isCompleted = false,
  });

  factory SubTask.fromJson(Map<String, dynamic> json) {
    return SubTask(
      content: json['content'] ?? '',
      tag: json['tag'] ?? '',
      icon: Icons.circle,
    );
  }
}

class Task {
  final String title;
  final String description;
  final String imageUrl;
  final List<SubTask> subTasks;

  Task({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.subTasks,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      title: json['sub_topic'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['image_url'] ?? '',
      subTasks: (json['sub_tasks'] as List<dynamic>?)
          ?.map((e) => SubTask.fromJson(e))
          .toList() ??
          [],
    );
  }
}
