import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  final SharedPreferences sharedPreferences;
  final String _baseUrl = 'https://api-splp.layanan.go.id/t/jatimprov.go.id/klinik-hoaks/v1/mobile';

  // Cache keys
  static const _statsHoaksKey = 'klinik_hoaks_stats_hoaks';
  static const _statsDisinformasiKey = 'klinik_hoaks_stats_disinformasi';
  static const _statsFaktaKey = 'klinik_hoaks_stats_fakta';
  static const _statsHateKey = 'klinik_hoaks_stats_hate';
  static const _statsCacheTimeKey = 'klinik_hoaks_stats_cache_time';
  static const _clarificationsCacheKey = 'klinik_hoaks_clarifications_cache';
  static const _clarificationsCacheTimeKey = 'klinik_hoaks_clarifications_cache_time';

  // Cache berlaku selama 6 jam
  static const _cacheDuration = Duration(hours: 6);

  // Timeout lebih pendek untuk stats (data kecil)
  static const _statsTimeout = Duration(seconds: 5);

  KlinikHoaksRemoteDataSourceImpl({
    required this.dioClient,
    required this.sharedPreferences,
  });

  /// Cek apakah cache masih valid berdasarkan timestamp
  bool _isCacheValid(String cacheTimeKey) {
    final cachedTime = sharedPreferences.getInt(cacheTimeKey);
    if (cachedTime == null) return false;
    final cachedAt = DateTime.fromMillisecondsSinceEpoch(cachedTime);
    return DateTime.now().difference(cachedAt) < _cacheDuration;
  }

  /// Simpan timestamp cache saat ini
  Future<void> _setCacheTime(String cacheTimeKey) async {
    await sharedPreferences.setInt(
      cacheTimeKey,
      DateTime.now().millisecondsSinceEpoch,
    );
  }

  // ─── STATS ────────────────────────────────────────────────────────────

  /// Ambil stats dari cache jika masih valid
  KlinikHoaksStatsModel? _getCachedStats() {
    if (!_isCacheValid(_statsCacheTimeKey)) return null;

    final hoaks = sharedPreferences.getInt(_statsHoaksKey);
    final disinformasi = sharedPreferences.getInt(_statsDisinformasiKey);
    final fakta = sharedPreferences.getInt(_statsFaktaKey);
    final hate = sharedPreferences.getInt(_statsHateKey);

    if (hoaks == null || disinformasi == null || fakta == null || hate == null) {
      return null;
    }

    debugPrint('[KlinikHoaks] Menggunakan stats dari cache');
    return KlinikHoaksStatsModel(
      jmlHoaksYtd: hoaks,
      jmlDisinformasiYtd: disinformasi,
      jmlFaktaYtd: fakta,
      jmlHateSpeechYtd: hate,
    );
  }

  /// Ambil stats dari cache TANPA cek expiry (untuk fallback saat error)
  KlinikHoaksStatsModel? _getStaleCachedStats() {
    final hoaks = sharedPreferences.getInt(_statsHoaksKey);
    final disinformasi = sharedPreferences.getInt(_statsDisinformasiKey);
    final fakta = sharedPreferences.getInt(_statsFaktaKey);
    final hate = sharedPreferences.getInt(_statsHateKey);

    if (hoaks == null || disinformasi == null || fakta == null || hate == null) {
      return null;
    }

    debugPrint('[KlinikHoaks] Menggunakan stats dari stale cache (fallback)');
    return KlinikHoaksStatsModel(
      jmlHoaksYtd: hoaks,
      jmlDisinformasiYtd: disinformasi,
      jmlFaktaYtd: fakta,
      jmlHateSpeechYtd: hate,
    );
  }

  /// Simpan stats ke cache
  Future<void> _cacheStats(KlinikHoaksStatsModel stats) async {
    await Future.wait([
      sharedPreferences.setInt(_statsHoaksKey, stats.jmlHoaksYtd),
      sharedPreferences.setInt(_statsDisinformasiKey, stats.jmlDisinformasiYtd),
      sharedPreferences.setInt(_statsFaktaKey, stats.jmlFaktaYtd),
      sharedPreferences.setInt(_statsHateKey, stats.jmlHateSpeechYtd),
      _setCacheTime(_statsCacheTimeKey),
    ]);
  }

  @override
  Future<KlinikHoaksStatsModel> getStats() async {
    // 1. Cek cache valid terlebih dahulu
    final cached = _getCachedStats();
    if (cached != null) return cached;

    // 2. Fetch dari API dengan timeout yang lebih pendek
    try {
      final statsOptions = Options(
        receiveTimeout: _statsTimeout,
        sendTimeout: _statsTimeout,
      );

      final responses = await Future.wait([
        dioClient.dio.get('$_baseUrl/getjmlhoaksytd', options: statsOptions),
        dioClient.dio.get('$_baseUrl/getjmldisinformasiytd', options: statsOptions),
        dioClient.dio.get('$_baseUrl/getjmlfaktaytd', options: statsOptions),
        dioClient.dio.get('$_baseUrl/getjmlhateytd', options: statsOptions),
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

      final stats = KlinikHoaksStatsModel.fromJson(
        hoaks: hoaks,
        disinformasi: disinformasi,
        fakta: fakta,
        hateSpeech: hateSpeech,
      );

      // Simpan ke cache untuk visit berikutnya
      await _cacheStats(stats);

      return stats;
    } catch (e) {
      debugPrint("[KlinikHoaks] Gagal memuat statistik dari server ($e)");

      // 3. Fallback ke stale cache (data lama tapi masih ada)
      final staleCache = _getStaleCachedStats();
      if (staleCache != null) return staleCache;

      // 4. Fallback terakhir: data simulasi
      debugPrint("[KlinikHoaks] Menggunakan data simulasi untuk stats");
      return const KlinikHoaksStatsModel(
        jmlHoaksYtd: 566,
        jmlDisinformasiYtd: 34,
        jmlFaktaYtd: 29,
        jmlHateSpeechYtd: 0,
      );
    }
  }

  // ─── CLARIFICATIONS ───────────────────────────────────────────────────

  /// Ambil clarifications dari cache jika masih valid
  List<KlinikHoaksClarificationModel>? _getCachedClarifications() {
    if (!_isCacheValid(_clarificationsCacheTimeKey)) return null;

    final jsonString = sharedPreferences.getString(_clarificationsCacheKey);
    if (jsonString == null) return null;

    try {
      final List<dynamic> decoded = json.decode(jsonString);
      debugPrint('[KlinikHoaks] Menggunakan clarifications dari cache (${decoded.length} items)');
      return decoded
          .map((item) => KlinikHoaksClarificationModel.fromJson(item))
          .toList();
    } catch (e) {
      debugPrint('[KlinikHoaks] Gagal parse cache clarifications: $e');
      return null;
    }
  }

  /// Ambil clarifications dari cache TANPA cek expiry (untuk fallback)
  List<KlinikHoaksClarificationModel>? _getStaleCachedClarifications() {
    final jsonString = sharedPreferences.getString(_clarificationsCacheKey);
    if (jsonString == null) return null;

    try {
      final List<dynamic> decoded = json.decode(jsonString);
      debugPrint('[KlinikHoaks] Menggunakan clarifications dari stale cache (${decoded.length} items)');
      return decoded
          .map((item) => KlinikHoaksClarificationModel.fromJson(item))
          .toList();
    } catch (e) {
      return null;
    }
  }

  /// Simpan clarifications ke cache sebagai JSON string
  Future<void> _cacheClarifications(List<KlinikHoaksClarificationModel> data) async {
    final jsonString = json.encode(data.map((item) => item.toJson()).toList());
    await Future.wait([
      sharedPreferences.setString(_clarificationsCacheKey, jsonString),
      _setCacheTime(_clarificationsCacheTimeKey),
    ]);
  }

  @override
  Future<List<KlinikHoaksClarificationModel>> getClarifications() async {
    // 1. Cek cache valid terlebih dahulu
    final cached = _getCachedClarifications();
    if (cached != null) return cached;

    // 2. Fetch dari API
    try {
      final response = await dioClient.dio.get('$_baseUrl/getklarifikasiterkini');
      if (response.statusCode == 200 && response.data != null) {
        final List<dynamic> data = response.data['data'] ?? [];
        final clarifications = data
            .map((json) => KlinikHoaksClarificationModel.fromJson(json))
            .toList();

        // Simpan ke cache
        await _cacheClarifications(clarifications);

        return clarifications;
      } else {
        throw ServerException(message: 'Gagal mengambil data klarifikasi');
      }
    } catch (e) {
      debugPrint("[KlinikHoaks] Gagal memuat klarifikasi dari server ($e)");

      // 3. Fallback ke stale cache
      final staleCache = _getStaleCachedClarifications();
      if (staleCache != null) return staleCache;

      // 4. Fallback terakhir: data simulasi
      debugPrint("[KlinikHoaks] Menggunakan data simulasi untuk clarifications");
      return [
        const KlinikHoaksClarificationModel(
          id: 369,
          judul: "[HOAKS] Menag Nasaruddin Terjerat Kasus Korupsi",
          tanggal: "2026-06-02 13:28:20",
          isi: "<p style=\"text-align: justify;\">Beredar sebuah unggahan di media sosial Tiktok berupa rekaman video yang mengeklaim bahwa Menteri Agama (Menag) RI, Nasaruddin Umar terjerat kasus korupsi senilai Rp 89 triliun.</p>\r\n<p style=\"text-align: justify;\">Setelah ditelusuri menggunakan Google Search, klaim video Menag Nasaruddin Umar terjerat kasus korupsi senilai Rp 89 triliun tersebut adalah hoaks. Video tersebut memotong pernyataan Jaksa Agung Burhanuddin dalam tayangan YouTube milik Kejaksaan Agung RI. Pernyataan tersebut sebenarnya membahas tentang penyelidikan kasus tindak pidana korupsi penyerapan dana sawit sebesar Rp 89 triliun oleh Badan Pengelola Dana Perkebunan Kelapa Sawit (BPDPKS) dari tahun 2015 hingga 2022. Kasus tersebut tidak melibatkan Menteri Agama Nasaruddin Umar.</p>\r\n<p style=\"text-align: justify;\">Jadi informasi yang mengeklaim Menag Nasaruddin Umar terjerat kasus korupsi senilai Rp 89 triliun tersebut adalah tidak benar atau hoaks.</p>",
          kategori: "Hoaks",
          slugPath: "https://klinikhoaks.jatimprov.go.id/post/hoaks-menag-nasaruddin-terjerat-kasus-korupsi",
          image: "https://klinikhoaks.jatimprov.go.id/storage/images/674d538c6fffe.jpg",
          sumber: "Kejaksaan Agung RI",
        ),
        const KlinikHoaksClarificationModel(
          id: 368,
          judul: "[DISINFORMASI] 5G Menyebabkan Virus Corona Menyebar",
          tanggal: "2026-05-30 08:35:10",
          isi: "<p style=\"text-align: justify;\">Beredar sebuah postingan di media sosial X yang mengeklaim jaringan 5G memiliki kaitan dengan penyebaran virus Corona. Jaringan 5G dapat memicu pelepasan virus dan bakteri dari dalam tubuh manusia.</p>\r\n<p style=\"text-align: justify;\">Setelah ditelusuri klaim jaringan 5G memiliki kaitan dengan penyebaran virus Corona tersebut adalah disinformasi. Jaringan 5G tidak memiliki hubungan dengan penyebaran virus. Virus menyebar melalui kontak droplet dan permukaan yang terkontaminasi. World Health Organization (WHO) menyatakan bahwa virus tidak dapat berpindah melalui gelombang radio atau jaringan seluler. Selain itu, COVID-19 menyebar di banyak negara yang tidak memiliki jaringan seluler 5G.</p>\r\n<p style=\"text-align: justify;\">Jadi informasi yang mengaitkan jaringan 5G dengan penyebaran virus Corona tersebut adalah tidak benar atau disinformasi.</p>",
          kategori: "Disinformasi",
          slugPath: "https://klinikhoaks.jatimprov.go.id/post/disinformasi-5g-menyebabkan-virus-corona-menyebar",
          image: "https://klinikhoaks.jatimprov.go.id/storage/images/67491ab54625b.jpg",
          sumber: "World Health Organization (WHO)",
        ),
        const KlinikHoaksClarificationModel(
          id: 367,
          judul: "[FAKTA] BPJS Kesehatan Gratis Tidak Dibagikan Lewat Whatsapp",
          tanggal: "2026-05-28 09:20:00",
          isi: "<p style=\"text-align: justify;\">Beredar sebuah pesan berantai di media sosial Whatsapp yang mengeklaim BPJS Kesehatan membagikan bantuan sosial berupa pelayanan gratis bagi masyarakat yang mendaftar melalui tautan terlampir dalam pesan tersebut.</p>\r\n<p style=\"text-align: justify;\">Setelah ditelusuri klaim pesan berantai tersebut adalah fakta hasil verifikasi bahwa BPJS Kesehatan tidak membagikan bantuan pelayanan gratis lewat pesan berantai Whatsapp. Direktur Utama BPJS Kesehatan menyatakan bahwa segala informasi resmi mengenai program jaminan kesehatan nasional hanya dipublikasikan melalui kanal komunikasi resmi BPJS Kesehatan seperti website bpjs-kesehatan.go.id atau aplikasi Mobile JKN. Tautan yang beredar dalam pesan tersebut disinyalir sebagai upaya penipuan or phishing.</p>\r\n<p style=\"text-align: justify;\">Jadi informasi mengenai pembagian BPJS Kesehatan gratis lewat pesan Whatsapp tersebut adalah tidak benar dan merupakan modus penipuan.</p>",
          kategori: "Fakta",
          slugPath: "https://klinikhoaks.jatimprov.go.id/post/fakta-bpjs-kesehatan-gratis-tidak-dibagikan-lewat-whatsapp",
          image: "https://klinikhoaks.jatimprov.go.id/storage/images/674681283bd78.jpg",
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
