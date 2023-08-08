import 'dart:convert';

class Task {
  String id;
  String taskText;
  String taskDate;
  bool isDone;
  int creationTimestamp;

  Task(
      {required this.id,
      required this.taskText,
      this.isDone = false,
      this.taskDate = "",
      required this.creationTimestamp});

  factory Task.fromJson(Map<String, dynamic> jsonData) {
    return Task(
      id: jsonData['id'],
      taskText: jsonData['taskText'],
      isDone: jsonData['isDone'],
      taskDate: jsonData['taskDate'],
      creationTimestamp: jsonData['creationTimestamp'],
    );
  }

  static List<Task> decode(String tasks) =>
      (json.decode(tasks) as List<dynamic>)
          .map<Task>((item) => Task.fromJson(item))
          .toList();

  static Map<String, dynamic> toMap(Task task) => {
        'id': task.id,
        'taskText': task.taskText,
        'isDone': task.isDone,
        'taskDate': task.taskDate,
        'creationTimestamp': task.creationTimestamp
      };

  static String encode(List<Task> tasks) => json.encode(
        tasks.map<Map<String, dynamic>>((task) => Task.toMap(task)).toList(),
      );
}
