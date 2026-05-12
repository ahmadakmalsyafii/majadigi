
import 'package:equatable/equatable.dart';

class FeatureEntity extends Equatable{
  final String id;
  final String layananId;
  final String judul;

  const FeatureEntity({
    required this.id,
    required this.layananId,
    required this.judul,
  });

  @override
  List<Object?> get props => [id, layananId, judul];
}