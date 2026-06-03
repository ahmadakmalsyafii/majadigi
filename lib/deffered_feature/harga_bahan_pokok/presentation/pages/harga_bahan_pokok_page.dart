import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:majadigi/core/di/di.dart';
import 'package:majadigi/deffered_feature/harga_bahan_pokok/presentation/bloc/harga_bahan_pokok_bloc.dart';
import 'package:majadigi/deffered_feature/harga_bahan_pokok/presentation/bloc/harga_bahan_pokok_event.dart';
import 'package:majadigi/deffered_feature/harga_bahan_pokok/presentation/bloc/harga_bahan_pokok_state.dart';
import 'package:majadigi/deffered_feature/harga_bahan_pokok/presentation/widgets/commodity_item_card.dart';
import 'package:majadigi/core/widgets/custom_header.dart';
import 'package:majadigi/core/widgets/custom_search_bar.dart';
import 'package:majadigi/core/feature_manager/presentation/bloc/feature_manager_bloc.dart';
import 'package:majadigi/core/feature_manager/presentation/bloc/feature_manager_event.dart';

class HargaBahanPokokPage extends StatelessWidget {
  const HargaBahanPokokPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<HargaBahanPokokBloc>()..add(FetchCommodityList()),
      child: const HargaBahanPokokView(),
    );
  }
}

class HargaBahanPokokView extends StatefulWidget {
  const HargaBahanPokokView({super.key});

  @override
  State<HargaBahanPokokView> createState() => _HargaBahanPokokViewState();
}

class _HargaBahanPokokViewState extends State<HargaBahanPokokView> {
  final TextEditingController _searchController = TextEditingController();
  int visibleCount = 12;
  bool isLoadingMore = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    setState(() {
      visibleCount = 12;
    });
    context.read<HargaBahanPokokBloc>().add(
      FetchCommodityList(searchQuery: query),
    );
  }

  void _loadMore() async {
    if (isLoadingMore) return;
    setState(() {
      isLoadingMore = true;
    });
    await Future.delayed(const Duration(milliseconds: 800));
    if (mounted) {
      setState(() {
        visibleCount += 12;
        isLoadingMore = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (!isLoadingMore &&
              scrollInfo.metrics.pixels >=
                  scrollInfo.metrics.maxScrollExtent - 50) {
            _loadMore();
          }
          return false;
        },
        child: CustomScrollView(
          slivers: [
            // Custom App Bar Area
            SliverToBoxAdapter(
              child: Column(
                children: [
                  CustomHeader(
                    title: 'Harga Bahan Pokok',
                    subtitle: 'Data harga pasar hari ini',
                    trailing: InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Hapus Fitur'),
                              content: const Text('Apakah Anda yakin ingin menghapus fitur ini dari perangkat?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Batal'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    sl<FeatureManagerBloc>().add(const UninstallFeatureEvent('harga_bahan_pokok'));
                                    Navigator.pop(context);
                                    context.pop();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Fitur berhasil dihapus')),
                                    );
                                  },
                                  child: const Text('Ya'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.delete_outline, color: Colors.white, size: 16),
                            SizedBox(width: 4),
                            Text('Hapus', style: TextStyle(color: Colors.white, fontSize: 14)),
                          ],
                        ),
                      ),
                    ),
                  ),

                  Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: CustomSearchBar(
                      hintText: 'Cari layanan...',
                      onChanged: _onSearchChanged,
                    ),
                  ),
                ],
              ),
            ),

            // Last updated text
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Updated ${DateFormat('HH:mm, dd MMMM yyyy').format(DateTime.now())}',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'KOMODITAS',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          'HARGA',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),

            // List content
            BlocBuilder<HargaBahanPokokBloc, HargaBahanPokokState>(
              builder: (context, state) {
                if (state is CommodityListLoading) {
                  return const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  );
                } else if (state is CommodityListError) {
                  return SliverFillRemaining(
                    child: Center(child: Text(state.message)),
                  );
                } else if (state is CommodityListLoaded) {
                  final totalItems = state.commodities;
                  if (totalItems.isEmpty) {
                    return const SliverFillRemaining(
                      child: Center(child: Text('Tidak ada data.')),
                    );
                  }

                  final int currentCount = visibleCount < totalItems.length
                      ? visibleCount
                      : totalItems.length;
                  final bool hasMore = currentCount < totalItems.length;

                  return SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        if (index == currentCount) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 24.0),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Memuat...',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                        final item = totalItems[index];
                        return CommodityItemCard(
                          item: item,
                          onTap: () {
                            context.push(
                              '/detail-harga-bahan-pokok',
                              extra: item.bpId,
                            );
                          },
                        );
                      }, childCount: currentCount + (hasMore ? 1 : 0)),
                    ),
                  );
                }
                return const SliverFillRemaining(child: SizedBox());
              },
            ),

            const SliverPadding(padding: EdgeInsets.only(bottom: 24)),
          ],
        ),
      ),
    );
  }
}
