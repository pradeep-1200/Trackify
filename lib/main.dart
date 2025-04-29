import 'package:flutter/material.dart';
import 'models/task.dart';
import 'widgets/filter_dialog.dart';
import 'screens/pomodoro_screen.dart';
import 'screens/stats_screen.dart';

void main() => runApp(const TrackifyApp());

class TrackifyApp extends StatefulWidget {
  const TrackifyApp({super.key});

  @override
  State<TrackifyApp> createState() => _TrackifyAppState();
}

class _TrackifyAppState extends State<TrackifyApp> {
  bool _isDarkMode = false;

  void _toggleTheme() {
    setState(() => _isDarkMode = !_isDarkMode);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trackify',
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
      ),
      home: TaskListScreen(
        toggleTheme: _toggleTheme, 
        isDarkMode: _isDarkMode,
      ),
    );
  }
}

class TaskListScreen extends StatefulWidget {
  final VoidCallback toggleTheme;
  final bool isDarkMode;

  const TaskListScreen({
    super.key,
    required this.toggleTheme,
    required this.isDarkMode,
  });

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final List<Task> _tasks = [];
  final _taskController = TextEditingController();
  String _selectedCategory = 'Assignment';
  String _selectedPriority = 'Medium';
  String? _filterCategory;
  String? _filterPriority;
  DateTime? _selectedDueDate;

  Future<void> _selectDueDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() => _selectedDueDate = picked);
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'No deadline';
    return 'Due: ${date.day}/${date.month}/${date.year}';
  }

  void _addTask() {
    if (_taskController.text.isEmpty) return;
    
    setState(() {
      _tasks.add(
        Task(
          id: DateTime.now().toString(),
          title: _taskController.text,
          category: _selectedCategory,
          priority: _selectedPriority,
          dueDate: _selectedDueDate,
        ),
      );
      _taskController.clear();
      _selectedDueDate = null;
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

  void _applyFilters(String? category, String? priority) {
    setState(() {
      _filterCategory = category;
      _filterPriority = priority;
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
    final filteredTasks = _tasks.where((task) {
      final categoryMatch = _filterCategory == null || 
                          task.category == _filterCategory;
      final priorityMatch = _filterPriority == null || 
                          task.priority == _filterPriority;
      return categoryMatch && priorityMatch;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Study Tasks'),
        actions: [
          IconButton(
            icon: Icon(widget.isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: widget.toggleTheme,
          ),
          IconButton(
            icon: const Icon(Icons.analytics),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => StatsScreen(tasks: _tasks),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.timer),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const PomodoroScreen(),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.filter_alt),
            onPressed: () => showDialog(
              context: context,
              builder: (context) => FilterDialog(
                onApply: _applyFilters,
                currentCategory: _filterCategory,
                currentPriority: _filterPriority,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
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
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => _selectDueDate(context),
                        child: Text(_selectedDueDate == null
                            ? 'Set Due Date'
                            : 'Due: ${_formatDate(_selectedDueDate)}'),
                      ),
                    ),
                    if (_selectedDueDate != null)
                      IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () => setState(() => _selectedDueDate = null),
                      ),
                  ],
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _addTask,
                  child: const Text('Add Task'),
                ),
                if (_filterCategory != null || _filterPriority != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Wrap(
                      spacing: 8,
                      children: [
                        if (_filterCategory != null)
                          Chip(
                            label: Text('Category: $_filterCategory'),
                            onDeleted: () => _applyFilters(null, _filterPriority),
                          ),
                        if (_filterPriority != null)
                          Chip(
                            label: Text('Priority: $_filterPriority'),
                            onDeleted: () => _applyFilters(_filterCategory, null),
                          ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredTasks.length,
              itemBuilder: (context, index) {
                final task = filteredTasks[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 4),
                  child: ListTile(
                    title: Text(task.title),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
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
                        Text(
                          _formatDate(task.dueDate),
                          style: TextStyle(
                            color: task.dueDate?.isBefore(DateTime.now()) ?? false
                                ? Colors.red
                                : Theme.of(context).textTheme.bodySmall?.color,
                          ),
                        ),
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