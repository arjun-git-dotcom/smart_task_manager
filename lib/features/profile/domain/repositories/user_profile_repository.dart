import '../entities/user_profile_entity.dart';

abstract class UserProfileRepository {
  Future<UserProfileEntity> fetchUserProfile({required String uid});
  Future<void> updateUserProfile(UserProfileEntity profile);
}