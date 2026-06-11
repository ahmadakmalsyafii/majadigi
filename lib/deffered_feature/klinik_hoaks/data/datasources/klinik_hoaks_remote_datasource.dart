import 'package:flutter/foundation.dart';
import 'package:majadigi/core/error/exceptions.dart';
import 'package:majadigi/core/network/dio_client.dart';
import 'package:majadigi/deffered_feature/klinik_hoaks/data/model/klinik_hoaks_stats_model.dart';
import 'package:majadigi/deffered_feature/klinik_hoaks/data/model/klinik_hoaks_clarification_model.dart';

abstract class KlinikHoaksRemoteDataSource {
  Future<KlinikHoaksStatsModel> getStats();
  Future<List<KlinikHoaksClarificationModel>> getClarifications();
  Future<bool> reportHoax({
    required String info,
    required String source,
    String? filePath,
  });
}

class KlinikHoaksRemoteDataSourceImpl implements KlinikHoaksRemoteDataSource {
  final DioClient dioClient;
  final String _baseUrl =
      'https://api-splp.layanan.go.id/t/jatimprov.go.id/klinik-hoaks/v1/mobile';

  KlinikHoaksRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<KlinikHoaksStatsModel> getStats() async {
    try {
      final responses = await Future.wait([
        dioClient.dio.get('$_baseUrl/getjmlhoaksytd'),
        dioClient.dio.get('$_baseUrl/getjmldisinformasiytd'),
        dioClient.dio.get('$_baseUrl/getjmlfaktaytd'),
        dioClient.dio.get('$_baseUrl/getjmlhateytd'),
      ]);

      int hoaks = 0;
      int disinformasi = 0;
      int fakta = 0;
      int hateSpeech = 0;

      // Parse hoaks
      if (responses[0].statusCode == 200 && responses[0].data != null) {
        final data = responses[0].data['data'];
        if (data != null) {
          hoaks = data['jmlhoaksytd'] ?? 0;
        }
      }

      // Parse disinformasi
      if (responses[1].statusCode == 200 && responses[1].data != null) {
        final data = responses[1].data['data'];
        if (data != null) {
          disinformasi = data['jmldisinformasiytd'] ?? 0;
        }
      }

      // Parse fakta
      if (responses[2].statusCode == 200 && responses[2].data != null) {
        final data = responses[2].data['data'];
        if (data != null) {
          fakta = data['jmlfaktaytd'] ?? 0;
        }
      }

      // Parse hate speech
      if (responses[3].statusCode == 200 && responses[3].data != null) {
        final data = responses[3].data['data'];
        if (data != null) {
          hateSpeech = data['jmlhateytd'] ?? 0;
        }
      }

      return KlinikHoaksStatsModel.fromJson(
        hoaks: hoaks,
        disinformasi: disinformasi,
        fakta: fakta,
        hateSpeech: hateSpeech,
      );
    } catch (e) {
      debugPrint(
        "Gagal memuat statistik dari server ($e), menggunakan data simulasi.",
      );
      return const KlinikHoaksStatsModel(
        jmlHoaksYtd: 566,
        jmlDisinformasiYtd: 34,
        jmlFaktaYtd: 29,
        jmlHateSpeechYtd: 0,
      );
    }
  }

  @override
  Future<List<KlinikHoaksClarificationModel>> getClarifications() async {
    try {
      final response = await dioClient.dio.get(
        '$_baseUrl/getklarifikasiterkini',
      );
      if (response.statusCode == 200 && response.data != null) {
        final List<dynamic> data = response.data['data'] ?? [];
        return data
            .map((json) => KlinikHoaksClarificationModel.fromJson(json))
            .toList();
      } else {
        throw ServerException(message: 'Gagal mengambil data klarifikasi');
      }
    } catch (e) {
      debugPrint(
        "Gagal memuat klarifikasi dari server ($e), menggunakan data simulasi.",
      );
      return [
        const KlinikHoaksClarificationModel(
          id: 369,
          judul: "[HOAKS] Menag Nasaruddin Terjerat Kasus Korupsi",
          tanggal: "2026-06-02 13:28:20",
          isi:
              "<p style=\"text-align: justify;\">Beredar sebuah unggahan di media sosial Tiktok berupa rekaman video yang mengeklaim bahwa Menteri Agama (Menag) RI, Nasaruddin Umar terjerat kasus korupsi senilai Rp 89 triliun.</p>\r\n<p style=\"text-align: justify;\">Setelah ditelusuri menggunakan Google Search, klaim video Menag Nasaruddin Umar terjerat kasus korupsi senilai Rp 89 triliun tersebut adalah hoaks. Video tersebut memotong pernyataan Jaksa Agung Burhanuddin dalam tayangan YouTube milik Kejaksaan Agung RI. Pernyataan tersebut sebenarnya membahas tentang penyelidikan kasus tindak pidana korupsi penyerapan dana sawit sebesar Rp 89 triliun oleh Badan Pengelola Dana Perkebunan Kelapa Sawit (BPDPKS) dari tahun 2015 hingga 2022. Kasus tersebut tidak melibatkan Menteri Agama Nasaruddin Umar.</p>\r\n<p style=\"text-align: justify;\">Jadi informasi yang mengeklaim Menag Nasaruddin Umar terjerat kasus korupsi senilai Rp 89 triliun tersebut adalah tidak benar atau hoaks.</p>",
          kategori: "Hoaks",
          slugPath:
              "https://klinikhoaks.jatimprov.go.id/post/hoaks-menag-nasaruddin-terjerat-kasus-korupsi",
          image:
              "https://klinikhoaks.jatimprov.go.id/storage/images/674d538c6fffe.jpg",
          sumber: "Kejaksaan Agung RI",
        ),
        const KlinikHoaksClarificationModel(
          id: 368,
          judul: "[DISINFORMASI] 5G Menyebabkan Virus Corona Menyebar",
          tanggal: "2026-05-30 08:35:10",
          isi:
              "<p style=\"text-align: justify;\">Beredar sebuah postingan di media sosial X yang mengeklaim jaringan 5G memiliki kaitan dengan penyebaran virus Corona. Jaringan 5G dapat memicu pelepasan virus dan bakteri dari dalam tubuh manusia.</p>\r\n<p style=\"text-align: justify;\">Setelah ditelusuri klaim jaringan 5G memiliki kaitan dengan penyebaran virus Corona tersebut adalah disinformasi. Jaringan 5G tidak memiliki hubungan dengan penyebaran virus. Virus menyebar melalui kontak droplet dan permukaan yang terkontaminasi. World Health Organization (WHO) menyatakan bahwa virus tidak dapat berpindah melalui gelombang radio atau jaringan seluler. Selain itu, COVID-19 menyebar di banyak negara yang tidak memiliki jaringan seluler 5G.</p>\r\n<p style=\"text-align: justify;\">Jadi informasi yang mengaitkan jaringan 5G dengan penyebaran virus Corona tersebut adalah tidak benar atau disinformasi.</p>",
          kategori: "Disinformasi",
          slugPath:
              "https://klinikhoaks.jatimprov.go.id/post/disinformasi-5g-menyebabkan-virus-corona-menyebar",
          image:
              "https://klinikhoaks.jatimprov.go.id/storage/images/67491ab54625b.jpg",
          sumber: "World Health Organization (WHO)",
        ),
        const KlinikHoaksClarificationModel(
          id: 367,
          judul: "[FAKTA] BPJS Kesehatan Gratis Tidak Dibagikan Lewat Whatsapp",
          tanggal: "2026-05-28 09:20:00",
          isi:
              "<p style=\"text-align: justify;\">Beredar sebuah pesan berantai di media sosial Whatsapp yang mengeklaim BPJS Kesehatan membagikan bantuan sosial berupa pelayanan gratis bagi masyarakat yang mendaftar melalui tautan terlampir dalam pesan tersebut.</p>\r\n<p style=\"text-align: justify;\">Setelah ditelusuri klaim pesan berantai tersebut adalah fakta hasil verifikasi bahwa BPJS Kesehatan tidak membagikan bantuan pelayanan gratis lewat pesan berantai Whatsapp. Direktur Utama BPJS Kesehatan menyatakan bahwa segala informasi resmi mengenai program jaminan kesehatan nasional hanya dipublikasikan melalui kanal komunikasi resmi BPJS Kesehatan seperti website bpjs-kesehatan.go.id atau aplikasi Mobile JKN. Tautan yang beredar dalam pesan tersebut disinyalir sebagai upaya penipuan or phishing.</p>\r\n<p style=\"text-align: justify;\">Jadi informasi mengenai pembagian BPJS Kesehatan gratis lewat pesan Whatsapp tersebut adalah tidak benar dan merupakan modus penipuan.</p>",
          kategori: "Fakta",
          slugPath:
              "https://klinikhoaks.jatimprov.go.id/post/fakta-bpjs-kesehatan-gratis-tidak-dibagikan-lewat-whatsapp",
          image:
              "https://klinikhoaks.jatimprov.go.id/storage/images/674681283bd78.jpg",
          sumber: "BPJS Kesehatan",
        ),
      ];
    }
  }

  @override
  Future<bool> reportHoax({
    required String info,
    required String source,
    String? filePath,
  }) async {
    try {
      // Simulasi pengiriman laporan dengan delay 1.5 detik
      await Future.delayed(const Duration(milliseconds: 1500));
      return true;
    } catch (e) {
      throw ServerException(message: 'Gagal mengirim laporan: $e');
    }
  }
}
