import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:majadigi/deffered_feature/harga_bahan_pokok/domain/entities/commodity_price_history_entity.dart';

class HargaChartWidget extends StatelessWidget {
  final List<PriceHistoryItemEntity> priceHistory;

  const HargaChartWidget({super.key, required this.priceHistory});

  @override
  Widget build(BuildContext context) {
    if (priceHistory.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(child: Text('Tidak ada data riwayat harga')),
      );
    }

    // Sort the history by date ascending just in case API returns descending
    final sortedHistory = List<PriceHistoryItemEntity>.from(priceHistory)
      ..sort((a, b) => a.date.compareTo(b.date));

    // Calculate min and max for Y-axis scaling
    double minPrice = sortedHistory.map((e) => e.price.toDouble()).reduce((a, b) => a < b ? a : b);
    double maxPrice = sortedHistory.map((e) => e.price.toDouble()).reduce((a, b) => a > b ? a : b);

    // Provide some padding to the chart
    final diff = maxPrice - minPrice;
    minPrice = diff == 0 ? minPrice - 1000 : minPrice - (diff * 0.2);
    maxPrice = diff == 0 ? maxPrice + 1000 : maxPrice + (diff * 0.2);

    List<FlSpot> spots = [];
    for (int i = 0; i < sortedHistory.length; i++) {
      spots.add(FlSpot(i.toDouble(), sortedHistory[i].price.toDouble()));
    }

    return Container(
      padding: const EdgeInsets.only(top: 16, right: 24, left: 16, bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Grafik Harga (30 Hari)',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 220,
            child: LineChart(
              LineChartData(
                minY: minPrice,
                maxY: maxPrice,
                minX: 0,
                maxX: (sortedHistory.length - 1).toDouble(),
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((LineBarSpot touchedSpot) {
                        final price = touchedSpot.y;
                        final dateStr = sortedHistory[touchedSpot.x.toInt()].date;
                        DateTime parsedDate;
                        try {
                          parsedDate = DateTime.parse(dateStr);
                        } catch(e) {
                          parsedDate = DateTime.now();
                        }
                        final formattedDate = DateFormat('dd MMM').format(parsedDate);
                        final formatCurrency = NumberFormat.currency(
                          locale: 'id_ID',
                          symbol: 'Rp ',
                          decimalDigits: 0,
                        );
                        
                        return LineTooltipItem(
                          '$formattedDate\n${formatCurrency.format(price)}',
                          const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        );
                      }).toList();
                    },
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: diff == 0 ? 1000 : (diff / 4).clamp(1, double.infinity),
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Colors.grey.shade200,
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: (sortedHistory.length / 5).ceil().toDouble().clamp(1, double.infinity),
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index < 0 || index >= sortedHistory.length) {
                          return const SizedBox.shrink();
                        }
                        final dateStr = sortedHistory[index].date;
                        DateTime parsedDate;
                        try {
                          parsedDate = DateTime.parse(dateStr);
                        } catch(e) {
                          return const SizedBox.shrink();
                        }
                        final text = DateFormat('dd MMM').format(parsedDate);
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            text,
                            style: const TextStyle(color: Colors.grey, fontSize: 10),
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 45,
                      getTitlesWidget: (value, meta) {
                        if (value == maxPrice || value == minPrice) {
                          return const SizedBox.shrink(); // Don't show top and bottom bounds
                        }
                        final formatCurrency = NumberFormat.compact(locale: 'id_ID');
                        return Text(
                          formatCurrency.format(value),
                          style: const TextStyle(color: Colors.grey, fontSize: 10),
                          textAlign: TextAlign.right,
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(
                  show: false,
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    color: Colors.cyan.shade400,
                    barWidth: 2,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 3,
                          color: Colors.white,
                          strokeWidth: 2,
                          strokeColor: Colors.cyan.shade400,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      color: Colors.cyan.shade400.withOpacity(0.1),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
