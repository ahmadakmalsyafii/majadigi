import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:majadigi/deffered_feature/klinik_hoaks/domain/usecases/get_klinik_hoaks_stats_usecase.dart';
import 'package:majadigi/deffered_feature/klinik_hoaks/domain/usecases/get_klinik_hoaks_clarifications_usecase.dart';
import 'package:majadigi/deffered_feature/klinik_hoaks/domain/usecases/report_hoax_usecase.dart';
import 'package:majadigi/deffered_feature/klinik_hoaks/presentation/bloc/klinik_hoaks_event.dart';
import 'package:majadigi/deffered_feature/klinik_hoaks/presentation/bloc/klinik_hoaks_state.dart';

class KlinikHoaksBloc extends Bloc<KlinikHoaksEvent, KlinikHoaksState> {
  final GetKlinikHoaksStatsUseCase getStats;
  final GetKlinikHoaksClarificationsUseCase getClarifications;
  final ReportHoaxUseCase reportHoax;

  KlinikHoaksBloc({
    required this.getStats,
    required this.getClarifications,
    required this.reportHoax,
  }) : super(KlinikHoaksInitial()) {
    on<FetchKlinikHoaksDataEvent>(_onFetchData);
    on<SearchKlinikHoaksEvent>(_onSearch);
    on<SubmitHoaxReportEvent>(_onSubmitReport);
  }

  Future<void> _onFetchData(
    FetchKlinikHoaksDataEvent event,
    Emitter<KlinikHoaksState> emit,
  ) async {
    emit(KlinikHoaksLoading());

    // Jalankan kedua future secara paralel
    final statsFuture = getStats();
    final clarificationsFuture = getClarifications();

    // Tunggu stats terlebih dahulu — tampilkan partial UI segera
    final statsResult = await statsFuture;

    statsResult.fold(
      (failure) => emit(KlinikHoaksError(message: failure.message)),
      (stats) {
        // Emit partial state: UI bisa langsung menampilkan statistik
        emit(KlinikHoaksPartialLoaded(stats: stats));
      },
    );

    // Jika stats gagal, tidak perlu lanjut ke clarifications
    if (state is KlinikHoaksError) return;

    // Tunggu clarifications selesai
    final clarificationsResult = await clarificationsFuture;

    clarificationsResult.fold(
      (failure) => emit(KlinikHoaksError(message: failure.message)),
      (clarifications) {
        final currentStats = (state as KlinikHoaksPartialLoaded).stats;
        emit(KlinikHoaksLoaded(
          stats: currentStats,
          allClarifications: clarifications,
          filteredClarifications: clarifications,
        ));
      },
    );
  }

  void _onSearch(
    SearchKlinikHoaksEvent event,
    Emitter<KlinikHoaksState> emit,
  ) {
    if (state is KlinikHoaksLoaded) {
      final currentState = state as KlinikHoaksLoaded;
      final queryLower = event.query.toLowerCase();
      final categoryLower = event.category.toLowerCase();

      final filtered = currentState.allClarifications.where((item) {
        final titleMatch = item.judul.toLowerCase().contains(queryLower) ||
            item.isi.toLowerCase().contains(queryLower);

        bool categoryMatch = true;
        if (event.category != 'Semua') {
          categoryMatch = item.kategori.toLowerCase() == categoryLower;
        }

        return titleMatch && categoryMatch;
      }).toList();

      emit(currentState.copyWith(
        filteredClarifications: filtered,
        searchQuery: event.query,
        selectedCategory: event.category,
        reportStatus: ReportStatus.initial, // Reset status lapor saat mencari
      ));
    }
  }

  Future<void> _onSubmitReport(
    SubmitHoaxReportEvent event,
    Emitter<KlinikHoaksState> emit,
  ) async {
    if (state is KlinikHoaksLoaded) {
      final currentState = state as KlinikHoaksLoaded;
      emit(currentState.copyWith(reportStatus: ReportStatus.loading));

      final result = await reportHoax(
        info: event.info,
        source: event.source,
        filePath: event.filePath,
      );

      result.fold(
        (failure) => emit(currentState.copyWith(
          reportStatus: ReportStatus.failure,
          reportErrorMessage: failure.message,
        )),
        (success) => emit(currentState.copyWith(
          reportStatus: ReportStatus.success,
        )),
      );
    }
  }
}
