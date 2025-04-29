class Task {
  final String id;
  final String title;
  final String category;
  final String priority;
  final DateTime? dueDate;
  bool isCompleted;

  Task({
    required this.id,
    required this.title,
    required this.category,
    required this.priority,
    this.dueDate,
    this.isCompleted = false,
  });
}