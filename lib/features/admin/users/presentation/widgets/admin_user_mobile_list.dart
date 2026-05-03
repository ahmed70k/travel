import 'package:flutter/material.dart';
import 'package:travle/core/theme/app_colors.dart';
import 'package:travle/core/widgets/glass_container.dart';
import '../../domain/entities/admin_users_entity.dart';

class AdminUserMobileList extends StatelessWidget {
  final List<UserEntity> users;

  const AdminUserMobileList({super.key, required this.users});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: users.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) => _buildUserCard(users[index]),
    );
  }

  Widget _buildUserCard(UserEntity user) {
    return GlassContainer(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: AppColors.primary.withOpacity(0.1),
                child: Text(
                  user.name.substring(0, 1).toUpperCase(),
                  style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    Text(user.email, style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
                  ],
                ),
              ),
              _buildTypeBadge(user.accountType),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1, color: Colors.white10),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Bookings', style: TextStyle(color: AppColors.textMuted, fontSize: 10)),
                  Text(user.bookingsCount.toString(), style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                ],
              ),
              _buildStatusBadge(user.status),
              IconButton(
                icon: const Icon(Icons.arrow_forward_ios, color: AppColors.textMuted, size: 14),
                onPressed: () {},
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTypeBadge(String type) {
    Color color;
    switch (type.toUpperCase()) {
      case 'ADMIN': color = Colors.orangeAccent; break;
      case 'B2B': color = Colors.purpleAccent; break;
      default: color = Colors.blueAccent;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(type, style: TextStyle(color: color, fontSize: 9, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildStatusBadge(String status) {
    final isActive = status.toLowerCase() == 'active';
    final color = isActive ? AppColors.success : AppColors.textMuted;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        isActive ? 'Active' : 'Inactive',
        style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }
}
