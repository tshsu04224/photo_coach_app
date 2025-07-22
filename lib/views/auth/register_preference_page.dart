// 使用者填寫個人偏好設定
import 'package:flutter/material.dart';
import '../../routes/routes.dart';

class RegisterPreferencePage extends StatefulWidget {
  const RegisterPreferencePage({super.key});

  @override
  State<RegisterPreferencePage> createState() => _RegisterPreferencePageState();
}

class _RegisterPreferencePageState extends State<RegisterPreferencePage> {
  final List<String> allPreferences = ['自然景物', '人物', '街景', '靜物', '夜景'];
  final List<String> selectedPreferences = [];

  String learningFrequency = '每天';
  TimeOfDay reminderTime = const TimeOfDay(hour: 9, minute: 0);

  void _togglePreference(String tag) {
    setState(() {
      if (selectedPreferences.contains(tag)) {
        selectedPreferences.remove(tag);
      } else {
        selectedPreferences.add(tag);
      }
    });
  }

  void _addNewPreference() async {
    final controller = TextEditingController();
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("新增攝影主題"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: "輸入攝影主題"),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("取消")),
          TextButton(onPressed: () => Navigator.pop(context, controller.text.trim()), child: const Text("新增")),
        ],
      ),
    );
    if (result != null && result.isNotEmpty && !allPreferences.contains(result)) {
      setState(() {
        allPreferences.add(result);
        selectedPreferences.add(result);
      });
    }
  }

  void _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: reminderTime,
    );
    if (picked != null) {
      setState(() {
        reminderTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: const BackButton(), elevation: 0),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/logo.png',
                    width: 60,
                    height: 60,
                  ),
                  const SizedBox(height: 10),
                  const Text("個人偏好設定", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  const Text("請填寫下列資訊來獲得更好的使用體驗", style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
            const Divider(),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("攝影偏好（可複選）"),
                    Wrap(
                      spacing: 8,
                      children: [
                        ...allPreferences.map((tag) {
                          final selected = selectedPreferences.contains(tag);
                          return FilterChip(
                            label: Text(tag),
                            selected: selected,
                            onSelected: (_) => _togglePreference(tag),
                            selectedColor: const Color(0xFF4A749E).withOpacity(0.2),
                            checkmarkColor: const Color(0xFF4A749E),
                            labelStyle: TextStyle(
                              color: selected ? const Color(0xFF4A749E) : Colors.black,
                            ),
                          );
                        }),
                        // 新增主題按鈕
                        ActionChip(
                          label: const Text("＋新增主題"),
                          onPressed: _addNewPreference,
                          backgroundColor: Colors.grey.shade200,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    const Text("學習頻率"),
                    Column(
                      children: ['每天', '每三天', '每週', '每兩週', '先不用'].map((freq) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: RadioListTile<String>(
                            title: Text(freq),
                            value: freq,
                            groupValue: learningFrequency,
                            onChanged: (val) => setState(() => learningFrequency = val!),
                            activeColor: const Color(0xFF4A749E),
                            contentPadding: EdgeInsets.zero,
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),

                    const Text("提醒時間"),
                    TextButton.icon(
                      onPressed: _pickTime,
                      icon: const Icon(Icons.access_time),
                      label: Text(
                        reminderTime.format(context),
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),

            // 完成註冊按鈕
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, Routes.home);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4A749E),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text("完成註冊"),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 進度條貼底
            Column(
              children: [
                LinearProgressIndicator(
                  value: 1.0,
                  backgroundColor: Colors.grey.shade300,
                  valueColor: const AlwaysStoppedAnimation(Color(0xFF4A749E)),
                  minHeight: 6,
                ),
                const SizedBox(height: 4),
              ],
            ),
          ],
        ),
      ),
    );
  }
}