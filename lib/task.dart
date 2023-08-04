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
}
