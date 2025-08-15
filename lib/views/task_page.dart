import 'package:flutter/material.dart';

class TaskPage extends StatelessWidget {
  const TaskPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('任務頁面'),
        automaticallyImplyLeading: false,
      ),
      body: const Center(
        child: Text(
          '這是測試用的任務頁面',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}