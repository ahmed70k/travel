import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:travle/core/theme/app_colors.dart';
import 'package:travle/core/widgets/glass_container.dart';
import 'package:travle/features/admin/b2c_dashboard/domain/entities/customer_distribution_entity.dart';

class CustomerDistributionPieChart extends StatelessWidget {
  final List<CustomerDistributionEntity> distributions;

  const CustomerDistributionPieChart({
    super.key,
    required this.distributions,
  });

  @override
  Widget build(BuildContext context) {
    if (distributions.isEmpty) {
      return const GlassContainer(
        child: Center(
          child: Text(
            'لا تتوفر بيانات للتوزيع',
            style: TextStyle(color: AppColors.textMuted),
          ),
        ),
      );
    }

    return GlassContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'توزيع العملاء',
            style: TextStyle(
              color: AppColors.textMain,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: PieChart(
                    PieChartData(
                      sectionsSpace: 2,
                      centerSpaceRadius: 40,
                      sections: distributions.asMap().entries.map((entry) {
                        final index = entry.key;
                        final data = entry.value;
                        final color = _getColorForIndex(index);
                        return PieChartSectionData(
                          color: color,
                          value: data.percentage,
                          title: '${data.percentage.toStringAsFixed(0)}%',
                          radius: 50,
                          titleStyle: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: distributions.asMap().entries.map((entry) {
                      final index = entry.key;
                      final data = entry.value;
                      final color = _getColorForIndex(index);
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: color,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                data.label,
                                style: const TextStyle(
                                  color: AppColors.textMuted,
                                  fontSize: 12,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getColorForIndex(int index) {
    final colors = [
      AppColors.primary,
      AppColors.secondary,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
    ];
    return colors[index % colors.length];
  }
}
