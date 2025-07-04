import 'package:flutter/material.dart';

class AppTheme {
  static final Color primary = Color(0xFF4A749E);
  static ThemeData light() {
    return ThemeData(
      useMaterial3: false,
      scaffoldBackgroundColor: Colors.white,
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: Colors.blue,
      ).copyWith(
        secondary: primary,
      ),

      // 全局文字樣式，讓大標題 '登入' 是深灰／黑
      textTheme: const TextTheme(
        headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black87),
        bodyMedium: TextStyle(color: Colors.grey),
      ),

      // 輸入框邊框、浮水印、Label 都套同一個主題
      inputDecorationTheme: InputDecorationTheme(
        filled: true,                    // 如果想要淺色背景可以打開
        fillColor: Colors.white,         // 也可以改成 Colors.grey.shade50
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        labelStyle: TextStyle(color: Colors.grey.shade600),
        hintStyle: TextStyle(color: Colors.grey.shade400),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: primary),
          borderRadius: BorderRadius.circular(8),
        ),
      ),

      // Divider 顏色
      dividerColor: Colors.grey.shade300,

      // ElevatedButton 主色 & 圓角
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          // 按鈕底色
          backgroundColor: MaterialStateProperty.all(primary),
          // 滑鼠懸浮時改變底色透明度
          overlayColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.hovered)) {
              return primary.withOpacity(0.1);
            }
            // 點擊時的 splash 可以保持預設
            return null;
          }),
          // 文字顏色
          foregroundColor: MaterialStateProperty.all(Colors.white),
          // 圓角、padding
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          padding: MaterialStateProperty.all(const EdgeInsets.symmetric(vertical: 16)),
        ),
      ),

      // OutlinedButton：邊框灰、字色主色
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          // 預設文字+圖示色
          foregroundColor: MaterialStateProperty.all(primary),
          // 邊框色
          side: MaterialStateProperty.all(const BorderSide(color: Color(0xFFEEEEEE))),
          backgroundColor: MaterialStateProperty.all(Colors.white),
          // hover 時把背景刷成淺灰
          overlayColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.hovered)) {
              return Colors.grey.shade100;
            }
            return null;
          }),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          padding: MaterialStateProperty.all(const EdgeInsets.symmetric(vertical: 16)),
        ),
      ),

      // TextButton (“忘記密碼？註冊”)
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: primary),
      ),
    );
  }
}