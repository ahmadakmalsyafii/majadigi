import 'package:bloc/bloc.dart';
import 'package:majadigi/features/profile/domain/usecases/update_profile_usecase.dart';
import 'package:majadigi/features/profile/presentation/bloc/profile_event.dart';
import 'package:majadigi/features/profile/presentation/bloc/profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UpdateProfileUseCase _updateProfile;

  ProfileBloc({
    required UpdateProfileUseCase updateProfile,
  })  : _updateProfile = updateProfile,
        super(const ProfileInitial()) {
    on<UpdateProfileRequested>(_onUpdateProfileRequested);
  }

  Future<void> _onUpdateProfileRequested(
      UpdateProfileRequested event,
      Emitter<ProfileState> emit,
      ) async {
    emit(const ProfileLoading());
    final result = await _updateProfile(
      event.name,
      event.NIK,
      event.dateOfBirth,
      event.email,
      event.password,
      event.gender,
      event.address,
    );
    result.fold(
          (failure) => emit(ProfileFailure(failure)),
          (user) => emit(ProfileSuccess(user)),
    );
  }
}
