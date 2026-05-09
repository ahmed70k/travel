import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/di/dependency_injection.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/neon_text.dart';
import '../../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../../auth/presentation/cubit/auth_state.dart';
import '../cubit/admin_dashboard_cubit.dart';
import '../widgets/admin_dashboard_skeleton.dart';
import '../widgets/admin_date_filter.dart';
import '../widgets/admin_kpi_card.dart';
class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AdminDashboardCubit>()..fetchDashboard(),
      child: const AdminDashboardView(),
    );
  }
}

class AdminDashboardView extends StatelessWidget {
  const AdminDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: BlocBuilder<AdminDashboardCubit, AdminDashboardState>(
        builder: (context, state) {
          if (state is AdminDashboardLoading) {
            return const AdminDashboardSkeleton();
          } else if (state is AdminDashboardUnauthorized) {
            return _buildUnauthorized(context);
          } else if (state is AdminDashboardError) {
            return _buildError(context, state.message);
          } else if (state is AdminDashboardLoaded) {
            return RefreshIndicator(
              onRefresh: () =>
                  context.read<AdminDashboardCubit>().fetchDashboard(),
              color: Colors.blueAccent,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(context, state),
                    const SizedBox(height: 32),
                    _buildKPIGrid(context, state),
                    const SizedBox(height: 32),
                    // Add more sections here (Profit Chart, etc.)
                  ],
                ),
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AdminDashboardLoaded state) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, authState) {
        String adminName = '';
        if (authState is Authenticated) {
          adminName = authState.user.name;
        }

        return isMobile
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    adminName.isNotEmpty
                        ? 'مرحباً بك يا $adminName،'
                        : 'مرحباً بك مجدداً،',
                    style: const TextStyle(
                        color: AppColors.textMuted, fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  const NeonText(
                    'نظرة عامة على الإدارة 👋',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  AdminDateFilter(
                    from: state.dashboard.dateRange.from,
                    to: state.dashboard.dateRange.to,
                    onDateRangeSelected: (range) {
                      context.read<AdminDashboardCubit>().fetchDashboard(
                            from: range.start,
                            to: range.end,
                          );
                    },
                  ),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        adminName.isNotEmpty
                            ? 'مرحباً بك يا $adminName،'
                            : 'مرحباً بك مجدداً،',
                        style: const TextStyle(
                            color: AppColors.textMuted, fontSize: 16),
                      ),
                      const SizedBox(height: 4),
                      const NeonText(
                        'نظرة عامة على الإدارة 👋',
                        style:
                            TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  AdminDateFilter(
                    from: state.dashboard.dateRange.from,
                    to: state.dashboard.dateRange.to,
                    onDateRangeSelected: (range) {
                      context.read<AdminDashboardCubit>().fetchDashboard(
                            from: range.start,
                            to: range.end,
                          );
                    },
                  ),
                ],
              );
      },
    );
  }

  Widget _buildKPIGrid(BuildContext context, AdminDashboardLoaded state) {
    final kpis = state.dashboard.kpis;
    final width = MediaQuery.of(context).size.width;
    final crossAxisCount = width < 600 ? 1 : (width < 1200 ? 2 : 4);

    return GridView.count(
      crossAxisCount: crossAxisCount,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: crossAxisCount == 1 ? 2.2 : 1.2,
      children: [
        AdminKPICard(
          title: 'وكالات B2B',
          value: kpis.b2bAgencies.total.toInt().toString(),
          delta: kpis.b2bAgencies.delta,
          icon: Icons.business,
          color: Colors.blueAccent,
        ),
        AdminKPICard(
          title: 'عملاء B2C',
          value: kpis.b2cCustomers.total.toInt().toString(),
          delta: kpis.b2cCustomers.delta,
          icon: Icons.people_outline,
          color: Colors.greenAccent,
        ),
        AdminKPICard(
          title: 'إجمالي الأرباح',
          value:
              kpis.totalProfit.formatted ??
              '\$${kpis.totalProfit.total.toStringAsFixed(0)}',
          delta: kpis.totalProfit.delta,
          icon: Icons.attach_money,
          color: Colors.purpleAccent,
        ),
        AdminKPICard(
          title: 'إجمالي الحجوزات',
          value: kpis.totalBookings.total.toInt().toString(),
          delta: kpis.totalBookings.delta,
          icon: Icons.book_online_outlined,
          color: Colors.orangeAccent,
        ),
      ],
    );
  }

  Widget _buildUnauthorized(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.lock_outline, size: 64, color: Colors.redAccent),
          const SizedBox(height: 16),
          const Text(
            'غير مصرح لك بالدخول',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'هذه اللوحة مخصصة للمديرين فقط.',
            style: TextStyle(color: AppColors.textMuted),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('العودة'),
          ),
        ],
      ),
    );
  }

  Widget _buildError(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.redAccent),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () =>
                context.read<AdminDashboardCubit>().fetchDashboard(),
            child: const Text('إعادة المحاولة'),
          ),
        ],
      ),
    );
  }
}
