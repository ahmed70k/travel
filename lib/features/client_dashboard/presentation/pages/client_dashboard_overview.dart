import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/neon_text.dart';
import '../../../../core/widgets/glass_container.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/presentation/cubit/auth_state.dart';
import '../../../../core/di/dependency_injection.dart';
import '../cubit/b2c_overview_cubit.dart';
import '../cubit/b2c_overview_state.dart';
import '../widgets/b2c_kpi_card.dart';
import '../pages/my_bookings_page.dart';
import '../pages/client_profile_page.dart';
import '../../domain/entities/current_dashboard_entity.dart';
import '../../../bookings/presentation/cubit/my_bookings_cubit.dart';
import '../../../bookings/presentation/widgets/booking_card.dart';
import '../../../bookings/domain/entities/my_bookings_entity.dart';

class ClientDashboardOverview extends StatelessWidget {
  const ClientDashboardOverview({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<B2cOverviewCubit>()..fetchOverview(),
      child: const ClientDashboardOverviewView(),
    );
  }
}

class ClientDashboardOverviewView extends StatelessWidget {
  const ClientDashboardOverviewView({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;

    return BlocBuilder<B2cOverviewCubit, B2cOverviewState>(
      builder: (context, state) {
        if (state is B2cOverviewLoading) {
          return const Center(child: CircularProgressIndicator(color: AppColors.primary));
        } else if (state is B2cOverviewError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.redAccent, size: 48),
                const SizedBox(height: 16),
                Text(state.message, style: const TextStyle(color: Colors.white70)),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => context.read<B2cOverviewCubit>().fetchOverview(),
                  child: const Text('إعادة المحاولة'),
                ),
              ],
            ),
          );
        } else if (state is B2cOverviewLoaded) {
          final data = state.overview;
          return RefreshIndicator(
            onRefresh: () => context.read<B2cOverviewCubit>().fetchOverview(),
            color: AppColors.primary,
            child: SingleChildScrollView(
              padding: EdgeInsets.all(isMobile ? 16.0 : 32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildWelcomeHeader(isMobile),
                  const SizedBox(height: 32),
                  _buildKPIGrid(data.kpis, isMobile),
                  const SizedBox(height: 32),
                  _buildAccessibleModules(context, data.accessibleModules, isMobile),
                  const SizedBox(height: 40),
                  _buildRecentBookings(context, isMobile),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildWelcomeHeader(bool isMobile) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        String userName = '';
        if (state is Authenticated) {
          userName = state.user.name;
        }

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'مرحباً بك مجدداً،',
                  style: TextStyle(color: AppColors.textMuted, fontSize: 16),
                ),
                const SizedBox(height: 4),
                NeonText(
                  userName.isNotEmpty ? '$userName 👋' : 'عزيزي العميل 👋',
                  style: TextStyle(
                    fontSize: isMobile ? 28 : 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildKPIGrid(KpisEntity kpis, bool isMobile) {
    return GridView.count(
      crossAxisCount: isMobile ? 2 : 4,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: isMobile ? 1.2 : 1.3,
      children: [
        B2cKpiCard(
          title: 'إجمالي العملاء',
          value: kpis.totalCustomers.toString(),
          icon: Icons.people,
          color: Colors.blueAccent,
        ),
        B2cKpiCard(
          title: 'إجمالي القيمة',
          value: '\$${kpis.totalValue.toStringAsFixed(0)}',
          icon: Icons.attach_money,
          color: Colors.greenAccent,
        ),
        B2cKpiCard(
          title: 'جديد هذا الشهر',
          value: kpis.newThisMonth.toString(),
          icon: Icons.person_add,
          color: Colors.purpleAccent,
        ),
        B2cKpiCard(
          title: 'متوسط الإنفاق',
          value: '\$${kpis.avgSpend.toStringAsFixed(0)}',
          icon: Icons.trending_up,
          color: Colors.orangeAccent,
        ),
      ],
    );
  }

  Widget _buildAccessibleModules(BuildContext context, List<String> modules, bool isMobile) {
    final filteredModules = modules.where((m) => m != 'offers').toList();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'الوصول السريع',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: filteredModules.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: isMobile ? 2 : 4,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 2.5,
          ),
          itemBuilder: (context, index) {
            final module = filteredModules[index];
            IconData icon;
            String title;
            Widget targetPage;

            switch (module) {
              case 'my-bookings':
                icon = Icons.book_online;
                title = 'حجوزاتي';
                targetPage = const MyBookingsPage();
                break;
              case 'offers':
                icon = Icons.local_offer;
                title = 'العروض';
                targetPage = const Scaffold(body: Center(child: Text('صفحة العروض')));
                break;
              case 'profile':
                icon = Icons.person;
                title = 'الملف الشخصي';
                targetPage = const ClientProfilePage();
                break;
              default:
                icon = Icons.apps;
                title = module;
                targetPage = const SizedBox();
            }

            return InkWell(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => targetPage)),
              child: GlassContainer(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Icon(icon, color: Colors.blueAccent, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(color: Colors.white, fontSize: 13),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildRecentBookings(BuildContext context, bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'أحدث الحجوزات',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const MyBookingsPage()),
                );
              },
              child: const Text(
                'عرض الكل',
                style: TextStyle(color: AppColors.primary),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        BlocBuilder<MyBookingsCubit, MyBookingsState>(
          builder: (context, state) {
            if (state is MyBookingsLoading) {
              return const Center(child: CircularProgressIndicator(color: AppColors.primary));
            } else if (state is MyBookingsError) {
              return Center(
                child: Text(
                  state.message,
                  style: const TextStyle(color: Colors.redAccent),
                ),
              );
            } else if (state is MyBookingsLoaded) {
              final recent = state.bookings.allBookings.take(3).toList();
              if (recent.isEmpty) {
                return _buildEmptyState();
              }
              return Column(
                children: recent.map((b) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: BookingCard(booking: b),
                )).toList(),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return GlassContainer(
      padding: const EdgeInsets.all(32),
      child: Center(
        child: Column(
          children: [
            const Icon(Icons.event_note, color: Colors.white24, size: 48),
            const SizedBox(height: 16),
            const Text(
              'لا توجد حجوزات حالياً',
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 8),
            const Text(
              'ابدأ بحجز رحلتك القادمة الآن!',
              style: TextStyle(color: Colors.white38, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}
