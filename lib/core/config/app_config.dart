import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  static String get baseUrlLayanan => 
    dotenv.env['BASE_URL_LAYANAN'] ?? 'https://api-splp.layanan.go.id';
  static String get baseUrlMajadigi => 
    dotenv.env['BASE_URL_MAJADIGI'] ?? 'https://api.majadigi.layanan.go.id';
  static String get apiKeyHargaBahanPokok => dotenv.env['API_KEY_HARGA_BAHAN_POKOK'] ?? '';
  static String get apiKeySaifulAnwar => dotenv.env['API_KEY_SAIFUL_ANWAR'] ?? '';
  static String get apiKeyDahaHusada => dotenv.env['API_KEY_DAHA'] ?? '';
  static String get apiKeyKarsaHusada => dotenv.env['API_KEY_KARSA_HUSADA'] ?? '';
  static String get apiKeyHaji => dotenv.env['API_KEY_HAJI'] ?? '';
}