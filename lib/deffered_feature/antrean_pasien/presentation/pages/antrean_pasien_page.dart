import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:majadigi/core/di/di.dart';
import 'package:majadigi/deffered_feature/antrean_pasien/domain/entity/dokter_entity.dart';
import 'package:majadigi/deffered_feature/antrean_pasien/domain/entity/poli_entity.dart';
import 'package:majadigi/deffered_feature/antrean_pasien/presentation/bloc/antrean_bloc.dart';
import 'package:majadigi/deffered_feature/antrean_pasien/presentation/bloc/antrean_event.dart';
import 'package:majadigi/deffered_feature/antrean_pasien/presentation/bloc/antrean_state.dart';
import 'package:majadigi/deffered_feature/antrean_pasien/presentation/widgets/status_antrean_bottom_sheet.dart';

class AntreanPasienPage extends StatelessWidget {
  const AntreanPasienPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AntreanBloc>()..add(FetchPoliEvent()),
      child: const _AntreanPasienView(),
    );
  }
}

class _AntreanPasienView extends StatelessWidget {
  const _AntreanPasienView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: BlocListener<AntreanBloc, AntreanState>(
        listenWhen: (previous, current) =>
            previous.isLoadingAntrean != current.isLoadingAntrean ||
            previous.antreanResult != current.antreanResult ||
            previous.errorMessage != current.errorMessage,
        listener: (context, state) {
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage!)),
            );
          }
        },
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildPoliDropdown(),
                    const SizedBox(height: 24),
                    _buildDokterDropdown(),
                    const SizedBox(height: 32),
                    _buildSubmitButton(context),
                    const SizedBox(height: 32),
                    BlocBuilder<AntreanBloc, AntreanState>(
                      buildWhen: (previous, current) =>
                          previous.antreanResult != current.antreanResult ||
                          previous.isLoadingAntrean != current.isLoadingAntrean ||
                          previous.selectedDokter != current.selectedDokter,
                      builder: (context, state) {
                        if (state.antreanResult != null && !state.isLoadingAntrean) {
                          return StatusAntreanView(antrean: state.antreanResult!);
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
                'Antrean Pasien',
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

  Widget _buildPoliDropdown() {
    return BlocBuilder<AntreanBloc, AntreanState>(
      buildWhen: (previous, current) =>
          previous.isLoadingPoli != current.isLoadingPoli ||
          previous.poliList != current.poliList ||
          previous.selectedPoli != current.selectedPoli,
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Poli',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A1A2E),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: state.isLoadingPoli
                  ? const Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Center(
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                    )
                  : DropdownButtonHideUnderline(
                      child: DropdownButton<PoliEntity>(
                        isExpanded: true,
                        hint: const Text('Pilih Poli'),
                        value: state.selectedPoli,
                        items: state.poliList.map((poli) {
                          return DropdownMenuItem<PoliEntity>(
                            value: poli,
                            child: Text(poli.label),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            context.read<AntreanBloc>().add(FetchDokterEvent(value));
                          }
                        },
                      ),
                    ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDokterDropdown() {
    return BlocBuilder<AntreanBloc, AntreanState>(
      buildWhen: (previous, current) =>
          previous.isLoadingDokter != current.isLoadingDokter ||
          previous.dokterList != current.dokterList ||
          previous.selectedDokter != current.selectedDokter ||
          previous.selectedPoli != current.selectedPoli,
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Pilih Dokter',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A1A2E),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: state.selectedPoli == null ? Colors.grey.shade100 : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: state.isLoadingDokter
                  ? const Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Center(
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                    )
                  : DropdownButtonHideUnderline(
                      child: DropdownButton<DokterEntity>(
                        isExpanded: true,
                        hint: Text(state.selectedPoli == null
                            ? 'Pilih Poli terlebih dahulu'
                            : 'Pilih Dokter'),
                        value: state.selectedDokter,
                        items: state.dokterList.map((dokter) {
                          return DropdownMenuItem<DokterEntity>(
                            value: dokter,
                            child: Text(dokter.label),
                          );
                        }).toList(),
                        onChanged: state.selectedPoli == null
                            ? null
                            : (value) {
                                if (value != null) {
                                  context.read<AntreanBloc>().add(SelectDokterEvent(value));
                                }
                              },
                      ),
                    ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return BlocBuilder<AntreanBloc, AntreanState>(
      builder: (context, state) {
        final isEnabled = state.selectedPoli != null && state.selectedDokter != null;

        return SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: isEnabled
                ? () {
                    context.read<AntreanBloc>().add(CekAntreanEvent());
                  }
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF016ACC),
              disabledBackgroundColor: Colors.grey.shade300,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: state.isLoadingAntrean
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : Text(
                    'Cek antrean',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isEnabled ? Colors.white : Colors.grey.shade600,
                    ),
                  ),
          ),
        );
      },
    );
  }
}
