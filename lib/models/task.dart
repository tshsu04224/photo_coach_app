import 'package:flutter/material.dart';


class SubTask {
  final int id;
  final String content;
  final String tag;
  final IconData icon;
  final String suggestedPosition;
  final String lightingCondition;
  final String shootingTechnique;
  final String recommendedTime;
  bool isCompleted;

  SubTask({
    required this.id,
    required this.content,
    required this.tag,
    required this.icon,
    required this.suggestedPosition,
    required this.lightingCondition,
    required this.shootingTechnique,
    required this.recommendedTime,
    this.isCompleted = false,
  });

  factory SubTask.fromJson(Map<String, dynamic> json) {
    return SubTask(
      id: (json['id'] is int) ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      content: json['content'] ?? '',
      tag: json['tag'] ?? '',
      icon: Icons.circle, // 或根據 tag 決定不同 icon
      suggestedPosition: json['suggested_position'] ?? '',
      lightingCondition: json['lighting_condition'] ?? '',
      shootingTechnique: json['shooting_technique'] ?? '',
      recommendedTime: json['recommended_time'] ?? '',
    );
  }
}

class Task {
  final int id;
  final String title; // 使用者輸入的主題
  final String imageUrl; // 封面圖片
  final List<SubTask> subTasks;
  final DateTime date; // 任務日期

  Task({
    required this.id,
    required this.title,
    this.imageUrl = "assets/images/example.webp", // 預設圖片
    required this.subTasks,
    required this.date,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['main_topic'] ?? '',
      // imageUrl: json['image_url'] ?? '',
      subTasks: (json['subtasks'] as List<dynamic>?)
          ?.map((e) => SubTask.fromJson(e))
          .toList() ??
          [],
      date: DateTime.parse(json['created_at']),
    );
  }
}
