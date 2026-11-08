import 'package:flutter_test/flutter_test.dart';
import 'package:clone/models/task.dart';
import 'package:clone/repositories/task_repository.dart';
void main() {
  group('TaskRepository Unit Tests', () {
    late TaskRepository repository;
    setUp(() {
      // Arrange - fresh repository before each test
      repository = TaskRepository();
    });
    test('addTask() should add a new task to repository', () {
      final task = Task(id: 't-1', title: 'Buy groceries');
      repository.addTask(task);
      expect(repository.tasks.length, equals(1));
      expect(repository.tasks.first, equals(task));
      expect(repository.tasks.first.title, equals('Buy groceries'));
    });
    test('deleteTask() should remove task by id from repository', () {
      // Arrange
      final task1 = Task(id: 't-1', title: 'Task 1');
      final task2 = Task(id: 't-2', title: 'Task 2');
      repository.addTask(task1);
      repository.addTask(task2);
      expect(repository.tasks.length, equals(2));
      final result = repository.deleteTask('t-1');
      expect(result, isTrue);
      expect(repository.tasks.length, equals(1));
      expect(repository.tasks.any((t) => t.id == 't-1'), isFalse);
      expect(repository.tasks.first.id, equals('t-2'));
    });

    test('updateTask() should update existing task fields in repository', () {
      final initialTask = Task(id: 't-1', title: 'Initial Title', completed: false);
      repository.addTask(initialTask);
      final updatedTask = initialTask.copyWith(
        title: 'Updated Title',
        completed: true,
      );
      final result = repository.updateTask(updatedTask);
      expect(result, isTrue);
      expect(repository.tasks.length, equals(1));
      expect(repository.tasks.first.title, equals('Updated Title'));
      expect(repository.tasks.first.completed, isTrue);
    });
    test('deleteTask() should return false when task does not exist', () {
      final task = Task(id: 't-1', title: 'Existing Task');
      repository.addTask(task);
      final result = repository.deleteTask('non-existent-id');
      expect(result, isFalse);
      expect(repository.tasks.length, equals(1));
    });
    test('updateTask() should return false when updating non-existent task', () {
      final nonExistentTask = Task(id: 'ghost-id', title: 'Ghost Task');
      final result = repository.updateTask(nonExistentTask);
      expect(result, isFalse);
      expect(repository.tasks.isEmpty, isTrue);
    });
  });
}
