// 註冊頁面
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../routes/routes.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _lastNameController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  DateTime? _selectedDate;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  void _pickDate() async {
    DateTime now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(2000),
      lastDate: now,
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
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
                          SizedBox(height: 8),
                          Text("歡迎！", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                          SizedBox(height: 4),
                          Text("請填寫下列資訊來完成註冊", style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _lastNameController,
                            decoration: const InputDecoration(labelText: '姓氏'),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextField(
                            controller: _firstNameController,
                            decoration: const InputDecoration(labelText: '名字'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    TextField(
                      controller: _emailController,
                      decoration: const InputDecoration(labelText: '信箱'),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),

                    TextField(
                      readOnly: true,
                      onTap: _pickDate,
                      decoration: InputDecoration(
                        labelText: '生日',
                        suffixIcon: const Icon(Icons.calendar_today),
                        hintText: _selectedDate == null
                            ? '選擇日期'
                            : DateFormat('yyyy-MM-dd').format(_selectedDate!),
                      ),
                    ),
                    const SizedBox(height: 16),

                    TextField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        labelText: '密碼',
                        suffixIcon: IconButton(
                          icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    TextField(
                      controller: _confirmPasswordController,
                      obscureText: _obscureConfirmPassword,
                      decoration: InputDecoration(
                        labelText: '確認密碼',
                        suffixIcon: IconButton(
                          icon: Icon(_obscureConfirmPassword ? Icons.visibility_off : Icons.visibility),
                          onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 下一步按鈕
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, Routes.registerPreferences);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4A749E),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text("下一步"),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 底部進度條
            Column(
              children: [
                LinearProgressIndicator(
                  value: 0.5,
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