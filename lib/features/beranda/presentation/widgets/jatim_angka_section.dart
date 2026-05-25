import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:majadigi/features/beranda/domain/entity/jatim_angka_entity.dart';

class JatimAngkaSection extends StatelessWidget {
  final List<JatimAngkaEntity> jatimAngkaList;

  const JatimAngkaSection({super.key, required this.jatimAngkaList});

  @override
  Widget build(BuildContext context) {
    if (jatimAngkaList.isEmpty) return const SizedBox.shrink();

    final formatCurrency = NumberFormat.decimalPattern('id');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 16.0),
          child: Text(
            'Jawa Timur Dalam Angka',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Column(
              children: [
                // Header Biru
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20.0),
                  color: const Color(0xFF003B8C),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Data Terkini',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        // Anda bisa mengganti ini dengan data dinamis dari entity jika ada
                        'Update: February 2026',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ),

                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 24.0),
                  child: IntrinsicHeight(
                    child: Row(
                      children: _buildRowItems(formatCurrency),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildRowItems(NumberFormat formatCurrency) {
    List<Widget> widgets = [];
    int count = jatimAngkaList.length > 3 ? 3 : jatimAngkaList.length;

    for (int i = 0; i < count; i++) {
      final item = jatimAngkaList[i];
      widgets.add(
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${formatCurrency.format(item.jumlah)} ${item.satuan ?? ''}'.trim(),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  item.nama,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      );

      // Menambahkan garis vertikal di antara item (kecuali item terakhir)
      if (i < count - 1) {
        widgets.add(
          VerticalDivider(
            color: Colors.grey.shade300,
            thickness: 1,
            width: 1,
          ),
        );
      }
    }

    return widgets;
  }
}