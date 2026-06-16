import 'package:majadigi/features/beranda/domain/entity/ketentuan_layanan_entity.dart';

class KetentuanLayananModel extends KetentuanLayananEntity {
  const KetentuanLayananModel({
    required super.manfaat,
    required super.sistemMekanismeProsedur,
  });

  factory KetentuanLayananModel.fromJson(Map<String, dynamic> json) {
    return KetentuanLayananModel(
      manfaat: json['manfaat'] != null ? List<String>.from(json['manfaat']) : [],
      sistemMekanismeProsedur: json['sistem_mekanisme_prosedur'] != null ? List<String>.from(json['sistem_mekanisme_prosedur']) : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'manfaat': manfaat,
      'sistem_mekanisme_prosedur': sistemMekanismeProsedur,
    };
  }
}
