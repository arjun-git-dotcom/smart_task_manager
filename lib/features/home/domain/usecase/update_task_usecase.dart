import '../entities/task_entity.dart';
import '../repository/task_repository.dart';

class UpdateTaskUseCase {
  final TaskRepository repository;

  UpdateTaskUseCase(this.repository);

  Future<TaskEntity> call({
    required TaskEntity task,
    required String userId,
  }) {
    return repository.updateTask(task: task, userId: userId);
  }
}