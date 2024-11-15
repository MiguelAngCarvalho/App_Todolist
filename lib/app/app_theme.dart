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

      // Estilos de texto
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: AppColors.textPrimary), // Texto primário
        bodyMedium:
            TextStyle(color: AppColors.textSecondary), // Texto secundário
        titleLarge: TextStyle(
          fontSize: 20.0,
          fontFamily: 'RobotoCondensed', // Fonte personalizada
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),

        //Textos Widget add_task
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: AppColors.secondaryColor,
        ),
        titleSmall: TextStyle(fontSize: 14, color: AppColors.textPrimary),
      ),

      // Estilo do AppBar
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.accentColor, // Cor do AppBar
        titleTextStyle: TextStyle(
          color: AppColors.textPrimary, // Cor do título do AppBar
          fontSize: 20.0,
        ),
      ),

      // Estilo do FloatingActionButton
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor:
            AppColors.accentColor, // Cor de fundo do botão flutuante
      ),

      // Definir o tema de ícones
      iconTheme:
          const IconThemeData(color: AppColors.textPrimary), // Cor dos ícones

      // Definir a cor do fundo da tela (Scaffold)
      scaffoldBackgroundColor:
          AppColors.backgroundColor, // Cor de fundo do Scaffold
    );
  }
}
