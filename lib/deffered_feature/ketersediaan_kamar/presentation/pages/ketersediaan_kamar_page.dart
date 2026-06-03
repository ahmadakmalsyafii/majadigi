import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:majadigi/core/di/di.dart';
import 'package:majadigi/deffered_feature/ketersediaan_kamar/domain/entity/room_availability_entity.dart';
import 'package:majadigi/deffered_feature/ketersediaan_kamar/presentation/bloc/ketersediaan_kamar_bloc.dart';
import 'package:majadigi/deffered_feature/ketersediaan_kamar/presentation/bloc/ketersediaan_kamar_event.dart';
import 'package:majadigi/deffered_feature/ketersediaan_kamar/presentation/bloc/ketersediaan_kamar_state.dart';
import 'package:majadigi/deffered_feature/ketersediaan_kamar/presentation/bloc/ketersediaan_kamar_state.dart';
import 'package:majadigi/features/beranda/domain/entity/service_entity.dart';
import 'package:majadigi/core/widgets/custom_header.dart';
import 'package:majadigi/core/feature_manager/presentation/bloc/feature_manager_bloc.dart';
import 'package:majadigi/core/feature_manager/presentation/bloc/feature_manager_event.dart';

class KetersediaanKamarPage extends StatelessWidget {
  final ServiceEntity service;

  const KetersediaanKamarPage({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<KetersediaanKamarBloc>()..add(FetchRoomAvailability(service.name)),
      child: _KetersediaanKamarView(service: service),
    );
  }
}

class _KetersediaanKamarView extends StatelessWidget {
  final ServiceEntity service;

  const _KetersediaanKamarView({required this.service});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [
          CustomHeader(
            title: service.name,
            subtitleWidget: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  service.address,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 10),
                BlocBuilder<KetersediaanKamarBloc, KetersediaanKamarState>(
                  builder: (context, state) {
                    if (state is KetersediaanKamarLoaded) {
                      return Text(
                        'Terakhir Diperbarui: ${state.data.summary.lastUpdate}',
                        style: const TextStyle(color: Colors.white54, fontSize: 11),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ],
            ),
            trailing: InkWell(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Hapus Fitur'),
                      content: const Text('Apakah Anda yakin ingin menghapus fitur ini dari perangkat?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Batal'),
                        ),
                        TextButton(
                          onPressed: () {
                            sl<FeatureManagerBloc>().add(const UninstallFeatureEvent('ketersediaan_kamar'));
                            Navigator.pop(context);
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Fitur berhasil dihapus')),
                            );
                          },
                          child: const Text('Ya'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.delete_outline, color: Colors.white, size: 16),
                    SizedBox(width: 4),
                    Text('Hapus', style: TextStyle(color: Colors.white, fontSize: 14)),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<KetersediaanKamarBloc, KetersediaanKamarState>(
              builder: (context, state) {
                if (state is KetersediaanKamarLoading) {
                  return const Center(
                    child: CircularProgressIndicator(color: Color(0xFF016ACC)),
                  );
                } else if (state is KetersediaanKamarError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, color: Colors.grey, size: 48),
                        const SizedBox(height: 16),
                        Text(
                          state.message,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            context.read<KetersediaanKamarBloc>().add(FetchRoomAvailability(service.name));
                          },
                          child: const Text('Coba Lagi'),
                        ),
                      ],
                    ),
                  );
                } else if (state is KetersediaanKamarLoaded) {
                  final data = state.data;
                  return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSummaryRow(data.summary),
                        const SizedBox(height: 24),
                        _buildRoomSection(data.rooms),
                      ],
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  // ── 3 Summary cards ────────────────────────────────────────────────────────

  Widget _buildSummaryRow(RoomSummaryEntity summary) {
    return Row(
      children: [
        _buildSummaryCard(
          value: '${summary.available}',
          label: 'Bed Tersedia',
          valueColor: const Color(0xFF2ECC71),
          bgColor: const Color(0xFFEAFAF1),
        ),
        const SizedBox(width: 10),
        _buildSummaryCard(
          value: '${summary.occupied}',
          label: 'Bed Terisi',
          valueColor: const Color(0xFFE74C3C),
          bgColor: const Color(0xFFFDEDEC),
        ),
        const SizedBox(width: 10),
        _buildSummaryCard(
          value: '${summary.total}',
          label: 'Total Bed',
          valueColor: const Color(0xFF016ACC),
          bgColor: const Color(0xFFE8F4FD),
        ),
      ],
    );
  }

  Widget _buildSummaryCard({
    required String value,
    required String label,
    required Color valueColor,
    required Color bgColor,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: valueColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 11,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Room grid ──────────────────────────────────────────────────────────────

  Widget _buildRoomSection(List<RoomDetailEntity> rooms) {
    if (rooms.isEmpty) {
      return const Center(child: Text("Tidak ada data kamar tersedia."));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Ketersediaan Kamar Rawat Inap',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A1A2E),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.all(16),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.6,
            ),
            itemCount: rooms.length,
            itemBuilder: (context, index) {
              return _buildRoomCard(rooms[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRoomCard(RoomDetailEntity room) {
    double progress = room.total > 0 ? room.available / room.total : 0;
    
    // Tentukan warna berdasarkan rasio ketersediaan
    Color barColor;
    if (progress > 0.5) {
      barColor = const Color(0xFF2ECC71); // Hijau (Banyak tersedia)
    } else if (progress > 0.2) {
      barColor = const Color(0xFFF39C12); // Orange (Sedikit tersedia)
    } else {
      barColor = const Color(0xFFE74C3C); // Merah (Penuh / Hampir penuh)
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            room.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1A2E),
            ),
          ),
          Text(
            '${room.available}',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: barColor,
            ),
          ),
          Text(
            'dari ${room.total} tersedia',
            style: const TextStyle(fontSize: 11, color: Colors.grey),
          ),
          const SizedBox(height: 4),
          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 5,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(barColor),
            ),
          ),
        ],
      ),
    );
  }
}
