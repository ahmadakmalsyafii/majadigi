import 'package:equatable/equatable.dart';

abstract class IslamicCenterEvent extends Equatable {
  const IslamicCenterEvent();

  @override
  List<Object?> get props => [];
}

class GetFacilitiesEvent extends IslamicCenterEvent {}
