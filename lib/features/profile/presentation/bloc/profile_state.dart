import 'package:equatable/equatable.dart';
import 'package:majadigi/core/error/failure.dart';
import 'package:majadigi/features/auth/domain/entitiy/user_entity.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

class ProfileInitial extends ProfileState {
  const ProfileInitial();
}

class ProfileLoading extends ProfileState {
  const ProfileLoading();
}

class ProfileSuccess extends ProfileState {
  final UserEntity user;

  const ProfileSuccess(this.user);

  @override
  List<Object> get props => [user];
}

class ProfileFailure extends ProfileState {
  final Failure failure;

  const ProfileFailure(this.failure);

  @override
  List<Object> get props => [failure];
}
