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
        _buildOperationalScheduleCard(),
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

  Widget _buildOperationalScheduleCard() {
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
          "Jadwal Layanan",
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
              children: [
                Text(
                  service.websiteUrl,
                  style: const TextStyle(fontSize: 14, color: Colors.black54),
                ),
                Text(service.address),
                // ListView.builder(itemBuilder: (context, index) {
                //   final schedule = service.operationalHours;
                //   return Text(
                //     "${schedule.hari}: ${schedule.buka} - ${schedule.tutup}",
                //     style: const TextStyle(fontSize: 14, color: Colors.black54),
                //   );
                // },
                // shrinkWrap: true,)
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTermsAndConditionsCard() {
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
          "Ketentuan Layanan",
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
                  service.icon,
                  style: const TextStyle(fontSize: 14, color: Colors.black54),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
