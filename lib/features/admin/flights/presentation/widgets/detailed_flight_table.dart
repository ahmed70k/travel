import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:travle/core/theme/app_colors.dart';
import 'package:travle/core/widgets/glass_container.dart';
import '../../domain/entities/admin_flights_entity.dart';

class DetailedFlightTable extends StatelessWidget {
  final List<FlightBookingEntity> bookings;

  const DetailedFlightTable({super.key, required this.bookings});

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(24.0),
            child: Text(
              'تقرير الحجوزات المفصل',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const Divider(height: 1, color: AppColors.glassBorder),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columnSpacing: 24,
              headingRowColor: WidgetStateProperty.all(
                AppColors.primary.withOpacity(0.05),
              ),
              columns: const [
                DataColumn(
                  label: Text(
                    'رقم الحجز',
                    style: TextStyle(color: AppColors.textMuted),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'العميل',
                    style: TextStyle(color: AppColors.textMuted),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'المسار',
                    style: TextStyle(color: AppColors.textMuted),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'المغادرة',
                    style: TextStyle(color: AppColors.textMuted),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'السعر',
                    style: TextStyle(color: AppColors.textMuted),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'الحالة',
                    style: TextStyle(color: AppColors.textMuted),
                  ),
                ),
              ],
              rows: bookings.map((b) => _buildDataRow(b)).toList(),
            ),
          ),
        ],
      ),
    );
  }

  DataRow _buildDataRow(FlightBookingEntity booking) {
    return DataRow(
      cells: [
        DataCell(
          Text(booking.id, style: const TextStyle(color: Colors.white70)),
        ),
        DataCell(
          Text(
            booking.customer,
            style: const TextStyle(color: Colors.white),
          ),
        ),
        DataCell(
          Text(
            booking.route ?? '${booking.from ?? '—'} ➔ ${booking.to ?? '—'}',
            style: const TextStyle(color: Colors.white70),
          ),
        ),
        DataCell(
          Text(
            booking.departureTime != null 
                ? DateFormat('yyyy-MM-dd HH:mm').format(booking.departureTime!) 
                : '—',
            style: const TextStyle(color: Colors.white70),
          ),
        ),
        DataCell(
          Text(
            '\$${booking.price.toStringAsFixed(0)}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        DataCell(_buildSmallBadge(booking.status)),
      ],
    );
  }

  Widget _buildSmallBadge(String status) {
    Color color;
    String label;

    switch (status.toLowerCase()) {
      case 'confirmed':
        color = AppColors.success;
        label = 'مؤكد';
        break;
      case 'pending':
        color = AppColors.warning;
        label = 'قيد الانتظار';
        break;
      case 'cancelled':
        color = Colors.redAccent;
        label = 'ملغي';
        break;
      default:
        color = AppColors.textMuted;
        label = status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(label, style: TextStyle(color: color, fontSize: 10)),
    );
  }
}
