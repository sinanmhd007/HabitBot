import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:habitbot/core/theme/theme_bloc.dart';
import 'package:habitbot/core/network/dio_client.dart';
import 'package:habitbot/core/network/webhook_service.dart';
import 'package:habitbot/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:habitbot/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:habitbot/features/auth/domain/repositories/auth_repository.dart';
import 'package:habitbot/features/auth/domain/usecases/check_auth_status_usecase.dart';
import 'package:habitbot/features/auth/domain/usecases/login_usecase.dart';
import 'package:habitbot/features/auth/domain/usecases/logout_usecase.dart';
import 'package:habitbot/features/auth/domain/usecases/signup_usecase.dart';
import 'package:habitbot/features/auth/domain/usecases/update_user_usecase.dart';
import 'package:habitbot/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:habitbot/features/habits/data/datasources/habit_remote_data_source.dart';
import 'package:habitbot/features/habits/data/repositories/habit_repository_impl.dart';
import 'package:habitbot/features/habits/domain/repositories/habit_repository.dart';
import 'package:habitbot/features/habits/domain/usecases/accountability_engine.dart';
import 'package:habitbot/features/habits/domain/usecases/add_habit_usecase.dart';
import 'package:habitbot/features/habits/domain/usecases/delete_habit_usecase.dart';
import 'package:habitbot/features/habits/domain/usecases/get_habits_usecase.dart';
import 'package:habitbot/features/habits/domain/usecases/toggle_habit_status_usecase.dart';
import 'package:habitbot/features/habits/domain/usecases/update_habit_usecase.dart';
import 'package:habitbot/features/habits/presentation/bloc/habit_bloc.dart';



final sl = GetIt.instance;

Future<void> init() async {
  // Initialize SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  // -- Features: Auth --
  sl.registerFactory(() => AuthBloc(
        loginUseCase: sl(),
        signupUseCase: sl(),
        logoutUseCase: sl(),
        checkAuthStatusUseCase: sl(),
        updateUserUseCase: sl(),
      ));
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => SignupUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  sl.registerLazySingleton(() => CheckAuthStatusUseCase(sl()));
  sl.registerLazySingleton(() => UpdateUserUseCase(sl()));
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(remoteDataSource: sl()));
  sl.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSourceImpl(firebaseAuth: sl(), firestore: sl()));

  // -- Features: Habits --
  sl.registerFactory(() => HabitBloc(
        getHabits: sl(),
        addHabit: sl(),
        updateHabit: sl(),
        deleteHabit: sl(),
        toggleHabitStatus: sl(),
        authRepository: sl(),
        accountabilityEngine: sl(),
      ));
  sl.registerLazySingleton(() => GetHabitsUseCase(sl()));
  sl.registerLazySingleton(() => AddHabitUseCase(sl()));
  sl.registerLazySingleton(() => UpdateHabitUseCase(sl()));
  sl.registerLazySingleton(() => DeleteHabitUseCase(sl()));
  sl.registerLazySingleton(() => ToggleHabitStatusUseCase(sl()));
  sl.registerLazySingleton(() => AccountabilityEngine(habitRepository: sl(), webhookService: sl()));
  sl.registerLazySingleton<HabitRepository>(() => HabitRepositoryImpl(remoteDataSource: sl()));
  sl.registerLazySingleton<HabitRemoteDataSource>(() => HabitRemoteDataSourceImpl(firestore: sl(), dioClient: sl()));

  // -- Core --
  sl.registerLazySingleton(() => DioClient(dio: sl()));
  sl.registerLazySingleton(() => WebhookService(sl()));
  sl.registerFactory(() => ThemeBloc(sharedPreferences: sl()));
  
  // -- External --
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => FirebaseFirestore.instance);
}
