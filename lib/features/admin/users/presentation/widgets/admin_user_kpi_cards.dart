import 'package:flutter/material.dart';
import 'package:travle/core/theme/app_colors.dart';
import 'package:travle/core/widgets/glass_container.dart';
import '../../domain/entities/admin_users_entity.dart';

class AdminUserKPICards extends StatelessWidget {
  final UserKPIEntity kpis;

  const AdminUserKPICards({super.key, required this.kpis});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: isMobile ? 1 : 4,
      crossAxisSpacing: 20,
      mainAxisSpacing: 20,
      childAspectRatio: isMobile ? 2.0 : 1.5,
      children: [
        _buildStatCard(
          'Total Users',
          kpis.totalUsers.toString(),
          Icons.people_outline,
          Colors.blueAccent,
        ),
        _buildStatCard(
          'B2B Agencies',
          kpis.b2bAgencies.toString(),
          Icons.business_center_outlined,
          Colors.purpleAccent,
        ),
        _buildStatCard(
          'B2C Customers',
          kpis.b2cCustomers.toString(),
          Icons.person_outline,
          AppColors.success,
        ),
        _buildStatCard(
          'New This Month',
          kpis.newThisMonth.toString(),
          Icons.person_add_alt_1_outlined,
          Colors.orangeAccent,
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return GlassContainer(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 24),
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
