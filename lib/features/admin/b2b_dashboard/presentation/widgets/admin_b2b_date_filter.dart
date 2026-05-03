import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:travle/core/theme/app_colors.dart';
import 'package:travle/core/widgets/glass_container.dart';

class AdminB2BDateFilter extends StatefulWidget {
  final DateTime initialFrom;
  final DateTime initialTo;
  final void Function(DateTime from, DateTime to) onApply;

  const AdminB2BDateFilter({
    super.key,
    required this.initialFrom,
    required this.initialTo,
    required this.onApply,
  });

  @override
  State<AdminB2BDateFilter> createState() => _AdminB2BDateFilterState();
}

class _AdminB2BDateFilterState extends State<AdminB2BDateFilter> {
  late DateTime _from;
  late DateTime _to;

  @override
  void initState() {
    super.initState();
    _from = widget.initialFrom;
    _to = widget.initialTo;
  }

  Future<void> _selectDate(BuildContext context, bool isFrom) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isFrom ? _from : _to,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
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
        if (isFrom) {
          _from = picked;
          if (_from.isAfter(_to)) {
            _to = _from;
          }
        } else {
          _to = picked;
          if (_to.isBefore(_from)) {
            _from = _to;
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildDateButton(context, true, _from),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Text('-', style: TextStyle(color: AppColors.textMuted)),
          ),
          _buildDateButton(context, false, _to),
          const SizedBox(width: 16),
          ElevatedButton(
            onPressed: () => widget.onApply(_from, _to),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }

  Widget _buildDateButton(BuildContext context, bool isFrom, DateTime date) {
    return InkWell(
      onTap: () => _selectDate(context, isFrom),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.glassBorder),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today, size: 16, color: AppColors.textMuted),
            const SizedBox(width: 8),
            Text(
              DateFormat('dd MMM yyyy').format(date),
              style: const TextStyle(color: AppColors.textMain, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
