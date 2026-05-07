import 'package:flutter/material.dart';
import 'package:majadigi/features/beranda/domain/entitiy/jatim_angka_entity.dart';
import 'package:intl/intl.dart';

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
            'Jatim Angka',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.5,
          ),
          itemCount: jatimAngkaList.length,
          itemBuilder: (context, index) {
            final item = jatimAngkaList[index];
            return Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Image.network(
                        item.icon,
                        width: 24,
                        height: 24,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.bar_chart, size: 24, color: Colors.blue),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          item.nama,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade700,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Text(
                    '${formatCurrency.format(item.jumlah)} ${item.satuan ?? ''}'.trim(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Tahun ${item.tahun}',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
