import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';

/// TaskTile is extracted into a dedicated widget file.
/// Optimizations applied:
/// 1. Uses [ValueKey(task.id)] to preserve state and widget identity.
/// 2. Uses [Selector<TaskProvider, Task>] to isolate item-level updates.
///    When another task is toggled or added, this widget's build subtree
///    is NOT re-executed by Flutter.
/// 3. Static decoration widgets and icons are marked `const`.
class TaskTile extends StatelessWidget {
  final Task initialTask;
  final VoidCallback? onTap;

  const TaskTile({
    required ValueKey<String> key,
    required this.initialTask,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<TaskProvider, Task>(
      selector: (_, provider) => provider.getTaskById(initialTask.id),
      builder: (context, task, child) {
        // Track rebuild event for this specific tile
        final provider = context.read<TaskProvider>();
        provider.recordTileRebuild(task.id);
        final rebuilds = provider.getTileRebuildCount(task.id);

        final theme = Theme.of(context);

        return Card(
          key: ValueKey('card_${task.id}'),
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(
              color: task.isCompleted
                  ? Colors.green.withValues(alpha: 0.3)
                  : Colors.grey.withValues(alpha: 0.2),
            ),
          ),
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            leading: Checkbox(
              value: task.isCompleted,
              activeColor: Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              onChanged: (_) {
                context.read<TaskProvider>().toggleTask(task.id);
              },
            ),
            title: Text(
              task.title,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                decoration: task.isCompleted
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
                color:
                    task.isCompleted ? Colors.grey : theme.colorScheme.onSurface,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (task.description.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    task.description,
                    style: TextStyle(
                      fontSize: 12,
                      color: task.isCompleted ? Colors.grey : Colors.black87,
                    ),
                  ),
                ],
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.blue.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'Rebuilds: $rebuilds',
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Key: ${task.id}',
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
              tooltip: 'Delete Task',
              onPressed: () {
                context.read<TaskProvider>().deleteTask(task.id);
              },
            ),
            onTap: onTap,
          ),
        );
      },
    );
  }
}
