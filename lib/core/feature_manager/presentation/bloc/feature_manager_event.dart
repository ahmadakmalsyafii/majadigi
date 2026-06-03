import 'package:equatable/equatable.dart';

abstract class FeatureManagerEvent extends Equatable {
  const FeatureManagerEvent();
  @override
  List<Object> get props => [];
}

class CheckFeatureStatusEvent extends FeatureManagerEvent {
  final String featureName;
  const CheckFeatureStatusEvent(this.featureName);
  @override
  List<Object> get props => [featureName];
}

class InstallFeatureEvent extends FeatureManagerEvent {
  final String featureName;
  final Future<void> Function() loadLibraryFuture;

  const InstallFeatureEvent({required this.featureName, required this.loadLibraryFuture});
  @override
  List<Object> get props => [featureName];
}

class UninstallFeatureEvent extends FeatureManagerEvent {
  final String featureName;
  const UninstallFeatureEvent(this.featureName);
  @override
  List<Object> get props => [featureName];
}

class GetAllInstalledFeaturesEvent extends FeatureManagerEvent {}
