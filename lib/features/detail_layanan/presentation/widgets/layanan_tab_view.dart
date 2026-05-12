import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:majadigi/features/beranda/domain/entity/service_entity.dart';

class LayananTabView extends StatefulWidget {
  final ServiceEntity service;
  const LayananTabView({super.key, required this.service});

  @override
  State<LayananTabView> createState() => _LayananTabViewState();
}

class _LayananTabViewState extends State<LayananTabView> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      children: [
        const Text(
          'Layanan yang tersedia',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.2,
          ),
          itemCount: widget.service.features.isNotEmpty
              ? widget.service.features.length
              : 2,
          itemBuilder: (context, index) {
            String featureName = '';
            IconData icon = Icons.apps;
            Color iconColor = Colors.blue;

            if (widget.service.features.isNotEmpty) {
              featureName = widget.service.features[index].judul;
              icon = Icons.local_hospital;
              iconColor = Colors.blue;
            } else {
              if (index == 0) {
                featureName = 'Ketersediaan Kamar';
                icon = Icons.bed;
                iconColor = Colors.blue;
              } else {
                featureName = 'Daftar Pasien';
                icon = Icons.person_add_alt_1;
                iconColor = Colors.orange;
              }
            }

            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    featureName,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Icon(icon, color: iconColor, size: 28),
                ],
              ),
            );
          },
        ),
      ],
    );
    ;
  }
}
