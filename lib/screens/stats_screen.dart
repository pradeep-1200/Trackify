import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import '../models/task.dart';

class StatsScreen extends StatelessWidget {
  final List<Task> tasks;

  const StatsScreen({super.key, required this.tasks});

  @override
  Widget build(BuildContext context) {
    final completedCount = tasks.where((t) => t.isCompleted).length;
    final highPriorityCount = tasks.where((t) => t.priority == 'High').length;
    
    final categoryCounts = <String, int>{};
    for (final task in tasks) {
      categoryCounts[task.category] = (categoryCounts[task.category] ?? 0) + 1;
    }

    final overdueCount = tasks.where((t) => 
        t.dueDate != null && t.dueDate!.isBefore(DateTime.now())).length;

    return Scaffold(
      appBar: AppBar(title: const Text('Task Statistics')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _StatCard(
              title: 'Completion',
              value: '${tasks.isEmpty ? 0 : (completedCount / tasks.length * 100).toStringAsFixed(1)}%',
              subtitle: '$completedCount/${tasks.length} tasks',
            ),
            _StatCard(
              title: 'High Priority',
              value: highPriorityCount.toString(),
              subtitle: 'urgent tasks',
            ),
            _StatCard(
              title: 'Overdue',
              value: overdueCount.toString(),
              subtitle: 'tasks',
            ),
            const SizedBox(height: 20),
            const Text('Tasks by Category:', style: TextStyle(fontSize: 18)),
            ...categoryCounts.entries.map(
              (e) => ListTile(
                title: Text(e.key),
                trailing: Text(e.value.toString()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;

  const _StatCard({
    required this.title,
    required this.value,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            Text(value, style: Theme.of(context).textTheme.headlineMedium),
            Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}