class TaskEntity {
  final String id;
  final String title;
  final String description;
  final String priority;
  final String category;
  final DateTime? dueDate;
  final bool isCompleted;
  final DateTime createdAt;
  final String userId;

  TaskEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.priority,
    required this.category,
    this.dueDate,
    required this.isCompleted,
    required this.createdAt,
    required this.userId,
  });

  TaskEntity copyWith({
    String? id,
    String? title,
    String? description,
    String? priority,
    String? category,
    DateTime? dueDate,
    bool? isCompleted,
    DateTime? createdAt,
    String? userId,
  }) {
    return TaskEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      priority: priority ?? this.priority,
      category: category ?? this.category,
      dueDate: dueDate ?? this.dueDate,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      userId: userId ?? this.userId,
    );
  }
}