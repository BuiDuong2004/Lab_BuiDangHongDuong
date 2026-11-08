import 'package:flutter/material.dart';
import 'models/task.dart';
import 'repositories/task_repository.dart';
import 'screens/task_list_screen.dart';

void main() {
  // Pre-seed task for full flow simulation on Chrome Web / Emulator
  final seededRepository = TaskRepository(initialTasks: [
    Task(
      id: 'task-int-1',
      title: 'Original title (Bấm vào để sửa thành Updated title)',
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
