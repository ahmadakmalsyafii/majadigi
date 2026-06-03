import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:majadigi/deffered_feature/destinasi_wisata/domain/entity/destination_entity.dart';

class DestinationModel extends DestinationEntity {
  const DestinationModel({
    required super.id,
    required super.category,
    required super.description,
    required super.imageUrl,
    required super.latitude,
    required super.longitude,
    required super.locationSummary,
    required super.name,
    required super.priceAmount,
    required super.priceFormatted,
    required super.province,
    required super.tips,
  });

  factory DestinationModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};

    double lat = 0.0;
    double lng = 0.0;
    
    final coordinates = data['location_coordinates'];
    if (coordinates is GeoPoint) {
      lat = coordinates.latitude;
      lng = coordinates.longitude;
    } else if (coordinates is String && coordinates.isNotEmpty) {
      try {
        final cleanStr = coordinates.replaceAll('[', '').replaceAll(']', '').trim();
        final parts = cleanStr.split(',');
        if (parts.length == 2) {
          lat = _parseCoordinate(parts[0].trim(), isLat: true);
          lng = _parseCoordinate(parts[1].trim(), isLat: false);
        }
      } catch (e) {
        // Fallback to 0.0
      }
    }

    final priceMap = data['price'] is Map ? data['price'] as Map : {};

    return DestinationModel(
      id: doc.id,
      category: data['category'] is List ? List<String>.from(data['category']) : [],
      description: data['description']?.toString() ?? '',
      imageUrl: data['image_url']?.toString() ?? '',
      latitude: lat,
      longitude: lng,
      locationSummary: data['location_summary']?.toString() ?? '',
      name: data['name']?.toString() ?? '',
      priceAmount: (priceMap['amount'] as num?)?.toInt() ?? 0,
      priceFormatted: priceMap['formatted']?.toString() ?? '',
      province: data['province']?.toString() ?? '',
      tips: data['tips'] is List ? List<String>.from(data['tips']) : [],
    );
  }

  static double _parseCoordinate(String part, {required bool isLat}) {
    // Expected format: "7.8389° S" or "114.3639° E"
    final regex = RegExp(r'([\d\.]+)[^\w]*([NSEW])?');
    final match = regex.firstMatch(part.toUpperCase());
    
    if (match != null) {
      double value = double.tryParse(match.group(1) ?? '0') ?? 0.0;
      String direction = match.group(2) ?? '';

      if (direction == 'S' || direction == 'W') {
        value = -value;
      }
      return value;
    }
    return 0.0;
  }
}
