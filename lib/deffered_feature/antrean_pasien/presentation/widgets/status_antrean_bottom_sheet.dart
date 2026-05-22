import 'package:flutter/material.dart';
import 'package:majadigi/deffered_feature/antrean_pasien/domain/entity/antrean_entity.dart';

class StatusAntreanView extends StatelessWidget {
  final AntreanEntity antrean;

  const StatusAntreanView({super.key, required this.antrean});

  @override
  Widget build(BuildContext context) {
    final antreanSaatIni = antrean.total - antrean.served;
    final kapasitasTerisi = antrean.served;
    final kapasitasTotal = antrean.total;
    
    // Safety check for progress
    double progress = 0.0;
    if (kapasitasTotal > 0) {
      progress = kapasitasTerisi / kapasitasTotal;
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade200),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Status Kapasitas Antrian',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1A2E),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Kapasitas harian: ${antrean.total} pasien',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Total Antrian
          _buildStatusCard(
            title: 'Total Antrian',
            value: antrean.total.toString(),
            color: const Color(0xFF016ACC),
            bgColor: const Color(0xFFE8F4FD),
            icon: Icons.people_outline,
          ),
          const SizedBox(height: 16),

          // Antrian Telah Dilayani
          _buildStatusCard(
            title: 'Antrian Telah Dilayani',
            value: antrean.served.toString(),
            color: const Color(0xFF2ECC71),
            bgColor: const Color(0xFFEAFAF1),
            icon: Icons.assignment_turned_in_outlined,
          ),
          const SizedBox(height: 16),

          // Antrian Saat Ini
          _buildStatusCard(
            title: 'Antrian Saat Ini',
            value: antreanSaatIni.toString(),
            color: const Color(0xFFE67E22), // Orange
            bgColor: const Color(0xFFFDF2E9),
            icon: Icons.person_outline,
          ),
          const SizedBox(height: 24),

          // Progress Bar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Kapasitas Terisi',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1A1A2E),
                ),
              ),
              Text(
                '$kapasitasTerisi/$kapasitasTotal',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1A1A2E),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              backgroundColor: Colors.grey.shade200,
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF016ACC)),
            ),
          ),
          const SizedBox(height: 24),

          // Details Box
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FA),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _buildDetailItem('Tanggal Kunjungan', antrean.date),
                    ),
                    Expanded(
                      child: _buildDetailItem('Poli', antrean.polyclinic),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _buildDetailItem('Dokter', antrean.doctor),
                    ),
                    Expanded(
                      child: _buildDetailItem('Jam Praktik', antrean.time),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard({
    required String title,
    required String value,
    required Color color,
    required Color bgColor,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1A1A2E),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                value,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          Icon(
            icon,
            color: color,
            size: 32,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 13,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1A1A2E),
          ),
        ),
      ],
    );
  }
}
