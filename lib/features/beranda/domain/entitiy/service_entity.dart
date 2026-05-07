
import 'package:equatable/equatable.dart';

class ServiceEntity extends Equatable{
  final String id;
  final String name;
  final String icon;
  final String about;
  final String? description;

  const ServiceEntity({
    required this.id,
    required this.name,
    required this.icon,
    required this.about,
    this.description,
  });

  @override
  List<Object?> get props => [id, name, icon, about, description];
}