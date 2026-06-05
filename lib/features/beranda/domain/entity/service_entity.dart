import 'package:equatable/equatable.dart';
import 'package:majadigi/features/beranda/domain/entity/feature_entity.dart';
import 'package:majadigi/features/beranda/domain/entity/operational_hour_entity.dart';

class ServiceEntity extends Equatable {
  final String id;
  final String name;
  final String icon;
  final String about;
  final String description;
  final String address;
  final String websiteUrl;
  final List<FeatureEntity> features;
  final OperationalHourEntity operationalHours;


  const ServiceEntity({
    required this.id,
    required this.name,
    required this.icon,
    required this.about,
    required this.description,
    required this.address,
    required this.websiteUrl,
    required this.features,
    required this.operationalHours,

  });

  @override
  List<Object?> get props => [id, name, icon, about, description, address, websiteUrl, features, operationalHours];
}
