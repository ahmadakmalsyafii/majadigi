import 'package:majadigi/deffered_feature/jadwal_operasi/domain/entity/jadwal_operasi_entity.dart';

class JadwalOperasiResponseModel extends JadwalOperasiResponseEntity {
  const JadwalOperasiResponseModel({
    required super.summary,
    required super.schedules,
  });

  factory JadwalOperasiResponseModel.fromJson(Map<String, dynamic> json) {
    var dataJson = json['data'] ?? {};
    var schedulesList = dataJson['schedules'] as List? ?? [];
    
    return JadwalOperasiResponseModel(
      summary: SummaryOperasiModel.fromJson(dataJson['summary'] ?? {}),
      schedules: schedulesList.map((e) => TanggalOperasiModel.fromJson(e)).toList(),
    );
  }
}

class SummaryOperasiModel extends SummaryOperasiEntity {
  const SummaryOperasiModel({
    required super.total,
    required super.done,
    required super.scheduled,
    required super.lastUpdate,
  });

  factory SummaryOperasiModel.fromJson(Map<String, dynamic> json) {
    return SummaryOperasiModel(
      total: json['total'] ?? 0,
      done: json['done'] ?? 0,
      scheduled: json['scheduled'] ?? 0,
      lastUpdate: json['last_update'] ?? '',
    );
  }
}

class TanggalOperasiModel extends TanggalOperasiEntity {
  const TanggalOperasiModel({
    required super.date,
    required super.schedules,
  });

  factory TanggalOperasiModel.fromJson(Map<String, dynamic> json) {
    var schedulesList = json['schedules'] as List? ?? [];
    return TanggalOperasiModel(
      date: json['date'] ?? '',
      schedules: schedulesList.map((e) => DetailOperasiModel.fromJson(e)).toList(),
    );
  }
}

class DetailOperasiModel extends DetailOperasiEntity {
  const DetailOperasiModel({
    required super.name,
    required super.surgeryId,
    required super.doctorName,
    required super.poliName,
    required super.surgeryName,
  });

  factory DetailOperasiModel.fromJson(Map<String, dynamic> json) {
    return DetailOperasiModel(
      name: json['name'] ?? '',
      surgeryId: json['surgery_id'] ?? '',
      doctorName: json['doctor_name'] ?? '',
      poliName: json['poli_name'] ?? '',
      surgeryName: json['surgery_name'] ?? '',
    );
  }
}
