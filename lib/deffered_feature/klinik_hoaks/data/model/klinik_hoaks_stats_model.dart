import 'package:majadigi/deffered_feature/klinik_hoaks/domain/entity/klinik_hoaks_stats_entity.dart';

class KlinikHoaksStatsModel extends KlinikHoaksStatsEntity {
  const KlinikHoaksStatsModel({
    required super.jmlHoaksYtd,
    required super.jmlDisinformasiYtd,
    required super.jmlFaktaYtd,
    required super.jmlHateSpeechYtd,
  });

  factory KlinikHoaksStatsModel.fromJson({
    required int hoaks,
    required int disinformasi,
    required int fakta,
    required int hateSpeech,
  }) {
    return KlinikHoaksStatsModel(
      jmlHoaksYtd: hoaks,
      jmlDisinformasiYtd: disinformasi,
      jmlFaktaYtd: fakta,
      jmlHateSpeechYtd: hateSpeech,
    );
  }
}
