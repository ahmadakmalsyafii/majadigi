import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:majadigi/deffered_feature/klinik_hoaks/data/datasources/klinik_hoaks_remote_datasource.dart';
import 'package:majadigi/deffered_feature/klinik_hoaks/domain/repositories/klinik_hoaks_repository.dart';
import 'package:majadigi/deffered_feature/klinik_hoaks/data/repository/klinik_hoaks_repository_impl.dart';
import 'package:majadigi/deffered_feature/klinik_hoaks/domain/usecases/get_klinik_hoaks_clarifications_usecase.dart';
import 'package:majadigi/deffered_feature/klinik_hoaks/domain/usecases/get_klinik_hoaks_stats_usecase.dart';
import 'package:majadigi/deffered_feature/klinik_hoaks/domain/usecases/report_hoax_usecase.dart';
import 'package:majadigi/deffered_feature/klinik_hoaks/presentation/bloc/klinik_hoaks_bloc.dart';
import 'package:majadigi/features/auth/data/datasources/local/auth_local_datasource.dart';
import 'package:majadigi/features/auth/data/datasources/remote/auth_remote_datasource.dart';
import 'package:majadigi/features/auth/data/repository/auth_repository_impl.dart';
import 'package:majadigi/features/auth/domain/repositories/auth_repository.dart';
import 'package:majadigi/features/auth/domain/usecases/get_cached_user_usecase.dart';
import 'package:majadigi/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:majadigi/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:majadigi/features/auth/domain/usecases/sign_up_usecase.dart';
import 'package:majadigi/features/beranda/data/datasources/remote/beranda_remote_datasource.dart';
import 'package:majadigi/features/beranda/domain/repositories/jatim_angka_repository.dart';
import 'package:majadigi/features/beranda/domain/repositories/service_repository.dart';
import 'package:majadigi/features/beranda/domain/usecases/get_all_service_usecase.dart';
import 'package:majadigi/features/beranda/domain/usecases/get_service_section_usecase.dart';
import 'package:majadigi/features/list_layanan/presentation/bloc/list_layanan_bloc.dart';
import 'package:majadigi/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:majadigi/features/profile/data/repository/profile_repository_impl.dart';
import 'package:majadigi/features/profile/domain/repositories/profile_repository.dart';
import 'package:majadigi/features/profile/domain/usecases/update_profile_usecase.dart';
import 'package:majadigi/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:majadigi/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:majadigi/core/network/api_key_manager.dart';
import 'package:majadigi/core/network/dio_client.dart';
import 'package:majadigi/core/router/app_router.dart';
import 'package:majadigi/features/layanan/data/datasources/layanan_remote_datasource.dart';
import 'package:majadigi/features/layanan/data/repositories/layanan_repository_impl.dart';
import 'package:majadigi/features/layanan/domain/repositories/layanan_repository.dart';
import 'package:majadigi/features/layanan/domain/usecases/get_katalog_layanan_usecase.dart';
import 'package:majadigi/features/layanan/presentation/bloc/layanan_bloc.dart';
import 'package:majadigi/features/beranda/data/repository/beranda_repository_impl.dart';
import 'package:majadigi/features/beranda/domain/repositories/banner_repository.dart';
import 'package:majadigi/features/beranda/domain/usecases/get_all_banner_usecase.dart';
import 'package:majadigi/features/beranda/presentation/bloc/beranda_bloc.dart';
import 'package:majadigi/deffered_feature/no_darurat/data/datasources/emergency_remote_datasource.dart';
import 'package:majadigi/deffered_feature/no_darurat/data/repository/emergency_repository_impl.dart';
import 'package:majadigi/deffered_feature/no_darurat/domain/repositories/emergency_repository.dart';
import 'package:majadigi/deffered_feature/no_darurat/domain/usecases/get_emergency_numbers_usecase.dart';
import 'package:majadigi/deffered_feature/no_darurat/domain/usecases/get_kab_kota_usecase.dart';
import 'package:majadigi/deffered_feature/no_darurat/presentation/bloc/emergency/emergency_bloc.dart';
import 'package:majadigi/features/beranda/domain/usecases/get_jatim_angka_usecase.dart';
import 'package:majadigi/deffered_feature/ketersediaan_kamar/data/datasources/ketersediaan_kamar_remote_datasource.dart';
import 'package:majadigi/deffered_feature/ketersediaan_kamar/data/repository/ketersediaan_kamar_repository_impl.dart';
import 'package:majadigi/deffered_feature/ketersediaan_kamar/domain/repositories/ketersediaan_kamar_repository.dart';
import 'package:majadigi/deffered_feature/ketersediaan_kamar/domain/usecases/get_room_availability_usecase.dart';
import 'package:majadigi/deffered_feature/ketersediaan_kamar/presentation/bloc/ketersediaan_kamar_bloc.dart';
import 'package:majadigi/deffered_feature/antrean_pasien/data/datasources/antrean_remote_datasource.dart';
import 'package:majadigi/deffered_feature/antrean_pasien/data/repository/antrean_repository_impl.dart';
import 'package:majadigi/deffered_feature/antrean_pasien/domain/repositories/antrean_repository.dart';
import 'package:majadigi/deffered_feature/antrean_pasien/domain/usecases/get_antrean_usecase.dart';
import 'package:majadigi/deffered_feature/antrean_pasien/domain/usecases/get_dokter_usecase.dart';
import 'package:majadigi/deffered_feature/antrean_pasien/domain/usecases/get_poli_usecase.dart';
import 'package:majadigi/deffered_feature/antrean_pasien/presentation/bloc/antrean_bloc.dart';
import 'package:majadigi/deffered_feature/jadwal_operasi/data/datasources/jadwal_operasi_remote_datasource.dart';
import 'package:majadigi/deffered_feature/jadwal_operasi/data/repository/jadwal_operasi_repository_impl.dart';
import 'package:majadigi/deffered_feature/jadwal_operasi/domain/repositories/jadwal_operasi_repository.dart';
import 'package:majadigi/deffered_feature/jadwal_operasi/domain/usecases/get_jadwal_operasi_usecase.dart';
import 'package:majadigi/deffered_feature/jadwal_operasi/presentation/bloc/jadwal_operasi_bloc.dart';
import 'package:majadigi/deffered_feature/pendaftaran_pasien/data/datasources/pendaftaran_remote_datasource.dart';
import 'package:majadigi/deffered_feature/pendaftaran_pasien/data/repository/pendaftaran_repository_impl.dart';
import 'package:majadigi/deffered_feature/pendaftaran_pasien/domain/repositories/pendaftaran_repository.dart';
import 'package:majadigi/deffered_feature/pendaftaran_pasien/domain/usecases/get_pendaftaran_doctors_usecase.dart';
import 'package:majadigi/deffered_feature/pendaftaran_pasien/domain/usecases/get_pendaftaran_polis_usecase.dart';
import 'package:majadigi/deffered_feature/pendaftaran_pasien/domain/usecases/get_time_slot_quotas_usecase.dart';
import 'package:majadigi/deffered_feature/pendaftaran_pasien/domain/usecases/save_registration_usecase.dart';
import 'package:majadigi/deffered_feature/pendaftaran_pasien/presentation/bloc/pendaftaran_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:majadigi/deffered_feature/harga_bahan_pokok/data/datasources/harga_bahan_pokok_remote_data_source.dart';
import 'package:majadigi/deffered_feature/harga_bahan_pokok/data/repositories/harga_bahan_pokok_repository_impl.dart';
import 'package:majadigi/deffered_feature/harga_bahan_pokok/domain/repositories/harga_bahan_pokok_repository.dart';
import 'package:majadigi/deffered_feature/harga_bahan_pokok/domain/usecases/get_commodity_price_list_usecase.dart';
import 'package:majadigi/deffered_feature/harga_bahan_pokok/domain/usecases/get_commodity_detail_usecase.dart';
import 'package:majadigi/deffered_feature/harga_bahan_pokok/domain/usecases/get_city_price_list_usecase.dart';
import 'package:majadigi/deffered_feature/harga_bahan_pokok/presentation/bloc/harga_bahan_pokok_bloc.dart';
import 'package:majadigi/deffered_feature/bansos/data/datasources/bansos_remote_datasource.dart';
import 'package:majadigi/deffered_feature/bansos/data/repository/bansos_repository_impl.dart';
import 'package:majadigi/deffered_feature/bansos/domain/repositories/bansos_repository.dart';
import 'package:majadigi/deffered_feature/bansos/domain/usecases/get_bansos_by_nik_usecase.dart';
import 'package:majadigi/deffered_feature/bansos/presentation/bloc/bansos_bloc.dart';
import 'package:majadigi/deffered_feature/destinasi_wisata/data/datasources/destination_remote_datasource.dart';
import 'package:majadigi/deffered_feature/destinasi_wisata/data/repository/destination_repository_impl.dart';
import 'package:majadigi/deffered_feature/destinasi_wisata/domain/repositories/destination_repository.dart';
import 'package:majadigi/deffered_feature/destinasi_wisata/domain/usecases/get_destinations_usecase.dart';
import 'package:majadigi/deffered_feature/destinasi_wisata/presentation/bloc/destination_bloc.dart';
import 'package:majadigi/core/feature_manager/data/datasources/feature_manager_local_datasource.dart';
import 'package:majadigi/core/feature_manager/data/repositories/feature_manager_repository_impl.dart';
import 'package:majadigi/core/feature_manager/domain/repositories/feature_manager_repository.dart';
import 'package:majadigi/core/feature_manager/domain/usecases/manage_feature_usecase.dart';
import 'package:majadigi/core/feature_manager/presentation/bloc/feature_manager_bloc.dart';
import 'package:majadigi/deffered_feature/islamic_center/data/datasources/islamic_center_remote_datasource.dart';
import 'package:majadigi/deffered_feature/islamic_center/data/repository/islamic_center_repository_impl.dart';
import 'package:majadigi/deffered_feature/islamic_center/domain/repositories/islamic_center_repository.dart';
import 'package:majadigi/deffered_feature/islamic_center/domain/usecases/get_facilities_usecase.dart';
import 'package:majadigi/deffered_feature/islamic_center/presentation/bloc/islamic_center_bloc.dart';

/// Global service locator.
final sl = GetIt.instance;

void init() async {
  // External dependencies
  final sharedpreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedpreferences);
  sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  sl.registerLazySingleton<FirebaseRemoteConfig>(
    () => FirebaseRemoteConfig.instance,
  );
  sl.registerLazySingleton(() => ApiKeyManager(sl()));
  sl.registerLazySingleton(() => DioClient(sl()));
  sl.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);

  // Factories/BLoCs
  // di.registerFactory<AuthBloc>(() => AuthBloc(di()));
  sl.registerLazySingleton(() => AppRouter(sl()));
  sl.registerLazySingleton(
    () => AuthBloc(
      signIn: sl(),
      signOut: sl(),
      signUp: sl(),
      getCachedUser: sl(),
    ),
  );

  sl.registerFactory(() => ProfileBloc(updateProfile: sl()));

  sl.registerFactory(() => LayananBloc(
    getAllServiceUseCase: sl(),
    getKatalogLayananUseCase: sl(),
  ));
  sl.registerFactory(
    () => BerandaBloc(
      getBannerUseCase: sl(),
      getServiceUseCase: sl(),
      getJatimAngkaUseCase: sl(),
    ),
  );
  sl.registerFactory(
    () => EmergencyBloc(getEmergencyNumbers: sl(), getKabKota: sl()),
  );
  sl.registerFactory(() => KetersediaanKamarBloc(getRoomAvailability: sl()));
  sl.registerFactory(
    () => AntreanBloc(
      getPoliUseCase: sl(),
      getDokterUseCase: sl(),
      getAntreanUseCase: sl(),
    ),
  );
  sl.registerFactory(() => JadwalOperasiBloc(getJadwalOperasiUseCase: sl()));
  sl.registerFactory(
    () => PendaftaranBloc(
      getPolis: sl(),
      getDoctors: sl(),
      getTimeSlotQuotas: sl(),
      saveRegistration: sl(),
    ),
  );
  sl.registerFactory(
    () => KlinikHoaksBloc(
      getStats: sl(),
      getClarifications: sl(),
      reportHoax: sl(),
    ),
  );
  sl.registerFactory(
    () => HargaBahanPokokBloc(
      getCommodityPriceList: sl(),
      getCommodityDetail: sl(),
      getCityPriceList: sl(),
    ),
  );
  sl.registerFactory(() => BansosBloc(getBansosByNik: sl()));
  sl.registerFactory(() => DestinationBloc(getDestinationsUseCase: sl()));

  sl.registerFactory(() => ListLayananBloc(getAllServiceUsecase: sl()));
  sl.registerFactory(() => IslamicCenterBloc(getFacilitiesUseCase: sl()));

  // Use Cases
  // di.registerLazySingleton<AuthUseCase>(() => AuthUseCaseImpl(di()));
  sl.registerLazySingleton(() => SignInUseCase(sl()));
  sl.registerLazySingleton(() => SignUpUsecase(sl()));
  sl.registerLazySingleton(() => SignOutUsecase(sl()));
  sl.registerLazySingleton(() => GetCachedUserUsecase(sl()));
  sl.registerLazySingleton(() => UpdateProfileUseCase(sl()));
  sl.registerLazySingleton(() => GetKatalogLayananUseCase(sl()));
  sl.registerLazySingleton(() => GetAllBannerUseCase(sl()));
  sl.registerLazySingleton(() => GetAllServiceUsecase(sl()));
  sl.registerLazySingleton(() => GetJatimAngkaUseCase(sl()));
  sl.registerLazySingleton(() => GetEmergencyNumbersUseCase(sl()));
  sl.registerLazySingleton(() => GetKabKotaUseCase(sl()));
  sl.registerLazySingleton(() => GetRoomAvailabilityUseCase(sl()));
  sl.registerLazySingleton(() => GetPoliUseCase(sl()));
  sl.registerLazySingleton(() => GetDokterUseCase(sl()));
  sl.registerLazySingleton(() => GetAntreanUseCase(sl()));
  sl.registerLazySingleton(() => GetJadwalOperasiUseCase(sl()));
  sl.registerLazySingleton(() => GetPendaftaranPolisUseCase(sl()));
  sl.registerLazySingleton(() => GetPendaftaranDoctorsUseCase(sl()));
  sl.registerLazySingleton(() => GetTimeSlotQuotasUseCase(sl()));
  sl.registerLazySingleton(() => SaveRegistrationUseCase(sl()));
  sl.registerLazySingleton(() => GetKlinikHoaksStatsUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetKlinikHoaksClarificationsUseCase(repository: sl()));
  sl.registerLazySingleton(() => ReportHoaxUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetServiceSectionUsecase(sl()));
  sl.registerLazySingleton(() => GetCommodityPriceListUseCase(sl()));
  sl.registerLazySingleton(() => GetCommodityDetailUseCase(sl()));
  sl.registerLazySingleton(() => GetCityPriceListUseCase(sl()));
  sl.registerLazySingleton(() => GetBansosByNikUseCase(sl()));
  sl.registerLazySingleton(() => GetDestinationsUseCase(sl()));
  sl.registerLazySingleton(() => GetFacilitiesUseCase(sl()));

  // Data Sources
  // di.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSourceImpl(di()));
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(firebaseAuth: sl()),
  );
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(sharedPreferences: sl()),
  );
  sl.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(firebaseAuth: sl()),
  );
  sl.registerLazySingleton<LayananRemoteDataSource>(
    () => LayananRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<BerandaRemoteDatasource>(
    () => BerandaRemoteDatasourceImpl(dioClient: sl()),
  );
  sl.registerLazySingleton<EmergencyRemoteDataSource>(
    () => EmergencyRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<KetersediaanKamarRemoteDataSource>(
    () => KetersediaanKamarRemoteDataSourceImpl(dioClient: sl()),
  );
  sl.registerLazySingleton<AntreanRemoteDataSource>(
    () => AntreanRemoteDataSourceImpl(dioClient: sl()),
  );
  sl.registerLazySingleton<JadwalOperasiRemoteDataSource>(
    () => JadwalOperasiRemoteDataSourceImpl(dioClient: sl()),
  );
  sl.registerLazySingleton<PendaftaranRemoteDataSource>(
        () => PendaftaranRemoteDataSourceImpl(firestore: sl()),
  );
  sl.registerLazySingleton<KlinikHoaksRemoteDataSource>(
    () => KlinikHoaksRemoteDataSourceImpl(dioClient: sl()),
  );
  sl.registerLazySingleton<HargaBahanPokokRemoteDataSource>(
    () => HargaBahanPokokRemoteDataSourceImpl(dioClient: sl()),
  );
  sl.registerLazySingleton<BansosRemoteDataSource>(
    () => BansosRemoteDataSourceImpl(firestore: sl()),
  );
  sl.registerLazySingleton<DestinationRemoteDataSource>(
    () => DestinationRemoteDataSourceImpl(firestore: sl()),
  );
  sl.registerLazySingleton<IslamicCenterRemoteDataSource>(
    () => IslamicCenterRemoteDataSourceImpl(firestore: sl()),
  );

  // Repositories
  // di.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(di()));
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      firebaseAuth: sl(),
    ),
  );
  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<LayananRepository>(
    () => LayananRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<BannerRepository>(
    () => BerandaRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<ServiceRepository>(
    () => BerandaRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<JatimAngkaRepository>(
    () => BerandaRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<EmergencyRepository>(
    () => EmergencyRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<KetersediaanKamarRepository>(
    () => KetersediaanKamarRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<AntreanRepository>(
    () => AntreanRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<JadwalOperasiRepository>(
    () => JadwalOperasiRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<PendaftaranRepository>(
        () => PendaftaranRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<KlinikHoaksRepository>(
    () => KlinikHoaksRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<HargaBahanPokokRepository>(
    () => HargaBahanPokokRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<BansosRepository>(
    () => BansosRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<DestinationRepository>(
    () => DestinationRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<IslamicCenterRepository>(
    () => IslamicCenterRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerLazySingleton<FeatureManagerLocalDataSource>(
    () => FeatureManagerLocalDataSourceImpl(sharedPreferences: sl()),
  );
  sl.registerLazySingleton<FeatureManagerRepository>(
    () => FeatureManagerRepositoryImpl(localDataSource: sl()),
  );
  sl.registerLazySingleton(() => ManageFeatureUsecase(sl()));
  sl.registerFactory(() => FeatureManagerBloc(manageFeatureUsecase: sl()));
}
