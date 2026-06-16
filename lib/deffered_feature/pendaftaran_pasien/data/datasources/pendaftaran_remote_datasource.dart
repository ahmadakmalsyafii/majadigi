import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:majadigi/core/error/exceptions.dart';
import 'package:majadigi/deffered_feature/pendaftaran_pasien/data/model/pendaftaran_poli_model.dart';
import 'package:majadigi/deffered_feature/pendaftaran_pasien/data/model/pendaftaran_dokter_model.dart';
import 'package:majadigi/deffered_feature/pendaftaran_pasien/data/model/pendaftaran_booking_model.dart';

abstract class PendaftaranRemoteDataSource {
  Future<List<PendaftaranPoliModel>> getPoliList(String hospitalId);
  Future<List<PendaftaranDokterModel>> getDokterList(
    String hospitalId,
    String poliId,
  );
  Future<Map<String, int>> getTimeSlotQuotas(String doctorId, String date);
  Future<PendaftaranBookingModel> saveRegistration(
    PendaftaranBookingModel booking,
  );
}

class PendaftaranRemoteDataSourceImpl implements PendaftaranRemoteDataSource {
  final FirebaseFirestore firestore;

  PendaftaranRemoteDataSourceImpl({required this.firestore});

  @override
  Future<List<PendaftaranPoliModel>> getPoliList(String hospitalId) async {
    try {
      final polisSnapshot = await firestore
          .collection('polis')
          .where('hospitalId', isEqualTo: hospitalId)
          .get();

      if (polisSnapshot.docs.isEmpty) {
        // Seeding otomatis jika kosong
        await _seedData(hospitalId);
        final reSnapshot = await firestore
            .collection('polis')
            .where('hospitalId', isEqualTo: hospitalId)
            .get();
        return reSnapshot.docs
            .map((doc) => PendaftaranPoliModel.fromFirestore(doc))
            .toList();
      }

      return polisSnapshot.docs
          .map((doc) => PendaftaranPoliModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw ServerException(
        message: 'Gagal memuat poliklinik dari database: $e',
      );
    }
  }

  @override
  Future<List<PendaftaranDokterModel>> getDokterList(
    String hospitalId,
    String poliId,
  ) async {
    try {
      final docsSnapshot = await firestore
          .collection('doctors')
          .where('hospitalId', isEqualTo: hospitalId)
          .where('poliId', isEqualTo: poliId)
          .get();
      return docsSnapshot.docs
          .map((doc) => PendaftaranDokterModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw ServerException(
        message: 'Gagal memuat daftar dokter dari database: $e',
      );
    }
  }

  @override
  Future<Map<String, int>> getTimeSlotQuotas(
    String doctorId,
    String date,
  ) async {
    try {
      final registrationsSnapshot = await firestore
          .collection('registrations')
          .where('doctorId', isEqualTo: doctorId)
          .where('date', isEqualTo: date)
          .get();

      final Map<String, int> counts = {};
      for (var doc in registrationsSnapshot.docs) {
        final time = doc.data()['time'] as String?;
        if (time != null) {
          counts[time] = (counts[time] ?? 0) + 1;
        }
      }
      return counts;
    } catch (e) {
      throw ServerException(message: 'Gagal mengambil kuota slot waktu: $e');
    }
  }

  @override
  Future<PendaftaranBookingModel> saveRegistration(
    PendaftaranBookingModel booking,
  ) async {
    try {
      final date = booking.date;
      final doctorId = booking.doctorId;

      // Hitung jumlah pendaftar hari itu untuk menentukan antrean
      final regSnapshot = await firestore
          .collection('registrations')
          .where('doctorId', isEqualTo: doctorId)
          .where('date', isEqualTo: date)
          .get();

      final queueNum = regSnapshot.docs.length + 1;
      final queueNumberStr = 'A-${queueNum.toString().padLeft(3, '0')}';

      final docRef = firestore.collection('registrations').doc();

      final updatedBooking = PendaftaranBookingModel(
        id: docRef.id,
        userId: booking.userId,
        patientName: booking.patientName,
        patientNIK: booking.patientNIK,
        hospitalId: booking.hospitalId,
        hospitalName: booking.hospitalName,
        poliId: booking.poliId,
        poliName: booking.poliName,
        doctorId: booking.doctorId,
        doctorName: booking.doctorName,
        date: booking.date,
        time: booking.time,
        queueNumber: queueNumberStr,
        createdAt: DateTime.now(),
      );

      await docRef.set(updatedBooking.toJson());

      // Ambil snapshot dokumen yang baru saja disimpan untuk mengembalikan model asli dari database
      final savedDoc = await docRef.get();
      return PendaftaranBookingModel.fromFirestore(savedDoc);
    } catch (e) {
      throw ServerException(message: 'Gagal menyimpan pendaftaran: $e');
    }
  }

  Future<void> _seedData(String hospitalId) async {
    final batch = firestore.batch();

    final defaultPolis = [
      {'name': 'Poli Umum', 'doctors': 3, 'quota': 100, 'code': 'UMUM'},
      {'name': 'Poli Gigi', 'doctors': 1, 'quota': 50, 'code': 'GIGI'},
      {'name': 'Poli Anak', 'doctors': 1, 'quota': 80, 'code': 'ANAK'},
      {'name': 'Poli Jantung', 'doctors': 1, 'quota': 40, 'code': 'JNTG'},
      {'name': 'Poli Mata', 'doctors': 1, 'quota': 60, 'code': 'MATA'},
    ];

    final defaultDoctors = [
      {
        'name': 'dr. Budi Santoso',
        'spesialis': 'Spesialis Umum',
        'jadwal': 'Senin - Jumat, 08:00 - 14:00',
        'kuota': 15,
        'poliCode': 'UMUM',
        'availableTimes': [
          '08:00 - 09:00',
          '09:00 - 10:00',
          '13:00 - 14:00',
          '14:00 - 15:00',
        ],
      },
      {
        'name': 'dr. Siti Aminah',
        'spesialis': 'Spesialis Umum',
        'jadwal': 'Senin, Rabu, Jumat, 09:00 - 15:00',
        'kuota': 5,
        'poliCode': 'UMUM',
        'availableTimes': ['09:00 - 10:00', '10:00 - 11:00', '14:00 - 15:00'],
      },
      {
        'name': 'dr. Andi Setiawan',
        'spesialis': 'Spesialis Umum',
        'jadwal': 'Selasa, Kamis, 10:00 - 16:00',
        'kuota': 20,
        'poliCode': 'UMUM',
        'availableTimes': ['10:00 - 11:00', '11:00 - 12:00', '15:00 - 16:00'],
      },
      {
        'name': 'drg. Charles Wijaya',
        'spesialis': 'Spesialis Gigi & Mulut',
        'jadwal': 'Senin - Rabu, 09:00 - 13:00',
        'kuota': 10,
        'poliCode': 'GIGI',
        'availableTimes': ['09:00 - 10:00', '10:00 - 11:00', '11:00 - 12:00'],
      },
      {
        'name': 'dr. Sarah Olivia, Sp.A',
        'spesialis': 'Spesialis Anak',
        'jadwal': 'Senin - Kamis, 08:00 - 12:00',
        'kuota': 12,
        'poliCode': 'ANAK',
        'availableTimes': ['08:00 - 09:00', '09:00 - 10:00', '10:00 - 11:00'],
      },
      {
        'name': 'dr. James Haryono, Sp.JP',
        'spesialis': 'Spesialis Jantung',
        'jadwal': 'Selasa & Jumat, 13:00 - 17:00',
        'kuota': 8,
        'poliCode': 'JNTG',
        'availableTimes': ['13:00 - 14:00', '14:00 - 15:00', '15:00 - 16:00'],
      },
      {
        'name': 'dr. Riana Wati, Sp.M',
        'spesialis': 'Spesialis Mata',
        'jadwal': 'Rabu & Kamis, 09:00 - 12:00',
        'kuota': 10,
        'poliCode': 'MATA',
        'availableTimes': ['09:00 - 10:00', '10:00 - 11:00', '11:00 - 12:00'],
      },
    ];

    final Map<String, String> poliDocIds = {};
    for (var poli in defaultPolis) {
      final ref = firestore.collection('polis').doc();
      batch.set(ref, {
        'hospitalId': hospitalId,
        'name': poli['name'],
        'doctors': poli['doctors'],
        'quota': poli['quota'],
        'createdAt': FieldValue.serverTimestamp(),
      });
      poliDocIds[poli['code'] as String] = ref.id;
    }

    for (var doc in defaultDoctors) {
      final ref = firestore.collection('doctors').doc();
      final poliId = poliDocIds[doc['poliCode'] as String];
      batch.set(ref, {
        'hospitalId': hospitalId,
        'poliId': poliId,
        'poliName': defaultPolis.firstWhere(
          (p) => p['code'] == doc['poliCode'],
        )['name'],
        'name': doc['name'],
        'spesialis': doc['spesialis'],
        'jadwal': doc['jadwal'],
        'kuota': doc['kuota'],
        'availableTimes': doc['availableTimes'],
        'createdAt': FieldValue.serverTimestamp(),
      });
    }

    await batch.commit();
  }
}
