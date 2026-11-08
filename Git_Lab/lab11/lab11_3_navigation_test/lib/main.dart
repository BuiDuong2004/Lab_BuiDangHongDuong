import 'package:flutter/material.dart';
import 'models/task.dart';
import 'repositories/task_repository.dart';
import 'screens/task_list_screen.dart';

void main() {
  // Pre-seed tasks for interactive testing on Chrome Web / Emulator
  final seededRepository = TaskRepository(initialTasks: [
    Task(
      id: 'task-nav-1',
      title: '👉 Bấm vào task này để chuyển sang Task Detail',
      completed: false,
    ),
    Task(
      id: 'task-nav-2',
      title: 'Review PRM393 Navigation Lecture',
      completed: true,
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
