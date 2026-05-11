import 'package:equatable/equatable.dart';
import 'package:majadigi/core/error/failure.dart';
import 'package:majadigi/features/beranda/domain/entitiy/banner_entity.dart';
import 'package:majadigi/features/beranda/domain/entitiy/service_entity.dart';
import 'package:majadigi/features/beranda/domain/entitiy/jatim_angka_entity.dart';

abstract class BerandaState extends Equatable {
  const BerandaState();

  @override
  List<Object?> get props => [];
}

class BerandaInitial extends BerandaState {
  const BerandaInitial();
}

class BerandaLoading extends BerandaState {
  const BerandaLoading();
}

class BerandaLoadingBanners extends BerandaState {
  const BerandaLoadingBanners();
}

class BerandaLoadingServices extends BerandaState{
  const BerandaLoadingServices();
}

class BerandaLoadedServices extends BerandaState {
  final List<ServiceEntity> services;

  const BerandaLoadedServices({required this.services});

  @override
  List<Object?> get props => [services];
}

class BerandaLoadedBanners extends BerandaState {
  final List<BannerEntity> banners;

  const BerandaLoadedBanners({required this.banners});

  @override
  List<Object?> get props => [banners];
}

class BerandaLoaded extends BerandaState {
  final List<ServiceEntity> services;
  final List<BannerEntity> banners;
  final List<JatimAngkaEntity> jatimAngka;

  const BerandaLoaded({required this.services, required this.banners, required this.jatimAngka});

  @override
  List<Object?> get props => [services, banners, jatimAngka];
}

class BannerError extends BerandaState {
  final String message;
  final Failure failure;

  const BannerError({required this.message, required this.failure});

  @override
  List<Object?> get props => [message, failure];
}

class ServiceError extends BerandaState {
  final String message;
  final Failure failure;

  const ServiceError({required this.message, required this.failure});

  @override
  List<Object?> get props => [message, failure];
}



class BerandaError extends BerandaState {
  final String message;
  final Failure failure;

  const BerandaError({required this.message, required this.failure});

  @override
  List<Object?> get props => [message, failure];
}

