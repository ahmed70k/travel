import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/glass_container.dart';
import 'package:intl/intl.dart';

class B2BDateFilter extends StatelessWidget {
  final DateTime from;
  final DateTime to;
  final Function(DateTimeRange) onDateRangeSelected;

  const B2BDateFilter({
    super.key,
    required this.from,
    required this.to,
    required this.onDateRangeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final DateTimeRange? picked = await showDateRangePicker(
          context: context,
          firstDate: DateTime(2020),
          lastDate: DateTime(2030),
          initialDateRange: DateTimeRange(start: from, end: to),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: const ColorScheme.dark(
                  primary: AppColors.primary,
                  onPrimary: Colors.white,
                  surface: AppColors.backgroundStart,
                  onSurface: Colors.white,
                ),
              ),
              child: child!,
            );
          },
        );
        if (picked != null) {
          onDateRangeSelected(picked);
        }
      },
      child: GlassContainer(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.calendar_today, color: AppColors.primary, size: 18),
            const SizedBox(width: 12),
            Text(
              '${DateFormat('MMM d').format(from)} - ${DateFormat('MMM d').format(to)}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.keyboard_arrow_down, color: AppColors.textMuted, size: 18),
          ],
        ),
      ),
    );
  }
}
