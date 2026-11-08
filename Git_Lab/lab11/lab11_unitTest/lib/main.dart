import 'package:flutter/material.dart';
import 'models/task.dart';
import 'repositories/task_repository.dart';

void main() {
  runApp(const UnitTestDemoApp());
}

class UnitTestDemoApp extends StatelessWidget {
  const UnitTestDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 11.1 — Unit Testing',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const UnitTestHomeScreen(),
    );
  }
}

class UnitTestHomeScreen extends StatefulWidget {
  const UnitTestHomeScreen({super.key});

  @override
  State<UnitTestHomeScreen> createState() => _UnitTestHomeScreenState();
}

class _UnitTestHomeScreenState extends State<UnitTestHomeScreen> {
  final Task _sampleTask = Task(id: 'task-unit-1', title: 'Learn Unit Testing');
  final TaskRepository _repository = TaskRepository();

  @override
  void initState() {
    super.initState();
    _repository.addTask(Task(id: 't-1', title: 'Sample Repository Task 1'));
    _repository.addTask(Task(id: 't-2', title: 'Sample Repository Task 2', completed: true));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LAB 11.1 — Pure Dart Unit Testing'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              color: Colors.blue.shade50,
              elevation: 2,
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.blue),
                        SizedBox(width: 8),
                        Text(
                          'Mục đích của LAB 11.1',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Lab 11.1 tập trung vào kiểm thử logic thuần (Pure Dart Logic) cho Task Model và TaskRepository bằng lệnh tự động.',
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(height: 6),
                    Text(
                      '💡 Để chạy 8 Unit Tests tự động, mở terminal và gõ: flutter test',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.indigo),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '1. Demo Task Model Logic',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text('• Task ID: ${_sampleTask.id}'),
                    Text('• Title: ${_sampleTask.title}'),
                    Row(
                      children: [
                        const Text('• Completed: '),
                        Text(
                          '${_sampleTask.completed}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: _sampleTask.completed ? Colors.green : Colors.red,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.swap_horiz),
                      label: const Text('Test task.toggle() (switches true ↔ false)'),
                      onPressed: () {
                        setState(() {
                          _sampleTask.toggle();
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListenableBuilder(
                  listenable: _repository,
                  builder: (context, _) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '2. Demo TaskRepository Logic',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text('• Số lượng tasks trong repository: ${_repository.tasks.length}'),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            ElevatedButton.icon(
                              icon: const Icon(Icons.add),
                              label: const Text('Test addTask()'),
                              onPressed: () {
                                final newId = DateTime.now().millisecondsSinceEpoch.toString();
                                _repository.addTask(Task(id: newId, title: 'Task $newId'));
                              },
                            ),
                            ElevatedButton.icon(
                              icon: const Icon(Icons.delete),
                              label: const Text('Test deleteTask()'),
                              onPressed: _repository.tasks.isNotEmpty
                                  ? () {
                                      _repository.deleteTask(_repository.tasks.last.id);
                                    }
                                  : null,
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Divider(),
                        ..._repository.tasks.map(
                          (t) => ListTile(
                            dense: true,
                            leading: Icon(
                              t.completed ? Icons.check_circle : Icons.circle_outlined,
                              color: t.completed ? Colors.green : Colors.grey,
                            ),
                            title: Text(t.title),
                            subtitle: Text('ID: ${t.id}'),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
