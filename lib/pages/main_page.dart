import 'package:cloud_firestore/cloud_firestore.dart'; 
import 'package:flutter/material.dart';
import 'package:app_todolist/widgets/task_widget.dart';
import 'package:app_todolist/pages/add_task_page.dart'; 
import 'package:app_todolist/pages/edit_task.dart';
import 'package:intl/intl.dart'; 

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, String>> tasks = []; 
  String _selectedCategory = 'Todos';

  @override
  void initState() {
    super.initState();
    _loadTasksFromFirebase(); 
  }

  Future<void> _loadTasksFromFirebase() async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      QuerySnapshot snapshot = await firestore.collection('tasks').get();

      setState(() {
        tasks = snapshot.docs.map((doc) {
          return {
            'task': doc['task'] as String,
            'description': doc['description'] as String,
            'date': doc['date'] as String,
            'list': doc['list'] as String,
          };
        }).toList();
      });
    } catch (e) {
      print("Erro ao carregar tarefas do Firebase: $e");
    }
  }

  Future<void> _deleteTaskFromFirebase(String taskId) async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      await firestore.collection('tasks').doc(taskId).delete();
    } catch (e) {
      print("Erro ao excluir tarefa do Firebase: $e");
    }
  }

  void _deleteTask(int index) {
    String taskId = tasks[index]['taskId']!; 
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar Exclusão'),
          content: const Text('Tem certeza que deseja excluir esta tarefa?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); 
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () async {
                await _deleteTaskFromFirebase(taskId); 
                setState(() {
                  tasks.removeAt(index); 
                });
                Navigator.pop(context); 
              },
              child: const Text('Excluir'),
            ),
          ],
        );
      },
    );
  }

  List<Map<String, String>> _filterTasks() {
    if (_selectedCategory == 'Todos') {
      return tasks; 
    }
    return tasks
        .where((task) => task['list'] == _selectedCategory)
        .toList(); 
  }

  List<Map<String, String>> _sortTasksByDate(
      List<Map<String, String>> taskList) {
    final DateFormat dateFormat =
        DateFormat("dd/MM/yy"); 

    taskList.sort((a, b) {
      DateTime dateA =
          dateFormat.parse(a['date']!); 
      DateTime dateB =
          dateFormat.parse(b['date']!); 
      return dateA.compareTo(dateB); 
    });

    return taskList;
  }

  void _navigateToAddTask(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddTask(), 
      ),
    );

    if (result != null && result is Map<String, String>) {
      await _addTaskToFirebase(result);

      setState(() {
        tasks.add(Map<String, String>.from(result)); 
      });
    }
  }

  Future<void> _addTaskToFirebase(Map<String, String> task) async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      await firestore.collection('tasks').add({
        'task': task['task'],
        'description': task['description'],
        'date': task['date'],
        'list': task['list']
      });
    } catch (e) {
      print("Erro ao adicionar tarefa no Firebase: $e");
    }
  }

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
        ), 
      ),
    );

    if (result != null && result is Map<String, String>) {
      await _updateTaskInFirebase(task['taskId']!, result);

      setState(() {
        tasks[index] = Map<String, String>.from(result); 
      });
    }
  }

  Future<void> _updateTaskInFirebase(
      String taskId, Map<String, String> task) async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      await firestore.collection('tasks').doc(taskId).update({
        'task': task['task'],
        'description': task['description'],
        'date': task['date'],
        'list': task['list']
      });
    } catch (e) {
      print("Erro ao atualizar tarefa no Firebase: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> filteredTasks = _filterTasks();
    List<Map<String, String>> sortedTasks = _sortTasksByDate(filteredTasks);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        actionsIconTheme: Theme.of(context).iconTheme,
        title: const Text('Página Principal'),
        centerTitle: true,
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
