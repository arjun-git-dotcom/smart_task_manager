import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:smart_task_manager/core/constants/app_constants.dart';
import 'package:smart_task_manager/core/network/dio_interceptor.dart';
import 'package:smart_task_manager/core/routes/app_router.dart';
import 'package:smart_task_manager/core/routes/app_routes.dart';
import 'package:smart_task_manager/features/auth/data/repositories/auth_repository_impl.dart';

import 'package:smart_task_manager/features/auth/domain/usecases/login_usecase.dart';
import 'package:smart_task_manager/features/auth/domain/usecases/logout_usecase.dart';
import 'package:smart_task_manager/features/auth/domain/usecases/register_usecase.dart';
import 'package:smart_task_manager/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:smart_task_manager/features/auth/presentation/cubit/auth_state.dart';
import 'package:smart_task_manager/features/home/data/datasources/task_local_datasource.dart';
import 'package:smart_task_manager/features/home/data/datasources/task_remote_datasource.dart';
import 'package:smart_task_manager/features/home/data/model/task_model.dart';
import 'package:smart_task_manager/features/home/data/repository/task_repository_impl.dart';
import 'package:smart_task_manager/features/home/domain/repository/task_repository.dart';
import 'package:smart_task_manager/features/home/domain/usecase/create_task_usecase.dart';
import 'package:smart_task_manager/features/home/domain/usecase/delete_task_usecase.dart';
import 'package:smart_task_manager/features/home/domain/usecase/get_tasks_usecase.dart';
import 'package:smart_task_manager/features/home/domain/usecase/update_task_usecase.dart';
import 'package:smart_task_manager/features/home/presentation/cubit/task_cubit.dart';
import 'package:smart_task_manager/features/profile/data/repository/user_profile_repository_impl.dart';
import 'package:smart_task_manager/features/profile/domain/repositories/user_profile_repository.dart';
import 'package:smart_task_manager/features/profile/domain/usecase/fetch_user_profile_usecase.dart';

final _connectivity = Connectivity();

final _authRepository = AuthRepositoryImpl(
  FirebaseAuth.instance,
  FirebaseFirestore.instance,
);

final _dio = Dio(BaseOptions(baseUrl: AppConstants.baseUrl))
  ..interceptors.add(AppDioInterceptor());

final _profileRepository = UserProfileRepositoryImpl(
  FirebaseFirestore.instance,
);

final _taskRepository = TaskRepositoryImpl(
  remoteDataSource: TaskRemoteDataSource(
    _dio
  ),
  localDataSource: TaskLocalDataSource(),
  connectivity: _connectivity,
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Hive.initFlutter();
  Hive.registerAdapter(TaskModelAdapter());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<UserProfileRepository>(
          create: (_) => _profileRepository,
        ),
        RepositoryProvider<TaskRepository>(
          create: (_) => _taskRepository,
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => AuthCubit(
              authRepository: _authRepository,
              loginUseCase: LoginUseCase(_authRepository),
              registerUseCase: RegisterUseCase(_authRepository),
              logoutUseCase: LogoutUseCase(_authRepository),
              fetchUserProfileUseCase: FetchUserProfileUseCase(_profileRepository),
            )
          ),
          BlocProvider(
            create: (_) => TaskCubit(
              getTasksUseCase: GetTasksUseCase(_taskRepository),
              createTaskUseCase: CreateTaskUseCase(_taskRepository),
              updateTaskUseCase: UpdateTaskUseCase(_taskRepository),
              deleteTaskUseCase: DeleteTaskUseCase(_taskRepository),
              connectivity: _connectivity,
            ),
          ),
        ],
        child: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              initialRoute: AppRoutes.splash,
              onGenerateRoute: AppRouter.onGenerateRoute,
              theme: ThemeData.light(useMaterial3: true),
              darkTheme: ThemeData.dark(useMaterial3: true),
              themeMode: (state.userProfile?.isDarkMode ?? false)
                  ? ThemeMode.dark
                  : ThemeMode.light,
            );
          },
        ),
      ),
    );
  }
}