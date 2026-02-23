import '../entities/user_profile_entity.dart';
import '../repositories/user_profile_repository.dart';

class FetchUserProfileUseCase {
  final UserProfileRepository repository;

  FetchUserProfileUseCase(this.repository);

  Future<UserProfileEntity> call({required String uid}) {
    return repository.fetchUserProfile(uid: uid);
  }
}