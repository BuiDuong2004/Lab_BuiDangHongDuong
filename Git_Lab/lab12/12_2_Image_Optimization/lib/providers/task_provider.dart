import 'package:flutter/foundation.dart';
import '../models/task.dart';

class TaskProvider extends ChangeNotifier {
  final List<Task> _tasks = [];
  final Map<String, int> _tileRebuildCounts = {};
  int _screenRebuildCount = 0;
  int _totalTileRebuildEvents = 0;

  List<Task> get tasks => List.unmodifiable(_tasks);
  List<String> get taskIds => _tasks.map((t) => t.id).toList();

  int get totalTasks => _tasks.length;
  int get completedCount => _tasks.where((t) => t.isCompleted).length;
  int get pendingCount => _tasks.where((t) => !t.isCompleted).length;

  int get screenRebuildCount => _screenRebuildCount;
  int get totalTileRebuildEvents => _totalTileRebuildEvents;
  int get tileRebuildCount => _totalTileRebuildEvents;

  int getTileRebuildCount(String id) => _tileRebuildCounts[id] ?? 0;

  TaskProvider() {
    _seedTasks();
  }

  void _seedTasks() {
    _tasks.addAll([
      Task(
        id: '1',
        title: 'Exercise 12.1 — Optimize List Rebuilds',
        description: 'Extract TaskTile, apply Selector, add const & ValueKey',
        isCompleted: true,
      ),
      Task(
        id: '2',
        title: 'Exercise 12.2 — Image & Asset Optimization',
        description: 'Resize assets to 128x128 and precache frequently used images',
        isCompleted: false,
      ),
      Task(
        id: '3',
        title: 'Exercise 12.3 — App Size Analysis',
        description: 'Analyze APK footprint with flutter build apk --analyze-size',
        isCompleted: false,
      ),
      Task(
        id: '4',
        title: 'Exercise 12.4 — Deployment & Release APK',
        description: 'Build release APK and complete performance verification checklist',
        isCompleted: false,
      ),
    ]);

    for (final task in _tasks) {
      _tileRebuildCounts[task.id] = 0;
    }
  }

  Task getTaskById(String id) {
    return _tasks.firstWhere(
      (t) => t.id == id,
      orElse: () => Task(id: id, title: 'Unknown Task'),
    );
  }

  void addTask(String title, [String description = '']) {
    if (title.trim().isEmpty) return;
    final newTask = Task(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title.trim(),
      description: description.trim(),
      isCompleted: false,
    );
    _tasks.add(newTask);
    _tileRebuildCounts[newTask.id] = 0;
    notifyListeners();
  }

  void toggleTask(String id) {
    final index = _tasks.indexWhere((t) => t.id == id);
    if (index != -1) {
      final task = _tasks[index];
      _tasks[index] = task.copyWith(isCompleted: !task.isCompleted);
      notifyListeners();
    }
  }

  void deleteTask(String id) {
    _tasks.removeWhere((t) => t.id == id);
    _tileRebuildCounts.remove(id);
    notifyListeners();
  }

  void recordTileRebuild(String id) {
    _tileRebuildCounts[id] = (_tileRebuildCounts[id] ?? 0) + 1;
    _totalTileRebuildEvents++;
  }

  void logScreenRebuild() {
    _screenRebuildCount++;
  }

  void resetMetrics() {
    _screenRebuildCount = 0;
    _totalTileRebuildEvents = 0;
    for (final key in _tileRebuildCounts.keys) {
      _tileRebuildCounts[key] = 0;
    }
    notifyListeners();
  }
}
