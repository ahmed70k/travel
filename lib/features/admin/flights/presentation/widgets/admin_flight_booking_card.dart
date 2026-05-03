import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:travle/core/theme/app_colors.dart';
import 'package:travle/core/widgets/glass_container.dart';
import '../../domain/entities/admin_flights_entity.dart';

class AdminFlightBookingCard extends StatelessWidget {
  final FlightBookingEntity booking;

  const AdminFlightBookingCard({super.key, required this.booking});

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
                      color: AppColors.primary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.flight_takeoff, color: AppColors.primary, size: 20),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        booking.route ?? '${booking.from ?? '—'} ➔ ${booking.to ?? '—'}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${booking.airline ?? 'Unknown Airline'} • ${booking.flightNo ?? '—'}',
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
              _buildInfoColumn('Customer', booking.customer, Icons.person_outline),
              _buildInfoColumn(
                'Departure',
                booking.departureTime != null 
                    ? DateFormat('MMM dd, HH:mm').format(booking.departureTime!) 
                    : '--:--',
                Icons.access_time,
              ),
              _buildInfoColumn(
                'Price',
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
        label = 'Confirmed';
        break;
      case 'pending':
        color = AppColors.warning;
        label = 'Pending';
        break;
      case 'cancelled':
        color = Colors.redAccent;
        label = 'Cancelled';
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
