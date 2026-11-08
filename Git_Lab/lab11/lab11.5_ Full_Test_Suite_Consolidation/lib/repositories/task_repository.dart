import 'package:flutter/foundation.dart';
import '../models/task.dart';

class TaskRepository extends ChangeNotifier {
  final List<Task> _tasks;

  TaskRepository({List<Task>? initialTasks})
      : _tasks = initialTasks != null ? List.from(initialTasks) : [];

  List<Task> get tasks => List.unmodifiable(_tasks);

  void addTask(Task task) {
    _tasks.add(task);
    notifyListeners();
  }

  bool deleteTask(String id) {
    final initialLength = _tasks.length;
    _tasks.removeWhere((t) => t.id == id);
    final removed = _tasks.length < initialLength;
    if (removed) {
      notifyListeners();
    }
    return removed;
  }

  bool updateTask(Task updatedTask) {
    final index = _tasks.indexWhere((t) => t.id == updatedTask.id);
    if (index != -1) {
      _tasks[index] = updatedTask;
      notifyListeners();
      return true;
    }
    return false;
  }

  void clear() {
    _tasks.clear();
    notifyListeners();
  }
}
