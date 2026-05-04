import 'package:equatable/equatable.dart';
import 'package:majadigi/core/error/failure.dart';
import 'package:majadigi/features/beranda/domain/entitiy/banner_entity.dart';

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

class BerandaLoaded extends BerandaState {
  final List<BannerEntity> banners;

  const BerandaLoaded({required this.banners});

  @override
  List<Object?> get props => [banners];
}

class BannerError extends BerandaState {
  final String message;
  final Failure failure;

  const BannerError({required this.message, required this.failure});

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

