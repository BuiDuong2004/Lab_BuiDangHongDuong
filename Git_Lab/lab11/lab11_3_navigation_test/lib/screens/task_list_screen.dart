import 'package:flutter/material.dart';
import '../models/task.dart';
import '../repositories/task_repository.dart';
import 'task_detail_screen.dart';

class TaskListScreen extends StatefulWidget {
  final TaskRepository repository;

  const TaskListScreen({
    super.key,
    required this.repository,
  });

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final TextEditingController _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _addTask() {
    final title = _textController.text.trim();
    if (title.isNotEmpty) {
      final task = Task(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        title: title,
      );
      widget.repository.addTask(task);
      _textController.clear();
    }
  }

  void _navigateToDetail(Task task) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaskDetailScreen(
          task: task,
          repository: widget.repository,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Taskly'),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.blue.shade50,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: const Row(
              children: [
                Icon(Icons.touch_app, size: 20, color: Colors.blue),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Lab 11.3: Chạm vào bất kỳ task nào bên dưới để chuyển sang màn hình Task Detail!',
                    style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: Colors.blue),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    key: const Key('taskInputField'),
                    controller: _textController,
                    decoration: const InputDecoration(
                      hintText: 'Enter task title',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                    onSubmitted: (_) => _addTask(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  key: const Key('addTaskButton'),
                  icon: const Icon(Icons.add),
                  tooltip: 'Add Task',
                  onPressed: _addTask,
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListenableBuilder(
              listenable: widget.repository,
              builder: (context, _) {
                final tasks = widget.repository.tasks;
                if (tasks.isEmpty) {
                  return const Center(
                    child: Text(
                      'No tasks yet. Add one!',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final task = tasks[index];
                    return ListTile(
                      key: Key('taskItem_${task.id}'),
                      leading: Checkbox(
                        key: Key('taskCheckbox_${task.id}'),
                        value: task.completed,
                        onChanged: (_) {
                          task.toggle();
                          widget.repository.updateTask(task);
                        },
                      ),
                      title: Text(
                        task.title,
                        style: TextStyle(
                          decoration: task.completed
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                      trailing: IconButton(
                        key: Key('deleteTaskButton_${task.id}'),
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () {
                          widget.repository.deleteTask(task.id);
                        },
                      ),
                      onTap: () => _navigateToDetail(task),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
