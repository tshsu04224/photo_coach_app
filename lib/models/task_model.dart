import 'package:flutter/material.dart';

class SubTask {
  final String content;
  final String tag;
  final IconData icon;
  final String suggestedPosition;
  final String lightingCondition;
  final String shootingTechnique;
  final String recommendedTime;
  bool isCompleted;

  SubTask({
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
  final String title; // 使用者輸入的主題
  final String imageUrl; // 封面圖片
  final List<SubTask> subTasks;

  Task({
    required this.title,
    required this.imageUrl,
    required this.subTasks,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      title: json['title'] ?? '',
      imageUrl: json['image_url'] ?? '',
      subTasks: (json['sub_tasks'] as List<dynamic>?)
          ?.map((e) => SubTask.fromJson(e))
          .toList() ??
          [],
    );
  }
}
