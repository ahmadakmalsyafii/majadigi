import 'package:bloc/bloc.dart';
import 'package:intl/intl.dart';
import 'package:majadigi/deffered_feature/pendaftaran_pasien/domain/entity/pendaftaran_booking_entity.dart';
import 'package:majadigi/deffered_feature/pendaftaran_pasien/domain/usecases/get_pendaftaran_doctors_usecase.dart';
import 'package:majadigi/deffered_feature/pendaftaran_pasien/domain/usecases/get_pendaftaran_polis_usecase.dart';
import 'package:majadigi/deffered_feature/pendaftaran_pasien/domain/usecases/get_time_slot_quotas_usecase.dart';
import 'package:majadigi/deffered_feature/pendaftaran_pasien/domain/usecases/save_registration_usecase.dart';
import 'package:majadigi/deffered_feature/pendaftaran_pasien/presentation/bloc/pendaftaran_event.dart';
import 'package:majadigi/deffered_feature/pendaftaran_pasien/presentation/bloc/pendaftaran_state.dart';

class PendaftaranBloc extends Bloc<PendaftaranEvent, PendaftaranState> {
  final GetPendaftaranPolisUseCase getPolis;
  final GetPendaftaranDoctorsUseCase getDoctors;
  final GetTimeSlotQuotasUseCase getTimeSlotQuotas;
  final SaveRegistrationUseCase saveRegistration;

  PendaftaranBloc({
    required this.getPolis,
    required this.getDoctors,
    required this.getTimeSlotQuotas,
    required this.saveRegistration,
  }) : super(const PendaftaranState()) {
    on<LoadPolisEvent>(_onLoadPolis);
    on<SelectPoliEvent>(_onSelectPoli);
    on<SelectDoctorEvent>(_onSelectDoctor);
    on<SelectDateEvent>(_onSelectDate);
    on<SelectTimeEvent>(_onSelectTime);
    on<SubmitRegistrationEvent>(_onSubmitRegistration);
    on<PrevStepEvent>(_onPrevStep);
    on<NextStepEvent>(_onNextStep);
  }

  Future<void> _onLoadPolis(LoadPolisEvent event, Emitter<PendaftaranState> emit) async {
    emit(state.copyWith(isLoading: true));
    final result = await getPolis(event.hospitalId);
    result.fold(
      (failure) => emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (polisList) => emit(state.copyWith(isLoading: false, polis: polisList)),
    );
  }

  Future<void> _onSelectPoli(SelectPoliEvent event, Emitter<PendaftaranState> emit) async {
    emit(state.clearPoli().copyWith(selectedPoli: event.poli, isLoadingDoctors: true));
    
    final result = await getDoctors(event.poli.hospitalId, event.poli.id);
    result.fold(
      (failure) => emit(state.copyWith(isLoadingDoctors: false, errorMessage: failure.message)),
      (doctorsList) => emit(state.copyWith(isLoadingDoctors: false, doctors: doctorsList)),
    );
  }

  void _onSelectDoctor(SelectDoctorEvent event, Emitter<PendaftaranState> emit) {
    emit(state.clearDoctor().copyWith(selectedDoctor: event.doctor));
  }

  Future<void> _onSelectDate(SelectDateEvent event, Emitter<PendaftaranState> emit) async {
    emit(state.copyWith(selectedDate: event.date, selectedTime: null, isLoadingTimes: true));
    
    if (state.selectedDoctor == null) {
      emit(state.copyWith(isLoadingTimes: false));
      return;
    }

    final dateStr = DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(event.date);
    final result = await getTimeSlotQuotas(state.selectedDoctor!.id, dateStr);
    
    result.fold(
      (failure) => emit(state.copyWith(isLoadingTimes: false, errorMessage: failure.message)),
      (quotas) => emit(state.copyWith(isLoadingTimes: false, timeRegistrationsCount: quotas)),
    );
  }

  void _onSelectTime(SelectTimeEvent event, Emitter<PendaftaranState> emit) {
    emit(state.copyWith(selectedTime: event.time));
  }

  Future<void> _onSubmitRegistration(SubmitRegistrationEvent event, Emitter<PendaftaranState> emit) async {
    if (state.selectedPoli == null ||
        state.selectedDoctor == null ||
        state.selectedDate == null ||
        state.selectedTime == null) {
      return;
    }

    emit(state.copyWith(isSubmitting: true));

    final dateStr = DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(state.selectedDate!);

    final booking = PendaftaranBookingEntity(
      id: '',
      userId: event.user.uid,
      patientName: event.user.name,
      patientNIK: event.user.NIK ?? '-',
      hospitalId: state.selectedDoctor!.hospitalId,
      hospitalName: event.hospitalName,
      poliId: state.selectedPoli!.id,
      poliName: state.selectedPoli!.name,
      doctorId: state.selectedDoctor!.id,
      doctorName: state.selectedDoctor!.name,
      date: dateStr,
      time: state.selectedTime!,
      queueNumber: '',
      createdAt: DateTime.now(),
    );

    final result = await saveRegistration(booking);
    result.fold(
      (failure) => emit(state.copyWith(isSubmitting: false, errorMessage: failure.message)),
      (savedBooking) => emit(state.copyWith(
        isSubmitting: false,
        registeredTicket: savedBooking,
        currentStep: 3,
      )),
    );
  }

  void _onPrevStep(PrevStepEvent event, Emitter<PendaftaranState> emit) {
    if (state.currentStep > 0) {
      emit(state.copyWith(currentStep: state.currentStep - 1));
    }
  }

  void _onNextStep(NextStepEvent event, Emitter<PendaftaranState> emit) {
    if (state.currentStep < 2) {
      emit(state.copyWith(currentStep: state.currentStep + 1));
    }
  }
}
