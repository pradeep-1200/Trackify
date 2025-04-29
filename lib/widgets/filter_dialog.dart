import 'package:flutter/material.dart';

class FilterDialog extends StatefulWidget {
  final Function(String?, String?) onApply;
  final String? currentCategory;
  final String? currentPriority;

  const FilterDialog({
    super.key,
    required this.onApply,
    this.currentCategory,
    this.currentPriority,
  });

  @override
  State<FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  String? _selectedCategory;
  String? _selectedPriority;

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.currentCategory;
    _selectedPriority = widget.currentPriority;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Filter Tasks'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<String>(
            value: _selectedCategory,
            decoration: const InputDecoration(labelText: 'Category'),
            items: [
              const DropdownMenuItem(value: null, child: Text('All')),
              ...['Assignment', 'Notes', 'Exam'].map((category) =>
                  DropdownMenuItem(value: category, child: Text(category))),
            ],
            onChanged: (value) => setState(() => _selectedCategory = value),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: _selectedPriority,
            decoration: const InputDecoration(labelText: 'Priority'),
            items: [
              const DropdownMenuItem(value: null, child: Text('All')),
              ...['Low', 'Medium', 'High'].map((priority) =>
                  DropdownMenuItem(value: priority, child: Text(priority))),
            ],
            onChanged: (value) => setState(() => _selectedPriority = value),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onApply(_selectedCategory, _selectedPriority);
            Navigator.pop(context);
          },
          child: const Text('Apply'),
        ),
      ],
    );
  }
}