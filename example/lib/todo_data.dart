class Todo {
  final String id;
  final String title;
  final String note;
  final String dueLabel;
  final bool completed;

  const Todo({
    required this.id,
    required this.title,
    required this.note,
    required this.dueLabel,
    required this.completed,
  });
}

const todoItems = <Todo>[
  Todo(
    id: 't1',
    title: 'Write project brief',
    note: 'Outline goals and scope for the next sprint.',
    dueLabel: 'Today',
    completed: false,
  ),
  Todo(
    id: 't2',
    title: 'Review pull requests',
    note: 'Check the navigation refactor and leave feedback.',
    dueLabel: 'Tomorrow',
    completed: false,
  ),
  Todo(
    id: 't3',
    title: 'Prepare demo',
    note: 'Capture screenshots for the release notes.',
    dueLabel: 'Fri',
    completed: true,
  ),
  Todo(
    id: 't4',
    title: 'Sync with design',
    note: 'Confirm layout spacing for the detail panel.',
    dueLabel: 'Next week',
    completed: false,
  ),
];

Todo? todoById(String id) {
  for (final todo in todoItems) {
    if (todo.id == id) {
      return todo;
    }
  }
  return null;
}
