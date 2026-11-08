class Task {
  final String id;
  String title;
  bool completed;

  Task({
    required this.id,
    required this.title,
    this.completed = false,
  });

  void toggle() {
    completed = !completed;
  }

  Task copyWith({
    String? id,
    String? title,
    bool? completed,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      completed: completed ?? this.completed,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Task &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          completed == other.completed;

  @override
  int get hashCode => id.hashCode ^ title.hashCode ^ completed.hashCode;

  @override
  String toString() {
    return 'Task(id: $id, title: $title, completed: $completed)';
  }
}
