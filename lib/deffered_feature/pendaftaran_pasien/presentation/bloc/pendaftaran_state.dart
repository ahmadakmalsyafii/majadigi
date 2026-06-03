import 'package:equatable/equatable.dart';
import 'package:majadigi/deffered_feature/pendaftaran_pasien/domain/entity/pendaftaran_poli_entity.dart';
import 'package:majadigi/deffered_feature/pendaftaran_pasien/domain/entity/pendaftaran_dokter_entity.dart';
import 'package:majadigi/deffered_feature/pendaftaran_pasien/domain/entity/pendaftaran_booking_entity.dart';

class PendaftaranState extends Equatable {
  final int currentStep;
  final bool isLoading;
  final bool isLoadingDoctors;
  final bool isLoadingTimes;
  final bool isSubmitting;
  final String? errorMessage;

  final List<PendaftaranPoliEntity> polis;
  final List<PendaftaranDokterEntity> doctors;
  final Map<String, int> timeRegistrationsCount; // time slot -> count

  final PendaftaranPoliEntity? selectedPoli;
  final PendaftaranDokterEntity? selectedDoctor;
  final DateTime? selectedDate;
  final String? selectedTime;

  final PendaftaranBookingEntity? registeredTicket;

  const PendaftaranState({
    this.currentStep = 0,
    this.isLoading = false,
    this.isLoadingDoctors = false,
    this.isLoadingTimes = false,
    this.isSubmitting = false,
    this.errorMessage,
    this.polis = const [],
    this.doctors = const [],
    this.timeRegistrationsCount = const {},
    this.selectedPoli,
    this.selectedDoctor,
    this.selectedDate,
    this.selectedTime,
    this.registeredTicket,
  });

  PendaftaranState copyWith({
    int? currentStep,
    bool? isLoading,
    bool? isLoadingDoctors,
    bool? isLoadingTimes,
    bool? isSubmitting,
    String? errorMessage,
    List<PendaftaranPoliEntity>? polis,
    List<PendaftaranDokterEntity>? doctors,
    Map<String, int>? timeRegistrationsCount,
    PendaftaranPoliEntity? selectedPoli,
    PendaftaranDokterEntity? selectedDoctor,
    DateTime? selectedDate,
    String? selectedTime,
    PendaftaranBookingEntity? registeredTicket,
  }) {
    return PendaftaranState(
      currentStep: currentStep ?? this.currentStep,
      isLoading: isLoading ?? this.isLoading,
      isLoadingDoctors: isLoadingDoctors ?? this.isLoadingDoctors,
      isLoadingTimes: isLoadingTimes ?? this.isLoadingTimes,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: errorMessage,
      polis: polis ?? this.polis,
      doctors: doctors ?? this.doctors,
      timeRegistrationsCount: timeRegistrationsCount ?? this.timeRegistrationsCount,
      selectedPoli: selectedPoli ?? this.selectedPoli,
      selectedDoctor: selectedDoctor ?? this.selectedDoctor,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedTime: selectedTime ?? this.selectedTime,
      registeredTicket: registeredTicket ?? this.registeredTicket,
    );
  }

  PendaftaranState clearDoctor() {
    return PendaftaranState(
      currentStep: currentStep,
      isLoading: isLoading,
      isLoadingDoctors: isLoadingDoctors,
      isLoadingTimes: isLoadingTimes,
      isSubmitting: isSubmitting,
      polis: polis,
      doctors: doctors,
      timeRegistrationsCount: const {},
      selectedPoli: selectedPoli,
      selectedDoctor: null,
      selectedDate: null,
      selectedTime: null,
      registeredTicket: null,
    );
  }

  PendaftaranState clearPoli() {
    return PendaftaranState(
      currentStep: currentStep,
      isLoading: isLoading,
      isLoadingDoctors: false,
      isLoadingTimes: false,
      isSubmitting: isSubmitting,
      polis: polis,
      doctors: const [],
      timeRegistrationsCount: const {},
      selectedPoli: null,
      selectedDoctor: null,
      selectedDate: null,
      selectedTime: null,
      registeredTicket: null,
    );
  }

  @override
  List<Object?> get props => [
        currentStep,
        isLoading,
        isLoadingDoctors,
        isLoadingTimes,
        isSubmitting,
        errorMessage,
        polis,
        doctors,
        timeRegistrationsCount,
        selectedPoli,
        selectedDoctor,
        selectedDate,
        selectedTime,
        registeredTicket,
      ];
}
