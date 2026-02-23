import 'package:smart_task_manager/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity> login({required String email, required String password});
  Future<UserEntity> register({
    required String email,
    required String password,
  });
  Future<void> logout();
  UserEntity? getCurrentUser();
}
