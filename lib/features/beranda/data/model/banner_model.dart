import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:majadigi/features/beranda/domain/entity/banner_entity.dart';

class BannerModel extends BannerEntity{
  const BannerModel({
    required super.id,
    required super.imageUrl,
    required super.name,
    required super.isActive,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: json['id'],
      imageUrl: json['imageUrl'],
      name: json['name'],
      isActive: json['isActive'] ?? true,
    );
  }

  factory BannerModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return BannerModel(
      id: data['id'] ?? doc.id,
      imageUrl: data['imageUrl'] ?? '',
      name: data['name'] ?? '',
      isActive: data['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'imageUrl': imageUrl,
      'name': name,
      'isActive': isActive,
    };
  }
}