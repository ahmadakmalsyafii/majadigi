import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:majadigi/core/di/di.dart';
import 'package:majadigi/deffered_feature/jadwal_operasi/domain/entity/jadwal_operasi_entity.dart';
import 'package:majadigi/deffered_feature/jadwal_operasi/presentation/bloc/jadwal_operasi_bloc.dart';
import 'package:majadigi/deffered_feature/jadwal_operasi/presentation/bloc/jadwal_operasi_event.dart';
import 'package:majadigi/deffered_feature/jadwal_operasi/presentation/bloc/jadwal_operasi_state.dart';

class JadwalOperasiPage extends StatelessWidget {
  const JadwalOperasiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<JadwalOperasiBloc>()..add(const FetchJadwalOperasiEvent()),
      child: const _JadwalOperasiView(),
    );
  }
}

class _JadwalOperasiView extends StatefulWidget {
  const _JadwalOperasiView();

  @override
  State<_JadwalOperasiView> createState() => _JadwalOperasiViewState();
}

class _JadwalOperasiViewState extends State<_JadwalOperasiView> {
  final TextEditingController _searchController = TextEditingController();
  DateTime? _selectedDate;

  void _onCekJadwal() {
    String? dateStr;
    if (_selectedDate != null) {
      dateStr = DateFormat('yyyy-MM-dd').format(_selectedDate!);
    }
    
    context.read<JadwalOperasiBloc>().add(FetchJadwalOperasiEvent(
      date: dateStr,
      surgeryName: _searchController.text.trim().isNotEmpty ? _searchController.text.trim() : null,
    ));
  }

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSummaryCards(),
                  const SizedBox(height: 24),
                  _buildFilterForm(),
                  const SizedBox(height: 32),
                  _buildSubmitButton(),
                  const SizedBox(height: 32),
                  _buildResultList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFF016ACC),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Row(
                  children: [
                    Icon(Icons.arrow_back_ios, color: Colors.white, size: 16),
                    SizedBox(width: 4),
                    Text('Kembali', style: TextStyle(color: Colors.white, fontSize: 14)),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Jadwal Operasi',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCards() {
    return BlocBuilder<JadwalOperasiBloc, JadwalOperasiState>(
      builder: (context, state) {
        final summary = state.data?.summary;
        return Row(
          children: [
            Expanded(
              child: _buildSingleCard('Total Operasi', summary?.total.toString() ?? '0', const Color(0xFF2ECC71)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildSingleCard('Terjadwal', summary?.scheduled.toString() ?? '0', const Color(0xFF2ECC71)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildSingleCard('Selesai', summary?.done.toString() ?? '0', const Color(0xFF2ECC71)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSingleCard(String title, String value, Color valueColor) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFEAFAF1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: valueColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Nama Operasi',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1A1A2E)),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Cari nama operasi...',
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Tanggal',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1A1A2E)),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: _pickDate,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _selectedDate == null ? 'dd/mm/yyyy' : DateFormat('dd/MM/yyyy').format(_selectedDate!),
                  style: TextStyle(
                    color: _selectedDate == null ? Colors.grey : Colors.black87,
                    fontSize: 16,
                  ),
                ),
                const Icon(Icons.calendar_today_outlined, color: Colors.grey),
              ],
            ),
          ),
        ),
        if (_selectedDate != null)
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                setState(() => _selectedDate = null);
              },
              child: const Text('Hapus Tanggal', style: TextStyle(color: Colors.red)),
            ),
          ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return BlocBuilder<JadwalOperasiBloc, JadwalOperasiState>(
      builder: (context, state) {
        return SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: state.isLoading ? null : _onCekJadwal,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF016ACC),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: state.isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                  )
                : const Text(
                    'Cek Jadwal',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
          ),
        );
      },
    );
  }

  Widget _buildResultList() {
    return BlocBuilder<JadwalOperasiBloc, JadwalOperasiState>(
      builder: (context, state) {
        if (state.isLoading) return const SizedBox.shrink();
        if (state.errorMessage != null) {
          return Center(child: Text(state.errorMessage!, style: const TextStyle(color: Colors.red)));
        }
        
        final schedules = state.data?.schedules;
        if (schedules == null || schedules.isEmpty) {
          return const Center(child: Text('Tidak ada jadwal operasi.'));
        }

        // Count total individual operations
        int totalOps = 0;
        for (var date in schedules) {
          totalOps += date.schedules.length;
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$totalOps Operasi',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...schedules.map((tanggalOperasi) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      tanggalOperasi.date,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey),
                    ),
                  ),
                  ...tanggalOperasi.schedules.map((op) => _buildOperasiCard(op)).toList(),
                ],
              );
            }).toList(),
          ],
        );
      },
    );
  }

  Widget _buildOperasiCard(DetailOperasiEntity op) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            op.surgeryName,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1A1A2E)),
          ),
          const SizedBox(height: 4),
          Text(
            op.doctorName,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 4),
          Text(
            op.poliName,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF016ACC)),
          ),
        ],
      ),
    );
  }
}
