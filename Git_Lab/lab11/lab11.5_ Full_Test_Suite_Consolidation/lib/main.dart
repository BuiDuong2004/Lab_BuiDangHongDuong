import 'package:flutter/material.dart';
import 'models/task.dart';
import 'repositories/task_repository.dart';
import 'screens/task_list_screen.dart';

void main() {
  final seededRepository = TaskRepository(initialTasks: [
    Task(
      id: 'task-1',
      title: 'Complete Lab 11 — Testing & Debugging',
      completed: true,
    ),
    Task(
      id: 'task-2',
      title: '👉 Click vào task này để mở Task Detail (Navigation Test)',
      completed: false,
    ),
  ]);
  runApp(TasklyApp(repository: seededRepository));
}

class TasklyApp extends StatelessWidget {
  final TaskRepository? repository;

  const TasklyApp({super.key, this.repository});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Taskly',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: TaskListScreen(repository: repository ?? TaskRepository()),
    );
  }
}
