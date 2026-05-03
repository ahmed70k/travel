import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:travle/core/theme/app_colors.dart';
import 'package:travle/core/widgets/glass_container.dart';
import 'package:travle/features/admin/b2b_dashboard/domain/entities/agency_distribution_entity.dart';

class AgencyDistributionPieChart extends StatefulWidget {
  final List<AgencyDistributionEntity> distributions;

  const AgencyDistributionPieChart({super.key, required this.distributions});

  @override
  State<AgencyDistributionPieChart> createState() => _AgencyDistributionPieChartState();
}

class _AgencyDistributionPieChartState extends State<AgencyDistributionPieChart> {
  int touchedIndex = -1;

  final List<Color> _chartColors = [
    AppColors.primary,
    AppColors.secondary,
    AppColors.info,
    AppColors.warning,
    AppColors.success,
  ];

  @override
  Widget build(BuildContext context) {
    if (widget.distributions.isEmpty) {
      return const GlassContainer(
        padding: EdgeInsets.all(24),
        child: Center(
          child: Text(
            'No distribution data available',
            style: TextStyle(color: AppColors.textMuted),
          ),
        ),
      );
    }

    return GlassContainer(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Agency Distribution',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textMain,
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
                      pieTouchData: PieTouchData(
                        touchCallback: (FlTouchEvent event, pieTouchResponse) {
                          setState(() {
                            if (!event.isInterestedForInteractions ||
                                pieTouchResponse == null ||
                                pieTouchResponse.touchedSection == null) {
                              touchedIndex = -1;
                              return;
                            }
                            touchedIndex =
                                pieTouchResponse.touchedSection!.touchedSectionIndex;
                          });
                        },
                      ),
                      borderData: FlBorderData(show: false),
                      sectionsSpace: 2,
                      centerSpaceRadius: 40,
                      sections: _showingSections(),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: widget.distributions.asMap().entries.map((entry) {
                      int idx = entry.key;
                      var data = entry.value;
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _chartColors[idx % _chartColors.length],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                data.type,
                                style: const TextStyle(
                                  color: AppColors.textMain,
                                  fontSize: 12,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Text(
                              '${data.value.toStringAsFixed(1)}%',
                              style: const TextStyle(
                                color: AppColors.textMuted,
                                fontSize: 12,
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

  List<PieChartSectionData> _showingSections() {
    return widget.distributions.asMap().entries.map((entry) {
      final index = entry.key;
      final data = entry.value;
      final isTouched = index == touchedIndex;
      final fontSize = isTouched ? 16.0 : 12.0;
      final radius = isTouched ? 60.0 : 50.0;

      return PieChartSectionData(
        color: _chartColors[index % _chartColors.length],
        value: data.value,
        title: '${data.value.toStringAsFixed(0)}%',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }
}
