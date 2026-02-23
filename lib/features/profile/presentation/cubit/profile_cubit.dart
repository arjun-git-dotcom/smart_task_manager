import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/user_profile_entity.dart';
import '../../domain/repositories/user_profile_repository.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final UserProfileRepository userProfileRepository;

  ProfileCubit(this.userProfileRepository) : super(const ProfileState());

 Future<void> fetchUserProfile(String uid) async {
  if (isClosed) return;
  emit(state.copyWith(isLoading: true, errorMessage: null));
  try {
    final profile = await userProfileRepository.fetchUserProfile(uid: uid);
    if (isClosed) return;
    emit(state.copyWith(isLoading: false, profile: profile));
  } catch (e) {
    if (isClosed) return;
    emit(state.copyWith(isLoading: false, errorMessage: 'Failed to load profile'));
  }
}

 Future<void> updateProfile(UserProfileEntity updatedProfile) async {
  if (isClosed) return; 
  emit(state.copyWith(isLoading: true));
  try {
    print("UPDATING PROFILE: ${updatedProfile.isDarkMode}");
    await userProfileRepository.updateUserProfile(updatedProfile);
    if (isClosed) return; 
    emit(state.copyWith(isLoading: false, profile: updatedProfile));
  } catch (e) {
    print("UPDATE ERROR: $e");
    if (isClosed) return; 
    emit(state.copyWith(isLoading: false, errorMessage: 'Failed to update profile: $e'));
  }
}
}