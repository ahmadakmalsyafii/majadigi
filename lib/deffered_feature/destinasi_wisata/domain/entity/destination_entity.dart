import 'package:equatable/equatable.dart';

class DestinationEntity extends Equatable {
  final String id;
  final List<String> category;
  final String description;
  final String imageUrl;
  final double latitude;
  final double longitude;
  final String locationSummary;
  final String name;
  final int priceAmount;
  final String priceFormatted;
  final String province;
  final List<String> tips;

  const DestinationEntity({
    required this.id,
    required this.category,
    required this.description,
    required this.imageUrl,
    required this.latitude,
    required this.longitude,
    required this.locationSummary,
    required this.name,
    required this.priceAmount,
    required this.priceFormatted,
    required this.province,
    required this.tips,
  });

  @override
  List<Object?> get props => [
        id,
        category,
        description,
        imageUrl,
        latitude,
        longitude,
        locationSummary,
        name,
        priceAmount,
        priceFormatted,
        province,
        tips,
      ];
}
