import '../repository/task_repository.dart';

class DeleteTaskUseCase {
  final TaskRepository repository;

  DeleteTaskUseCase(this.repository);

  Future<void> call({
    required String taskId,
    required String userId,
  }) {
    return repository.deleteTask(taskId: taskId, userId: userId);
  }
}