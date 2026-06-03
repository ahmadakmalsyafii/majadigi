import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:majadigi/core/widgets/custom_header.dart';
import 'package:intl/intl.dart';
import 'package:majadigi/core/di/di.dart';
import 'package:majadigi/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:majadigi/features/auth/presentation/bloc/auth_state.dart';
import 'package:majadigi/features/auth/domain/entity/user_entity.dart';
import 'package:majadigi/features/beranda/domain/entity/service_entity.dart';
import 'package:majadigi/deffered_feature/pendaftaran_pasien/domain/entity/pendaftaran_poli_entity.dart';
import 'package:majadigi/deffered_feature/pendaftaran_pasien/domain/entity/pendaftaran_dokter_entity.dart';
import 'package:majadigi/deffered_feature/pendaftaran_pasien/presentation/bloc/pendaftaran_bloc.dart';
import 'package:majadigi/deffered_feature/pendaftaran_pasien/presentation/bloc/pendaftaran_event.dart';
import 'package:majadigi/deffered_feature/pendaftaran_pasien/presentation/bloc/pendaftaran_state.dart';
import 'package:majadigi/core/feature_manager/presentation/bloc/feature_manager_bloc.dart';
import 'package:majadigi/core/feature_manager/presentation/bloc/feature_manager_event.dart';

class PendaftaranPasienPage extends StatelessWidget {
  final ServiceEntity service;
  const PendaftaranPasienPage({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<PendaftaranBloc>()..add(LoadPolisEvent(service.id)),
      child: _PendaftaranPasienView(service: service),
    );
  }
}

class _PendaftaranPasienView extends StatefulWidget {
  final ServiceEntity service;
  const _PendaftaranPasienView({required this.service});

  @override
  State<_PendaftaranPasienView> createState() => _PendaftaranPasienViewState();
}

class _PendaftaranPasienViewState extends State<_PendaftaranPasienView> {
  String _searchQuery = '';
  late final List<DateTime> _generatedDates;

  @override
  void initState() {
    super.initState();
    _generatedDates = _generateDates();
  }

  List<DateTime> _generateDates() {
    final List<DateTime> list = [];
    DateTime date = DateTime.now();
    for (int i = 0; i < 5; i++) {
      list.add(date);
      date = date.add(const Duration(days: 1));
    }
    return list;
  }


  bool _isTimeSlotPassed(DateTime? selectedDate, String timeSlot) {
    if (selectedDate == null) return false;

    final now = DateTime.now();
    final isToday = selectedDate.year == now.year &&
        selectedDate.month == now.month &&
        selectedDate.day == now.day;

    if (!isToday) return false;

    try {
      final parts = timeSlot.split('-');
      if (parts.isEmpty) return false;

      final startTimeStr = parts[0].trim();
      final timeParts = startTimeStr.split(':');
      if (timeParts.length < 2) return false;

      final startHour = int.parse(timeParts[0]);
      final startMinute = int.parse(timeParts[1]);

      if (now.hour > startHour) {
        return true;
      } else if (now.hour == startHour) {
        return now.minute >= startMinute;
      }
    } catch (e) {
      debugPrint("Error parsing time slot: $e");
    }
    return false;
  }

  bool _isDoctorAllTimesPassedToday(List<String> availableTimes) {
    final now = DateTime.now();
    return availableTimes.every((time) {
      try {
        final parts = time.split('-');
        if (parts.isEmpty) return false;
        final startTimeStr = parts[0].trim();
        final timeParts = startTimeStr.split(':');
        if (timeParts.length < 2) return false;
        final startHour = int.parse(timeParts[0]);
        final startMinute = int.parse(timeParts[1]);

        if (now.hour > startHour) return true;
        if (now.hour == startHour) return now.minute >= startMinute;
      } catch (e) {
        debugPrint("Error parsing time: $e");
      }
      return false;
    });
  }

  String _buildQrPayload(dynamic ticket) {
    return 'TIKET PENDAFTARAN PASIEN MAJADIGI\n'
        'No. Antrean: ${ticket.queueNumber}\n'
        'Nama Pasien: ${ticket.patientName}\n'
        'NIK: ${ticket.patientNIK}\n'
        'Rumah Sakit: ${ticket.hospitalName}\n'
        'Poliklinik: ${ticket.poliName}\n'
        'Dokter: ${ticket.doctorName}\n'
        'Tanggal: ${ticket.date}\n'
        'Waktu: ${ticket.time}\n'
        'ID Registrasi: ${ticket.id}';
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    UserEntity? currentUser;
    if (authState is AuthAuthenticated) {
      currentUser = authState.user;
    }

    return BlocConsumer<PendaftaranBloc, PendaftaranState>(
      listener: (context, state) {
        if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage!)),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: const Color(0xFFF5F5F5),
          body: Column(
            children: [
              CustomHeader(
                title: 'Pendaftaran Pasien',
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
                                sl<FeatureManagerBloc>().add(const UninstallFeatureEvent('pendaftaran_pasien'));
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
                onBackPressed: () {
                  if (state.currentStep == 3) {
                    Navigator.pop(context);
                  } else if (state.currentStep > 0) {
                    context.read<PendaftaranBloc>().add(PrevStepEvent());
                  } else {
                    Navigator.pop(context);
                  }
                },
              ),
              _buildStepIndicator(context, state),
              Expanded(
                child: state.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: _buildCurrentStepContent(context, state),
                      ),
              ),
            ],
          ),
          bottomNavigationBar: state.currentStep < 3 ? _buildBottomBar(context, state, currentUser) : null,
        );
      },
    );
  }



  Widget _buildStepIndicator(BuildContext context, PendaftaranState state) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _stepItem(state, 0, 'Poli'),
              _stepLine(state, 0),
              _stepItem(state, 1, 'Dokter'),
              _stepLine(state, 1),
              _stepItem(state, 2, 'Jadwal'),
              _stepLine(state, 2),
              _stepItem(state, 3, 'Tiket'),
            ],
          ),
          if (state.currentStep == 2) ...[
            const SizedBox(height: 20),
            _buildDateSelector(context, state),
          ]
        ],
      ),
    );
  }

  Widget _stepItem(PendaftaranState state, int stepIndex, String title) {
    final isActive = state.currentStep >= stepIndex;
    final isCurrent = state.currentStep == stepIndex;
    return Column(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFF016ACC) : Colors.grey.shade300,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(
            '${stepIndex + 1}',
            style: TextStyle(
              color: isActive ? Colors.white : Colors.grey.shade600,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: TextStyle(
            color: isActive ? const Color(0xFF016ACC) : Colors.grey.shade600,
            fontSize: 12,
            fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _stepLine(PendaftaranState state, int stepIndex) {
    final isActive = state.currentStep > stepIndex;
    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.symmetric(horizontal: 4).copyWith(bottom: 20),
        color: isActive ? const Color(0xFF016ACC) : Colors.grey.shade300,
      ),
    );
  }

  Widget _buildDateSelector(BuildContext context, PendaftaranState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Pilih Tanggal',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF1A1A2E)),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 70,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _generatedDates.length,
            itemBuilder: (context, index) {
              final date = _generatedDates[index];
              final isSelected = state.selectedDate != null &&
                  state.selectedDate!.year == date.year &&
                  state.selectedDate!.month == date.month &&
                  state.selectedDate!.day == date.day;

              final hari = DateFormat('EEEE', 'id_ID').format(date);
              final tanggal = DateFormat('d', 'id_ID').format(date);
              final bulan = DateFormat('MMM', 'id_ID').format(date);

              return GestureDetector(
                onTap: () => context.read<PendaftaranBloc>().add(SelectDateEvent(date)),
                child: Container(
                  width: 70,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF016ACC) : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: isSelected ? const Color(0xFF016ACC) : Colors.grey.shade300),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        hari,
                        style: TextStyle(
                          color: isSelected ? Colors.white70 : Colors.grey.shade600,
                          fontSize: 10,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        tanggal,
                        style: TextStyle(
                          color: isSelected ? Colors.white : const Color(0xFF1A1A2E),
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        bulan,
                        style: TextStyle(
                          color: isSelected ? Colors.white70 : Colors.grey.shade600,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCurrentStepContent(BuildContext context, PendaftaranState state) {
    switch (state.currentStep) {
      case 0:
        return _buildStepPoli(context, state);
      case 1:
        return _buildStepDokter(context, state);
      case 2:
        return _buildStepJadwal(context, state);
      case 3:
        return _buildStepTiket(context, state);
      default:
        return const SizedBox.shrink();
    }
  }

  // ─── STEP 1: POLI ──────────────────────────────────────────────────────────
  Widget _buildStepPoli(BuildContext context, PendaftaranState state) {
    final filteredPolis = state.polis
        .where((p) => p.name.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: TextField(
            onChanged: (val) => setState(() => _searchQuery = val),
            decoration: InputDecoration(
              hintText: 'Cari Poliklinik...',
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF016ACC)),
              ),
            ),
          ),
        ),
        Expanded(
          child: filteredPolis.isEmpty
              ? const Center(child: Text('Poliklinik tidak ditemukan'))
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 20).copyWith(bottom: 20),
                  itemCount: filteredPolis.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final poli = filteredPolis[index];
                    final isSelected = state.selectedPoli?.id == poli.id;
                    return GestureDetector(
                      onTap: () {
                        context.read<PendaftaranBloc>().add(SelectPoliEvent(poli));
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFFE8F4FD) : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected ? const Color(0xFF016ACC) : Colors.grey.shade200,
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(poli.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                const SizedBox(height: 4),
                                Text('${poli.doctorsCount} Dokter tersedia', style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const Text('Kuota Total', style: TextStyle(color: Colors.grey, fontSize: 11)),
                                const SizedBox(height: 2),
                                Text('${poli.quota}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF016ACC))),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  // ─── STEP 2: DOKTER ────────────────────────────────────────────────────────
  Widget _buildStepDokter(BuildContext context, PendaftaranState state) {
    if (state.isLoadingDoctors) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.doctors.isEmpty) {
      return const Center(child: Text('Tidak ada dokter di poliklinik ini'));
    }

    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: state.doctors.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final doc = state.doctors[index];
        final isSelected = state.selectedDoctor?.id == doc.id;

        // Cek jika seluruh jadwal dokter hari ini sudah terlewat
        final allTimesPassed = _isDoctorAllTimesPassedToday(doc.availableTimes);
        final sisaKuota = allTimesPassed ? 0 : doc.kuota;

        return GestureDetector(
          onTap: () {
            context.read<PendaftaranBloc>().add(SelectDoctorEvent(doc));
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFFE8F4FD) : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? const Color(0xFF016ACC) : Colors.grey.shade200,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.grey.shade200,
                  child: const Icon(Icons.person, color: Colors.grey),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(doc.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                      Text(doc.spesialis, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                      const SizedBox(height: 12),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                          const SizedBox(width: 6),
                          Expanded(child: Text(doc.jadwal, style: const TextStyle(fontSize: 12, color: Colors.grey))),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(
                            Icons.people_outline, 
                            size: 16, 
                            color: sisaKuota == 0 ? Colors.red : Colors.green,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            sisaKuota == 0 
                                ? 'Kuota Hari Ini: Habis' 
                                : 'Sisa Kuota Hari ini: $sisaKuota', 
                            style: TextStyle(
                              fontSize: 12, 
                              fontWeight: FontWeight.bold, 
                              color: sisaKuota == 0 ? Colors.red : Colors.green,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ─── STEP 3: JADWAL ────────────────────────────────────────────────────────
  Widget _buildStepJadwal(BuildContext context, PendaftaranState state) {
    if (state.selectedDate == null) {
      return const Center(
        child: Text(
          'Silakan pilih tanggal di atas terlebih dahulu',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    final List<String> availableTimes = state.selectedDoctor?.availableTimes ?? [];

    if (availableTimes.isEmpty) {
      return const Center(
        child: Text('Tidak ada slot waktu yang tersedia untuk dokter ini'),
      );
    }

    if (state.isLoadingTimes) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text('Pilih Waktu', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 2.0,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: availableTimes.length,
          itemBuilder: (context, index) {
            final String time = availableTimes[index];
            final currentCount = state.timeRegistrationsCount[time] ?? 0;
            final remainingQuota = 5 - currentCount;
            final isQuotaFull = remainingQuota <= 0;
            final isPassed = _isTimeSlotPassed(state.selectedDate, time);
            final isFull = isQuotaFull || isPassed;
            final isSelected = state.selectedTime == time;

            return GestureDetector(
              onTap: isFull ? null : () => context.read<PendaftaranBloc>().add(SelectTimeEvent(time)),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isFull ? Colors.grey.shade100 : (isSelected ? const Color(0xFFE8F4FD) : Colors.white),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: isFull ? Colors.grey.shade200 : (isSelected ? const Color(0xFF016ACC) : Colors.grey.shade300)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      time,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isFull ? Colors.grey : (isSelected ? const Color(0xFF016ACC) : const Color(0xFF1A1A2E)),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isPassed
                          ? 'Terlewat'
                          : (isQuotaFull ? 'Penuh' : 'Sisa Kuota: $remainingQuota'),
                      style: TextStyle(
                        fontSize: 11,
                        color: isPassed
                            ? Colors.orange.shade700
                            : (isQuotaFull ? Colors.red : Colors.green),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  // ─── STEP 4: TIKET ─────────────────────────────────────────────────────────
  Widget _buildStepTiket(BuildContext context, PendaftaranState state) {
    if (state.registeredTicket == null) {
      return const Center(child: Text("Data tiket tidak ditemukan"));
    }

    final ticket = state.registeredTicket!;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Icon(Icons.check_circle, color: Color(0xFF2ECC71), size: 64),
            const SizedBox(height: 16),
            const Text(
              'Pendaftaran Berhasil!',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1A1A2E)),
            ),
            const SizedBox(height: 8),
            const Text(
              'Tunjukkan tiket ini kepada petugas saat Anda tiba di Rumah Sakit.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 32),

            // Tiket Card
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      color: Color(0xFF016ACC),
                      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'No. Antrean',
                          style: TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                        Text(
                          ticket.queueNumber,
                          style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        _ticketInfoRow('Nama Pasien', ticket.patientName),
                        const Divider(height: 30),
                        _ticketInfoRow('Poliklinik', ticket.poliName),
                        const Divider(height: 30),
                        _ticketInfoRow('Dokter', ticket.doctorName),
                        const Divider(height: 30),
                        Row(
                          children: [
                            Expanded(child: _ticketInfoRow('Tanggal', ticket.date)),
                            Expanded(child: _ticketInfoRow('Waktu', ticket.time)),
                          ],
                        ),
                        const SizedBox(height: 30),
                        // QR Code
                        Container(
                          width: 160,
                          height: 160,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: QrImageView(
                            data: _buildQrPayload(ticket),
                            version: QrVersions.auto,
                            size: 140.0,
                            gapless: false,
                            errorStateBuilder: (cxt, err) {
                              return const Center(
                                child: Text(
                                  "Gagal me-render QR Code",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 10),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text('Scan QR Code ini di mesin antrean', style: TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF016ACC),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                ),
                child: const Text('Kembali ke Beranda', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _ticketInfoRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(color: Color(0xFF1A1A2E), fontSize: 15, fontWeight: FontWeight.bold)),
      ],
    );
  }

  // ─── BOTTOM NAVIGATION BAR (Action Buttons) ────────────────────────────────
  Widget _buildBottomBar(BuildContext context, PendaftaranState state, UserEntity? user) {
    bool isNextEnabled = false;
    if (state.currentStep == 0) isNextEnabled = state.selectedPoli != null;
    if (state.currentStep == 1) isNextEnabled = state.selectedDoctor != null;
    if (state.currentStep == 2) isNextEnabled = state.selectedDate != null && state.selectedTime != null && !state.isSubmitting;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          height: 50,
          child: ElevatedButton(
            onPressed: isNextEnabled
                ? () {
                    if (state.currentStep == 2) {
                      if (user != null) {
                        context.read<PendaftaranBloc>().add(SubmitRegistrationEvent(
                              user: user,
                              hospitalName: widget.service.name,
                            ));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('User belum terautentikasi. Silakan login kembali.')),
                        );
                      }
                    } else {
                      context.read<PendaftaranBloc>().add(NextStepEvent());
                    }
                  }
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF016ACC),
              disabledBackgroundColor: Colors.grey.shade300,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            child: state.isSubmitting
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                  )
                : Text(
                    state.currentStep == 2 ? 'Konfirmasi Pendaftaran' : 'Lanjutkan',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isNextEnabled ? Colors.white : Colors.grey.shade500,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
