import '../../domain/entities/user_profile_entity.dart';

class ProfileState {
  final bool isLoading;
  final UserProfileEntity? profile;
  final String? errorMessage;

  const ProfileState({this.isLoading = false, this.profile, this.errorMessage});

  ProfileState copyWith({
    bool? isLoading,
    UserProfileEntity? profile,
    String? errorMessage,
  }) {
    return ProfileState(
      isLoading: isLoading ?? this.isLoading,
      profile: profile ?? this.profile,
      errorMessage: errorMessage,
    );
  }
}