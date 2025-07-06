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

      // 文字樣式
      textTheme: const TextTheme(
        headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black87),
        bodyMedium: TextStyle(color: Colors.grey),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
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
          backgroundColor: WidgetStateProperty.all(primary),
          // hover 效果
          overlayColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.hovered)) {
              return primary.withOpacity(0.1);
            }
            return null;
          }),
          // 文字顏色
          foregroundColor: WidgetStateProperty.all(Colors.white),
          // 圓角、padding
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          padding: WidgetStateProperty.all(const EdgeInsets.symmetric(vertical: 16)),
        ),
      ),

      // OutlinedButton
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          // 預設文字+圖示色
          foregroundColor: WidgetStateProperty.all(primary),
          // 邊框色
          side: WidgetStateProperty.all(const BorderSide(color: Color(0xFFEEEEEE))),
          backgroundColor: WidgetStateProperty.all(Colors.white),
          // hover 效果
          overlayColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.hovered)) {
              return Colors.grey.shade100;
            }
            return null;
          }),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          padding: WidgetStateProperty.all(const EdgeInsets.symmetric(vertical: 16)),
        ),
      ),

      // TextButton
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: primary),
      ),
    );
  }
}