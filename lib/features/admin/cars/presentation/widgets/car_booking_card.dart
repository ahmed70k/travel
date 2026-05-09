import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/glass_container.dart';
import '../../domain/entities/car_booking_entity.dart';
import 'status_badge.dart';

class CarBookingCard extends StatefulWidget {
  final CarBookingEntity booking;

  const CarBookingCard({super.key, required this.booking});

  @override
  State<CarBookingCard> createState() => _CarBookingCardState();
}

class _CarBookingCardState extends State<CarBookingCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _isExpanded = !_isExpanded),
      child: GlassContainer(
        padding: const EdgeInsets.all(16),
        borderRadiusGeometry: _isExpanded 
            ? const BorderRadius.vertical(top: Radius.circular(16)) 
            : BorderRadius.circular(16),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.directions_car, color: AppColors.primary),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.booking.car,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'ID: ${widget.booking.id}',
                        style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12),
                      ),
                    ],
                  ),
                ),
                CarStatusBadge(status: widget.booking.status),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildInfoColumn(
                  'المسار',
                  '${widget.booking.fromCity} → ${widget.booking.toCity}',
                  Icons.route,
                ),
                _buildInfoColumn(
                  'الاستلام',
                  DateFormat('dd MMM yyyy').format(widget.booking.pickupDate),
                  Icons.calendar_today,
                ),
                _buildInfoColumn(
                  'السعر',
                  '${widget.booking.price.toStringAsFixed(0)} \$',
                  Icons.attach_money,
                ),
              ],
            ),
            if (_isExpanded) ...[
              const Divider(color: Colors.white10, height: 32),
              _buildExpandedDetail('المسار الكامل', '${widget.booking.fromCity} إلى ${widget.booking.toCity}'),
              _buildExpandedDetail('تاريخ العودة', DateFormat('dd MMM yyyy').format(widget.booking.returnDate)),
              _buildExpandedDetail('المدة', widget.booking.duration),
              _buildExpandedDetail('تفاصيل الحالة', widget.booking.status),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoColumn(String label, String value, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 12, color: AppColors.primary.withOpacity(0.7)),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 10),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildExpandedDetail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 13)),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
