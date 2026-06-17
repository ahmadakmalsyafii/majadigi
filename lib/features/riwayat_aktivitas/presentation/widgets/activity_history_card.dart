import 'package:flutter/material.dart';
import '../../domain/entities/activity_history_entity.dart';

class ActivityHistoryCard extends StatelessWidget {
  final ActivityHistoryEntity history;
  final VoidCallback onTap;

  const ActivityHistoryCard({
    super.key,
    required this.history,
    required this.onTap,
  });

  IconData _getIconForType(String type) {
    switch (type) {
      case 'islamic_center':
        return Icons.nights_stay_outlined;
      case 'destinasi_wisata':
        return Icons.map_outlined;
      case 'rsud':
        return Icons.local_hospital_outlined;
      default:
        return Icons.receipt_long_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade300),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              _getIconForType(history.type),
              color: Colors.blueGrey.shade700,
              size: 24,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                history.title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
