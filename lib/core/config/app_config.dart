class AppConfig {
  static const baseUrlLayanan =
  String.fromEnvironment('BASE_URL_LAYANAN', defaultValue: 'https://api-splp.layanan.go.id');

  static const baseUrlMajadigi =
  String.fromEnvironment('BASE_URL_MAJADIGI', defaultValue: 'https://api.majadigi.jatimprov.go.id');

  static const apiKeyHargaBahanPokok =
  String.fromEnvironment('API_KEY_HARGA_BAHAN_POKOK');

  static const apiKeySaifulAnwar =
  String.fromEnvironment('API_KEY_SAIFUL_ANWAR');

  static const apiKeyDahaHusada =
  String.fromEnvironment('API_KEY_DAHA');

  static const apiKeyKarsaHusada =
  String.fromEnvironment('API_KEY_KARSA_HUSADA');

  static const apiKeyHaji =
  String.fromEnvironment('API_KEY_HAJI');
}