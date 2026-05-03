import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:travle/core/theme/app_colors.dart';
import 'package:travle/core/widgets/glass_container.dart';

class AdminB2BKPICard extends StatelessWidget {
  final String title;
  final num value;
  final IconData icon;
  final bool isCurrency;
  final bool isPercentage;

  const AdminB2BKPICard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    this.isCurrency = false,
    this.isPercentage = false,
  });

  @override
  Widget build(BuildContext context) {
    String displayValue;
    if (isCurrency) {
      displayValue = NumberFormat.currency(symbol: '\$', decimalDigits: 0).format(value);
    } else if (isPercentage) {
      displayValue = '${value.toStringAsFixed(1)}%';
    } else {
      displayValue = NumberFormat.compact().format(value);
    }

    return GlassContainer(
      padding: const EdgeInsets.all(20),
      animateHover: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textMuted,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            displayValue,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textMain,
                ),
          ),
        ],
      ),
    );
  }
}
