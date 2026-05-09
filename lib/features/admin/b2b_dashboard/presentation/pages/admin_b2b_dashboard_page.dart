import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travle/core/di/dependency_injection.dart';
import 'package:travle/core/theme/app_colors.dart';
import 'package:travle/features/admin/b2b_dashboard/presentation/cubit/admin_b2b_cubit.dart';
import 'package:travle/features/admin/b2b_dashboard/presentation/cubit/admin_b2b_state.dart';
import 'package:travle/features/admin/b2b_dashboard/presentation/widgets/admin_b2b_date_filter.dart';
import 'package:travle/features/admin/b2b_dashboard/presentation/widgets/admin_b2b_kpi_card.dart';
import 'package:travle/features/admin/b2b_dashboard/presentation/widgets/agency_distribution_pie_chart.dart';
import 'package:travle/features/admin/b2b_dashboard/presentation/widgets/top_agencies_bar_chart.dart';

class AdminB2BDashboardPage extends StatelessWidget {
  const AdminB2BDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AdminB2BCubit>()..fetchDashboard(),
      child: const _AdminB2BDashboardView(),
    );
  }
}

class _AdminB2BDashboardView extends StatelessWidget {
  const _AdminB2BDashboardView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.backgroundStart,
              AppColors.backgroundMiddle,
              AppColors.backgroundEnd,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: BlocBuilder<AdminB2BCubit, AdminB2BState>(
          builder: (context, state) {
            if (state is AdminB2BInitial || state is AdminB2BLoading) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );
            }

            if (state is AdminB2BError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, color: AppColors.error, size: 48),
                    const SizedBox(height: 16),
                    Text(
                      state.message,
                      style: const TextStyle(color: AppColors.error, fontSize: 16),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => context.read<AdminB2BCubit>().fetchDashboard(),
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                      child: const Text('إعادة المحاولة'),
                    ),
                  ],
                ),
              );
            }

            if (state is AdminB2BLoaded) {
              final data = state.dashboardData;
              final kpis = data.kpis;

              return RefreshIndicator(
                onRefresh: () async {
                  await context.read<AdminB2BCubit>().fetchDashboard(
                        from: data.dateRange.from,
                        to: data.dateRange.to,
                      );
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header & Date Filter
                      LayoutBuilder(
                        builder: (context, headerConstraints) {
                          final isSmallHeader = headerConstraints.maxWidth < 500;
                          if (isSmallHeader) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'تحليلات B2B',
                                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                        color: AppColors.textMain,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                const SizedBox(height: 16),
                                AdminB2BDateFilter(
                                  initialFrom: data.dateRange.from,
                                  initialTo: data.dateRange.to,
                                  onApply: (from, to) {
                                    context.read<AdminB2BCubit>().fetchDashboard(from: from, to: to);
                                  },
                                ),
                              ],
                            );
                          }
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'تحليلات B2B',
                                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                      color: AppColors.textMain,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              AdminB2BDateFilter(
                                initialFrom: data.dateRange.from,
                                initialTo: data.dateRange.to,
                                onApply: (from, to) {
                                  context.read<AdminB2BCubit>().fetchDashboard(from: from, to: to);
                                },
                              ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 32),

                      // KPI Cards
                      LayoutBuilder(
                        builder: (context, constraints) {
                          int crossAxisCount = 4;
                          if (constraints.maxWidth < 600) {
                            crossAxisCount = 1;
                          } else if (constraints.maxWidth < 900) {
                            crossAxisCount = 2;
                          }

                          return GridView.count(
                            crossAxisCount: crossAxisCount,
                            crossAxisSpacing: 24,
                            mainAxisSpacing: 24,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            childAspectRatio: 2,
                            children: [
                              AdminB2BKPICard(
                                title: 'إجمالي الوكالات',
                                value: kpis.totalAgencies,
                                icon: Icons.business,
                              ),
                              AdminB2BKPICard(
                                title: 'إجمالي الإيرادات',
                                value: kpis.totalRevenue,
                                icon: Icons.attach_money,
                                isCurrency: true,
                              ),
                              AdminB2BKPICard(
                                title: 'إجمالي العمولات',
                                value: kpis.totalCommission,
                                icon: Icons.money_off,
                                isCurrency: true,
                              ),
                              AdminB2BKPICard(
                                title: 'متوسط نسبة العمولة',
                                value: kpis.avgCommissionRate,
                                icon: Icons.percent,
                                isPercentage: true,
                              ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 32),

                      // Charts Section
                      LayoutBuilder(
                        builder: (context, constraints) {
                          if (constraints.maxWidth < 900) {
                            return Column(
                              children: [
                                SizedBox(
                                  height: 300,
                                  child: AgencyDistributionPieChart(
                                    distributions: data.agencyDistribution,
                                  ),
                                ),
                                const SizedBox(height: 24),
                                SizedBox(
                                  height: 350,
                                  child: TopAgenciesBarChart(
                                    agencies: data.topAgencies,
                                  ),
                                ),
                              ],
                            );
                          }

                          return IntrinsicHeight(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: AgencyDistributionPieChart(
                                    distributions: data.agencyDistribution,
                                  ),
                                ),
                                const SizedBox(width: 24),
                                Expanded(
                                  flex: 2,
                                  child: TopAgenciesBarChart(
                                    agencies: data.topAgencies,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }
}
