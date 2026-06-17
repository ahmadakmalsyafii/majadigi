import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:majadigi/features/beranda/domain/entity/service_entity.dart';
import 'package:majadigi/core/feature_manager/presentation/bloc/feature_manager_bloc.dart';
import 'package:majadigi/core/feature_manager/presentation/bloc/feature_manager_event.dart';
import 'package:majadigi/core/feature_manager/presentation/bloc/feature_manager_state.dart';
import 'package:majadigi/core/feature_manager/domain/entities/feature_status.dart';
import 'package:majadigi/core/di/di.dart';
import 'package:majadigi/deffered_feature/harga_bahan_pokok/presentation/pages/harga_bahan_pokok_page.dart'
    deferred as harga_bahan_pokok;
import 'package:majadigi/deffered_feature/ketersediaan_kamar/presentation/pages/ketersediaan_kamar_page.dart'
    deferred as ketersediaan_kamar;
import 'package:majadigi/deffered_feature/antrean_pasien/presentation/pages/antrean_pasien_page.dart'
    deferred as antrean_pasien;
import 'package:majadigi/deffered_feature/jadwal_operasi/presentation/pages/jadwal_operasi_page.dart'
    deferred as jadwal_operasi;
import 'package:majadigi/deffered_feature/bansos/presentation/pages/bansos_page.dart'
    deferred as bansos;
import 'package:majadigi/deffered_feature/destinasi_wisata/presentation/pages/destinasi_wisata_page.dart'
    deferred as destinasi_wisata;
import 'package:majadigi/deffered_feature/islamic_center/presentation/pages/islamic_center_page.dart'
    deferred as islamic_center;
import 'package:majadigi/deffered_feature/pendaftaran_pasien/presentation/pages/pendaftaran_pasien_page.dart'
    deferred as pendaftaran_pasien;
import 'package:majadigi/deffered_feature/klinik_hoaks/presentation/pages/klinik_hoaks_page.dart'
    deferred as klinik_hoaks;
import 'package:majadigi/deffered_feature/no_darurat/presentation/pages/noDarurat_pages.dart'
    deferred as no_darurat;

class LayananTabView extends StatefulWidget {
  final ServiceEntity service;
  const LayananTabView({super.key, required this.service});

  @override
  State<LayananTabView> createState() => _LayananTabViewState();
}

class _LayananTabViewState extends State<LayananTabView> {
  late FeatureManagerBloc _featureManagerBloc;

  @override
  void initState() {
    super.initState();
    _featureManagerBloc = sl<FeatureManagerBloc>();
    _featureManagerBloc.add(const CheckFeatureStatusEvent('harga_bahan_pokok'));
    _featureManagerBloc.add(
      const CheckFeatureStatusEvent('ketersediaan_kamar'),
    );
    _featureManagerBloc.add(const CheckFeatureStatusEvent('antrean_pasien'));
    _featureManagerBloc.add(const CheckFeatureStatusEvent('jadwal_operasi'));
    _featureManagerBloc.add(const CheckFeatureStatusEvent('bansos'));
    _featureManagerBloc.add(const CheckFeatureStatusEvent('destinasi_wisata'));
    _featureManagerBloc.add(const CheckFeatureStatusEvent('islamic_center'));
    _featureManagerBloc.add(
      const CheckFeatureStatusEvent('pendaftaran_pasien'),
    );
    _featureManagerBloc.add(const CheckFeatureStatusEvent('klinik_hoaks'));
    _featureManagerBloc.add(const CheckFeatureStatusEvent('no_darurat'));
  }

  @override
  Widget build(BuildContext context) {
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
        SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.0,
          ),
          itemCount:
              (widget.service.name == 'Program Bansos' ||
                  widget.service.name.toLowerCase().contains('islamic'))
              ? 1
              : widget.service.features.isNotEmpty
              ? widget.service.features.length
              : (_isHospital(widget.service.name) ? 2 : 0),
          itemBuilder: (context, index) {
            String featureName = '';
            IconData icon = Icons.apps;
            Color iconColor = Colors.blue;

            if (widget.service.name == 'Program Bansos') {
              featureName = 'Cek Penerima Bansos';
              icon = Icons.search;
              iconColor = Colors.green;
            } else if (widget.service.name.toLowerCase().contains('islamic')) {
              featureName = 'Islamic Center';
              icon = Icons.nights_stay_outlined;
              iconColor = Colors.green;
            } else if (widget.service.features.isNotEmpty) {
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

            if (widget.service.name.toLowerCase().contains('sidita')) {
              featureName = 'Destinasi Wisata';
              icon = Icons.map;
              iconColor = Colors.green;
            }

            final isHargaBahanPokok = featureName.toLowerCase().contains(
              'harga bahan pokok',
            );
            final isKamar = featureName.toLowerCase().contains('kamar');
            final isAntrean =
                featureName.toLowerCase().contains('antrean') ||
                featureName.toLowerCase().contains('antrian');
            final isOperasi = featureName.toLowerCase().contains('operasi');
            final isBansos = featureName.toLowerCase().contains('bansos');
            final isDestinasi =
                featureName.toLowerCase().contains('destinasi') ||
                featureName.toLowerCase().contains('wisata') ||
                featureName.toLowerCase().contains('sidita');
            final isIslamicCenter = featureName.toLowerCase().contains(
              'islamic',
            );
            final isPendaftaran =
                featureName.toLowerCase().contains('daftar') ||
                featureName.toLowerCase().contains('pendaftaran');
            final isHoaks =
                featureName.toLowerCase().contains('hoaks') ||
                featureName.toLowerCase().contains('hoax');
            final isDarurat = featureName.toLowerCase().contains('darurat');

            String featureKey = '';
            if (isHargaBahanPokok) {
              featureKey = 'harga_bahan_pokok';
            } else if (isKamar)
              featureKey = 'ketersediaan_kamar';
            else if (isAntrean)
              featureKey = 'antrean_pasien';
            else if (isOperasi)
              featureKey = 'jadwal_operasi';
            else if (isBansos)
              featureKey = 'bansos';
            else if (isDestinasi)
              featureKey = 'destinasi_wisata';
            else if (isIslamicCenter)
              featureKey = 'islamic_center';
            else if (isPendaftaran)
              featureKey = 'pendaftaran_pasien';
            else if (isHoaks)
              featureKey = 'klinik_hoaks';
            else if (isDarurat)
              featureKey = 'no_darurat';

            final isDeferred = featureKey.isNotEmpty;

            return BlocBuilder<FeatureManagerBloc, FeatureManagerState>(
              bloc: _featureManagerBloc,
              builder: (context, state) {
                final status = isDeferred
                    ? state.getStatus(featureKey)
                    : FeatureStatus.installed;
                final progress = isDeferred
                    ? state.getProgress(featureKey)
                    : 0.0;

                final isNotInstalled = status == FeatureStatus.notInstalled;
                final isInstalling = status == FeatureStatus.installing;

                return GestureDetector(
                  onTap: () {
                    if (isDeferred) {
                      if (isNotInstalled) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Unduh Fitur'),
                              content: const Text(
                                'Fitur ini belum diunduh. Apakah Anda ingin mengunduhnya sekarang?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Batal'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);

                                    Future<void> Function() loadFuture;
                                    if (featureKey == 'ketersediaan_kamar') {
                                      loadFuture = () =>
                                          ketersediaan_kamar.loadLibrary();
                                    } else if (featureKey == 'antrean_pasien')
                                      loadFuture = () =>
                                          antrean_pasien.loadLibrary();
                                    else if (featureKey == 'jadwal_operasi')
                                      loadFuture = () =>
                                          jadwal_operasi.loadLibrary();
                                    else if (featureKey == 'bansos')
                                      loadFuture = () => bansos.loadLibrary();
                                    else if (featureKey == 'destinasi_wisata')
                                      loadFuture = () =>
                                          destinasi_wisata.loadLibrary();
                                    else if (featureKey == 'islamic_center')
                                      loadFuture = () =>
                                          islamic_center.loadLibrary();
                                    else if (featureKey == 'pendaftaran_pasien')
                                      loadFuture = () =>
                                          pendaftaran_pasien.loadLibrary();
                                    else if (featureKey == 'klinik_hoaks')
                                      loadFuture = () =>
                                          klinik_hoaks.loadLibrary();
                                    else if (featureKey == 'no_darurat')
                                      loadFuture = () =>
                                          no_darurat.loadLibrary();
                                    else
                                      loadFuture = () =>
                                          harga_bahan_pokok.loadLibrary();

                                    _featureManagerBloc.add(
                                      InstallFeatureEvent(
                                        featureName: featureKey,
                                        loadLibraryFuture: loadFuture,
                                      ),
                                    );
                                  },
                                  child: const Text('Ya'),
                                ),
                              ],
                            );
                          },
                        );
                        return;
                      } else if (isInstalling) {
                        return;
                      } else {
                        if (featureKey == 'ketersediaan_kamar') {
                          context.push(
                            '/ketersediaan-kamar',
                            extra: widget.service,
                          );
                        } else if (featureKey == 'antrean_pasien') {
                          context.push('/antrean-pasien');
                        } else if (featureKey == 'jadwal_operasi') {
                          context.push('/jadwal-operasi');
                        } else if (featureKey == 'bansos') {
                          context.push('/bansos');
                        } else if (featureKey == 'destinasi_wisata') {
                          context.push('/destinasi-wisata');
                        } else if (featureKey == 'islamic_center') {
                          context.push('/islamic-center');
                        } else if (featureKey == 'pendaftaran_pasien') {
                          context.push(
                            '/pendaftaran-pasien',
                            extra: widget.service,
                          );
                        } else if (featureKey == 'klinik_hoaks') {
                          context.push('/klinik-hoaks');
                        } else if (featureKey == 'no_darurat') {
                          context.push('/no-darurat');
                        } else {
                          context.push('/harga-bahan-pokok');
                        }
                        return;
                      }
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isNotInstalled || isInstalling
                          ? Colors.grey.shade300
                          : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Flexible(
                                child: Text(
                                  featureName,
                                  textAlign: TextAlign.center,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: isNotInstalled || isInstalling
                                        ? Colors.grey.shade600
                                        : Colors.black87,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Icon(
                                icon,
                                color: isNotInstalled || isInstalling
                                    ? Colors.grey.shade500
                                    : iconColor,
                                size: 28,
                              ),
                            ],
                          ),
                        ),
                        if (isNotInstalled)
                          const Positioned(
                            bottom: 0,
                            right: 0,
                            child: Icon(
                              Icons.download_rounded,
                              color: Colors.black54,
                            ),
                          ),
                        if (isInstalling)
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: LinearProgressIndicator(value: progress),
                          ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }

  IconData _getIconForFeature(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('kamar')) return Icons.bed;
    if (lower.contains('daftar') || lower.contains('pendaftaran'))
      return Icons.person_add_alt_1;
    if (lower.contains('antrean') || lower.contains('antrian'))
      return Icons.people_outline;
    if (lower.contains('operasi')) return Icons.schedule;
    if (lower.contains('hoaks') || lower.contains('hoax'))
      return Icons.gavel_rounded;
    if (lower.contains('darurat')) return Icons.contact_phone;
    return Icons.apps;
  }

  Color _getColorForFeature(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('kamar')) return Colors.blue;
    if (lower.contains('daftar') || lower.contains('pendaftaran'))
      return Colors.orange;
    if (lower.contains('antrean') || lower.contains('antrian'))
      return Colors.green;
    if (lower.contains('operasi')) return Colors.red;
    if (lower.contains('hoaks') || lower.contains('hoax'))
      return Colors.redAccent;
    if (lower.contains('darurat')) return Colors.red;
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
