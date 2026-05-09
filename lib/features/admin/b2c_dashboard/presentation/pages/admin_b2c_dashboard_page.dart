import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travle/core/di/dependency_injection.dart';
import 'package:travle/core/theme/app_colors.dart';
import 'package:travle/features/admin/b2c_dashboard/presentation/cubit/admin_b2c_cubit.dart';
import 'package:travle/features/admin/b2c_dashboard/presentation/cubit/admin_b2c_state.dart';
import 'package:travle/features/admin/b2c_dashboard/presentation/widgets/admin_b2c_date_filter.dart';
import 'package:travle/features/admin/b2c_dashboard/presentation/widgets/admin_b2c_kpi_card.dart';
import 'package:travle/features/admin/b2c_dashboard/presentation/widgets/customer_distribution_pie_chart.dart';
import 'package:travle/features/admin/b2c_dashboard/presentation/widgets/top_customers_bar_chart.dart';

class AdminB2CDashboardPage extends StatelessWidget {
  const AdminB2CDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AdminB2CCubit>()..fetchDashboard(),
      child: const _AdminB2CDashboardView(),
    );
  }
}

class _AdminB2CDashboardView extends StatelessWidget {
  const _AdminB2CDashboardView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // Background provided by layout
      body: BlocBuilder<AdminB2CCubit, AdminB2CState>(
        builder: (context, state) {
          if (state is AdminB2CInitial || state is AdminB2CLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          if (state is AdminB2CError) {
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
                      onPressed: () => context.read<AdminB2CCubit>().fetchDashboard(),
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                      child: const Text('إعادة المحاولة'),
                    ),
                ],
              ),
            );
          }

          if (state is AdminB2CLoaded) {
            final data = state.dashboardData;
            final kpis = data.kpis;

            return RefreshIndicator(
              onRefresh: () async {
                await context.read<AdminB2CCubit>().fetchDashboard(
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
                        final isSmallHeader = headerConstraints.maxWidth < 600;
                        return Flex(
                          direction: isSmallHeader ? Axis.vertical : Axis.horizontal,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: isSmallHeader ? CrossAxisAlignment.start : CrossAxisAlignment.center,
                          children: [
                            Text(
                              'إحصائيات العملاء B2C',
                              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24,
                                  ),
                            ),
                            if (isSmallHeader) const SizedBox(height: 16),
                            AdminB2CDateFilter(
                              initialFrom: data.dateRange.from,
                              initialTo: data.dateRange.to,
                              onApply: (from, to) {
                                context.read<AdminB2CCubit>().fetchDashboard(from: from, to: to);
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
                            AdminB2CKPICard(
                              title: 'إجمالي العملاء',
                              value: kpis.totalCustomers,
                              icon: Icons.people,
                            ),
                            AdminB2CKPICard(
                              title: 'العملاء النشطين',
                              value: kpis.activeCustomers,
                              icon: Icons.person_pin_circle,
                            ),
                            AdminB2CKPICard(
                              title: 'إجمالي الأرباح',
                              value: kpis.totalRevenue,
                              icon: Icons.attach_money,
                              isCurrency: true,
                            ),
                            AdminB2CKPICard(
                              title: 'إجمالي الحجوزات',
                              value: kpis.totalBookings,
                              icon: Icons.book_online,
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
                                child: CustomerDistributionPieChart(
                                  distributions: data.customerDistribution,
                                ),
                              ),
                              const SizedBox(height: 24),
                              SizedBox(
                                height: 350,
                                child: TopCustomersBarChart(
                                  customers: data.topCustomers,
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
                                child: CustomerDistributionPieChart(
                                  distributions: data.customerDistribution,
                                ),
                              ),
                              const SizedBox(width: 24),
                              Expanded(
                                flex: 2,
                                child: TopCustomersBarChart(
                                  customers: data.topCustomers,
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
    );
  }
}
