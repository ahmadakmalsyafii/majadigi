import 'package:equatable/equatable.dart';
import '../../domain/entities/feature_status.dart';

class FeatureManagerState extends Equatable {
  final Map<String, FeatureStatus> statuses;
  final Map<String, double> progresses;

  const FeatureManagerState({this.statuses = const {}, this.progresses = const {}});

  FeatureManagerState copyWith({
    Map<String, FeatureStatus>? statuses,
    Map<String, double>? progresses,
  }) {
    return FeatureManagerState(
      statuses: statuses ?? this.statuses,
      progresses: progresses ?? this.progresses,
    );
  }

  FeatureStatus getStatus(String featureName) => statuses[featureName] ?? FeatureStatus.notInstalled;
  double getProgress(String featureName) => progresses[featureName] ?? 0.0;

  @override
  List<Object> get props => [statuses, progresses];
}
