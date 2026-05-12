
import 'package:equatable/equatable.dart';

class BannerEntity extends Equatable {
  final String id;
  final String imageUrl;
  final String name;
  final bool isActive;


  const BannerEntity({
    required this.id,
    required this.imageUrl,
    required this.name,
    this.isActive = true,
  });
  @override
  List<Object?> get props => [
    id,
    imageUrl,
    name,
    isActive
  ];



}