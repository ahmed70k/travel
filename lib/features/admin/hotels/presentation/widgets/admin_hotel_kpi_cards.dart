import 'package:flutter/material.dart';
import 'package:travle/core/theme/app_colors.dart';
import 'package:travle/core/widgets/glass_container.dart';
import '../../domain/entities/admin_hotels_entity.dart';

class AdminHotelKPICards extends StatelessWidget {
  final HotelKPIEntity kpis;

  const AdminHotelKPICards({super.key, required this.kpis});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: isMobile ? 1 : 4,
      crossAxisSpacing: 20,
      mainAxisSpacing: 20,
      childAspectRatio: isMobile ? 2.0 : 1.4,
      children: [
        _buildStatCard(
          'Total Bookings',
          kpis.totalHotelBookings.toString(),
          kpis.bookingsDelta,
          Icons.hotel,
          Colors.orangeAccent,
        ),
        _buildStatCard(
          'Revenue',
          '\$${kpis.hotelRevenue.toStringAsFixed(1)}k',
          kpis.revenueDelta,
          Icons.monetization_on,
          AppColors.success,
        ),
        _buildStatCard(
          'Avg Occupancy',
          '${kpis.avgOccupancy.toStringAsFixed(1)}%',
          null,
          Icons.percent,
          Colors.blueAccent,
        ),
        _buildStatCard(
          'Hotel Partners',
          kpis.hotelPartners.toString(),
          null,
          Icons.business,
          Colors.purpleAccent,
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    String? delta,
    IconData icon,
    Color color,
  ) {
    final isPositive = delta?.contains('+') ?? false;
    final isNegative = delta?.contains('-') ?? false;
    final deltaColor = isPositive 
        ? AppColors.success 
        : (isNegative ? Colors.redAccent : AppColors.textMuted);

    return GlassContainer(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              if (delta != null)
                Row(
                  children: [
                    Icon(
                      isPositive ? Icons.trending_up : (isNegative ? Icons.trending_down : Icons.trending_flat),
                      color: deltaColor,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      delta,
                      style: TextStyle(
                        color: deltaColor,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
            ],
          ),
          const SizedBox(height: 16),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Text(
            title,
            style: const TextStyle(color: AppColors.textMuted, fontSize: 13),
          ),
        ],
      ),
    );
  }
}
