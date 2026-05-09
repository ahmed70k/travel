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
    final width = MediaQuery.of(context).size.width;
    final isVerySmall = width < 420; // Increased threshold

    return GlassContainer(
      padding: EdgeInsets.symmetric(horizontal: isVerySmall ? 12 : 16, vertical: 8),
      child: isVerySmall 
        ? Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildDateButton(context, true, _from, true),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text('-', style: TextStyle(color: AppColors.textMuted)),
                  ),
                  _buildDateButton(context, false, _to, true),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => widget.onApply(_from, _to),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text('تطبيق'),
                ),
              ),
            ],
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDateButton(context, true, _from, false),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text('-', style: TextStyle(color: AppColors.textMuted)),
              ),
              _buildDateButton(context, false, _to, false),
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

  Widget _buildDateButton(BuildContext context, bool isFrom, DateTime date, bool isVerySmall) {
    return InkWell(
      onTap: () => _selectDate(context, isFrom),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: isVerySmall ? 6 : 12, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.glassBorder),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_today, size: isVerySmall ? 12 : 16, color: AppColors.textMuted),
            SizedBox(width: isVerySmall ? 4 : 8),
            Text(
              DateFormat(isVerySmall ? 'dd/MM/yy' : 'dd MMM yyyy').format(date),
              style: TextStyle(color: AppColors.textMain, fontSize: isVerySmall ? 12 : 14),
            ),
          ],
        ),
      ),
    );
  }
}
