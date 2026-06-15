import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.background,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.surfaceVariant,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.textDark),
        centerTitle: true,
      ),
      colorScheme: ColorScheme.fromSwatch(brightness: Brightness.dark).copyWith(
        primary: AppColors.primary,
        secondary: AppColors.primary,
        surface: AppColors.surface,
        error: AppColors.error,
      ),
    );
  }
}
