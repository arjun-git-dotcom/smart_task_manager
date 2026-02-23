import '../../domain/entities/task_entity.dart';

enum TaskFilter { all, completed, pending }
enum TaskSort { dueDate, priority, createdDate }

class TaskState {
  final List<TaskEntity> tasks;
  final bool isLoading;
  final bool isPaginating;
  final String? errorMessage;
  final bool isOffline;
  final bool hasReachedMax;
  final TaskFilter filter;
  final TaskSort sort;
  final String searchQuery;

  const TaskState({
    this.tasks = const [],
    this.isLoading = false,
    this.isPaginating = false,
    this.errorMessage,
    this.isOffline = false,
    this.hasReachedMax = false,
    this.filter = TaskFilter.all,
    this.sort = TaskSort.createdDate,
    this.searchQuery = '',
  });

  TaskState copyWith({
    List<TaskEntity>? tasks,
    bool? isLoading,
    bool? isPaginating,
    String? errorMessage,
    bool? isOffline,
    bool? hasReachedMax,
    TaskFilter? filter,
    TaskSort? sort,
    String? searchQuery,
    bool clearError = false,
  }) {
    return TaskState(
      tasks: tasks ?? this.tasks,
      isLoading: isLoading ?? this.isLoading,
      isPaginating: isPaginating ?? this.isPaginating,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      isOffline: isOffline ?? this.isOffline,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      filter: filter ?? this.filter,
      sort: sort ?? this.sort,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  List<TaskEntity> get filteredAndSortedTasks {
    List<TaskEntity> result = List.from(tasks);

  
    if (searchQuery.isNotEmpty) {
      result = result
          .where((t) => t.title.toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();
    }

    
    if (filter == TaskFilter.completed) {
      result = result.where((t) => t.isCompleted).toList();
    } else if (filter == TaskFilter.pending) {
      result = result.where((t) => !t.isCompleted).toList();
    }

  
    if (sort == TaskSort.dueDate) {
      result.sort((a, b) => (a.dueDate ?? DateTime(9999))
          .compareTo(b.dueDate ?? DateTime(9999)));
    } else if (sort == TaskSort.priority) {
      const order = {'high': 0, 'medium': 1, 'low': 2};
      result.sort((a, b) =>
          (order[a.priority] ?? 2).compareTo(order[b.priority] ?? 2));
    } else {
      result.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    }

    return result;
  }
}