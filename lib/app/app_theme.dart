import 'package:app_todolist/app/app_colors.dart';
import 'package:flutter/material.dart';

abstract class AppTheme {
  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primaryColor,
        secondary: AppColors.secondaryColor,
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: AppColors.textPrimary),
        bodyMedium: TextStyle(color: AppColors.textSecondary),
        titleLarge: TextStyle(
          fontSize: 20.0,
          fontFamily: 'RobotoCondensed',
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
        titleSmall: TextStyle(fontSize: 14, color: AppColors.textPrimary),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.accentColor,
        titleTextStyle: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 20.0,
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.accentColor,
      ),
      iconTheme: const IconThemeData(color: AppColors.primaryColor),
      scaffoldBackgroundColor: AppColors.backgroundColor,
    );
  }
}
