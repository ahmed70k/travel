import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:travle/core/theme/app_colors.dart';
import 'package:travle/core/widgets/glass_container.dart';
import 'package:travle/features/admin/b2c_dashboard/domain/entities/top_customer_entity.dart';

class TopCustomersBarChart extends StatelessWidget {
  final List<TopCustomerEntity> customers;

  const TopCustomersBarChart({
    super.key,
    required this.customers,
  });

  @override
  Widget build(BuildContext context) {
    if (customers.isEmpty) {
      return const GlassContainer(
        child: Center(
          child: Text(
            'لا تتوفر بيانات لأفضل العملاء',
            style: TextStyle(color: AppColors.textMuted),
          ),
        ),
      );
    }

    final double maxY = customers.fold(
      0.0,
      (max, customer) => customer.totalSpent > max ? customer.totalSpent : max,
    );

    return GlassContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'أفضل العملاء حسب الإيرادات',
            style: TextStyle(
              color: AppColors.textMain,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 32),
          Expanded(
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: maxY * 1.2, // add some headroom
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipColor: (_) => AppColors.glassBackground,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      return BarTooltipItem(
                        '${customers[group.x.toInt()].name}\n',
                        const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        children: [
                          TextSpan(
                            text: NumberFormat.currency(
                                    symbol: '\$', decimalDigits: 0)
                                .format(rod.toY),
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() >= 0 &&
                            value.toInt() < customers.length) {
                          // Try to show only first name or short name to prevent overflow
                          final name = customers[value.toInt()].name.split(' ').first;
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              name,
                              style: const TextStyle(
                                color: AppColors.textMuted,
                                fontSize: 10,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        }
                        return const Text('');
                      },
                      reservedSize: 28,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        if (value == 0) return const SizedBox.shrink();
                        return Text(
                          NumberFormat.compact().format(value),
                          style: const TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 10,
                          ),
                        );
                      },
                    ),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  checkToShowHorizontalLine: (value) => value % (maxY / 5) == 0,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: AppColors.glassBorder.withOpacity(0.2),
                    strokeWidth: 1,
                  ),
                  drawVerticalLine: false,
                ),
                borderData: FlBorderData(show: false),
                barGroups: customers.asMap().entries.map((entry) {
                  final index = entry.key;
                  final customer = entry.value;
                  return BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: customer.totalSpent,
                        color: AppColors.primary,
                        width: 16,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(4),
                        ),
                        backDrawRodData: BackgroundBarChartRodData(
                          show: true,
                          toY: maxY * 1.2,
                          color: AppColors.glassBackground.withOpacity(0.5),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
