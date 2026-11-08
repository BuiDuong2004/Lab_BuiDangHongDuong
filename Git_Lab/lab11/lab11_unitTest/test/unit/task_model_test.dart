import 'package:flutter_test/flutter_test.dart';
import 'package:clone/models/task.dart';
void main() {
  group('Task Model Unit Tests', () {
    test('Default completed value should be false', () {
      const id = 'task-1';
      const title = 'Write Unit Tests';
      final task = Task(id: id, title: title);
      expect(task.id, equals('task-1'));
      expect(task.title, equals('Write Unit Tests'));
      expect(task.completed, isFalse, reason: 'New task must have completed default to false');   });
    test('toggle() switches completed from false to true and back to false', () {
      final task = Task(id: 'task-2', title: 'Test toggle behavior');
      expect(task.completed, isFalse);
      task.toggle();
      expect(task.completed, isTrue, reason: 'toggle() should switch false to true');
      task.toggle();
      expect(task.completed, isFalse, reason: 'toggle() should switch true to false'); });
    test('copyWith() returns a updated copy without mutating original values', () {
      final original = Task(id: 'task-3', title: 'Original Task', completed: false);
      final updated = original.copyWith(title: 'Updated Task', completed: true);
      // Assert
      expect(original.title, equals('Original Task'));
      expect(original.completed, isFalse);
      expect(updated.id, equals('task-3'));
      expect(updated.title, equals('Updated Task'));
      expect(updated.completed, isTrue);
    });
  });
}
