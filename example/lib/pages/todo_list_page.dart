import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:master_detail_navigation/master_detail_navigation.dart';

import '../app_router.gr.dart';
import '../todo_data.dart';

@RoutePage()
class TodoListPage extends StatelessWidget {
  const TodoListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Todos')),
      body: ListView.separated(
        itemCount: todoItems.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final todo = todoItems[index];
          final statusIcon = todo.completed
              ? Icons.check_circle
              : Icons.radio_button_unchecked;
          final statusColor = todo.completed ? Colors.green : Colors.orange;

          return ListTile(
            leading: Icon(statusIcon, color: statusColor),
            title: Text(todo.title),
            subtitle: Text(
              todo.note,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Text(
              todo.dueLabel,
              style: TextStyle(color: Colors.blueGrey.shade600),
            ),
            onTap: () {
              MasterDetailShell.of(
                context,
              ).openDetails(TodoDetailRoute(id: todo.id));
            },
          );
        },
      ),
    );
  }
}
