import 'package:equatable/equatable.dart';

abstract class ActivityHistoryEvent extends Equatable {
  const ActivityHistoryEvent();

  @override
  List<Object> get props => [];
}

class FetchActivityHistories extends ActivityHistoryEvent {
  final String userId;

  const FetchActivityHistories({required this.userId});

  @override
  List<Object> get props => [userId];
}
