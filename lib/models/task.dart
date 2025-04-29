class Task {
  final String id;
  final String title;
  final String category;
  final String priority;
  bool isCompleted;

  Task({
    required this.id,
    required this.title,
    required this.category,
    required this.priority,
    this.isCompleted = false,
  });
}