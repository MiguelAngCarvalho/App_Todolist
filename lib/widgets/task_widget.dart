import 'package:flutter/material.dart';

class TaskWidget extends StatefulWidget {
  final String task;
  final String description;
  final String date;
  final String list;
  final VoidCallback onDelete; 
  final VoidCallback onEdit; 

  const TaskWidget({
    Key? key,
    required this.task,
    required this.description,
    required this.date,
    required this.list,
    required this.onDelete, 
    required this.onEdit, 
  }) : super(key: key);

  @override
  _TaskWidgetState createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> {
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 4.0,
      color: Theme.of(context).colorScheme.secondary,
      child: ListTile(
        leading: Checkbox(
          value: _isChecked,
          onChanged: (bool? value) {
            setState(() {
              _isChecked = value ?? false;
            });
          },
          activeColor: Theme.of(context).textTheme.bodyLarge?.color,
          checkColor: Theme.of(context).scaffoldBackgroundColor,
        ),
        title: Text(
          widget.task,
          style: _isChecked
              ? Theme.of(context).textTheme.titleLarge!.copyWith(
                    decoration: TextDecoration.lineThrough,
                  )
              : Theme.of(context).textTheme.titleLarge,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Data: ${widget.date}',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            Text(
              'Lista: ${widget.list}',
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(
                Icons.edit,
                color: Theme.of(context).iconTheme.color,
              ),
              onPressed: widget.onEdit, 
            ),
            IconButton(
              icon: Icon(
                Icons.delete,
                color: Theme.of(context).iconTheme.color, 
              ),
              onPressed: widget.onDelete, 
            ),
          ],
        ),
      ),
    );
  }
}
