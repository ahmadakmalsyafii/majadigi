import 'package:flutter/material.dart';
import 'package:majadigi/features/beranda/domain/entity/service_entity.dart';

class TentangTabView extends StatelessWidget {
  final ServiceEntity service;
  const TentangTabView({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      children: [
        _buildAboutCard(),
        _buildOperationalCard(context),
        _buildTermsAndConditionsCard(),
      ],
    );
  }

  Widget _buildAboutCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: EdgeInsetsGeometry.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: ExpansionTile(
        shape: Border.all(style: BorderStyle.none),
        backgroundColor: Colors.white,
        collapsedBackgroundColor: Colors.white,
        expansionAnimationStyle: AnimationStyle(
          curve: Curves.easeInOut,
          duration: const Duration(milliseconds: 400),
        ),

        title: Text(
          "Tentang Layanan",
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        tilePadding: EdgeInsetsGeometry.all(16),
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  service.about,
                  style: const TextStyle(fontSize: 14, color: Colors.black54),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOperationalCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: EdgeInsetsGeometry.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: ExpansionTile(
        shape: Border.all(style: BorderStyle.none),
        backgroundColor: Colors.white,
        collapsedBackgroundColor: Colors.white,
        expansionAnimationStyle: AnimationStyle(
          curve: Curves.easeInOut,
          duration: const Duration(milliseconds: 400),
        ),
        title: const Text(
          "Operasional",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        tilePadding: EdgeInsetsGeometry.all(16),
        children: [
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (service.websiteUrl.isNotEmpty) ...[
                  const Text(
                    "Link Layanan",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    service.websiteUrl,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                if (service.address.isNotEmpty) ...[
                  const Text(
                    "Alamat",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    service.address,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                if (service.operationalHours.isNotEmpty) ...[
                  const Text(
                    "Jam Operasional",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 16,
                    runSpacing: 8,
                    children: service.operationalHours.map((schedule) {
                      final hari = schedule.hari;
                      final buka = schedule.buka;
                      final tutup = schedule.tutup;
                      final ket = schedule.keterangan;
                      
                      String jamText = '';
                      if (buka != null && tutup != null && buka.isNotEmpty && tutup.isNotEmpty) {
                        jamText = '($buka - $tutup)';
                      } else if (ket != null && ket.isNotEmpty) {
                        jamText = '($ket)';
                      }
                      
                      // Capitalize first letter of hari
                      String capitalize(String s) => s.isNotEmpty ? '${s[0].toUpperCase()}${s.substring(1)}' : s;

                      return SizedBox(
                        width: MediaQuery.of(context).size.width / 2 - 48,
                        child: Text(
                          "${capitalize(hari)} $jamText".trim(),
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTermsAndConditionsCard() {
    final ketentuan = service.ketentuanLayanan;
    if (ketentuan == null) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: EdgeInsetsGeometry.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: ExpansionTile(
        shape: Border.all(style: BorderStyle.none),
        backgroundColor: Colors.white,
        collapsedBackgroundColor: Colors.white,
        expansionAnimationStyle: AnimationStyle(
          curve: Curves.easeInOut,
          duration: const Duration(milliseconds: 400),
        ),
        title: const Text(
          "Ketentuan Layanan",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        tilePadding: EdgeInsetsGeometry.all(16),
        children: [
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (ketentuan.manfaat.isNotEmpty) ...[
                  const Text(
                    "Manfaat",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: ketentuan.manfaat
                          .map((m) => Padding(
                                padding: const EdgeInsets.only(bottom: 6),
                                child: Text(
                                  m,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black54,
                                    height: 1.4,
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                if (ketentuan.sistemMekanismeProsedur.isNotEmpty) ...[
                  const Text(
                    "Sistem, Mekanisme, dan Prosedur",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: ketentuan.sistemMekanismeProsedur
                          .map((s) => Padding(
                                padding: const EdgeInsets.only(bottom: 6),
                                child: Text(
                                  s,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black54,
                                    height: 1.4,
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
