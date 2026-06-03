import 'dart:async';
import 'package:bloc/bloc.dart';
import '../../domain/entities/feature_status.dart';
import '../../domain/usecases/manage_feature_usecase.dart';
import 'feature_manager_event.dart';
import 'feature_manager_state.dart';

class FeatureManagerBloc extends Bloc<FeatureManagerEvent, FeatureManagerState> {
  final ManageFeatureUsecase manageFeatureUsecase;

  FeatureManagerBloc({required this.manageFeatureUsecase}) : super(const FeatureManagerState()) {
    on<CheckFeatureStatusEvent>(_onCheckFeatureStatus);
    on<InstallFeatureEvent>(_onInstallFeature);
    on<UninstallFeatureEvent>(_onUninstallFeature);
  }

  Future<void> _onCheckFeatureStatus(CheckFeatureStatusEvent event, Emitter<FeatureManagerState> emit) async {
    final isInstalled = await manageFeatureUsecase.checkIsInstalled(event.featureName);
    
    final newStatuses = Map<String, FeatureStatus>.from(state.statuses);
    newStatuses[event.featureName] = isInstalled ? FeatureStatus.installed : FeatureStatus.notInstalled;
    
    emit(state.copyWith(statuses: newStatuses));
  }

  Future<void> _onInstallFeature(InstallFeatureEvent event, Emitter<FeatureManagerState> emit) async {
    final featureName = event.featureName;
    
    var newStatuses = Map<String, FeatureStatus>.from(state.statuses);
    var newProgresses = Map<String, double>.from(state.progresses);
    
    newStatuses[featureName] = FeatureStatus.installing;
    newProgresses[featureName] = 0.0;
    emit(state.copyWith(statuses: newStatuses, progresses: newProgresses));

    bool isDone = false;
    bool isError = false;

    // Start load library in background
    event.loadLibraryFuture().then((_) {
      isDone = true;
    }).catchError((_) {
      isError = true;
      isDone = true;
    });

    double currentProgress = 0.0;
    while (!isDone && currentProgress < 0.9) {
      await Future.delayed(const Duration(milliseconds: 200));
      if (isDone) break;
      currentProgress += 0.1;
      newProgresses = Map<String, double>.from(state.progresses);
      newProgresses[featureName] = currentProgress;
      emit(state.copyWith(progresses: newProgresses));
    }

    // wait for actual finish if simulation finished before load
    while (!isDone) {
      await Future.delayed(const Duration(milliseconds: 100));
    }

    if (isError) {
      newStatuses = Map<String, FeatureStatus>.from(state.statuses);
      newStatuses[featureName] = FeatureStatus.notInstalled;
      emit(state.copyWith(statuses: newStatuses));
    } else {
      await manageFeatureUsecase.markAsInstalled(featureName);
      newStatuses = Map<String, FeatureStatus>.from(state.statuses);
      newProgresses = Map<String, double>.from(state.progresses);
      newStatuses[featureName] = FeatureStatus.installed;
      newProgresses[featureName] = 1.0;
      emit(state.copyWith(statuses: newStatuses, progresses: newProgresses));
    }
  }

  Future<void> _onUninstallFeature(UninstallFeatureEvent event, Emitter<FeatureManagerState> emit) async {
    await manageFeatureUsecase.removeInstalledStatus(event.featureName);
    
    final newStatuses = Map<String, FeatureStatus>.from(state.statuses);
    final newProgresses = Map<String, double>.from(state.progresses);
    
    newStatuses[event.featureName] = FeatureStatus.notInstalled;
    newProgresses[event.featureName] = 0.0;
    
    emit(state.copyWith(statuses: newStatuses, progresses: newProgresses));
  }
}
