import 'package:dio/dio.dart';
import 'package:smart_task_manager/core/errors/app_exceptions.dart';
import '../model/task_model.dart';

class TaskRemoteDataSource {
  final Dio dio;

  TaskRemoteDataSource(this.dio);

  DioException _handleDioError(DioException e) {
    if (e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      throw const NetworkException();
    } else if (e.response != null) {
      throw ServerException(e.response?.data?['message'] ?? 'Server error');
    } else {
      throw const ServerException();
    }
  }

  Future<List<TaskModel>> getTasks({
    required String userId,
    required int skip,
    required int limit,
  }) async {
    try {
      final response = await dio.get(
        '/tasks/',
        queryParameters: {'user_id': userId, 'skip': skip, 'limit': limit},
      );
     
    
      List data;
      if (response.data is List) {
        data = response.data;
      } else if (response.data is Map) {
        data = response.data['data'] ?? [];
      } else {
        data = [];
      }
      return data.map((e) => TaskModel.fromJson(e)).toList();
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw const ServerException();
    }
  }

  Future<TaskModel> createTask({
    required Map<String, dynamic> taskJson,
    required String userId,
  }) async {
    try {
      final response = await dio.post(
        '/tasks/',
        queryParameters: {'user_id': userId},
        data: taskJson,
      );
    
      return TaskModel.fromJson(response.data['data']);
    } on DioException catch (e) {
     
      throw _handleDioError(e);
    } catch (e) {
      throw const ServerException();
    }
  }

  Future<TaskModel> updateTask({
    required String taskId,
    required Map<String, dynamic> taskJson,
    required String userId,
  }) async {
    try {
      final response = await dio.put(
        '/tasks/$taskId',
        queryParameters: {'user_id': userId},
        data: taskJson,
      );
      return TaskModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw const ServerException();
    }
  }

  Future<void> deleteTask({
    required String taskId,
    required String userId,
  }) async {
    try {
      await dio.delete(
        '/tasks/$taskId',
        queryParameters: {'user_id': userId},
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw const ServerException();
    }
  }
}