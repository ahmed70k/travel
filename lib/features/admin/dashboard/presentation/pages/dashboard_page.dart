import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/neon_text.dart';
import '../../../../../core/widgets/glass_container.dart';
import '../../../shared/presentation/state/admin_providers.dart';
import '../../../shared/presentation/widgets/components/booking_table.dart';
import '../../../shared/presentation/widgets/components/offers_table.dart';
import '../../../shared/presentation/widgets/components/providers_grid.dart';
import '../../../shared/presentation/widgets/components/quick_actions.dart';
import '../../../shared/presentation/widgets/components/stat_card.dart';

class DashboardContent extends ConsumerWidget {
  const DashboardContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(statsProvider);

    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 800;

    return SingleChildScrollView(
      padding: EdgeInsets.all(isMobile ? 16.0 : 32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    NeonText(
                      'مرحباً، أحمد',
                      style: TextStyle(
                        fontSize: isMobile ? 24 : 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'هذا هو ملخص أداء وكالة السفر اليوم',
                      style: TextStyle(color: AppColors.textMuted),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildHeaderAction(Icons.notifications),
                  const SizedBox(width: 12),
                  _buildHeaderAction(Icons.settings),
                ],
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Stats Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isMobile ? 1 : 4,
              crossAxisSpacing: 24,
              mainAxisSpacing: 24,
              childAspectRatio: isMobile ? 1.5 : 1.4,
            ),
            itemCount: stats.length,
            itemBuilder: (context, index) {
              final stat = stats[index];
              return StatCard(
                stat: stat,
                icon: _getIconForStat(index),
                iconColor: _getColorForStat(index),
              );
            },
          ),
          const SizedBox(height: 32),

          // Main Section (Bookings + Quick Actions/B2B)
          if (isMobile) ...[
            const BookingTable(),
            const SizedBox(height: 24),
            const QuickActions(),
            const SizedBox(height: 24),
            _buildTopB2BWidget(ref),
          ] else
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Expanded(flex: 2, child: BookingTable()),
                const SizedBox(width: 24),
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      const QuickActions(),
                      const SizedBox(height: 24),
                      _buildTopB2BWidget(ref),
                    ],
                  ),
                ),
              ],
            ),
          const SizedBox(height: 32),

          // Providers Grid
          const ProvidersGrid(),
          const SizedBox(height: 32),

          // Offers Table
          const OffersTable(),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildHeaderAction(IconData icon) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.glassBackground,
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: IconButton(
        icon: Icon(icon, color: AppColors.textMuted),
        onPressed: () {},
      ),
    );
  }

  Widget _buildTopB2BWidget(WidgetRef ref) {
    final topB2b = ref.watch(topB2bProvider);

    return GlassContainer(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.emoji_events, color: AppColors.warning),
              SizedBox(width: 8),
              Text(
                'أفضل وكلاء B2B',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...topB2b.map(
            (b2b) => Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        b2b.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        b2b.bookings,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    b2b.revenue,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.success,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIconForStat(int index) {
    switch (index) {
      case 0:
        return Icons.event_available;
      case 1:
        return Icons.attach_money;
      case 2:
        return Icons.group_add;
      case 3:
        return Icons.handshake;
      default:
        return Icons.info;
    }
  }

  Color _getColorForStat(int index) {
    switch (index) {
      case 0:
        return AppColors.primary;
      case 1:
        return AppColors.success;
      case 2:
        return Colors.blue;
      case 3:
        return AppColors.warning;
      default:
        return AppColors.primary;
    }
  }
}
