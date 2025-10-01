import 'package:flutter/material.dart';
import 'package:todo_app/model/task.dart';
class TaskTile extends StatelessWidget{
  final Task task;
  final VoidCallback onDelete;
  final Function(bool?) onToggle;
  const TaskTile({
    Key?key,
    required this.task,
    required this.onDelete,
    required this.onToggle,
  }):super(key: key);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ListTile(
      title: Text(
        task.title,
        style: TextStyle(
          decoration: task.isDone ? TextDecoration.lineThrough : null,
        ),
      ),
      leading: Checkbox(
        value: task.isDone, 
        onChanged: onToggle
        
        ),
        trailing: IconButton(
         onPressed: onDelete,
         icon: const Icon(Icons.delete_outline),
         ),
      
    );
  }
}