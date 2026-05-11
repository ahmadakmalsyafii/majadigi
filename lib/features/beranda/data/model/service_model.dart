import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:majadigi/features/beranda/domain/entitiy/service_entity.dart';

class ServiceModel extends ServiceEntity {
  const ServiceModel({
    required super.id,
    required super.name,
    required super.icon,
    required super.about,
    super.description,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      icon: json['icon'] ?? '',
      about: json['about'] ?? '',
      description: json['description'],
    );
  }

  factory ServiceModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ServiceModel(
      id: data['id'] ?? '',
      name: data['name'] ?? '',
      icon: data['icon'] ?? '',
      about: data['about'] ?? '',
      description: data['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'about': about,
      'description': description,
    };
  }
}
