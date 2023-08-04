import 'package:flutter/material.dart';
import 'task.dart';

class TaskItem extends StatelessWidget {
  final Task task;
  final String taskDate;
  final Function(Task) onTaskChanged; // Immer einen Datentypen angeben
  final Function(Task) onDelete; // Immer einen Datentypen angeben

  const TaskItem(
      {super.key,
      required this.task,
      required this.onTaskChanged,
      required this.onDelete,
      this.taskDate = ""});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        onTap: () {
          onTaskChanged(task);
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        tileColor: const Color.fromRGBO(28, 28, 28, 1),
        titleAlignment: ListTileTitleAlignment.center,
        leading: Icon(
          task.isDone ? Icons.check_box : Icons.check_box_outline_blank,
          color: const Color.fromRGBO(16, 185, 129, 1),
        ),
        title: Text(
          task.taskText,
          style: TextStyle(
              fontSize: 16,
              decoration: task.isDone ? TextDecoration.lineThrough : null,
              color: Colors.white),
        ),
        subtitle: task.taskDate != ""
            ? Text(
                task.taskDate,
                style: TextStyle(
                    fontSize: 12,
                    decoration: task.isDone ? TextDecoration.lineThrough : null,
                    color: Colors.grey[500]),
              )
            : null,
        trailing: Container(
          height: 35,
          width: 35,
          decoration: BoxDecoration(
              color: Colors.red, borderRadius: BorderRadius.circular(5)),
          child: IconButton(
            icon: const Icon(Icons.delete),
            iconSize: 18,
            color: Colors.white,
            onPressed: () {
              onDelete(task);
            },
          ),
        ),
      ),
    );
  }
}
