import 'package:hive/hive.dart';
import '../../domain/entities/task_entity.dart';

part 'task_model.g.dart';

@HiveType(typeId: 0)
class TaskModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final String priority;

  @HiveField(4)
  final String category;

  @HiveField(5)
  final DateTime? dueDate;

  @HiveField(6)
  final bool isCompleted;

  @HiveField(7)
  final DateTime createdAt;

  @HiveField(8)
  final String userId;

  TaskModel({
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

 factory TaskModel.fromJson(Map<String, dynamic> json) {
  return TaskModel(
    id: json['id']?.toString() ?? '',
    title: json['title']?.toString() ?? '',
    description: json['description']?.toString() ?? '',
    priority: json['priority']?.toString() ?? 'Low',
    category: json['category']?.toString() ?? 'Work',
    dueDate: json['due_date'] != null ? DateTime.parse(json['due_date'].toString()) : null,
    isCompleted: json['is_completed'] ?? false,
    createdAt: json['created_at'] != null
        ? DateTime.parse(json['created_at'].toString())
        : DateTime.now(),
    userId: json['user_id']?.toString() ?? '',
  );
}

  Map<String, dynamic> toJson() {
  final Map<String, dynamic> data = {
    'title': title,
    'description': description,
    'priority': priority,
    'category': category,
    'is_completed': isCompleted,
    
  };


  if (dueDate != null) {
    data['due_date'] = dueDate!.toIso8601String();
  }

  return data;
}
  TaskEntity toEntity() {
    return TaskEntity(
      id: id,
      title: title,
      description: description,
      priority: priority,
      category: category,
      dueDate: dueDate,
      isCompleted: isCompleted,
      createdAt: createdAt,
      userId: userId,
    );
  }

  factory TaskModel.fromEntity(TaskEntity entity) {
    return TaskModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      priority: entity.priority,
      category: entity.category,
      dueDate: entity.dueDate,
      isCompleted: entity.isCompleted,
      createdAt: entity.createdAt,
      userId: entity.userId,
    );
  }
}
