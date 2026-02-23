import '../entities/task_entity.dart';
import '../repository/task_repository.dart';

class GetTasksUseCase {
  final TaskRepository repository;

  GetTasksUseCase(this.repository);

  Future<List<TaskEntity>> call({
    required String userId,
    required int skip,
    required int limit,
  }) {
    return repository.getTasks(userId: userId, skip: skip, limit: limit);
  }
}