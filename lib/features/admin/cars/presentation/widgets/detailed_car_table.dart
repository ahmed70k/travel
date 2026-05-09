import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/glass_container.dart';
import '../../domain/entities/car_booking_entity.dart';
import 'status_badge.dart';

class DetailedCarTable extends StatelessWidget {
  final List<CarBookingEntity> bookings;

  const DetailedCarTable({super.key, required this.bookings});

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      padding: const EdgeInsets.all(0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: DataTable(
          headingRowColor: WidgetStateProperty.all(Colors.white.withOpacity(0.05)),
          dataRowMaxHeight: 70,
          horizontalMargin: 24,
          columnSpacing: 24,
          columns: const [
            DataColumn(label: Text('رقم الحجز', style: _headerStyle)),
            DataColumn(label: Text('العميل', style: _headerStyle)),
            DataColumn(label: Text('السيارة', style: _headerStyle)),
            DataColumn(label: Text('المسار', style: _headerStyle)),
            DataColumn(label: Text('الاستلام', style: _headerStyle)),
            DataColumn(label: Text('المدة', style: _headerStyle)),
            DataColumn(label: Text('السعر', style: _headerStyle)),
            DataColumn(label: Text('الحالة', style: _headerStyle)),
          ],
          rows: bookings.map((booking) => DataRow(
            cells: [
              DataCell(Text(booking.id, style: _cellStyle)),
              DataCell(Text(booking.customer, style: _cellStyle)),
              DataCell(
                Row(
                  children: [
                    const Icon(Icons.directions_car, size: 16, color: AppColors.primary),
                    const SizedBox(width: 8),
                    Text(booking.car, style: _cellStyle.copyWith(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              DataCell(
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(booking.fromCity, style: _cellStyle),
                    const Icon(Icons.arrow_downward, size: 10, color: Colors.white24),
                    Text(booking.toCity, style: _cellStyle),
                  ],
                ),
              ),
              DataCell(Text(DateFormat('dd MMM yyyy').format(booking.pickupDate), style: _cellStyle)),
              DataCell(Text(booking.duration, style: _cellStyle)),
              DataCell(Text('${booking.price.toStringAsFixed(0)} ', style: _cellStyle.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold))),
              DataCell(CarStatusBadge(status: booking.status)),
            ],
          )).toList(),
        ),
      ),
    );
  }

  static const _headerStyle = TextStyle(
    color: AppColors.textMuted,
    fontSize: 12,
    fontWeight: FontWeight.bold,
    letterSpacing: 1,
  );

  static const _cellStyle = TextStyle(
    color: Colors.white,
    fontSize: 13,
  );
}
