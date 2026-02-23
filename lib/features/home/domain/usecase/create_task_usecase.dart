import '../entities/task_entity.dart';
import '../repository/task_repository.dart';

class CreateTaskUseCase {
  final TaskRepository repository;

  CreateTaskUseCase(this.repository);

  Future<TaskEntity> call({
    required TaskEntity task,
    required String userId,
  }) {
    return repository.createTask(task: task, userId: userId);
  }
}