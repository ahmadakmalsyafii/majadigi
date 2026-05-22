import 'package:equatable/equatable.dart';
import 'package:majadigi/deffered_feature/antrean_pasien/domain/entity/antrean_entity.dart';
import 'package:majadigi/deffered_feature/antrean_pasien/domain/entity/dokter_entity.dart';
import 'package:majadigi/deffered_feature/antrean_pasien/domain/entity/poli_entity.dart';

class AntreanState extends Equatable {
  final bool isLoadingPoli;
  final bool isLoadingDokter;
  final bool isLoadingAntrean;
  
  final List<PoliEntity> poliList;
  final List<DokterEntity> dokterList;
  
  final PoliEntity? selectedPoli;
  final DokterEntity? selectedDokter;
  
  final AntreanEntity? antreanResult;
  final String? errorMessage;

  const AntreanState({
    this.isLoadingPoli = false,
    this.isLoadingDokter = false,
    this.isLoadingAntrean = false,
    this.poliList = const [],
    this.dokterList = const [],
    this.selectedPoli,
    this.selectedDokter,
    this.antreanResult,
    this.errorMessage,
  });

  AntreanState copyWith({
    bool? isLoadingPoli,
    bool? isLoadingDokter,
    bool? isLoadingAntrean,
    List<PoliEntity>? poliList,
    List<DokterEntity>? dokterList,
    PoliEntity? selectedPoli,
    DokterEntity? selectedDokter,
    AntreanEntity? antreanResult,
    String? errorMessage,
    bool clearDokter = false,
  }) {
    return AntreanState(
      isLoadingPoli: isLoadingPoli ?? this.isLoadingPoli,
      isLoadingDokter: isLoadingDokter ?? this.isLoadingDokter,
      isLoadingAntrean: isLoadingAntrean ?? this.isLoadingAntrean,
      poliList: poliList ?? this.poliList,
      dokterList: dokterList ?? this.dokterList,
      selectedPoli: selectedPoli ?? this.selectedPoli,
      selectedDokter: clearDokter ? null : (selectedDokter ?? this.selectedDokter),
      antreanResult: antreanResult ?? this.antreanResult,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        isLoadingPoli,
        isLoadingDokter,
        isLoadingAntrean,
        poliList,
        dokterList,
        selectedPoli,
        selectedDokter,
        antreanResult,
        errorMessage,
      ];
}
