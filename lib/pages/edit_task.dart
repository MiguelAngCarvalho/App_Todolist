import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EditTask extends StatefulWidget {
  final String task;
  final String description;
  final String date;
  final String list;

  const EditTask({
    super.key,
    required this.task,
    required this.description,
    required this.date,
    required this.list,
  });

  @override
  _EditTaskState createState() => _EditTaskState();
}

class _EditTaskState extends State<EditTask> {
  late TextEditingController _taskController;
  late TextEditingController _descriptionController;
  late DateTime? _selectedDate;
  late String _selectedList;

  final List<String> _availableLists = [
    'Padrão',
    'Trabalho',
    'Pessoal',
    'Estudos'
  ];

  @override
  void initState() {
    super.initState();
    _taskController = TextEditingController(text: widget.task);
    _descriptionController = TextEditingController(text: widget.description);
    _selectedDate = widget.date.isNotEmpty
        ? DateFormat('dd/MM/yyyy').parse(widget.date)
        : null;
    _selectedList = widget.list;
  }

  @override
  void dispose() {
    _taskController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  void _saveTask() {
    String task = _taskController.text;
    String description = _descriptionController.text;
    String formattedDate = _selectedDate != null
        ? DateFormat('dd/MM/yyyy').format(_selectedDate!)
        : 'Sem data';

    Navigator.pop(
      context,
      {
        'task': task,
        'description': description,
        'date': formattedDate,
        'list': _selectedList,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Theme.of(context).iconTheme.color,
        ),
        title: const Text('Editar Tarefa'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              cursorColor: Theme.of(context).iconTheme.color,
              controller: _taskController,
              decoration: InputDecoration(
                labelStyle: Theme.of(context).textTheme.titleMedium,
                labelText: 'O que deve ser feito?',
                suffixIcon:
                    Icon(Icons.check, color: Theme.of(context).iconTheme.color),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              cursorColor: Theme.of(context).iconTheme.color,
              controller: _descriptionController,
              decoration: InputDecoration(
                labelStyle: Theme.of(context).textTheme.titleMedium,
                labelText: 'Descrição',
                suffixIcon: Icon(Icons.description,
                    color: Theme.of(context).iconTheme.color),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              readOnly: true,
              onTap: () => _selectDate(context),
              decoration: InputDecoration(
                labelStyle: Theme.of(context).textTheme.titleMedium,
                labelText: 'Data da Tarefa',
                suffixIcon: Icon(Icons.calendar_today,
                    color: Theme.of(context).iconTheme.color),
              ),
              controller: TextEditingController(
                text: _selectedDate != null
                    ? DateFormat('dd/MM/yyyy').format(_selectedDate!)
                    : '',
              ),
            ),
            const SizedBox(height: 20),
            DropdownButton<String>(
              value: _selectedList,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedList = newValue!;
                });
              },
              items:
                  _availableLists.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _saveTask,
        child: const Icon(Icons.check),
      ),
    );
  }
}
