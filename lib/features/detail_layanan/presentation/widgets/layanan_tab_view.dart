import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:majadigi/features/beranda/domain/entity/service_entity.dart';
import 'package:majadigi/deffered_feature/no_darurat/presentation/pages/noDarurat_pages.dart';

class LayananTabView extends StatefulWidget {
  final ServiceEntity service;
  const LayananTabView({super.key, required this.service});

  @override
  State<LayananTabView> createState() => _LayananTabViewState();
}

class _LayananTabViewState extends State<LayananTabView> {
  @override
  Widget build(BuildContext context) {
    if (widget.service.name == 'Nomor Darurat') {
      return const EmergencyNumberPage();
    }
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      children: [
        const Text(
          'Layanan yang tersedia',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.2,
          ),
          itemCount: widget.service.features.isNotEmpty
              ? widget.service.features.length
              : (_isHospital(widget.service.name) ? 2 : 0),
          itemBuilder: (context, index) {
            String featureName = '';
            IconData icon = Icons.apps;
            Color iconColor = Colors.blue;

            if (widget.service.features.isNotEmpty) {
              featureName = widget.service.features[index].judul;
              icon = _getIconForFeature(featureName);
              iconColor = _getColorForFeature(featureName);
            } else {
              if (index == 0) {
                featureName = 'Ketersediaan Kamar';
                icon = Icons.bed;
                iconColor = Colors.blue;
              } else {
                featureName = 'Daftar Pasien';
                icon = Icons.person_add_alt_1;
                iconColor = Colors.orange;
              }
            }

            return GestureDetector(
              onTap: () {
                if (featureName.toLowerCase().contains('kamar')) {
                  context.push('/ketersediaan-kamar', extra: widget.service);
                } else if (featureName.toLowerCase().contains('antrean') || featureName.toLowerCase().contains('antrian')) {
                  context.push('/antrean-pasien');
                } else if (featureName.toLowerCase().contains('operasi')) {
                  context.push('/jadwal-operasi');
                } else if (featureName.toLowerCase().contains('daftar') || featureName.toLowerCase().contains('pendaftaran')) {
                  context.push('/pendaftaran-pasien', extra: widget.service);
                } else if (featureName.toLowerCase().contains('hoaks') || featureName.toLowerCase().contains('hoax')) {
                  context.push('/klinik-hoaks');
                }
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      featureName,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Icon(icon, color: iconColor, size: 28),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  IconData _getIconForFeature(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('kamar')) return Icons.bed;
    if (lower.contains('daftar') || lower.contains('pendaftaran')) return Icons.person_add_alt_1;
    if (lower.contains('antrean') || lower.contains('antrian')) return Icons.people_outline;
    if (lower.contains('operasi')) return Icons.schedule;
    if (lower.contains('hoaks') || lower.contains('hoax')) return Icons.gavel_rounded;
    return Icons.apps;
  }

  Color _getColorForFeature(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('kamar')) return Colors.blue;
    if (lower.contains('daftar') || lower.contains('pendaftaran')) return Colors.orange;
    if (lower.contains('antrean') || lower.contains('antrian')) return Colors.green;
    if (lower.contains('operasi')) return Colors.red;
    if (lower.contains('hoaks') || lower.contains('hoax')) return Colors.redAccent;
    return Colors.blue;
  }

  bool _isHospital(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('hoaks') || lower.contains('hoax')) {
      return false;
    }
    return lower.contains('rumah sakit') ||
        lower.contains('hospital') ||
        lower.contains('klinik') ||
        lower.contains('puskesmas') ||
        lower.contains('rsud') ||
        lower.contains('rsu') ||
        lower.contains('rssa') ||
        lower.split(RegExp(r'[\s.,\-/]')).contains('rs');
  }
}
