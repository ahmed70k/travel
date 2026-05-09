import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:travle/core/theme/app_colors.dart';
import 'package:travle/core/widgets/glass_container.dart';
import '../../domain/entities/car_booking_entity.dart';

class AdminCarBookingCard extends StatelessWidget {
  final CarBookingEntity booking;

  const AdminCarBookingCard({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.blueAccent.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.directions_car_outlined, color: Colors.blueAccent, size: 20),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        booking.car,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${booking.route} • ${booking.duration}',
                        style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
              _buildStatusBadge(booking.status),
            ],
          ),
          const Divider(height: 32, color: Colors.white10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildInfoColumn(
                'الاستلام',
                DateFormat('MMM dd, HH:mm').format(booking.pickupDate),
                Icons.calendar_today_outlined,
              ),
              _buildInfoColumn(
                'التسليم',
                DateFormat('MMM dd, HH:mm').format(booking.returnDate),
                Icons.event_available_outlined,
              ),
              _buildInfoColumn(
                'السعر',
                '\$${booking.price.toStringAsFixed(0)}',
                Icons.attach_money,
                isPrice: true,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
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
        label = 'ملغى';
        break;
      default:
        color = AppColors.textMuted;
        label = status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildInfoColumn(String label, String value, IconData icon, {bool isPrice = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: AppColors.textMuted, size: 12),
            const SizedBox(width: 4),
            Text(label, style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: TextStyle(
            color: isPrice ? AppColors.primary : Colors.white,
            fontSize: 13,
            fontWeight: isPrice ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
