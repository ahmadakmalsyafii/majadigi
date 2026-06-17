import 'package:equatable/equatable.dart';
import '../../domain/entities/activity_history_entity.dart';

abstract class ActivityHistoryState extends Equatable {
  const ActivityHistoryState();
  
  @override
  List<Object> get props => [];
}

class ActivityHistoryInitial extends ActivityHistoryState {}

class ActivityHistoryLoading extends ActivityHistoryState {}

class ActivityHistoryLoaded extends ActivityHistoryState {
  final List<ActivityHistoryEntity> histories;

  const ActivityHistoryLoaded({required this.histories});

  @override
  List<Object> get props => [histories];
}

class ActivityHistoryError extends ActivityHistoryState {
  final String message;

  const ActivityHistoryError({required this.message});

  @override
  List<Object> get props => [message];
}
