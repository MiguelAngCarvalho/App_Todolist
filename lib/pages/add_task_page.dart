import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

  // Controladores dos campos de entrada
  final TextEditingController _taskController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  // Chave global do formulário
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Função reutilizável para TextFormField
  Widget _buildTextFormField({
    required TextEditingController controller,
    required String labelText,
    required String? Function(String?) validator,
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
        suffixIcon: Icon(Icons.check, color: Theme.of(context).iconTheme.color),
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

  // Método para exibir o DatePicker
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

  // Função para salvar a tarefa e enviar para a HomePage
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
        } as Map<String, String>,
      );
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
          key: _formKey, // Atribuindo a chave ao formulário
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Campo de texto "O que deve ser feito?"
              _buildTextFormField(
                controller: _taskController,
                labelText: 'O que deve ser feito?',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'O título da tarefa é obrigatório.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Campo de texto para "Descrição"
              _buildTextFormField(
                controller: _descriptionController,
                labelText: 'Descrição',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'A descrição é obrigatória.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Campo de seleção de data
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
              ),
              const SizedBox(height: 20),

              Text(
                'Adicionar à lista',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DropdownButton<String>(
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.secondary,
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
        onPressed:
            _saveTask, // Salva a tarefa apenas se os campos forem válidos
        child: const Icon(Icons.check),
      ),
    );
  }
}
