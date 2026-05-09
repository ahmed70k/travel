import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:travle/core/theme/app_colors.dart';

class AdminB2CDateFilter extends StatefulWidget {
  final DateTime initialFrom;
  final DateTime initialTo;
  final Function(DateTime from, DateTime to) onApply;

  const AdminB2CDateFilter({
    super.key,
    required this.initialFrom,
    required this.initialTo,
    required this.onApply,
  });

  @override
  State<AdminB2CDateFilter> createState() => _AdminB2CDateFilterState();
}

class _AdminB2CDateFilterState extends State<AdminB2CDateFilter> {
  late DateTime _from;
  late DateTime _to;

  @override
  void initState() {
    super.initState();
    _from = widget.initialFrom;
    _to = widget.initialTo;
  }

  Future<void> _selectDateRange(BuildContext context) async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: DateTimeRange(start: _from, end: _to),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: AppColors.backgroundMiddle,
              onSurface: AppColors.textMain,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _from = picked.start;
        _to = picked.end;
      });
      widget.onApply(_from, _to);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = MediaQuery.of(context).size.width;
        final isVerySmall = width < 420;
        final format = DateFormat(isVerySmall ? 'dd/MM/yy' : 'MMM dd, yyyy');

        return InkWell(
          onTap: () => _selectDateRange(context),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: isVerySmall ? 12 : 16, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.glassBackground,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.glassBorder, width: 1.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.calendar_today, 
                     color: AppColors.primary, 
                     size: isVerySmall ? 16 : 18),
                const SizedBox(width: 8),
                Text(
                  '${format.format(_from)} - ${format.format(_to)}',
                  style: TextStyle(
                    color: AppColors.textMain,
                    fontSize: isVerySmall ? 11 : 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(Icons.arrow_drop_down, 
                     color: AppColors.textMain.withOpacity(0.5), 
                     size: 18),
              ],
            ),
          ),
        );
      },
    );
  }
}
