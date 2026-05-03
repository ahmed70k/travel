import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/widgets/glass_container.dart';
import '../../../../domain/entities/dashboard_models.dart';
import '../../state/admin_providers.dart';

class BookingTable extends ConsumerWidget {
  const BookingTable({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookings = ref.watch(recentBookingsProvider);

    return GlassContainer(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              runSpacing: 16,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                const Row(
                  children: [
                    Icon(Icons.flight, color: AppColors.primary),
                    SizedBox(width: 8),
                    Text(
                      'أحدث حجوزات الطيران',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                InkWell(
                  onTap: () {},
                  child: const Row(
                    children: [
                      Text(
                        'عرض الكل',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(
                        Icons.arrow_back,
                        color: AppColors.primary,
                        size: 14,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.glassBorder),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowColor: MaterialStateProperty.all(
                AppColors.primary.withOpacity(0.1),
              ),
              dataRowColor: MaterialStateProperty.resolveWith<Color?>((
                Set<MaterialState> states,
              ) {
                if (states.contains(MaterialState.hovered)) {
                  return AppColors.primary.withOpacity(0.1);
                }
                return null;
              }),
              columns: const [
                DataColumn(
                  label: Text(
                    'العميل',
                    style: TextStyle(color: AppColors.textMuted),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'الرحلة',
                    style: TextStyle(color: AppColors.textMuted),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'التاريخ',
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
              rows: bookings.map((b) => _buildRow(b)).toList(),
            ),
          ),
        ],
      ),
    );
  }

  DataRow _buildRow(BookingModel booking) {
    return DataRow(
      cells: [
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: AppColors.primary,
                child: Text(
                  booking.clientName[0],
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
              const SizedBox(width: 12),
              Flexible(
                child: Text(
                  booking.clientName,
                  style: const TextStyle(color: Colors.white),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        DataCell(Text(booking.flightPath)),
        DataCell(Text(booking.date)),
        DataCell(
          Text(
            booking.price,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        DataCell(_buildStatusBadge(booking.status)),
      ],
    );
  }

  Widget _buildStatusBadge(BookingStatus status) {
    Color color;
    String label;
    switch (status) {
      case BookingStatus.confirmed:
        color = AppColors.success;
        label = 'مؤكد';
        break;
      case BookingStatus.pending:
        color = AppColors.warning;
        label = 'قيد الانتظار';
        break;
      case BookingStatus.issued:
        color = AppColors.info;
        label = 'تم الإصدار';
        break;
      case BookingStatus.payment_pending:
        color = AppColors.warning;
        label = 'بانتظار الدفع';
        break;
      case BookingStatus.cancelled:
        color = Colors.redAccent;
        label = 'ملغي';
        break;
      case BookingStatus.issuing:
        color = Colors.blueAccent;
        label = 'قيد الإصدار';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(label, style: TextStyle(color: color, fontSize: 12)),
    );
  }
}
