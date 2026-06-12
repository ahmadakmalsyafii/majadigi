import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:majadigi/core/di/di.dart';
import 'package:majadigi/deffered_feature/harga_bahan_pokok/presentation/bloc/harga_bahan_pokok_bloc.dart';
import 'package:majadigi/deffered_feature/harga_bahan_pokok/presentation/bloc/harga_bahan_pokok_event.dart';
import 'package:majadigi/deffered_feature/harga_bahan_pokok/presentation/bloc/harga_bahan_pokok_state.dart';
import 'package:majadigi/deffered_feature/harga_bahan_pokok/presentation/widgets/harga_chart_widget.dart';
import 'package:majadigi/core/widgets/custom_header.dart';

class DetailHargaBahanPokokPage extends StatelessWidget {
  final int bpId;

  const DetailHargaBahanPokokPage({super.key, required this.bpId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<HargaBahanPokokBloc>()..add(FetchCommodityDetail(bpId)),
      child: const DetailHargaBahanPokokView(),
    );
  }
}

class DetailHargaBahanPokokView extends StatelessWidget {
  const DetailHargaBahanPokokView({super.key});

  @override
  Widget build(BuildContext context) {
    final formatCurrency = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: CustomScrollView(
        slivers: [
          // App Bar Area (Blue Background)
          SliverToBoxAdapter(
            child: Stack(
              children: [
                // Blue background header
                const CustomHeader(title: ''),

                // Content Card overlapping the header
                BlocBuilder<HargaBahanPokokBloc, HargaBahanPokokState>(
                  builder: (context, state) {
                    if (state is CommodityDetailLoading) {
                      return Container(
                        margin: const EdgeInsets.only(top: 100),
                        height: 200,
                        child: const Center(child: CircularProgressIndicator()),
                      );
                    } else if (state is CommodityDetailError) {
                      return Container(
                        margin: const EdgeInsets.only(top: 100),
                        height: 200,
                        child: Center(child: Text(state.message)),
                      );
                    } else if (state is CommodityDetailLoaded) {
                      final detail = state.detail;

                      Color diffColor = Colors.black;
                      IconData? diffIcon;
                      if (detail.diff > 0) {
                        diffColor = Colors.red;
                        diffIcon = Icons.arrow_upward;
                      } else if (detail.diff < 0) {
                        diffColor = Colors.green;
                        diffIcon = Icons.arrow_downward;
                      }

                      return Container(
                        margin: const EdgeInsets.only(
                          top: 100,
                          left: 16,
                          right: 16,
                        ),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
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
                          children: [
                            // Header info
                            Row(
                              children: [
                                Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: Colors.grey.shade100,
                                  ),
                                  child: detail.image.isNotEmpty
                                      ? ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          child: Image.network(
                                            detail.image,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) =>
                                                    const Icon(
                                                      Icons.shopping_bag,
                                                      color: Colors.grey,
                                                    ),
                                          ),
                                        )
                                      : const Icon(
                                          Icons.shopping_bag,
                                          color: Colors.grey,
                                        ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        detail.commodityName,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                      Text(
                                        'per ${detail.commodityUnit}',
                                        style: TextStyle(
                                          color: Colors.grey.shade600,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      formatCurrency.format(detail.price),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    detail.diff == 0
                                        ? const Text(
                                            'Stabil',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey,
                                            ),
                                          )
                                        : Row(
                                            children: [
                                              Icon(
                                                diffIcon,
                                                color: diffColor,
                                                size: 12,
                                              ),
                                              const SizedBox(width: 2),
                                              Text(
                                                detail.diffPercent.replaceAll(
                                                  '-',
                                                  '',
                                                ),
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
                            const SizedBox(height: 24),
                            // Min Max info
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Harga rata-rata tertinggi',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        detail.maxCity.kabkotaName,
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.grey.shade600,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Text(
                                            formatCurrency.format(
                                              detail.maxCity.avgPrice,
                                            ),
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Harga rata-rata terendah',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        detail.minCity.kabkotaName,
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.grey.shade600,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Text(
                                            formatCurrency.format(
                                              detail.minCity.avgPrice,
                                            ),
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ],
            ),
          ),

          // Chart Widget Area
          BlocBuilder<HargaBahanPokokBloc, HargaBahanPokokState>(
            builder: (context, state) {
              if (state is CommodityDetailLoaded) {
                return SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: HargaChartWidget(priceHistory: state.priceHistory),
                  ),
                );
              }
              return const SliverToBoxAdapter(child: SizedBox());
            },
          ),

          // Harga di Kab/Kota List
          BlocBuilder<HargaBahanPokokBloc, HargaBahanPokokState>(
            builder: (context, state) {
              if (state is CommodityDetailLoaded) {
                return SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Harga di Kab/Kota',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: state.cityPrices.length,
                          separatorBuilder: (context, index) =>
                              Divider(color: Colors.grey.shade200),
                          itemBuilder: (context, index) {
                            final cityPrice = state.cityPrices[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8.0,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      cityPrice.kabkotaName,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    formatCurrency.format(cityPrice.avgPrice),
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                );
              }
              return const SliverToBoxAdapter(child: SizedBox());
            },
          ),
        ],
      ),
    );
  }
}
