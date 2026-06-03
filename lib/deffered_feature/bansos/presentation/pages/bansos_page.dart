import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:majadigi/core/di/di.dart';
import 'package:majadigi/core/widgets/custom_header.dart';
import 'package:majadigi/deffered_feature/bansos/domain/entity/bansos_entity.dart';
import 'package:majadigi/deffered_feature/bansos/presentation/bloc/bansos_bloc.dart';
import 'package:majadigi/deffered_feature/bansos/presentation/bloc/bansos_event.dart';
import 'package:majadigi/deffered_feature/bansos/presentation/bloc/bansos_state.dart';
import 'package:majadigi/core/feature_manager/presentation/bloc/feature_manager_bloc.dart';
import 'package:majadigi/core/feature_manager/presentation/bloc/feature_manager_event.dart';

class BansosPage extends StatefulWidget {
  const BansosPage({super.key});

  @override
  State<BansosPage> createState() => _BansosPageState();
}

class _BansosPageState extends State<BansosPage> {
  late BansosBloc _bansosBloc;
  final TextEditingController _nikController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _bansosBloc = sl<BansosBloc>();
  }

  @override
  void dispose() {
    _nikController.dispose();
    _bansosBloc.close();
    super.dispose();
  }

  void _searchBansos() {
    final nik = _nikController.text.trim();
    if (nik.isNotEmpty) {
      _bansosBloc.add(SearchBansosEvent(nik));
    }
  }

  void _clearForm() {
    _nikController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _bansosBloc,
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        body: Column(
          children: [
            CustomHeader(
              title: 'Bantuan Sosial',
              subtitle: 'Program bansos aktif dari Pemprov Jawa Timur',
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
                              sl<FeatureManagerBloc>().add(const UninstallFeatureEvent('bansos'));
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.delete_outline, color: Colors.white, size: 16),
                      SizedBox(width: 4),
                      Text('Hapus', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'NIK',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _nikController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              fillColor: Colors.white,
                              hintText: 'e.g 351512461064',
                              hintStyle: TextStyle(color: Colors.grey.shade400),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade300,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade300,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: Colors.blue,
                                ),
                              ),
                              suffixIcon: IconButton(
                                icon: const Icon(
                                  Icons.cancel,
                                  color: Colors.grey,
                                ),
                                onPressed: () {
                                  _nikController.clear();
                                },
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: _searchBansos,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF016ACC),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 20,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Cek',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    BlocBuilder<BansosBloc, BansosState>(
                      builder: (context, state) {
                        if (state is BansosInitial) {
                          return const SizedBox.shrink();
                        } else if (state is BansosLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (state is BansosLoaded) {
                          return _buildSuccessWidget(state.bansos);
                        } else if (state is BansosNotFound) {
                          return _buildNotFoundWidget();
                        } else if (state is BansosError) {
                          return Center(
                            child: Text(
                              state.message,
                              style: const TextStyle(color: Colors.red),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuccessWidget(BansosEntity bansos) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Status',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.check, color: Colors.green),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Terdaftar sebagai Penerima Bansos',
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Data Terakhir : ${bansos.lastUpdated}',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              _buildDetailItem('Nama', bansos.name),
              _buildDivider(),
              _buildDetailItem('NIK', bansos.nik),
              _buildDivider(),
              _buildDetailItem('Kabupaten/Kota', bansos.city),
              _buildDivider(),
              _buildDetailItem('Kategori', bansos.category),
              _buildDivider(),
              _buildDetailItem('Total Bantuan/Tahun', bansos.totalBantuan),
              _buildDivider(),
              _buildDetailItem('Pencairan Terakhir', bansos.pencairanTerakhir),
              _buildDivider(),
              _buildDetailItem(
                'Pencairan Berikutnya',
                bansos.pencairanBerikutnya,
              ),
              _buildDivider(),
              _buildDetailItem('No Rekening Penerima', bansos.bankNumber),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNotFoundWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Status',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFFFEBEE),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Row(
            children: [
              Icon(Icons.close, color: Colors.red),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Anda Belum Terdaftar sebagai Penerima Bantuan Sosial',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetailItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              title,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(height: 1, color: Color(0xFFEEEEEE));
  }
}
