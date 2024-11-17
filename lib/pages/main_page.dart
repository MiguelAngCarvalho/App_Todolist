import 'package:flutter/material.dart';
import 'package:app_todolist/widgets/task_widget.dart';
import 'package:app_todolist/pages/add_task_page.dart'; // Importando a página de adicionar tarefa
import 'package:app_todolist/pages/edit_task.dart'; // Importando a página de editar tarefa
import 'package:intl/intl.dart'; // Importando a biblioteca intl

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, String>> tasks = [];
  String _selectedCategory = 'Todos'; // Filtro para a categoria

  // Função para excluir uma tarefa
  void _deleteTask(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar Exclusão'),
          content: const Text('Tem certeza que deseja excluir esta tarefa?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Fecha o diálogo
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () {
                setState(() {
                  tasks.removeAt(index); // Remove a tarefa
                });
                Navigator.pop(context); // Fecha o diálogo
              },
              child: const Text('Excluir'),
            ),
          ],
        );
      },
    );
  }

  // Função para filtrar as tarefas pela categoria
  List<Map<String, String>> _filterTasks() {
    if (_selectedCategory == 'Todos') {
      return tasks; // Se a categoria for "Todos", retorna todas as tarefas
    }
    return tasks
        .where((task) => task['list'] == _selectedCategory)
        .toList(); // Filtra pelas tarefas da categoria selecionada
  }

  // Função para ordenar as tarefas por data
  List<Map<String, String>> _sortTasksByDate(
      List<Map<String, String>> taskList) {
    final DateFormat dateFormat =
        DateFormat("dd/MM/yy"); // Definindo o formato da data

    taskList.sort((a, b) {
      DateTime dateA =
          dateFormat.parse(a['date']!); // Converte a data para DateTime
      DateTime dateB =
          dateFormat.parse(b['date']!); // Converte a data para DateTime
      return dateA.compareTo(dateB); // Ordena as tarefas pela data
    });

    return taskList;
  }

  // Navegar para a tela de adicionar tarefa
  void _navigateToAddTask(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddTask(), // Chamando a página de adicionar
      ),
    );

    if (result != null && result is Map<String, String>) {
      setState(() {
        tasks.add(Map<String, String>.from(result)); // Adiciona nova tarefa
      });
    }
  }

  // Navegar para a tela de editar tarefa
  void _navigateToEditTask(
      BuildContext context, Map<String, String> task, int index) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditTask(
          task: task['task']!,
          description: task['description']!,
          date: task['date']!,
          list: task['list']!,
        ), // Chamando a página de edição
      ),
    );

    if (result != null && result is Map<String, String>) {
      setState(() {
        tasks[index] = Map<String, String>.from(result); // Atualiza a tarefa
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Filtra as tarefas conforme a categoria e ordena pela data
    List<Map<String, String>> filteredTasks = _filterTasks();
    List<Map<String, String>> sortedTasks = _sortTasksByDate(filteredTasks);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        actionsIconTheme: Theme.of(context).iconTheme,
        title: const Text('Página Principal'),
        centerTitle: true,
        // Filtro no AppBar
        actions: [
          PopupMenuButton<String>(
            onSelected: (String selectedCategory) {
              setState(() {
                _selectedCategory = selectedCategory;
              });
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem<String>(
                  value: 'Todos',
                  child: Text('Todas as Tarefas'),
                ),
                const PopupMenuItem<String>(
                  value: 'Trabalho',
                  child: Text('Trabalho'),
                ),
                const PopupMenuItem<String>(
                  value: 'Pessoal',
                  child: Text('Pessoal'),
                ),
                const PopupMenuItem<String>(
                  value: 'Estudos',
                  child: Text('Estudos'),
                ),
              ];
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: sortedTasks.length,
        itemBuilder: (context, index) {
          return TaskWidget(
            task: sortedTasks[index]['task']!,
            description: sortedTasks[index]['description']!,
            date: sortedTasks[index]['date']!,
            list: sortedTasks[index]['list']!,
            onDelete: () => _deleteTask(index),
            onEdit: () =>
                _navigateToEditTask(context, sortedTasks[index], index),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _navigateToAddTask(context);
        },
        tooltip: 'Adicionar Tarefa',
        backgroundColor:
            Theme.of(context).floatingActionButtonTheme.backgroundColor,
        child: const Icon(Icons.add),
      ),
    );
  }
}
