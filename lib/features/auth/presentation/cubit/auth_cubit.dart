import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_task_manager/features/auth/domain/repositories/auth_repository.dart';
import 'package:smart_task_manager/features/auth/domain/usecases/login_usecase.dart';
import 'package:smart_task_manager/features/auth/domain/usecases/logout_usecase.dart';
import 'package:smart_task_manager/features/auth/domain/usecases/register_usecase.dart';
import 'package:smart_task_manager/features/auth/presentation/cubit/auth_state.dart';
import 'package:smart_task_manager/features/profile/domain/entities/user_profile_entity.dart';
import 'package:smart_task_manager/features/profile/domain/usecase/fetch_user_profile_usecase.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final LogoutUseCase logoutUseCase;
  final FetchUserProfileUseCase fetchUserProfileUseCase;
  final AuthRepository authRepository;

  AuthCubit({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.logoutUseCase,
    required this.fetchUserProfileUseCase,
    required this.authRepository
  }) : super(const AuthState());

  void togglePasswordVisibility() {
    emit(state.copyWith(isPasswordObscure: !state.isPasswordObscure));
  }

  void emailChanged(String email) => emit(state.copyWith(email: email.trim()));
  void passwordChanged(String password) =>
      emit(state.copyWith(password: password));

  Future<void> loginUser() async {
    if (!state.email.contains('@')) {
      emit(
        state.copyWith(isLoading: false, errorMessage: 'Enter a valid email'),
      );
      return;
    }

    if (state.password.length < 6) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'Password must be at least 6 characters',
        ),
      );
      return;
    }

    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      final user = await loginUseCase(
        email: state.email,
        password: state.password,
      );

      try {
        final profile = await fetchUserProfileUseCase(uid: user.uid);
        emit(
          state.copyWith(isLoading: false, user: user, userProfile: profile),
        );
      } catch (_) {
        emit(state.copyWith(isLoading: false, user: user));
      }
    } on FirebaseAuthException catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: mapFirebaseError(e)));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> registerUser() async {
    if (!state.email.contains('@')) {
      emit(
        state.copyWith(isLoading: false, errorMessage: 'Enter a valid email'),
      );
      return;
    }

    if (state.password.length < 6) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'Password must be at least 6 characters',
        ),
      );
      return;
    }

    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      final user = await registerUseCase(
        email: state.email,
        password: state.password,
      );
      emit(state.copyWith(isLoading: false, user: user));
    } on FirebaseAuthException catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: mapFirebaseError(e)));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  String mapFirebaseError(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'Email is invalid';
      case 'user-not-found':
        return 'No user found for this email';
      case 'wrong-password':
        return 'Incorrect password';
      case 'email-already-in-use':
        return 'This email is already registered';
      case 'weak-password':
        return 'Password is too weak, use at least 6 characters';
      case 'invalid-credential':
        return 'Invalid email or password';
      default:
        return 'Authentication error: ${e.message}';
    }
  }
  Future<void> logoutUser() async {
  await logoutUseCase();
  emit(const AuthState());
}

  void clearError() {
    emit(state.copyWith(clearError: true));
  }

  void updateUserProfile(UserProfileEntity profile) {
    emit(state.copyWith(userProfile: profile));
  }

Future<void> checkCurrentUser() async {
 
  emit(state.copyWith(isLoading: true));
  final user = authRepository.getCurrentUser();
   
  if (user != null) {
    try {
      final profile = await fetchUserProfileUseCase(uid: user.uid);
      emit(state.copyWith(isLoading: false, user: user, userProfile: profile));
    } catch (_) {
      emit(state.copyWith(isLoading: false, user: user));
    }
  } else {
    emit(state.copyWith(isLoading: false,clearUser: true,clearUserProfile: true));
  }
   
}
}
