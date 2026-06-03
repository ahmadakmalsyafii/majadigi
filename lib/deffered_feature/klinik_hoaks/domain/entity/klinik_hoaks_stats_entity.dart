import 'package:equatable/equatable.dart';

class KlinikHoaksStatsEntity extends Equatable {
  final int jmlHoaksYtd;
  final int jmlDisinformasiYtd;
  final int jmlFaktaYtd;
  final int jmlHateSpeechYtd;

  const KlinikHoaksStatsEntity({
    required this.jmlHoaksYtd,
    required this.jmlDisinformasiYtd,
    required this.jmlFaktaYtd,
    required this.jmlHateSpeechYtd,
  });

  @override
  List<Object?> get props => [
        jmlHoaksYtd,
        jmlDisinformasiYtd,
        jmlFaktaYtd,
        jmlHateSpeechYtd,
      ];
}
