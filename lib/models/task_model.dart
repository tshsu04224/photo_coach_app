import 'package:flutter/material.dart';

class SubTask {
  final IconData icon;
  final String content;
  bool isCompleted;

  SubTask({
    required this.icon,
    required this.content,
    this.isCompleted = false,
  });
}

class Task {
  final String title;
  final String description;
  final String imageAssetPath; // for mocking, will change to imageUrl later
  final List<SubTask> subTasks;

  Task({
    required this.title,
    required this.description,
    required this.imageAssetPath,
    required this.subTasks,
  });
}
