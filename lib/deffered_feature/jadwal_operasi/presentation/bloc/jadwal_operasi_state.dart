import 'package:equatable/equatable.dart';
import 'package:majadigi/deffered_feature/jadwal_operasi/domain/entity/jadwal_operasi_entity.dart';

class JadwalOperasiState extends Equatable {
  final bool isLoading;
  final JadwalOperasiResponseEntity? data;
  final String? errorMessage;

  const JadwalOperasiState({
    this.isLoading = false,
    this.data,
    this.errorMessage,
  });

  JadwalOperasiState copyWith({
    bool? isLoading,
    JadwalOperasiResponseEntity? data,
    String? errorMessage,
  }) {
    return JadwalOperasiState(
      isLoading: isLoading ?? this.isLoading,
      data: data ?? this.data,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [isLoading, data, errorMessage];
}
