import 'package:equatable/equatable.dart';

abstract class BerandaEvent extends Equatable {
  const BerandaEvent();

  @override
  List<Object?> get props => [];
}

class GetBerandaDataEvent extends BerandaEvent {
  const GetBerandaDataEvent();
}

class GetAllBannersEvent extends BerandaEvent {
  const GetAllBannersEvent();
}

