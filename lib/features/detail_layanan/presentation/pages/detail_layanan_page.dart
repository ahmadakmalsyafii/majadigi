import 'package:flutter/material.dart';
import 'package:majadigi/features/beranda/domain/entity/service_entity.dart';
import 'package:go_router/go_router.dart';
import 'package:majadigi/features/detail_layanan/presentation/widgets/layanan_tab_view.dart';
import 'package:majadigi/features/detail_layanan/presentation/widgets/tentang_tab_view.dart';

class DetailLayananPage extends StatefulWidget {
  final ServiceEntity service;

  const DetailLayananPage({super.key, required this.service});

  @override
  State<DetailLayananPage> createState() => _DetailLayananPageState();
}

class _DetailLayananPageState extends State<DetailLayananPage>
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
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xFF0048B5),
            ),
            padding: EdgeInsets.only(top: 24, left: 24, right: 24, bottom: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () => context.pop(),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        'Kembali',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  widget.service.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.service.address.isNotEmpty
                      ? widget.service.address
                      : widget.service.description,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
                const SizedBox(height: 24),
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
                padding: EdgeInsetsGeometry.all(8),
                dividerColor: Colors.transparent,
                indicator: BoxDecoration(
                  color: Color(0xFF0065FF),
                  borderRadius: BorderRadius.circular(10),
                ),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.black87,
                labelStyle: const TextStyle(fontWeight: FontWeight.normal),
                tabs: const [
                  Tab(text: 'Tentang'),
                  Tab(text: 'Layanan'),
                ],
              ),
            ),
          ),

          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                TentangTabView(service: widget.service),
                LayananTabView(service: widget.service),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
