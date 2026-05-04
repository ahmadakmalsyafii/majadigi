import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {

  final baseUrlLayanan = dotenv.env['BASE_URL_LAYANAN'] ?? 'https://api-splp.layanan.go.id';

  final baseUrlMajadigi = dotenv.env['BASE_URL_MAJADIGI'] ?? 'https://api-majadigi.layanan.go.id';

  final apiKeyHargaBahanPokok = dotenv.env['API_KEY_HARGA_BAHAN_POKOK'];

  final apiKeySaifulAnwar = dotenv.env['API_KEY_SAIFUL_ANWAR'];

  final apiKeyDahaHusada = dotenv.env['API_KEY_DAHA'];

  final apiKeyKarsaHusada = dotenv.env['API_KEY_KARSA_HUSADA'];

  final apiKeyHaji = dotenv.env['API_KEY_HAJI'];
}