import 'package:flutter/material.dart';
import 'models/task.dart';

void main() => runApp(const TrackifyApp());

class TrackifyApp extends StatelessWidget {
  const TrackifyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trackify',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const TaskListScreen(),
    );
  }
}

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final List<Task> _tasks = [];
  final _taskController = TextEditingController();
  String _selectedCategory = 'Assignment';
  String _selectedPriority = 'Medium';

  void _addTask() {
    if (_taskController.text.isEmpty) return;
    
    setState(() {
      _tasks.add(
        Task(
          id: DateTime.now().toString(),
          title: _taskController.text,
          category: _selectedCategory,
          priority: _selectedPriority,
        ),
      );
      _taskController.clear();
    });
  }

  void _deleteTask(String id) {
    setState(() {
      _tasks.removeWhere((task) => task.id == id);
    });
  }

  void _toggleComplete(String id) {
    setState(() {
      final task = _tasks.firstWhere((t) => t.id == id);
      task.isCompleted = !task.isCompleted;
    });
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'High': return Colors.red;
      case 'Medium': return Colors.orange;
      case 'Low': return Colors.green;
      default: return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Study Tasks'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt),
            onPressed: () {}, // We'll implement filters next
          ),
        ],
      ),
      body: Column(
        children: [
          // Add Task Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _taskController,
                  decoration: const InputDecoration(
                    hintText: 'Enter task...',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    // Category Dropdown
                    Expanded(
                      child: DropdownButtonFormField(
                        value: _selectedCategory,
                        items: ['Assignment', 'Notes', 'Exam']
                            .map((category) => DropdownMenuItem(
                                  value: category,
                                  child: Text(category),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedCategory = value!;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Priority Dropdown
                    Expanded(
                      child: DropdownButtonFormField(
                        value: _selectedPriority,
                        items: ['Low', 'Medium', 'High']
                            .map((priority) => DropdownMenuItem(
                                  value: priority,
                                  child: Text(priority),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedPriority = value!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _addTask,
                  child: const Text('Add Task'),
                ),
              ],
            ),
          ),
          // Task List
          Expanded(
            child: ListView.builder(
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                final task = _tasks[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 4),
                  child: ListTile(
                    title: Text(task.title),
                    subtitle: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: _getPriorityColor(task.priority)
                                .withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            task.priority,
                            style: TextStyle(
                              color: _getPriorityColor(task.priority),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(task.category),
                      ],
                    ),
                    leading: Checkbox(
                      value: task.isCompleted,
                      onChanged: (_) => _toggleComplete(task.id),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _deleteTask(task.id),
                    ),
                    tileColor: task.isCompleted
                        ? Colors.grey[200]
                        : null,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}