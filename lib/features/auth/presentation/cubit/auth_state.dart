import 'package:smart_task_manager/features/auth/domain/entities/user_entity.dart';
import 'package:smart_task_manager/features/profile/domain/entities/user_profile_entity.dart';

class AuthState {
  final bool isPasswordObscure;
  final String email;
  final String password;
  final bool isLoading;
  final String? errorMessage;
  final UserEntity? user;
  final UserProfileEntity? userProfile;

  const AuthState({
    this.isPasswordObscure = true,
    this.email = '',
    this.password = '',
    this.isLoading = false,
    this.errorMessage,
    this.user,
    this.userProfile
  });

  AuthState copyWith({
    bool? isPasswordObscure,
    String? email,
    String? password,
    bool? isLoading,
    String? errorMessage,
    UserEntity? user,
    bool clearError = false,
    bool clearUser = false,
    UserProfileEntity?userProfile,
    bool clearUserProfile = false, 
  }) {
    return AuthState(
      isPasswordObscure: isPasswordObscure ?? this.isPasswordObscure,
      email: email ?? this.email,
      password: password ?? this.password,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
     user: clearUser ? null : user ?? this.user,                          
    userProfile: clearUserProfile ? null : userProfile ?? this.userProfile,
    );
  }
}
