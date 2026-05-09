import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../core/widgets/glass_container.dart';

class AdminDateFilter extends StatelessWidget {
  final DateTime? from;
  final DateTime? to;
  final Function(DateTimeRange) onDateRangeSelected;

  const AdminDateFilter({
    super.key,
    this.from,
    this.to,
    required this.onDateRangeSelected,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isSmall = width < 400;
    final format = DateFormat(isSmall ? 'dd/MM/yy' : 'MMM dd, yyyy');
    
    final label = from != null && to != null
        ? '${format.format(from!)} - ${format.format(to!)}'
        : 'اختر الفترة الزمنية';

    return InkWell(
      onTap: () async {
        final initialRange = from != null && to != null
            ? DateTimeRange(start: from!, end: to!)
            : null;

        final range = await showDateRangePicker(
          context: context,
          initialDateRange: initialRange,
          firstDate: DateTime(2020),
          lastDate: DateTime.now().add(const Duration(days: 365)),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: const ColorScheme.dark(
                  primary: Colors.blueAccent,
                  onPrimary: Colors.white,
                  surface: Color(0xFF1A1A2E),
                  onSurface: Colors.white,
                ),
              ),
              child: child!,
            );
          },
        );

        if (range != null) {
          onDateRangeSelected(range);
        }
      },
      child: GlassContainer(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.calendar_today, color: Colors.blueAccent, size: 18),
            const SizedBox(width: 12),
            Text(
              label,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_drop_down, color: Colors.white54),
          ],
        ),
      ),
    );
  }
}
