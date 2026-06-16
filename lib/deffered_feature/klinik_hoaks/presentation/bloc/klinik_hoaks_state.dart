import 'package:equatable/equatable.dart';
import 'package:majadigi/deffered_feature/klinik_hoaks/domain/entity/klinik_hoaks_stats_entity.dart';
import 'package:majadigi/deffered_feature/klinik_hoaks/domain/entity/klinik_hoaks_clarification_entity.dart';

enum ReportStatus { initial, loading, success, failure }

abstract class KlinikHoaksState extends Equatable {
  const KlinikHoaksState();

  @override
  List<Object?> get props => [];
}

class KlinikHoaksInitial extends KlinikHoaksState {}

class KlinikHoaksLoading extends KlinikHoaksState {}

/// State ketika stats sudah dimuat tapi clarifications masih loading.
/// Memungkinkan UI menampilkan statistik terlebih dahulu (progressive loading).
class KlinikHoaksPartialLoaded extends KlinikHoaksState {
  final KlinikHoaksStatsEntity stats;

  const KlinikHoaksPartialLoaded({required this.stats});

  @override
  List<Object?> get props => [stats];
}

class KlinikHoaksLoaded extends KlinikHoaksState {
  final KlinikHoaksStatsEntity stats;
  final List<KlinikHoaksClarificationEntity> allClarifications;
  final List<KlinikHoaksClarificationEntity> filteredClarifications;
  final String searchQuery;
  final String selectedCategory;
  final ReportStatus reportStatus;
  final String? reportErrorMessage;

  const KlinikHoaksLoaded({
    required this.stats,
    required this.allClarifications,
    required this.filteredClarifications,
    this.searchQuery = '',
    this.selectedCategory = 'Semua',
    this.reportStatus = ReportStatus.initial,
    this.reportErrorMessage,
  });

  KlinikHoaksLoaded copyWith({
    KlinikHoaksStatsEntity? stats,
    List<KlinikHoaksClarificationEntity>? allClarifications,
    List<KlinikHoaksClarificationEntity>? filteredClarifications,
    String? searchQuery,
    String? selectedCategory,
    ReportStatus? reportStatus,
    String? reportErrorMessage,
  }) {
    return KlinikHoaksLoaded(
      stats: stats ?? this.stats,
      allClarifications: allClarifications ?? this.allClarifications,
      filteredClarifications: filteredClarifications ?? this.filteredClarifications,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      reportStatus: reportStatus ?? this.reportStatus,
      reportErrorMessage: reportErrorMessage ?? this.reportErrorMessage,
    );
  }

  @override
  List<Object?> get props => [
        stats,
        allClarifications,
        filteredClarifications,
        searchQuery,
        selectedCategory,
        reportStatus,
        reportErrorMessage,
      ];
}

class KlinikHoaksError extends KlinikHoaksState {
  final String message;

  const KlinikHoaksError({required this.message});

  @override
  List<Object?> get props => [message];
}

class KlinikHoaksReportLoading extends KlinikHoaksState {}

class KlinikHoaksReportSuccess extends KlinikHoaksState {}

class KlinikHoaksReportFailure extends KlinikHoaksState {
  final String message;

  const KlinikHoaksReportFailure({required this.message});

  @override
  List<Object?> get props => [message];
}
