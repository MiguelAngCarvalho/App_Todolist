import 'package:flutter/material.dart';

import 'package:app_todolist/app/app_theme.dart';
import 'package:app_todolist/pages/main_page.dart';
import 'package:app_todolist/app/app_routes.dart';
import 'package:app_todolist/pages/add_task_page.dart';

class AppToDoList extends StatelessWidget {
  const AppToDoList({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Todo List',
      theme: AppTheme.light(),

      initialRoute: AppRoutes.homePage, // Rota inicial para a página inicial
      routes: {
        AppRoutes.homePage: (context) =>
            const HomePage(), // Definindo a rota para HomePage
        AppRoutes.addTask: (context) =>
            const AddTask(), // Definindo a rota para AddTask
      },
    );
  }
}
