import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/glass_container.dart';
import '../../domain/entities/booking_entities.dart';
import 'status_chip.dart';
import '../pages/b2b_booking_details_page.dart';

class BookingCard extends StatelessWidget {
  final dynamic booking;

  const BookingCard({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    double price = 0;
    if (booking is FlightBookingEntity) price = booking.price;
    if (booking is HotelBookingEntity) price = booking.price;
    if (booking is CarBookingEntity) price = booking.totalPrice;

    return GlassContainer(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildTypeBadge(),
              StatusChip(status: booking.status),
            ],
          ),
          const SizedBox(height: 16),
          if (booking is FlightBookingEntity) _buildFlightDetails(booking),
          if (booking is HotelBookingEntity) _buildHotelDetails(booking),
          if (booking is CarBookingEntity) _buildCarDetails(booking),
          const Divider(height: 32, color: AppColors.glassBorder),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'السعر الإجمالي',
                    style: TextStyle(color: AppColors.textMuted, fontSize: 12),
                  ),
                  Text(
                    '${price.toStringAsFixed(2)} \$',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => B2bBookingDetailsPage(booking: booking),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('التفاصيل'),
                  ),
                  if (booking.status.toLowerCase() == 'pending') ...[
                    const SizedBox(width: 8),
                    OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.redAccent,
                        side: const BorderSide(color: Colors.redAccent),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('إلغاء'),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTypeBadge() {
    IconData icon;
    String label;
    Color color;

    if (booking is FlightBookingEntity) {
      icon = Icons.flight_takeoff;
      label = 'طيران';
      color = Colors.blueAccent;
    } else if (booking is HotelBookingEntity) {
      icon = Icons.hotel;
      label = 'فندق';
      color = Colors.orangeAccent;
    } else {
      icon = Icons.directions_car;
      label = 'سيارة';
      color = Colors.greenAccent;
    }

    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildFlightDetails(FlightBookingEntity flight) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          flight.airlineName,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        Text(
          '${flight.airlineCode} · ${flight.flightType}',
          style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('من', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
                  Text(flight.from, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
                  Text(DateFormat('HH:mm').format(flight.departureTime), style: const TextStyle(color: Colors.white70, fontSize: 12)),
                ],
              ),
            ),
            const Icon(Icons.swap_horiz, color: AppColors.textMuted),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text('إلى', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
                  Text(flight.to, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
                  Text(DateFormat('HH:mm').format(flight.arrivalTime), style: const TextStyle(color: Colors.white70, fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            const Icon(Icons.calendar_today, size: 14, color: AppColors.textMuted),
            const SizedBox(width: 4),
            Text(
              DateFormat('dd MMM yyyy').format(flight.departureTime),
              style: const TextStyle(color: Colors.white70),
            ),
            const Spacer(),
            const Icon(Icons.timer_outlined, size: 14, color: AppColors.textMuted),
            const SizedBox(width: 4),
            Text(
              flight.duration,
              style: const TextStyle(color: Colors.white70),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHotelDetails(HotelBookingEntity hotel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          hotel.hotelName,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        Text(
          hotel.location,
          style: const TextStyle(color: AppColors.textMuted),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildInfoColumn('دخول', DateFormat('dd MMM').format(hotel.checkIn)),
            _buildInfoColumn('خروج', DateFormat('dd MMM').format(hotel.checkOut)),
            _buildInfoColumn('أفراد', hotel.guests),
            _buildInfoColumn('الغرفة', hotel.roomType),
          ],
        ),
      ],
    );
  }

  Widget _buildCarDetails(CarBookingEntity car) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          car.carModel,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        Text(
          car.category,
          style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(Icons.location_on, size: 14, color: AppColors.textMuted),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                '${car.pickupLocation} ← ${car.returnLocation}',
                style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildInfoColumn('استلام', DateFormat('dd MMM').format(car.pickupDate)),
            _buildInfoColumn('تسليم', DateFormat('dd MMM').format(car.returnDate)),
            _buildInfoColumn('المدة', car.duration),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoColumn(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
        Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white)),
      ],
    );
  }
}
