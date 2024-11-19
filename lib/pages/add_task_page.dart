import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Task {
  final String task;
  final String description;
  final String date;
  final String list;

  Task({
    required this.task,
    required this.description,
    required this.date,
    required this.list,
  });

  Map<String, String> json() {
    return {
      'task': task,
      'description': description,
      'date': date,
      'list': list,
    };
  }
}

class AddTask extends StatefulWidget {
  const AddTask({super.key});

  @override
  _AddTaskState createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  DateTime? _selectedDate;
  String _selectedList = 'Padrão';
  final List<String> _availableLists = [
    'Padrão',
    'Trabalho',
    'Pessoal',
    'Estudos'
  ];

  final TextEditingController _taskController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String labelText,
    required String? Function(String?) validator,
    required IconData icon,
    bool readOnly = false,
    Function()? onTap,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      onTap: onTap,
      cursorColor: Theme.of(context).iconTheme.color,
      decoration: InputDecoration(
        labelStyle: Theme.of(context).textTheme.titleMedium,
        labelText: labelText,
        suffixIcon: Icon(icon, color: Theme.of(context).iconTheme.color),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).iconTheme.color!),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).iconTheme.color!),
        ),
      ),
      validator: validator,
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  void _saveTask() async {
    if (_formKey.currentState?.validate() ?? false) {
      String taskTitle = _taskController.text;
      String description = _descriptionController.text;
      String formattedDate = _selectedDate != null
          ? DateFormat('dd/MM/yyyy').format(_selectedDate!)
          : 'Sem data';

      Task task = Task(
        task: taskTitle,
        description: description,
        date: formattedDate,
        list: _selectedList,
      );

      try {
        const url =
            'https://todoapplist-fea55-default-rtdb.firebaseio.com/task.json';
        final response = await http.post(
          Uri.parse(url),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(task.json()),
        );

        if (response.statusCode == 200) {
          if (mounted) {
            Navigator.pop(context, task.json());
          }
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content:
                    Text('Erro ao salvar a tarefa: ${response.statusCode}'),
              ),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro ao salvar a tarefa: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Theme.of(context).iconTheme.color,
        ),
        title: const Text('Nova tarefa'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextFormField(
                controller: _taskController,
                labelText: 'O que deve ser feito?',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'O título da tarefa é obrigatório.';
                  }
                  return null;
                },
                icon: Icons.check,
              ),
              const SizedBox(height: 20),
              _buildTextFormField(
                controller: _descriptionController,
                labelText: 'Descrição',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'A descrição é obrigatória.';
                  }
                  return null;
                },
                icon: Icons.description,
              ),
              const SizedBox(height: 20),
              _buildTextFormField(
                controller: TextEditingController(
                  text: _selectedDate != null
                      ? DateFormat('dd/MM/yyyy').format(_selectedDate!)
                      : '',
                ),
                labelText: 'Data da Tarefa',
                readOnly: true,
                onTap: () => _selectDate(context),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'A data é obrigatória.';
                  }
                  return null;
                },
                icon: Icons.calendar_today,
              ),
              const SizedBox(height: 20),
              Text(
                'Adicionar à lista:',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DropdownButton<String>(
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    value: _selectedList,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedList = newValue!;
                      });
                    },
                    items: _availableLists
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  Icon(Icons.list,
                      size: 30, color: Theme.of(context).iconTheme.color),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _saveTask,
        child: const Icon(Icons.check),
      ),
    );
  }
}
