import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:travle/core/theme/app_colors.dart';
import 'package:travle/core/widgets/glass_container.dart';

class AdminB2CKPICard extends StatelessWidget {
  final String title;
  final num value;
  final IconData icon;
  final bool isCurrency;
  final bool isPercentage;

  const AdminB2CKPICard({
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.primary, size: 32),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  displayValue,
                  style: const TextStyle(
                    color: AppColors.textMain,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
