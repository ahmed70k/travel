import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/di/dependency_injection.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/neon_text.dart';
import '../cubit/admin_overview_cubit.dart';
import '../cubit/admin_overview_state.dart';
import '../widgets/admin_date_filter.dart';
import '../widgets/admin_kpi_cards.dart';
import '../widgets/admin_quick_actions.dart';
import '../widgets/admin_recent_bookings.dart';

class AdminDashboardOverview extends StatelessWidget {
  const AdminDashboardOverview({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;

    return BlocProvider(
      create: (context) => sl<AdminOverviewCubit>()..getOverview(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: BlocBuilder<AdminOverviewCubit, AdminOverviewState>(
          builder: (context, state) {
            if (state is AdminOverviewLoading) {
              return _buildSkeletonLoading(isMobile);
            } else if (state is AdminOverviewLoaded) {
              return RefreshIndicator(
                onRefresh: () => context.read<AdminOverviewCubit>().refresh(),
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(isMobile ? 16.0 : 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(context, state, isMobile),
                      const SizedBox(height: 32),
                      AdminKPICards(kpis: state.overview.kpis),
                      const SizedBox(height: 32),
                      if (isMobile) ...[
                        AdminRecentBookings(bookings: state.overview.bookings),
                        const SizedBox(height: 24),
                        AdminQuickActions(actions: state.overview.quickActions),
                      ] else
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 2,
                              child: AdminRecentBookings(bookings: state.overview.bookings),
                            ),
                            const SizedBox(width: 24),
                            Expanded(
                              flex: 1,
                              child: AdminQuickActions(actions: state.overview.quickActions),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              );
            } else if (state is AdminOverviewError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, color: Colors.redAccent, size: 48),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        state.message,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => context.read<AdminOverviewCubit>().getOverview(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AdminOverviewLoaded state, bool isMobile) {
    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NeonText(
            state.overview.greeting.title,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            state.overview.greeting.subtitle,
            style: const TextStyle(color: AppColors.textMuted),
          ),
          const SizedBox(height: 16),
          AdminDateFilter(
            from: state.overview.from,
            to: state.overview.to,
            onDateChanged: (from, to) {
              context.read<AdminOverviewCubit>().getOverview(from: from, to: to);
            },
          ),
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            NeonText(
              state.overview.greeting.title,
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              state.overview.greeting.subtitle,
              style: const TextStyle(color: AppColors.textMuted),
            ),
          ],
        ),
        AdminDateFilter(
          from: state.overview.from,
          to: state.overview.to,
          onDateChanged: (from, to) {
            context.read<AdminOverviewCubit>().getOverview(from: from, to: to);
          },
        ),
      ],
    );
  }

  Widget _buildSkeletonLoading(bool isMobile) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(isMobile ? 16.0 : 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 200,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const SizedBox(height: 32),
          GridView.count(
            shrinkWrap: true,
            crossAxisCount: isMobile ? 1 : 4,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            childAspectRatio: isMobile ? 2.5 : 1.5,
            children: List.generate(
              4,
              (index) => Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),
          if (isMobile) ...[
            Container(
              height: 300,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            const SizedBox(height: 24),
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ] else
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    height: 400,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  flex: 1,
                  child: Container(
                    height: 400,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
