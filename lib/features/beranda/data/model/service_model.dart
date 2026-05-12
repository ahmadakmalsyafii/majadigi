import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:majadigi/features/beranda/data/model/feature_model.dart';
import 'package:majadigi/features/beranda/data/model/operational_hour_model.dart';
import 'package:majadigi/features/beranda/domain/entity/service_entity.dart';

class ServiceModel extends ServiceEntity {
  const ServiceModel({
    required super.id,
    required super.name,
    required super.icon,
    required super.about,
    required super.description,
    required super.address,
    required super.websiteUrl,
    required super.features,
    required super.operationalHours,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      icon: json['icon'] ?? '',
      about: json['about'] ?? '',
      description: json['description'] ?? '',
      address: json['address'] ?? '',
      websiteUrl: json['website_url'] ?? '',
      features: json['feature'] != null
          ? (json['feature'] as List<dynamic>)
                .map(
                  (item) => FeatureModel.fromJson(
                    Map<String, dynamic>.from(item as Map),
                  ),
                )
                .toList()
          : [],
      operationalHours: json['operational_hours'] != null
          ? OperationalHourModel.fromJson(
              Map<String, dynamic>.from(json['operational_hours'] as Map),
            )
          : const OperationalHourModel(
              hari: '',
              buka: '',
              tutup: '',
              keterangan: '',
            ),
    );
  }

  factory ServiceModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ServiceModel(
      id: data['id'] ?? '',
      name: data['name'] ?? '',
      icon: data['icon'] ?? '',
      about: data['about'] ?? '',
      description: data['description'] ?? '',
      address: data['address'] ?? '',
      websiteUrl: data['website_url'] ?? '',
      features: data['feature'] != null
          ? (data['feature'] as List<dynamic>)
                .map(
                  (item) => FeatureModel.fromJson(
                    Map<String, dynamic>.from(item as Map),
                  ),
                )
                .toList()
          : [],
      operationalHours: data['operational_hours'] != null
          ? OperationalHourModel.fromJson(
              Map<String, dynamic>.from(data['operational_hours'] as Map),
            )
          : const OperationalHourModel(
              hari: '',
              buka: '',
              tutup: '',
              keterangan: '',
            ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'about': about,
      'description': description,
      'address': address,
      'website_url': websiteUrl,
      'feature': features.map((f) => (f as FeatureModel).toJson()).toList(),
      'operational_hours': (operationalHours as OperationalHourModel).toJson(),
    };
  }
}
