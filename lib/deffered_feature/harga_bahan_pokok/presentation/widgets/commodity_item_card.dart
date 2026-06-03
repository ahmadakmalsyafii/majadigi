import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:majadigi/deffered_feature/harga_bahan_pokok/domain/entities/commodity_entity.dart';

class CommodityItemCard extends StatelessWidget {
  final CommodityItemEntity item;
  final VoidCallback onTap;

  const CommodityItemCard({super.key, required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final formatCurrency = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    
    // Determine color and icon for diff
    Color diffColor = Colors.black;
    IconData? diffIcon;
    if (item.diff > 0) {
      diffColor = Colors.red;
      diffIcon = Icons.arrow_upward;
    } else if (item.diff < 0) {
      diffColor = Colors.green;
      diffIcon = Icons.arrow_downward;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Image placeholder
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey.shade100,
              ),
              child: item.image.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        item.image,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => const Icon(Icons.shopping_bag, color: Colors.grey),
                      ),
                    )
                  : const Icon(Icons.shopping_bag, color: Colors.grey),
            ),
            const SizedBox(width: 16),
            // Title and unit
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.commodityName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'per ${item.commodityUnit}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            // Price and Diff
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  formatCurrency.format(item.price),
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                item.diff == 0
                    ? const Text(
                        'Stabil',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      )
                    : Row(
                        children: [
                          Icon(diffIcon, color: diffColor, size: 12),
                          const SizedBox(width: 2),
                          Text(
                            item.diffPercent.replaceAll('-', ''), // remove minus sign
                            style: TextStyle(
                              fontSize: 12,
                              color: diffColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
