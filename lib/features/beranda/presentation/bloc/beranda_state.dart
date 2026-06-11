import 'package:equatable/equatable.dart';
import 'package:majadigi/core/error/failure.dart';
import 'package:majadigi/features/beranda/domain/entity/banner_entity.dart';
import 'package:majadigi/features/beranda/domain/entity/jatim_angka_entity.dart';
import 'package:majadigi/features/beranda/domain/entity/service_entity.dart';

enum BerandaSectionStatus { initial, loading, loaded, error }

class BerandaState extends Equatable {
  final BerandaSectionStatus bannerStatus;
  final List<BannerEntity> banners;
  final String bannerError;

  final BerandaSectionStatus serviceStatus;
  final List<ServiceEntity> services;
  final String serviceError;

  final BerandaSectionStatus jatimAngkaStatus;
  final List<JatimAngkaEntity> jatimAngka;
  final String jatimAngkaError;

  const BerandaState({
    this.bannerStatus = BerandaSectionStatus.initial,
    this.banners = const [],
    this.bannerError = '',
    this.serviceStatus = BerandaSectionStatus.initial,
    this.services = const [],
    this.serviceError = '',
    this.jatimAngkaStatus = BerandaSectionStatus.initial,
    this.jatimAngka = const [],
    this.jatimAngkaError = '',
  });

  BerandaState copyWith({
    BerandaSectionStatus? bannerStatus,
    List<BannerEntity>? banners,
    String? bannerError,
    BerandaSectionStatus? serviceStatus,
    List<ServiceEntity>? services,
    String? serviceError,
    BerandaSectionStatus? jatimAngkaStatus,
    List<JatimAngkaEntity>? jatimAngka,
    String? jatimAngkaError,
  }) {
    return BerandaState(
      bannerStatus: bannerStatus ?? this.bannerStatus,
      banners: banners ?? this.banners,
      bannerError: bannerError ?? this.bannerError,
      serviceStatus: serviceStatus ?? this.serviceStatus,
      services: services ?? this.services,
      serviceError: serviceError ?? this.serviceError,
      jatimAngkaStatus: jatimAngkaStatus ?? this.jatimAngkaStatus,
      jatimAngka: jatimAngka ?? this.jatimAngka,
      jatimAngkaError: jatimAngkaError ?? this.jatimAngkaError,
    );
  }

  @override
  List<Object?> get props => [
        bannerStatus,
        banners,
        bannerError,
        serviceStatus,
        services,
        serviceError,
        jatimAngkaStatus,
        jatimAngka,
        jatimAngkaError,
      ];
}
