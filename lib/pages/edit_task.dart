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

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
    if (_formKey.currentState?.validate() ?? false) {
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
  }

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
                  Icon(
                    Icons.list,
                    size: 30,
                    color: Theme.of(context).iconTheme.color,
                  ),
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
