import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String uid;
  final String name;
  final String email;
  final String? password;
  final String? address;
  final String? NIK;
  final DateTime? dateOfBirth;
  final String? gender;

  UserEntity({
    required this.uid,
    required this.name,
    required this.email,
    this.password,
    this.address,
    this.NIK,
    this.dateOfBirth,
    this.gender,
  });

  @override
  List<Object?> get props => [
    uid,
    name,
    email,
    password,
    address,
    NIK,
    dateOfBirth,
    gender
  ];
}