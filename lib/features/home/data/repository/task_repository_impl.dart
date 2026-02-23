import 'package:connectivity_plus/connectivity_plus.dart';
import '../../domain/entities/task_entity.dart';
import '../../domain/repository/task_repository.dart';
import '../datasources/task_local_datasource.dart';
import '../datasources/task_remote_datasource.dart';
import '../model/task_model.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskRemoteDataSource remoteDataSource;
  final TaskLocalDataSource localDataSource;
  final Connectivity connectivity;

  TaskRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.connectivity,
  });

  Future<bool> _isOnline() async {
    final result = await connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
  }

  @override
  Future<List<TaskEntity>> getTasks({
    required String userId,
    required int skip,
    required int limit,
  }) async {
    if (await _isOnline()) {
      final tasks = await remoteDataSource.getTasks(
        userId: userId,
        skip: skip,
        limit: limit,
      );
      if (skip == 0) await localDataSource.cacheTasks(tasks);
      return tasks.map((e) => e.toEntity()).toList();
    } else {
      final cached = await localDataSource.getCachedTasks();
        print("CACHED TASKS COUNT: ${cached.length}");
      return cached.map((e) => e.toEntity()).toList();
    }
  }

  @override
  Future<TaskEntity> createTask({
    required TaskEntity task,
    required String userId,
  }) async {
    final model = TaskModel.fromEntity(task);
    final created = await remoteDataSource.createTask(
      taskJson: model.toJson(),
      userId: userId,
    );
    await localDataSource.saveTask(created);
    return created.toEntity();
  }

  @override
  Future<TaskEntity> updateTask({
    required TaskEntity task,
    required String userId,
  }) async {
    final model = TaskModel.fromEntity(task);
    final updated = await remoteDataSource.updateTask(
      taskId: task.id,
      taskJson: model.toJson(),
      userId: userId,
    );
    await localDataSource.saveTask(updated);
    return updated.toEntity();
  }

  @override
  Future<void> deleteTask({
    required String taskId,
    required String userId,
  }) async {
    await remoteDataSource.deleteTask(taskId: taskId, userId: userId);
    await localDataSource.deleteTask(taskId);
  }

  @override
  Future<List<TaskEntity>> getCachedTasks() async {
    final cached = await localDataSource.getCachedTasks();
    return cached.map((e) => e.toEntity()).toList();
  }
}
