# Laporan Implementasi Network Dio

Laporan ini menjelaskan implementasi HTTP Client menggunakan library `dio` pada project `majadigi`. Implementasi ini dirancang secara modular dengan memisahkan konfigurasi dasar, interceptor untuk autentikasi API Key dan penanganan error, serta manajemen pengambilan API Key.

## 1. DioClient (`dio_client.dart`)

File ini bertanggung jawab sebagai pusat konfigurasi utama untuk objek `Dio`. File ini berlokasi di `lib/core/network/dio_client.dart`.

```dart
import 'package:dio/dio.dart';
import 'package:majadigi/core/config/app_config.dart';
import 'package:majadigi/core/network/api_key_interceptor.dart';
import 'package:majadigi/core/network/api_key_manager.dart';

class DioClient {
  late final Dio _dio;

  DioClient(ApiKeyManager keyManager) {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.baseUrlLayanan,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 20),
      ),
    );

    _dio.interceptors.addAll([
      ApiKeyInterceptor(keyManager),
      LogInterceptor(requestBody: false, responseBody: false, error: true),
    ]);
  }

  Dio get dio => _dio;
}
```

**Kegunaan dan Penjelasan:**
- **`BaseOptions`**: Mengatur konfigurasi dasar yang akan digunakan di setiap pemanggilan API, seperti `baseUrl`, `connectTimeout` (waktu maksimal menunggu koneksi terbuka, yaitu 15 detik), dan `receiveTimeout` (waktu maksimal menunggu data diterima, yaitu 20 detik).
- **`interceptors`**: Menambahkan *layer* (perantara) sebelum request dikirim atau sesudah error terjadi. Di sini kita memasang `ApiKeyInterceptor` untuk operasi custom aplikasi kita, dan `LogInterceptor` bawaan Dio untuk keperluan mencetak *log error* ke dalam console.
- **`dio getter`**: Digunakan oleh layer datasource untuk mendapatkan instance `Dio` yang telah dikonfigurasi.

## 2. ApiKeyInterceptor (`api_key_interceptor.dart`)

File ini bertugas mencegat (intercept) setiap request yang keluar untuk menyisipkan header API Key, serta mencegat error yang masuk untuk disederhanakan tipenya. File ini berlokasi di `lib/core/network/api_key_interceptor.dart`.

```dart
import 'package:dio/dio.dart';
import 'package:majadigi/core/error/failure.dart';
import 'package:majadigi/core/network/api_key_manager.dart';

class ApiKeyInterceptor extends Interceptor {
  final ApiKeyManager _keyManager;
  ApiKeyInterceptor(this._keyManager);

  static final _endpointMap = <RegExp, ApiEndpoint>{
    RegExp(r'/disperindag/commodity'): ApiEndpoint.hargaBahanPokok,
    RegExp(r'/rssa/rooms'): ApiEndpoint.saifulAnwar,
    RegExp(r'/rsud-daha-husada'): ApiEndpoint.dahaHusada,
    RegExp(r'/rsukarsahusadabatu'): ApiEndpoint.karsaHusada,
    RegExp(r'/rshaji'): ApiEndpoint.haji,
  };

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final path = options.path;
    for (final entry in _endpointMap.entries) {
      if (entry.key.hasMatch(path)) {
        final key = _keyManager.getKey(entry.value);
        if (key.isNotEmpty) {
          options.headers['ApiKey'] = key;
        }
        break;
      }
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final failure = switch (err.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.receiveTimeout => const NetworkFailure(),
      DioExceptionType.badResponse
          when (err.response?.statusCode ?? 0) == 401 =>
        const UnauthorizedFailure(),
      _ => ServerFailure(),
    };
    handler.reject(
      DioException(requestOptions: err.requestOptions, error: failure),
    );
  }
}
```

**Kegunaan dan Penjelasan:**
- **`_endpointMap`**: Kumpulan pemetaan (*Map*) yang menghubungkan pola URL (dalam format `RegExp`) dengan klasifikasi spesifik di dalam enum `ApiEndpoint`. Ini diperlukan karena aplikasi memanggil banyak layanan API berbeda yang membutuhkan tipe kunci yang berbeda pula.
- **`onRequest`**: Method ini akan terpanggil otomatis sebelum setiap HTTP Request dikirimkan ke internet. Di dalamnya kode mengecek path/URL tujuan, mencocokkannya dengan `_endpointMap`, lalu meminta string API Key dari `ApiKeyManager`. String API Key tersebut disisipkan ke dalam format `options.headers['ApiKey']`. Setelah itu, proses dilanjutkan dengan `handler.next(options)`.
- **`onError`**: Mengubah berbagai macam exception kompleks bawaan `DioException` ke bentuk error custom khusus aplikasi ini (seperti `NetworkFailure`, `UnauthorizedFailure`, dan `ServerFailure`). Hal ini membuat deteksi jenis error pada layer UI/Presentation jauh lebih mudah dimengerti.

## 3. ApiKeyManager (`api_key_manager.dart`)

File ini bertanggung jawab sebagai jembatan untuk mendapatkan nilai rahasia API Key yang aman. Berlokasi di `lib/core/network/api_key_manager.dart`.

```dart
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:majadigi/core/config/app_config.dart';

class ApiKeyManager {
  final FirebaseRemoteConfig _remoteConfig;
  bool _initialized = false;

  ApiKeyManager(this._remoteConfig);
  
  // ... fungsi init remote config ...

  String getKey(ApiEndpoint endpoint) {
    return switch (endpoint) {
      ApiEndpoint.hargaBahanPokok => AppConfig.apiKeyHargaBahanPokok,
      ApiEndpoint.saifulAnwar => AppConfig.apiKeySaifulAnwar,
      ApiEndpoint.dahaHusada => AppConfig.apiKeyDahaHusada,
      ApiEndpoint.karsaHusada => AppConfig.apiKeyKarsaHusada,
      ApiEndpoint.haji => AppConfig.apiKeyHaji,
      ApiEndpoint.nomorDarurat => '',
    };
  }
}

enum ApiEndpoint {
  hargaBahanPokok,
  saifulAnwar,
  dahaHusada,
  karsaHusada,
  haji,
  nomorDarurat,
}
```

**Kegunaan dan Penjelasan:**
- **`getKey()`**: Fungsi ini berfungsi seperti kamus penterjemah. Saat dipanggil dan diberikan tipe `ApiEndpoint` (misal: *hargaBahanPokok*), fungsi ini me-return variabel string yang tepat (mengambil nilai asli yang terpusat di class `AppConfig`).
- **`enum ApiEndpoint`**: Daftar kaku (*enum*) berisi identifikasi sumber daya layanan backend apa saja yang didukung oleh aplikasi secara valid.

---

## Alur Cara Kerja Penggunaan Kode (Flow)

Berikut adalah urutan alur kerja dari ketiga komponen yang saling terhubung tersebut saat ada proses pemanggilan API dari dalam aplikasi:

1. **Tahap Inisialisasi Aplikasi (Dependency Injection)**
   Aplikasi membuat *instance* tunggal (Singleton) dari `DioClient`. Pada momen ini, konfigurasi `baseUrl` dan pembatasan `timeout` di-set. Selain itu, objek `ApiKeyInterceptor` disuntikkan (*injected*) ke dalam `DioClient`.
   
2. **Tahap Layer Datasource Meminta Data**
   Satu blok program dari Remote Datasource (misal: menu 'Cek Harga Bahan Pokok') ingin mengambil data. Datasource menggunakan instance `Dio` yang diekspos dari fungsi `getter` milik `DioClient` untuk memanggil perintah seperti `dio.get('/disperindag/commodity')`.
   
3. **Tahap Pencegatan oleh Interceptor (`onRequest`)**
   Sebelum menyeberang ke jaringan internet, request yang diminta ditahan sementara oleh `ApiKeyInterceptor`. Interceptor memeriksa apakah tujuan URL (`/disperindag/commodity`) terdaftar di dalam daftarnya.
   
4. **Tahap Pemasangan Kunci (API Key Header)**
   Ternyata pola URL cocok dengan `ApiEndpoint.hargaBahanPokok`. Interceptor lantas meminta kunci aktual ke `ApiKeyManager` lewat fungsi `getKey()`. Nilai yang didapat langsung disisipkan ke header request `ApiKey: {nilai_kunci}`. Request kini siap dengan "tiket masuk" dan diteruskan ke server lewat internet.
   
5. **Tahap Eksekusi dan Tanggapan (Response / Error)**
   - Jika response server **BERHASIL** (Code 200/201), maka data langsung dilempar kembali kepada si Pemanggil Data (Layer Datasource) seperti biasa.
   - Jika response server **GAGAL** (contoh karena jaringan tidak ada / *Connection Timeout* atau Token tertolak / *Code 401*), blok `onError` pada Interceptor akan menahan error tersebut. Error tersebut ditransformasikan dari "Bahasa Mesin Dio" ke "Bahasa Class Failure Aplikasi" (`NetworkFailure`, `UnauthorizedFailure`, dsb). Kemudian di-reject kepada blok program Datasource agar dapat ditangkap oleh baris program `try-catch` secara elegan.
