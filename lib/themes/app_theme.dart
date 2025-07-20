import 'package:flutter/material.dart';

class AppTheme {
  static final Color primary = const Color(0xFF4A749E);

  static ThemeData light() {
    return ThemeData(
      useMaterial3: false,
      scaffoldBackgroundColor: Colors.white,
      primaryColor: primary,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
        iconTheme: IconThemeData(color: Colors.grey.shade800),
      ),

      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: Colors.blue,
        backgroundColor: Colors.white,
      ).copyWith(
        secondary: primary,
        primary: primary,
        surface: Colors.white,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: Colors.black87,
      ),

      textTheme: const TextTheme(
        displayLarge: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.black87),
        headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black87),
        headlineMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
        titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black87),
        bodyLarge: TextStyle(fontSize: 16, color: Colors.black87),
        bodyMedium: TextStyle(fontSize: 14, color: Colors.black54),
        labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black87),
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

      dividerColor: Colors.grey.shade300,

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(primary),
          foregroundColor: WidgetStateProperty.all(Colors.white),
          overlayColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.hovered)) {
              return primary.withOpacity(0.1);
            }
            return null;
          }),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          padding: WidgetStateProperty.all(const EdgeInsets.symmetric(vertical: 16, horizontal: 20)),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          foregroundColor: WidgetStateProperty.all(primary),
          side: WidgetStateProperty.all(BorderSide(color: primary)),
          backgroundColor: WidgetStateProperty.all(Colors.white),
          overlayColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.hovered)) {
              return Colors.grey.shade100;
            }
            return null;
          }),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          padding: WidgetStateProperty.all(const EdgeInsets.symmetric(vertical: 16, horizontal: 20)),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primary,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        ),
      ),

      chipTheme: ChipThemeData(
        backgroundColor: Colors.grey.shade200,
        disabledColor: Colors.grey.shade100,
        selectedColor: primary.withOpacity(0.2),
        secondarySelectedColor: primary,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        labelStyle: const TextStyle(color: Colors.black87),
        secondaryLabelStyle: const TextStyle(color: Colors.white),
        brightness: Brightness.light,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),

      cardTheme: CardThemeData(
        color: Colors.white,
        shadowColor: Colors.black12,
        elevation: 2,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),

      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: primary,
        linearTrackColor: Colors.grey.shade300,
      ),

      iconTheme: IconThemeData(
        color: Colors.grey.shade700,
        size: 24,
      ),

      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        iconColor: Colors.black87,
        textColor: Colors.black87,
      ),
    );
  }
}
