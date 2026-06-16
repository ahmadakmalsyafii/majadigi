import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:majadigi/core/di/di.dart';
import 'package:majadigi/core/widgets/custom_header.dart';
import 'package:majadigi/deffered_feature/klinik_hoaks/presentation/bloc/klinik_hoaks_bloc.dart';
import 'package:majadigi/deffered_feature/klinik_hoaks/presentation/bloc/klinik_hoaks_event.dart';
import 'package:majadigi/deffered_feature/klinik_hoaks/presentation/bloc/klinik_hoaks_state.dart';

class LaporkanHoaksPage extends StatelessWidget {
  const LaporkanHoaksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<KlinikHoaksBloc>(
      create: (_) => sl<KlinikHoaksBloc>(),
      child: const _LaporkanHoaksView(),
    );
  }
}

class _LaporkanHoaksView extends StatefulWidget {
  const _LaporkanHoaksView({super.key});

  @override
  State<_LaporkanHoaksView> createState() => _LaporkanHoaksViewState();
}

class _LaporkanHoaksViewState extends State<_LaporkanHoaksView> {
  final _formKey = GlobalKey<FormState>();
  final _infoController = TextEditingController();
  final _sourceController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();
  XFile? _selectedImage;
  Uint8List? _imageBytes;

  @override
  void dispose() {
    _infoController.dispose();
    _sourceController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _selectedImage = pickedFile;
          _imageBytes = bytes;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal memilih gambar: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showImageSourceSelector() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  'Pilih Bukti',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.photo_library, color: Colors.blue),
                title: const Text('Pilih dari Galeri'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Colors.green),
                title: const Text('Ambil Foto Kamera'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  void _removeSelectedFile() {
    setState(() {
      _selectedImage = null;
      _imageBytes = null;
    });
  }

  void _submitReport() {
    if (_formKey.currentState!.validate()) {
      context.read<KlinikHoaksBloc>().add(
        SubmitHoaxReportEvent(
          info: _infoController.text,
          source: _sourceController.text,
          imageBytes: _imageBytes,
          fileName: _selectedImage?.name,
        ),
      );
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_circle,
                    size: 64,
                    color: Colors.green.shade600,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Laporan Terkirim!',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Terima kasih atas laporan Anda. Tim Klinik Hoaks Jawa Timur akan segera memproses dan memverifikasi informasi tersebut.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Tutup dialog
                      Navigator.pop(ctx);
                      // Kembali ke halaman utama Klinik Hoaks
                      context.pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade600,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text(
                      'Kembali ke Beranda',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocConsumer<KlinikHoaksBloc, KlinikHoaksState>(
          listener: (context, state) {
            if (state is KlinikHoaksReportSuccess) {
              _showSuccessDialog();
            } else if (state is KlinikHoaksReportFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            final isLoading = state is KlinikHoaksReportLoading;

            return Stack(
              children: [
                Column(
                  children: [
                    // Header Section dengan gradasi
                    const CustomHeader(
                      title: 'Laporkan Hoaks',
                      subtitle: 'Bantu masyarakat dari informasi menyesatkan',
                    ),

                    // Formulir Pengisian
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(24.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Input Informasi yang dilaporkan
                              const Text(
                                'Informasi yang dilaporkan',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: _infoController,
                                maxLines: 5,
                                decoration: InputDecoration(
                                  hintText: 'Isi informasi',
                                  hintStyle: TextStyle(color: Colors.grey.shade400),
                                  filled: true,
                                  fillColor: Colors.grey.shade50,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: Colors.grey.shade200),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: Colors.grey.shade200),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: Colors.blue.shade200),
                                  ),
                                  contentPadding: const EdgeInsets.all(16),
                                ),
                                validator: (val) {
                                  if (val == null || val.trim().isEmpty) {
                                    return 'Harap masukkan informasi yang dilaporkan';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 24),

                              // Input Sumber Informasi
                              const Text(
                                'Sumber Informasi',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: _sourceController,
                                decoration: InputDecoration(
                                  hintText: 'https://berita.com/fakta-asli',
                                  hintStyle: TextStyle(color: Colors.grey.shade400),
                                  filled: true,
                                  fillColor: Colors.grey.shade50,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: Colors.grey.shade200),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: Colors.grey.shade200),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: Colors.blue.shade200),
                                  ),
                                  contentPadding: const EdgeInsets.all(16),
                                ),
                                validator: (val) {
                                  if (val == null || val.trim().isEmpty) {
                                    return 'Harap masukkan sumber informasi';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 24),

                              // File Upload / Bukti container
                              const Text(
                                'Bukti Pendukung (Opsional)',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 8),

                              _selectedImage == null
                                  ? InkWell(
                                      onTap: _showImageSourceSelector,
                                      borderRadius: BorderRadius.circular(16),
                                      child: Container(
                                        width: double.infinity,
                                        height: 140,
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade50,
                                          borderRadius: BorderRadius.circular(16),
                                          border: Border.all(
                                            color: Colors.grey.shade300,
                                            style: BorderStyle.solid,
                                            width: 1.2,
                                          ),
                                        ),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.image_outlined,
                                              size: 36,
                                              color: Colors.grey.shade500,
                                            ),
                                            const SizedBox(height: 8),
                                            const Text(
                                              'Upload Screenshot / Bukti',
                                              style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black54,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              'JPG, PNG maks. 10MB',
                                              style: TextStyle(
                                                fontSize: 11,
                                                color: Colors.grey.shade500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  : Column(
                                      children: [
                                        // Preview gambar
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(12),
                                          child: Stack(
                                            children: [
                                              Image.memory(
                                                _imageBytes!,
                                                width: double.infinity,
                                                height: 200,
                                                fit: BoxFit.cover,
                                              ),
                                              Positioned(
                                                top: 8,
                                                right: 8,
                                                child: GestureDetector(
                                                  onTap: _removeSelectedFile,
                                                  child: Container(
                                                    padding: const EdgeInsets.all(6),
                                                    decoration: BoxDecoration(
                                                      color: Colors.black54,
                                                      borderRadius: BorderRadius.circular(20),
                                                    ),
                                                    child: const Icon(
                                                      Icons.close,
                                                      color: Colors.white,
                                                      size: 18,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        // Nama file
                                        Container(
                                          width: double.infinity,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 10,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.blue.shade50.withOpacity(0.5),
                                            borderRadius: BorderRadius.circular(8),
                                            border: Border.all(color: Colors.blue.shade200),
                                          ),
                                          child: Row(
                                            children: [
                                              const Icon(Icons.image, color: Colors.blue, size: 18),
                                              const SizedBox(width: 8),
                                              Expanded(
                                                child: Text(
                                                  _selectedImage!.name,
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.black87,
                                                  ),
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: _showImageSourceSelector,
                                                child: Text(
                                                  'Ganti',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.blue.shade600,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Bottom Sticky Button "Lapor"
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, -4),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: isLoading ? null : _submitReport,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade600,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          isLoading ? 'Mengirim...' : 'Lapor',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
                if (isLoading)
                  Container(
                    color: Colors.black26,
                    child: const Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(color: Colors.white),
                          SizedBox(height: 16),
                          Text(
                            'Mengirim laporan...',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            );
          },
      ),
    );
  }
}
