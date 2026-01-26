import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../todo_data.dart';

@RoutePage()
class TodoDetailPage extends StatelessWidget {
  final String id;

  const TodoDetailPage({super.key, @PathParam('id') required this.id});

  @override
  Widget build(BuildContext context) {
    final todo = todoById(id);
    if (todo == null) {
      return Scaffold(
        key: ValueKey('todo-detail-$id'),
        appBar: AppBar(title: const Text('Todo not found')),
        body: const Center(child: Text('Todo not found')),
      );
    }

    final statusColor = todo.completed ? Colors.green : Colors.orange;
    final statusLabel = todo.completed ? 'Completed' : 'In progress';

    return Scaffold(
      key: ValueKey('todo-detail-${todo.id}'),
      appBar: AppBar(title: Text(todo.title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Status', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Chip(
              label: Text(statusLabel),
              backgroundColor: statusColor.withValues(alpha: 0.15),
              labelStyle: TextStyle(color: statusColor),
            ),
            const SizedBox(height: 24),
            Text('Due', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(todo.dueLabel),
            const SizedBox(height: 24),
            Text('Notes', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(todo.note),
          ],
        ),
      ),
    );
  }
}
