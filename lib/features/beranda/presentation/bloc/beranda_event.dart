import 'package:equatable/equatable.dart';

abstract class BerandaEvent extends Equatable {
  const BerandaEvent();

  @override
  List<Object?> get props => [];
}

class GetBerandaDataEvent extends BerandaEvent {
  const GetBerandaDataEvent();
}

class GetAllBannerEvent extends BerandaEvent {
  const GetAllBannerEvent();
}

class GetAllServiceEvent extends BerandaEvent {
  const GetAllServiceEvent();
}

