import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:majadigi/deffered_feature/pendaftaran_pasien/domain/entity/pendaftaran_dokter_entity.dart';

class PendaftaranDokterModel extends PendaftaranDokterEntity {
  const PendaftaranDokterModel({
    required super.id,
    required super.name,
    required super.spesialis,
    required super.jadwal,
    required super.kuota,
    required super.availableTimes,
    required super.poliId,
    required super.hospitalId,
  });

  factory PendaftaranDokterModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PendaftaranDokterModel(
      id: doc.id,
      name: data['name'] ?? '',
      spesialis: data['spesialis'] ?? '',
      jadwal: data['jadwal'] ?? '',
      kuota: data['kuota'] ?? 0,
      availableTimes: List<String>.from(data['availableTimes'] ?? []),
      poliId: data['poliId'] ?? '',
      hospitalId: data['hospitalId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'spesialis': spesialis,
      'jadwal': jadwal,
      'kuota': kuota,
      'availableTimes': availableTimes,
      'poliId': poliId,
      'hospitalId': hospitalId,
    };
  }
}
