import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Service untuk upload gambar ke Cloudinary via unsigned upload.
/// Mendukung Web dan Mobile.
class CloudinaryService {
  final Dio _dio;

  String get _cloudName => dotenv.env['CLOUDINARY_CLOUD_NAME'] ?? '';
  String get _uploadPreset => dotenv.env['CLOUDINARY_UPLOAD_PRESET'] ?? '';

  CloudinaryService() : _dio = Dio();

  /// Upload gambar ke Cloudinary dari bytes.
  /// Mengembalikan URL publik dari gambar yang diupload.
  /// Throws [Exception] jika upload gagal.
  Future<String> uploadImageBytes(Uint8List imageBytes, String fileName) async {
    if (_cloudName.isEmpty || _uploadPreset.isEmpty) {
      throw Exception(
        'Cloudinary belum dikonfigurasi. '
        'Pastikan CLOUDINARY_CLOUD_NAME dan CLOUDINARY_UPLOAD_PRESET ada di .env',
      );
    }

    final url = 'https://api.cloudinary.com/v1_1/$_cloudName/image/upload';

    final formData = FormData.fromMap({
      'file': MultipartFile.fromBytes(
        imageBytes,
        filename: fileName,
      ),
      'upload_preset': _uploadPreset,
      'folder': 'hoax_reports',
    });

    try {
      final response = await _dio.post(
        url,
        data: formData,
        options: Options(
          receiveTimeout: const Duration(seconds: 30),
          sendTimeout: const Duration(seconds: 60),
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        final imageUrl = response.data['secure_url'] as String?;
        if (imageUrl != null && imageUrl.isNotEmpty) {
          debugPrint('[Cloudinary] Upload berhasil: $imageUrl');
          return imageUrl;
        }
      }

      throw Exception('Gagal mendapatkan URL gambar dari Cloudinary');
    } on DioException catch (e) {
      debugPrint('[Cloudinary] Upload gagal: ${e.message}');
      throw Exception('Gagal mengupload gambar: ${e.message}');
    }
  }
}
