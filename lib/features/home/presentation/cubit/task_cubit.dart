import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_task_manager/core/errors/app_exceptions.dart';
import '../../domain/entities/task_entity.dart';
import '../../domain/usecase/create_task_usecase.dart';
import '../../domain/usecase/delete_task_usecase.dart';
import '../../domain/usecase/get_tasks_usecase.dart';
import '../../domain/usecase/update_task_usecase.dart';
import 'task_state.dart';

class TaskCubit extends Cubit<TaskState> {
  final GetTasksUseCase getTasksUseCase;
  final CreateTaskUseCase createTaskUseCase;
  final UpdateTaskUseCase updateTaskUseCase;
  final DeleteTaskUseCase deleteTaskUseCase;
  final Connectivity connectivity;

  static const int _limit = 10;
  int _skip = 0;

  TaskCubit({
    required this.getTasksUseCase,
    required this.createTaskUseCase,
    required this.updateTaskUseCase,
    required this.deleteTaskUseCase,
    required this.connectivity,
  }) : super(const TaskState());

  String _mapError(Object e) {
    if (e is NetworkException) return 'No internet connection';
    if (e is ServerException) return e.message;
    if (e is CacheException) return e.message;
    if (e is AuthException) return e.message;
    return 'Something went wrong';
  }

  Future<void> fetchTasks({required String userId}) async {
    _skip = 0;
    emit(state.copyWith(isLoading: true, clearError: true, hasReachedMax: false));
    try {
      final result = await connectivity.checkConnectivity();
      final isOffline = result == ConnectivityResult.none;
      final tasks = await getTasksUseCase(userId: userId, skip: 0, limit: _limit);
      _skip = tasks.length;
      emit(state.copyWith(
        isLoading: false,
        tasks: tasks,
        isOffline: isOffline,
        hasReachedMax: tasks.length < _limit,
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: _mapError(e),isOffline: true));
    }
  }

  Future<void> fetchMoreTasks({required String userId}) async {
    if (state.hasReachedMax || state.isPaginating) return;
    emit(state.copyWith(isPaginating: true));
    try {
      final tasks = await getTasksUseCase(userId: userId, skip: _skip, limit: _limit);
      _skip += tasks.length;
      emit(state.copyWith(
        isPaginating: false,
        tasks: [...state.tasks, ...tasks],
        hasReachedMax: tasks.length < _limit,
      ));
    } catch (e) {
      emit(state.copyWith(isPaginating: false, errorMessage: _mapError(e)));
    }
  }

  Future<void> createTask({required TaskEntity task, required String userId}) async {
    final tempTask = task.copyWith(id: 'temp_${DateTime.now().millisecondsSinceEpoch}');
    emit(state.copyWith(tasks: [tempTask, ...state.tasks]));
    try {
      final created = await createTaskUseCase(task: task, userId: userId);
      
      final updated = state.tasks.map((t) => t.id == tempTask.id ? created : t).toList();
      emit(state.copyWith(tasks: updated));
    } catch (e) {
      final rollback = state.tasks.where((t) => t.id != tempTask.id).toList();
      emit(state.copyWith(tasks: rollback, errorMessage: _mapError(e)));
    }
  }

  Future<void> updateTask({required TaskEntity task, required String userId}) async {
    final previous = state.tasks;
    final updated = state.tasks.map((t) => t.id == task.id ? task : t).toList();
    emit(state.copyWith(tasks: updated));
    try {
      final result = await updateTaskUseCase(task: task, userId: userId);
      final finalList = state.tasks.map((t) => t.id == result.id ? result : t).toList();
      emit(state.copyWith(tasks: finalList));
    } catch (e) {
      emit(state.copyWith(tasks: previous, errorMessage: _mapError(e)));
    }
  }

  Future<void> deleteTask({required String taskId, required String userId}) async {
    final previous = state.tasks;
    final updated = state.tasks.where((t) => t.id != taskId).toList();
    emit(state.copyWith(tasks: updated));
    try {
      await deleteTaskUseCase(taskId: taskId, userId: userId);
    } catch (e) {
      emit(state.copyWith(tasks: previous, errorMessage: _mapError(e)));
    }
  }

  void setFilter(TaskFilter filter) => emit(state.copyWith(filter: filter));
  void setSort(TaskSort sort) => emit(state.copyWith(sort: sort));
  void setSearch(String query) => emit(state.copyWith(searchQuery: query));
  void clearError() => emit(state.copyWith(clearError: true));
}