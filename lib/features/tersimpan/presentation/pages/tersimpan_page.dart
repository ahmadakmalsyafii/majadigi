import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:majadigi/core/di/di.dart';
import 'package:majadigi/core/feature_manager/presentation/bloc/feature_manager_bloc.dart';
import 'package:majadigi/core/feature_manager/presentation/bloc/feature_manager_event.dart';
import 'package:majadigi/core/feature_manager/presentation/bloc/feature_manager_state.dart';
import 'package:majadigi/core/widgets/custom_header.dart';

class TersimpanPage extends StatefulWidget {
  const TersimpanPage({super.key});

  @override
  State<TersimpanPage> createState() => _TersimpanPageState();
}

class _TersimpanPageState extends State<TersimpanPage> {
  late FeatureManagerBloc _featureManagerBloc;

  @override
  void initState() {
    super.initState();
    _featureManagerBloc = sl<FeatureManagerBloc>();
    _featureManagerBloc.add(GetAllInstalledFeaturesEvent());
  }

  Widget _getIconForFeature(String featureKey) {
    IconData iconData;
    Color iconColor;
    Color bgColor;

    switch (featureKey) {
      case 'ketersediaan_kamar':
        iconData = Icons.bed;
        iconColor = Colors.blue;
        bgColor = Colors.blue.shade50;
        break;
      case 'antrean_pasien':
        iconData = Icons.person_add_alt_1;
        iconColor = Colors.orange;
        bgColor = Colors.orange.shade50;
        break;
      case 'jadwal_operasi':
        iconData = Icons.local_hospital;
        iconColor = Colors.blue;
        bgColor = Colors.blue.shade50;
        break;
      case 'bansos':
        iconData = Icons.search;
        iconColor = Colors.green;
        bgColor = Colors.green.shade50;
        break;
      case 'destinasi_wisata':
        iconData = Icons.map;
        iconColor = Colors.green;
        bgColor = Colors.green.shade50;
        break;
      case 'harga_bahan_pokok':
        iconData = Icons.shopping_cart;
        iconColor = Colors.blue;
        bgColor = Colors.blue.shade50;
        break;
      case 'islamic_center':
        iconData = Icons.mosque;
        iconColor = Colors.pink;
        bgColor = Colors.pink.shade50;
        break;
      default:
        iconData = Icons.apps;
        iconColor = Colors.grey;
        bgColor = Colors.grey.shade200;
    }

    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(iconData, color: iconColor),
    );
  }

  String _getNameForFeature(String featureKey) {
    switch (featureKey) {
      case 'ketersediaan_kamar':
        return 'Ketersediaan Kamar';
      case 'antrean_pasien':
        return 'Daftar Pasien';
      case 'jadwal_operasi':
        return 'Jadwal Operasi';
      case 'bansos':
        return 'Cek Penerima Bansos';
      case 'destinasi_wisata':
        return 'Destinasi Wisata';
      case 'harga_bahan_pokok':
        return 'Harga Bahan Pokok';
      case 'islamic_center':
        return 'Islamic Center';
      default:
        return featureKey;
    }
  }

  void _navigateToFeature(BuildContext context, String featureKey) {
    switch (featureKey) {
      case 'ketersediaan_kamar':
        context.push('/ketersediaan-kamar');
        break;
      case 'antrean_pasien':
        context.push('/antrean-pasien');
        break;
      case 'jadwal_operasi':
        context.push('/jadwal-operasi');
        break;
      case 'bansos':
        context.push('/bansos');
        break;
      case 'destinasi_wisata':
        context.push('/destinasi-wisata');
        break;
      case 'harga_bahan_pokok':
        context.push('/harga-bahan-pokok');
        break;
      case 'islamic_center':
        context.push('/islamic-center');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [
          const CustomHeader(
            title: 'Tersimpan',
            subtitle: 'Layanan yang telah diunduh',
            showBackButton: false,
          ),
          Expanded(
            child: BlocBuilder<FeatureManagerBloc, FeatureManagerState>(
              bloc: _featureManagerBloc,
              builder: (context, state) {
                final features = state.installedFeatures;

                if (features.isEmpty) {
                  return const Center(
                    child: Text('Belum ada layanan yang disimpan.'),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: features.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final featureKey = features[index];
                    final featureName = _getNameForFeature(featureKey);

                    return InkWell(
                      onTap: () => _navigateToFeature(context, featureKey),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Row(
                          children: [
                            _getIconForFeature(featureKey),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    featureName,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
