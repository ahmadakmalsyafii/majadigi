import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:majadigi/features/auth/data/datasources/remote/auth_datasource_remote.dart';
import 'package:majadigi/features/auth/data/repository/auth_repository_impl.dart';
import 'package:majadigi/features/auth/domain/repositories/auth_repository.dart';
import 'package:majadigi/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:majadigi/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:majadigi/features/auth/domain/usecases/sign_up_usecase.dart';
import 'package:majadigi/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:majadigi/features/navigation/presentation/bloc/navigation_bloc.dart';

/// Global service locator.
final sl = GetIt.instance;

void init(){

  // External dependencies
  sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);

  // Factories/BLoCs
  // di.registerFactory<AuthBloc>(() => AuthBloc(di()));
  sl.registerFactory(() => NavigationBloc());
  sl.registerLazySingleton(
        () => AuthBloc(
      signIn: sl(),
      signOut: sl(),
      signUp: sl(),
    ),
  );




  // Use Cases
  // di.registerLazySingleton<AuthUseCase>(() => AuthUseCaseImpl(di()));
  sl.registerLazySingleton(() => SignInUseCase(sl()));
  sl.registerLazySingleton(() => SignUpUsecase(sl()));
  sl.registerLazySingleton(() => SignOutUsecase(sl()));
  // sl.registerLazySingleton(() => GetCachedUser(sl()));

  // Data Sources
  // di.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSourceImpl(di()));
  sl.registerLazySingleton<AuthRemoteDataSource>(
        () => AuthRemoteDataSourceImpl(firebaseAuth: sl()),
  );

  // Repositories
  // di.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(di()));
  sl.registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      firebaseAuth: sl(),
    ),
  );

}