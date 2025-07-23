import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _obscurePassword = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Page title
              Row(
                children: [
                  Image.asset(
                    'assets/images/logo.png',
                    width: 32,
                    height: 32,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'PhotoCoach',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              // Page header
              Text(
                '登入',
                style: textTheme.headlineLarge,
              ),
              const SizedBox(height: 8),
              Text(
                '請輸入信箱以登入',
                style: textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),

              // Email field
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: '信箱',
                ),
              ),
              const SizedBox(height: 16),

              // Password field
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: '密碼',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // Forgot password
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    // TODO: implement forgot password flow
                  },
                  child: const Text('忘記密碼？'),
                ),
              ),
              const SizedBox(height: 16),

              // Login button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: implement login action
                  },
                  child: const Text('登入'),
                ),
              ),
              const SizedBox(height: 24),

              // Divider
              Row(
                children: const [
                  Expanded(child: Divider()),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text('OR'),
                  ),
                  Expanded(child: Divider()),
                ],
              ),
              const SizedBox(height: 24),

              // Google Sign-In Button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  icon: Image.asset(
                    'assets/images/google_logo.png',
                    width: 24,
                    height: 24,
                  ),
                  label: const Text('透過 Google 登入'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.black,       // 文字、圖示顏色
                    side: BorderSide(color: Colors.grey.shade300),// 邊框顏色
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () {
                    // TODO: implement Google sign-in
                  },
                ),
              ),
              const SizedBox(height: 16),

              // Facebook Sign-In Button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  icon: Image.asset(
                    'assets/images/facebook_logo.png',
                    width: 24,
                    height: 24,
                  ),
                  label: const Text('透過 Facebook 登入'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.black,       // 文字、圖示顏色
                    side: BorderSide(color: Colors.grey.shade300),// 邊框顏色
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () {
                    // TODO: implement Facebook sign-in
                  },
                ),
              ),
              const SizedBox(height: 32),

              // Signup prompt
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('沒有帳號嗎？'),
                  TextButton(
                    onPressed: () {
                      // TODO: navigate to sign-up page
                    },
                    child: const Text('註冊'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}