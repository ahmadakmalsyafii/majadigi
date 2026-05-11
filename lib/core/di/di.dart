import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:majadigi/features/auth/data/datasources/remote/auth_datasource_remote.dart';
import 'package:majadigi/features/auth/data/repository/auth_repository_impl.dart';
import 'package:majadigi/features/auth/domain/repositories/auth_repository.dart';
import 'package:majadigi/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:majadigi/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:majadigi/features/auth/domain/usecases/sign_up_usecase.dart';
import 'package:majadigi/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:majadigi/features/profile/data/repository/profile_repository_impl.dart';
import 'package:majadigi/features/profile/domain/repositories/profile_repository.dart';
import 'package:majadigi/features/profile/domain/usecases/update_profile_usecase.dart';
import 'package:majadigi/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:majadigi/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:majadigi/core/network/api_key_manager.dart';
import 'package:majadigi/core/network/dio_client.dart';
import 'package:majadigi/features/navigation/presentation/bloc/navigation_bloc.dart';
import 'package:majadigi/features/layanan/data/datasources/layanan_remote_datasource.dart';
import 'package:majadigi/features/layanan/data/repositories/layanan_repository_impl.dart';
import 'package:majadigi/features/layanan/domain/repositories/layanan_repository.dart';
import 'package:majadigi/features/layanan/domain/usecases/get_katalog_layanan_usecase.dart';
import 'package:majadigi/features/layanan/presentation/bloc/layanan_bloc.dart';
import 'package:majadigi/features/beranda/data/datasources/remote/banner_remote_datasource.dart';
import 'package:majadigi/features/beranda/data/repository/beranda_repository_impl.dart';
import 'package:majadigi/features/beranda/domain/repositories/banner_repository.dart';
import 'package:majadigi/features/beranda/domain/usecases/get_all_banner_usecase.dart';
import 'package:majadigi/features/beranda/presentation/bloc/beranda_bloc.dart';
import 'package:majadigi/features/no_darurat/data/datasources/emergency_remote_datasource.dart';
import 'package:majadigi/features/no_darurat/data/repository/emergency_repository_impl.dart';
import 'package:majadigi/features/no_darurat/domain/repositories/emergency_repository.dart';
import 'package:majadigi/features/no_darurat/domain/usecases/get_emergency_numbers_usecase.dart';
import 'package:majadigi/features/no_darurat/domain/usecases/get_kab_kota_usecase.dart';
import 'package:majadigi/features/no_darurat/presentation/bloc/emergency/emergency_bloc.dart';

/// Global service locator.
final sl = GetIt.instance;

void init(){

  // External dependencies
  sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  sl.registerLazySingleton<FirebaseRemoteConfig>(() => FirebaseRemoteConfig.instance);
  sl.registerLazySingleton(() => ApiKeyManager(sl()));
  sl.registerLazySingleton(() => DioClient(sl()));
  sl.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);

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

  sl.registerFactory(
        () => ProfileBloc(
      updateProfile: sl(),
    ),
  );
  
  sl.registerFactory(() => LayananBloc(sl()));
  sl.registerFactory(() => BerandaBloc(getBannersUseCase: sl()));
  sl.registerFactory(() => EmergencyBloc(
    getEmergencyNumbers: sl(),
    getKabKota: sl(),
  ));




  // Use Cases
  // di.registerLazySingleton<AuthUseCase>(() => AuthUseCaseImpl(di()));
  sl.registerLazySingleton(() => SignInUseCase(sl()));
  sl.registerLazySingleton(() => SignUpUsecase(sl()));
  sl.registerLazySingleton(() => SignOutUsecase(sl()));
  sl.registerLazySingleton(() => UpdateProfileUseCase(sl()));
  sl.registerLazySingleton(() => GetKatalogLayananUseCase(sl()));
  // sl.registerLazySingleton(() => GetCachedUser(sl()));
  sl.registerLazySingleton(() => GetAllBannersUseCase(sl()));
  sl.registerLazySingleton(() => GetEmergencyNumbersUseCase(sl()));
  sl.registerLazySingleton(() => GetKabKotaUseCase(sl()));

  // Data Sources
  // di.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSourceImpl(di()));
  sl.registerLazySingleton<AuthRemoteDataSource>(
        () => AuthRemoteDataSourceImpl(firebaseAuth: sl()),
  );
  sl.registerLazySingleton<ProfileRemoteDataSource>(
        () => ProfileRemoteDataSourceImpl(firebaseAuth: sl()),
  );
  sl.registerLazySingleton<LayananRemoteDataSource>(
        () => LayananRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<BannerRemoteDataSource>(
        () => BannerRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<EmergencyRemoteDataSource>(
        () => EmergencyRemoteDataSourceImpl(sl()),
  );

  // Repositories
  // di.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(di()));
  sl.registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      firebaseAuth: sl(),
    ),
  );
  sl.registerLazySingleton<ProfileRepository>(
        () => ProfileRepositoryImpl(
      remoteDataSource: sl(),
    ),
  );
  sl.registerLazySingleton<LayananRepository>(
        () => LayananRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<BannerRepository>(
        () => BerandaRepositoryImpl(
      remoteDataSource: sl(),
    ),
  );
  sl.registerLazySingleton<EmergencyRepository>(
        () => EmergencyRepositoryImpl(remoteDataSource: sl()),
  );

}