import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class UpdateProfileRequested extends ProfileEvent {
  final String name;
  final String NIK;
  final DateTime dateOfBirth;
  final String email;
  final String password;
  final String? gender;
  final String? address;

  const UpdateProfileRequested({
    required this.name,
    required this.NIK,
    required this.dateOfBirth,
    required this.email,
    required this.password,
    this.gender,
    this.address,
  });

  @override
  List<Object?> get props => [name, NIK, dateOfBirth, email, password, gender, address];
}
