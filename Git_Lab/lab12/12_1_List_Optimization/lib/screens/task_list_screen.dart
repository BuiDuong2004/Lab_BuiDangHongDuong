import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';
import '../widgets/task_tile.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final TextEditingController _taskController = TextEditingController();
  bool _isOptimizedMode = true;
  int _unoptimizedScreenRebuilds = 0;
  int _unoptimizedTileRebuilds = 0;

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }

  void _handleAddTask() {
    final title = _taskController.text.trim();
    if (title.isNotEmpty) {
      context.read<TaskProvider>().addTask(title);
      _taskController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isOptimizedMode) {
      // In unoptimized mode, watching the entire provider causes the whole screen to rebuild!
      final provider = context.watch<TaskProvider>();
      _unoptimizedScreenRebuilds++;
      return _buildScaffold(
        context: context,
        screenRebuildCount: _unoptimizedScreenRebuilds,
        tileRebuildCount: _unoptimizedTileRebuilds,
        isOptimized: false,
        tasks: provider.tasks,
      );
    } else {
      // In optimized mode, TaskListScreen is NOT listening to task updates directly!
      return _buildScaffold(
        context: context,
        screenRebuildCount: 1,
        tileRebuildCount: 0,
        isOptimized: true,
      );
    }
  }

  Widget _buildScaffold({
    required BuildContext context,
    required int screenRebuildCount,
    required int tileRebuildCount,
    required bool isOptimized,
    List<Task>? tasks,
  }) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.check_circle_outline, color: Colors.white),
            SizedBox(width: 8),
            Text(
              'Taskly — Exercise 12.1',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ),
        backgroundColor: isOptimized ? Colors.deepPurple : Colors.blueGrey,
        foregroundColor: Colors.white,
        elevation: 2,
        actions: [
          IconButton(
            tooltip: 'Reset Rebuild Metrics',
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _unoptimizedScreenRebuilds = 0;
                _unoptimizedTileRebuilds = 0;
              });
              context.read<TaskProvider>().resetMetrics();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Banner for Performance Mode
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            color: isOptimized
                ? Colors.green.shade50
                : Colors.amber.shade50,
            child: Row(
              children: [
                Icon(
                  isOptimized ? Icons.speed : Icons.warning_amber_rounded,
                  color: isOptimized ? Colors.green.shade800 : Colors.amber.shade900,
                  size: 26,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isOptimized
                            ? 'Mode: OPTIMIZED (Selector + Extracted Tile)'
                            : 'Mode: UNOPTIMIZED (Before Optimization)',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isOptimized
                              ? Colors.green.shade900
                              : Colors.amber.shade900,
                        ),
                      ),
                      Text(
                        isOptimized
                            ? 'Uses Selector, ValueKey(task.id) & const widgets'
                            : 'Rebuilds full tree and inline ListTiles on any change',
                        style: TextStyle(
                          fontSize: 11,
                          color: isOptimized
                              ? Colors.green.shade700
                              : Colors.amber.shade800,
                        ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: _isOptimizedMode,
                  activeTrackColor: Colors.green,
                  onChanged: (val) {
                    setState(() {
                      _isOptimizedMode = val;
                    });
                  },
                ),
              ],
            ),
          ),

          // Live Metrics Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade300),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildMetricChip(
                  label: 'Screen Rebuilds',
                  value: isOptimized ? '1 (Static)' : '$screenRebuildCount',
                  color: isOptimized ? Colors.green : Colors.red,
                ),
                Consumer<TaskProvider>(
                  builder: (context, prov, _) {
                    return _buildMetricChip(
                      label: 'Total Tasks',
                      value: '${prov.totalTasks} (${prov.completedCount} done)',
                      color: Colors.blueGrey,
                    );
                  },
                ),
                Consumer<TaskProvider>(
                  builder: (context, prov, _) {
                    final tileCount = isOptimized
                        ? prov.tileRebuildCount
                        : _unoptimizedTileRebuilds;
                    return _buildMetricChip(
                      label: 'Tile Rebuild Events',
                      value: '$tileCount',
                      color: isOptimized ? Colors.teal : Colors.deepOrange,
                    );
                  },
                ),
              ],
            ),
          ),

          // Add Task Input Area (optimized with const decorations)
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _taskController,
                    decoration: const InputDecoration(
                      hintText: 'Enter new task title...',
                      prefixIcon: Icon(Icons.add_task),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    ),
                    onSubmitted: (_) => _handleAddTask(),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                  icon: const Icon(Icons.add, size: 20),
                  label: const Text('Add'),
                  onPressed: _handleAddTask,
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // The List Section: demonstrates Selector vs Full Rebuild
          Expanded(
            child: isOptimized
                ? _buildOptimizedList()
                : _buildUnoptimizedList(tasks!),
          ),
        ],
      ),
    );
  }

  /// Optimized list using `Selector<TaskProvider, List<Task>>`
  /// Only rebuilds the list widget when tasks are added or removed.
  Widget _buildOptimizedList() {
    return Selector<TaskProvider, List<Task>>(
      selector: (context, provider) => provider.tasks,
      shouldRebuild: (prev, next) => prev.length != next.length,
      builder: (context, tasks, child) {
        if (tasks.isEmpty) {
          return const Center(
            child: Text(
              'No tasks yet. Create your first task!',
              style: TextStyle(fontSize: 15, color: Colors.grey),
            ),
          );
        }

        return ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            final task = tasks[index];
            // Uses ValueKey to guarantee item identity and prevent unnecessary rebuilds
            return TaskTile(
              key: ValueKey(task.id),
              initialTask: task,
            );
          },
        );
      },
    );
  }

  /// Unoptimized list (re-evaluates every item without extracted widget or keys)
  Widget _buildUnoptimizedList(List<Task> tasks) {
    if (tasks.isEmpty) {
      return const Center(
        child: Text(
          'No tasks yet. Create your first task!',
          style: TextStyle(fontSize: 15, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        _unoptimizedTileRebuilds++;
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.amber.shade300),
          ),
          child: ListTile(
            leading: Checkbox(
              value: task.isCompleted,
              onChanged: (_) {
                context.read<TaskProvider>().toggleTask(task.id);
              },
            ),
            title: Text(
              task.title,
              style: TextStyle(
                decoration: task.isCompleted
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
              ),
            ),
            subtitle: Text(
              'Inline ListTile (Rebuilt in full screen build: $_unoptimizedScreenRebuilds)',
              style: const TextStyle(fontSize: 11, color: Colors.redAccent),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.grey),
              onPressed: () {
                context.read<TaskProvider>().deleteTask(task.id);
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildMetricChip({
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(fontSize: 11, color: Colors.grey.shade700),
        ),
      ],
    );
  }
}
