import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/glass_container.dart';
import '../../domain/entities/admin_overview_entity.dart';

class AdminKPICards extends StatelessWidget {
  final KPIEntity kpis;

  const AdminKPICards({super.key, required this.kpis});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: isMobile ? 1 : 4,
      crossAxisSpacing: 20,
      mainAxisSpacing: 20,
      childAspectRatio: isMobile ? 1.8 : 1.4, // Made taller for mobile
      children: [
        _buildStatCard(
          'B2B Agencies',
          kpis.b2bAgencies.toString(),
          kpis.b2bDelta,
          Icons.business_center,
          Colors.blueAccent,
        ),
        _buildStatCard(
          'B2C Customers',
          kpis.b2cCustomers.toString(),
          kpis.b2cDelta,
          Icons.people_alt,
          Colors.purpleAccent,
        ),
        _buildStatCard(
          'Total Profit',
          kpis.formattedProfit,
          kpis.profitDelta,
          Icons.account_balance_wallet,
          AppColors.success,
        ),
        _buildStatCard(
          'Total Bookings',
          kpis.totalBookings.toString(),
          kpis.bookingsDelta,
          Icons.confirmation_number,
          AppColors.warning,
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    String delta,
    IconData icon,
    Color color,
  ) {
    final isPositive = delta.contains('+') || delta.contains('جديد');
    final isNegative = delta.contains('-');
    final deltaColor = isPositive 
        ? AppColors.success 
        : (isNegative ? Colors.redAccent : AppColors.textMuted);

    return GlassContainer(
      padding: const EdgeInsets.all(16), // Slightly reduced padding
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
                child: Icon(icon, color: color, size: 20), // Smaller icon
              ),
              if (delta.isNotEmpty)
                Flexible(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isPositive ? Icons.trending_up : (isNegative ? Icons.trending_down : Icons.trending_flat),
                        color: deltaColor,
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          delta,
                          style: TextStyle(
                            color: deltaColor,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
