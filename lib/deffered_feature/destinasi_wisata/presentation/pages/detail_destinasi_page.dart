import 'package:flutter/material.dart';
import 'package:majadigi/core/widgets/custom_header.dart';
import 'package:majadigi/deffered_feature/destinasi_wisata/domain/entity/destination_entity.dart';
import 'package:majadigi/deffered_feature/destinasi_wisata/presentation/widgets/rute_tab_view.dart';
import 'package:majadigi/deffered_feature/destinasi_wisata/presentation/widgets/tentang_tab_view.dart';
import 'package:majadigi/deffered_feature/destinasi_wisata/presentation/pages/destinasi_booking_page.dart';

class DetailDestinasiPage extends StatefulWidget {
  final DestinationEntity destination;

  const DetailDestinasiPage({super.key, required this.destination});

  @override
  State<DetailDestinasiPage> createState() => _DetailDestinasiPageState();
}

class _DetailDestinasiPageState extends State<DetailDestinasiPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Column(
        children: [
          CustomHeader(
            title: widget.destination.name,
            subtitleWidget: Row(
              children: [
                const Icon(Icons.location_on_outlined, color: Colors.white, size: 16),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    widget.destination.locationSummary,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),

          // Custom TabBar
          Transform.translate(
            offset: const Offset(0, -24),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: TabBar(
                controller: _tabController,
                indicatorSize: TabBarIndicatorSize.tab,
                padding: const EdgeInsets.all(8),
                dividerColor: Colors.transparent,
                indicator: BoxDecoration(
                  color: const Color(0xFF0065FF),
                  borderRadius: BorderRadius.circular(10),
                ),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.black87,
                labelStyle: const TextStyle(fontWeight: FontWeight.normal),
                tabs: const [
                  Tab(text: 'Tentang'),
                  Tab(text: 'Rute'),
                ],
              ),
            ),
          ),

          // Tab Views
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                TentangTabView(destination: widget.destination),
                RuteTabView(destination: widget.destination),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(24),
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
        child: SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DestinasiBookingPage(
                    destination: widget.destination,
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0065FF),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Pesan Tiket',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
