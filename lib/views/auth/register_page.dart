import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../routes/routes.dart';
import '../../controllers/auth_controller.dart';

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
  bool _isLoading = false;
  String? _errorMessage;

  void _pickDate() async {
    final DateTime now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(1900),
      lastDate: now,
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _handleNext() async {
    final lastName = _lastNameController.text.trim();
    final firstName = _firstNameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if ([lastName, firstName, email, password, confirmPassword].any((e) => e.isEmpty) || _selectedDate == null) {
      setState(() => _errorMessage = '請完整填寫所有欄位');
      return;
    }

    if (password != confirmPassword) {
      setState(() => _errorMessage = '密碼與確認密碼不一致');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    final username = '$lastName $firstName';
    // 呼叫 AuthController 註冊
    final auth = Provider.of<AuthController>(context, listen: false);
    final success = await auth.register(username, email, password);

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (success) {
      Navigator.pushNamed(context, Routes.registerPreferences);
    } else {
      setState(() => _errorMessage = '註冊失敗，請確認資料');
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
                          Image.asset('assets/images/logo.png', width: 60, height: 60),
                          const SizedBox(height: 8),
                          const Text("歡迎！", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          const Text("請填寫下列資訊來完成註冊", style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // 姓名
                    Row(
                      children: [
                        Expanded(child: TextField(controller: _lastNameController, decoration: const InputDecoration(labelText: '姓氏'))),
                        const SizedBox(width: 16),
                        Expanded(child: TextField(controller: _firstNameController, decoration: const InputDecoration(labelText: '名字'))),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // 信箱
                    TextField(controller: _emailController, decoration: const InputDecoration(labelText: '信箱'), keyboardType: TextInputType.emailAddress),
                    const SizedBox(height: 16),

                    // 生日
                    TextField(
                      readOnly: true,
                      onTap: _pickDate,
                      decoration: InputDecoration(
                        labelText: '生日',
                        suffixIcon: const Icon(Icons.calendar_today),
                        hintText: _selectedDate == null ? '選擇日期' : DateFormat('yyyy-MM-dd').format(_selectedDate!),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // 密碼
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

                    // 確認密碼
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
                    const SizedBox(height: 12),

                    if (_errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
                      ),
                  ],
                ),
              ),
            ),

            // 下一步
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleNext,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4A749E),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: _isLoading
                      ? const SizedBox(height: 22, width: 22, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Text("下一步"),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 進度條
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
