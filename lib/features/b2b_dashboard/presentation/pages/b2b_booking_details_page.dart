import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/glass_container.dart';
import '../../../../core/widgets/neon_text.dart';
import '../../domain/entities/booking_entities.dart';

class B2bBookingDetailsPage extends StatelessWidget {
  final dynamic booking;

  const B2bBookingDetailsPage({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A081C),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('تفاصيل الحجز', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 24),
            _buildDetailsCard(),
            const SizedBox(height: 24),
            _buildStatusTimeline(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    String title = '';
    IconData icon;
    Color color;

    if (booking is FlightBookingEntity) {
      title = 'حجز طيران - ${booking.airlineName}';
      icon = Icons.flight_takeoff;
      color = Colors.blueAccent;
    } else if (booking is HotelBookingEntity) {
      title = 'حجز فندق - ${booking.hotelName}';
      icon = Icons.hotel;
      color = Colors.orangeAccent;
    } else {
      title = 'حجز سيارة - ${booking.carModel}';
      icon = Icons.directions_car;
      color = Colors.greenAccent;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(width: 16),
            Expanded(
              child: NeonText(
                title,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'رقم المرجعي: ${booking.id.toString().toUpperCase()}',
          style: const TextStyle(color: AppColors.textMuted, fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildDetailsCard() {
    return GlassContainer(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'معلومات الحجز',
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const Divider(height: 32, color: Colors.white10),
          if (booking is FlightBookingEntity) ...[
            _buildDetailItem('من', booking.from),
            _buildDetailItem('إلى', booking.to),
            _buildDetailItem('وقت الإقلاع', DateFormat('dd MMM yyyy, HH:mm').format(booking.departureTime)),
            _buildDetailItem('وقت الوصول', DateFormat('dd MMM yyyy, HH:mm').format(booking.arrivalTime)),
            _buildDetailItem('الدرجة', booking.flightType),
            _buildDetailItem('السعر', '${booking.price} \$'),
          ] else if (booking is HotelBookingEntity) ...[
            _buildDetailItem('الفندق', booking.hotelName),
            _buildDetailItem('الموقع', booking.location),
            _buildDetailItem('تاريخ الدخول', DateFormat('dd MMM yyyy').format(booking.checkIn)),
            _buildDetailItem('تاريخ الخروج', DateFormat('dd MMM yyyy').format(booking.checkOut)),
            _buildDetailItem('نوع الغرفة', booking.roomType),
            _buildDetailItem('الضيوف', booking.guests),
            _buildDetailItem('السعر الإجمالي', '${booking.price} \$'),
          ] else if (booking is CarBookingEntity) ...[
            _buildDetailItem('موديل السيارة', booking.carModel),
            _buildDetailItem('موقع الاستلام', booking.pickupLocation),
            _buildDetailItem('تاريخ الاستلام', DateFormat('dd MMM yyyy').format(booking.pickupDate)),
            _buildDetailItem('تاريخ التسليم', DateFormat('dd MMM yyyy').format(booking.returnDate)),
            _buildDetailItem('المدة', booking.duration),
            _buildDetailItem('السعر الإجمالي', '${booking.totalPrice} \$'),
          ],
          _buildDetailItem('الحالة', booking.status.toUpperCase(), isStatus: true),
        ],
      ),
    );
  }

  Widget _buildDetailItem(String label, String value, {bool isStatus = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppColors.textMuted, fontSize: 14)),
          Text(
            value,
            style: TextStyle(
              color: isStatus ? Colors.blueAccent : Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusTimeline() {
    return GlassContainer(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'تتبع الحالة',
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          _buildTimelineItem('تم استلام الطلب', 'منذ 2 ساعة', true),
          _buildTimelineItem('جاري مراجعة البيانات', 'منذ 1 ساعة', true),
          _buildTimelineItem('تم تأكيد الحجز', 'الآن', booking.status.toLowerCase() == 'confirmed'),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(String title, String time, bool isCompleted) {
    return Row(
      children: [
        Column(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isCompleted ? Colors.blueAccent : Colors.white24,
              ),
            ),
            Container(width: 2, height: 30, color: Colors.white10),
          ],
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(color: isCompleted ? Colors.white : Colors.white30, fontSize: 14, fontWeight: FontWeight.bold)),
            Text(time, style: const TextStyle(color: Colors.white24, fontSize: 12)),
          ],
        ),
      ],
    );
  }
}
