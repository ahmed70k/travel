import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/widgets/glass_container.dart';
import '../../../../../../core/widgets/progress_bar.dart';
import '../../../../domain/entities/dashboard_models.dart';
import '../../../../../../core/widgets/floating_icon.dart';

class StatCard extends StatelessWidget {
  final StatModel stat;
  final IconData icon;
  final Color iconColor;

  const StatCard({
    super.key,
    required this.stat,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      animateHover: true,
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      stat.title,
                      style: const TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      stat.value,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          stat.isPositive
                              ? Icons.arrow_upward
                              : Icons.arrow_downward,
                          color: stat.isPositive
                              ? AppColors.success
                              : AppColors.error,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          stat.changeLabel,
                          style: TextStyle(
                            color: stat.isPositive
                                ? AppColors.success
                                : AppColors.error,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: FloatingIcon(icon: icon, color: iconColor, size: 28),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ProgressShimmerBar(value: stat.progress, color: iconColor),
        ],
      ),
    );
  }
}
