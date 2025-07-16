// 註冊
// 這個頁面是用來讓使用者填寫個人偏好設定的
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../routes/routes.dart';

class RegisterPreferencePage extends StatefulWidget {
  const RegisterPreferencePage({super.key});

  @override
  State<RegisterPreferencePage> createState() => _RegisterPreferencePageState();
}

class _RegisterPreferencePageState extends State<RegisterPreferencePage> {
  final List<String> allPreferences = ['自然景物', '人物', '街景', '靜物', '夜景'];  // 可以再調整
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
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Column(
                        children: [
                          Image.asset(
                            'assets/images/logo.png',
                            width: 60,
                            height: 60,
                          ),
                          SizedBox(height: 10),
                          Text("個人偏好設定", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                          SizedBox(height: 4),
                          Text("請填寫下列資訊來獲得更好的使用體驗", style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    const Text("攝影偏好（可複選）"),
                    Wrap(
                      spacing: 8,
                      children: allPreferences.map((tag) {
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
                      }).toList(),
                    ),
                    const SizedBox(height: 24),

                    const Text("學習頻率"),
                    Column(
                      children: ['每天', '每三天', '每週', '每兩週'].map((freq) {
                        return RadioListTile<String>(
                          title: Text(freq),
                          value: freq,
                          groupValue: learningFrequency,
                          onChanged: (val) => setState(() => learningFrequency = val!),
                          activeColor: const Color(0xFF4A749E),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 8),

                    const Text("提醒時間"),
                    TextButton.icon(
                      onPressed: _pickTime,
                      icon: const Icon(Icons.access_time),
                      label: Text(
                        reminderTime.format(context),
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // 實際上可傳送偏好資料給後端
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
