
import 'package:hive_flutter/hive_flutter.dart';
import 'package:smart_task_manager/core/errors/app_exceptions.dart';
import '../model/task_model.dart';

class TaskLocalDataSource {
  static const String boxName = 'tasks';

  Future<Box<TaskModel>> _openBox() async {
    try {
      return await Hive.openBox<TaskModel>(boxName);
    } catch (e) {
      throw const CacheException('Failed to open local storage');
    }
  }

  Future<List<TaskModel>> getCachedTasks() async {
    try {
      final box = await _openBox();
      return box.values.toList();
    } catch (e) {
      throw const CacheException('Failed to load cached tasks');
    }
  }

  Future<void> cacheTasks(List<TaskModel> tasks) async {
    try {
      final box = await _openBox();
      await box.clear();
      for (var task in tasks) {
        await box.put(task.id, task);
      }
    } catch (e) {
      throw const CacheException('Failed to cache tasks');
    }
  }

  Future<void> saveTask(TaskModel task) async {
    try {
      final box = await _openBox();
      await box.put(task.id, task);
    } catch (e) {
      throw const CacheException('Failed to save task');
    }
  }

  Future<void> deleteTask(String taskId) async {
    try {
      final box = await _openBox();
      await box.delete(taskId);
    } catch (e) {
      throw const CacheException('Failed to delete task');
    }
  }
}