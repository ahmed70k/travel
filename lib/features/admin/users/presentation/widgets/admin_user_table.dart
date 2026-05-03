import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:travle/core/theme/app_colors.dart';
import 'package:travle/core/widgets/glass_container.dart';
import '../../domain/entities/admin_users_entity.dart';

class AdminUserTable extends StatelessWidget {
  final List<UserEntity> users;

  const AdminUserTable({super.key, required this.users});

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
              'Users Management',
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
                DataColumn(label: Text('User', style: TextStyle(color: AppColors.textMuted))),
                DataColumn(label: Text('Account Type', style: TextStyle(color: AppColors.textMuted))),
                DataColumn(label: Text('Registered', style: TextStyle(color: AppColors.textMuted))),
                DataColumn(label: Text('Bookings', style: TextStyle(color: AppColors.textMuted))),
                DataColumn(label: Text('Status', style: TextStyle(color: AppColors.textMuted))),
                DataColumn(label: Text('Actions', style: TextStyle(color: AppColors.textMuted))),
              ],
              rows: users.map((u) => _buildDataRow(u)).toList(),
            ),
          ),
        ],
      ),
    );
  }

  DataRow _buildDataRow(UserEntity user) {
    return DataRow(
      cells: [
        DataCell(
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: AppColors.primary.withOpacity(0.1),
                child: Text(
                  user.name.substring(0, 1).toUpperCase(),
                  style: const TextStyle(color: AppColors.primary, fontSize: 12),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(user.name, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                  Text(user.email, style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
                ],
              ),
            ],
          ),
        ),
        DataCell(_buildTypeBadge(user.accountType)),
        DataCell(Text(DateFormat('MMM dd, yyyy').format(user.registeredAt), style: const TextStyle(color: Colors.white70, fontSize: 12))),
        DataCell(Text(user.bookingsCount.toString(), style: const TextStyle(color: Colors.white70))),
        DataCell(_buildStatusBadge(user.status)),
        DataCell(
          IconButton(
            icon: const Icon(Icons.more_vert, color: AppColors.textMuted, size: 18),
            onPressed: () {},
          ),
        ),
      ],
    );
  }

  Widget _buildTypeBadge(String type) {
    Color color;
    switch (type.toUpperCase()) {
      case 'ADMIN':
        color = Colors.orangeAccent;
        break;
      case 'B2B':
        color = Colors.purpleAccent;
        break;
      default:
        color = Colors.blueAccent;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(type, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildStatusBadge(String status) {
    final isActive = status.toLowerCase() == 'active';
    final color = isActive ? AppColors.success : AppColors.textMuted;
    return Row(
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          isActive ? 'Active' : 'Inactive',
          style: TextStyle(color: color, fontSize: 11),
        ),
      ],
    );
  }
}
