import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:majadigi/deffered_feature/pendaftaran_pasien/domain/entity/pendaftaran_poli_entity.dart';

class PendaftaranPoliModel extends PendaftaranPoliEntity {
  const PendaftaranPoliModel({
    required super.id,
    required super.name,
    required super.doctorsCount,
    required super.quota,
    required super.hospitalId,
  });

  factory PendaftaranPoliModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PendaftaranPoliModel(
      id: doc.id,
      name: data['name'] ?? '',
      doctorsCount: data['doctors'] ?? 0,
      quota: data['quota'] ?? 0,
      hospitalId: data['hospitalId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'doctors': doctorsCount,
      'quota': quota,
      'hospitalId': hospitalId,
    };
  }
}
