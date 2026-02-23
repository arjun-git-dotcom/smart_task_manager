import '../entities/task_entity.dart';

abstract class TaskRepository {
  Future<List<TaskEntity>> getTasks({
    required String userId,
    required int skip,
    required int limit,
  });

  Future<TaskEntity> createTask({
    required TaskEntity task,
    required String userId,
  });

  Future<TaskEntity> updateTask({
    required TaskEntity task,
    required String userId,
  });

  Future<void> deleteTask({
    required String taskId,
    required String userId,
  });

  Future<List<TaskEntity>> getCachedTasks();
}