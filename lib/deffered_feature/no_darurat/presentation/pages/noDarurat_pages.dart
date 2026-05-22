import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:majadigi/core/di/di.dart';
import 'package:majadigi/deffered_feature/no_darurat/presentation/bloc/emergency/emergency_bloc.dart';
import 'package:majadigi/deffered_feature/no_darurat/presentation/bloc/emergency/emergency_event.dart';
import 'package:majadigi/deffered_feature/no_darurat/presentation/bloc/emergency/emergency_state.dart';
import 'package:url_launcher/url_launcher.dart';

class EmergencyNumberPage extends StatelessWidget {
  const EmergencyNumberPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<EmergencyBloc>(),
      child: const _EmergencyNumberView(),
    );
  }
}

class _EmergencyNumberView extends StatefulWidget {
  const _EmergencyNumberView();

  @override
  State<_EmergencyNumberView> createState() => _EmergencyNumberViewState();
}

class _EmergencyNumberViewState extends State<_EmergencyNumberView> {
  @override
  void initState() {
    super.initState();
    context.read<EmergencyBloc>().add(const LoadEmergencyData());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EmergencyBloc, EmergencyState>(
      builder: (context, state) {
        if (state is EmergencyLoading) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF016ACC)),
          );
        } else if (state is EmergencyLoaded) {
          return _buildLayananView(context, state);
        } else if (state is EmergencyError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.wifi_off_rounded, color: Colors.grey, size: 48),
                const SizedBox(height: 16),
                Text(
                  state.message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => context
                      .read<EmergencyBloc>()
                      .add(const LoadEmergencyData()),
                  child: const Text('Coba Lagi'),
                ),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
  Widget _buildLayananView(BuildContext context, EmergencyLoaded state,
      {Key? key}) {
    return Column(
      key: key,
      children: [
        const SizedBox(height: 16),

        // Location Selector Button
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: GestureDetector(
            onTap: () => _showLocationBottomSheet(context, state),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: Row(
                children: [
                  const Icon(Icons.location_on_outlined,
                      color: Colors.grey, size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      state.selectedKabKotaNama,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF1A1A2E),
                      ),
                    ),
                  ),
                  const Icon(Icons.keyboard_arrow_down_rounded,
                      color: Colors.grey),
                ],
              ),
            ),
          ),
        ),

        // Info jumlah hasil
        Padding(
          padding: const EdgeInsets.only(
              left: 24.0, right: 24.0, top: 12.0, bottom: 4.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "${state.numbers.length} nomor darurat ditemukan",
              style: TextStyle(fontSize: 12, color: Colors.grey[500]),
            ),
          ),
        ),

        // List nomor darurat
        Expanded(
          child: state.numbers.isEmpty
              ? const Center(
                  child: Text(
                    'Tidak ada nomor darurat\nuntuk kota ini',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24.0, vertical: 8.0),
                  itemCount: state.numbers.length,
                  itemBuilder: (context, index) {
                    final item = state.numbers[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16.0),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          )
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.serviceName,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[700],
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  item.number,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1A1A2E),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              final Uri url = Uri.parse('tel:${item.number}');
                              try {
                                final success = await launchUrl(url,
                                    mode: LaunchMode.externalApplication);
                                if (!success && context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            'Tidak dapat membuka aplikasi telepon')),
                                  );
                                }
                              } catch (e) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            'Terjadi kesalahan saat membuka aplikasi telepon')),
                                  );
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFE5F0FA),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 12),
                            ),
                            child: const Text(
                              "Hubungi",
                              style: TextStyle(
                                color: Color(0xFF016ACC),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  void _showLocationBottomSheet(BuildContext parentContext, EmergencyLoaded state) {
    showModalBottomSheet(
      context: parentContext,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.only(top: 12, left: 24, right: 24, bottom: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const Text(
                'Pilih Kota / Kabupaten',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A2E),
                ),
              ),
              const SizedBox(height: 16),

              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    // Opsi "Semua Kota"
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        'Semua Kota',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: state.selectedKabKotaId == null
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: state.selectedKabKotaId == null
                              ? const Color(0xFF016ACC)
                              : const Color(0xFF1A1A2E),
                        ),
                      ),
                      trailing: state.selectedKabKotaId == null
                          ? const Icon(Icons.check, color: Color(0xFF016ACC))
                          : null,
                      onTap: () {
                        Navigator.pop(ctx);
                        parentContext.read<EmergencyBloc>().add(
                              const SelectCity(
                                kabKotaId: null,
                                kabKotaNama: 'Semua Kota',
                              ),
                            );
                      },
                    ),
                    const Divider(height: 1),

                    // Daftar kab/kota dari API
                    if (state.kabKotaList.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        child: Center(child: Text('Memuat daftar kota...')),
                      )
                    else
                      ...state.kabKotaList.asMap().entries.map((entry) {
                        final kota = entry.value;
                        final isSelected = state.selectedKabKotaId == kota.id;
                        return Column(
                          children: [
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text(
                                kota.nama,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  color: isSelected
                                      ? const Color(0xFF016ACC)
                                      : const Color(0xFF1A1A2E),
                                ),
                              ),
                              trailing: isSelected
                                  ? const Icon(Icons.check,
                                      color: Color(0xFF016ACC))
                                  : null,
                              onTap: () {
                                Navigator.pop(ctx);
                                parentContext.read<EmergencyBloc>().add(
                                      SelectCity(
                                        kabKotaId: kota.id,
                                        kabKotaNama: kota.nama,
                                      ),
                                    );
                              },
                            ),
                            const Divider(height: 1),
                          ],
                        );
                      }),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
