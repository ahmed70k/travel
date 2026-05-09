import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travle/core/di/dependency_injection.dart';
import 'package:travle/core/theme/app_colors.dart';
import 'package:travle/core/widgets/neon_text.dart';

import '../cubit/admin_cars_cubit.dart';
import '../cubit/admin_cars_state.dart';
import '../../../shared/presentation/widgets/components/admin_date_filter.dart';
import '../widgets/admin_car_kpi_cards.dart';
import '../widgets/admin_car_filters.dart';
import '../widgets/admin_car_booking_card.dart';
import '../widgets/detailed_car_table.dart';

import 'admin_car_bookings_page.dart';
import 'create_car_booking_page.dart';

class AdminCarsPage extends StatelessWidget {
  const AdminCarsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;

    return BlocProvider(
      create: (context) => sl<AdminCarsCubit>()..getCars(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: BlocBuilder<AdminCarsCubit, AdminCarsState>(
          builder: (context, state) {
            if (state is AdminCarsLoading) {
              return _buildLoading();
            } else if (state is AdminCarsLoaded) {
              return RefreshIndicator(
                onRefresh: () => context.read<AdminCarsCubit>().refresh(),
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(isMobile ? 16.0 : 32.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(context, state, isMobile),
                      const SizedBox(height: 32),
                      AdminCarKPICards(kpis: state.data.kpis),
                      const SizedBox(height: 32),
                      AdminCarFilters(
                        filters: state.data.filters,
                        onFilterChanged: (carType, category) {
                          context.read<AdminCarsCubit>().getCars(
                            carType: carType,
                            category: category,
                          );
                        },
                      ),
                      const SizedBox(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.directions_car, color: Colors.blueAccent),
                              SizedBox(width: 8),
                              const Text(
                                'الإيجارات النشطة',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            'الإجمالي: ${state.data.bookings.length}',
                            style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      if (state.data.bookings.isEmpty)
                        _buildEmptyState()
                      else
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: state.data.bookings.length,
                          separatorBuilder: (context, index) => const SizedBox(height: 16),
                          itemBuilder: (context, index) =>
                              AdminCarBookingCard(booking: state.data.bookings[index]),
                        ),
                      const SizedBox(height: 32),
                      if (!isMobile) ...[
                        DetailedCarTable(
                          bookings: state.data.bookings,
                        ),
                        const SizedBox(height: 40),
                      ],
                    ],
                  ),
                ),
              );
            } else if (state is AdminCarsError) {
              return _buildError(context, state.message);
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AdminCarsLoaded state, bool isMobile) {
    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.end,
      spacing: 16,
      runSpacing: 16,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('الإدارة', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
                SizedBox(width: 4),
                Icon(Icons.chevron_left, color: AppColors.textMuted, size: 12),
                SizedBox(width: 4),
                Text('السيارات', style: TextStyle(color: Colors.white, fontSize: 12)),
              ],
            ),
            const SizedBox(height: 12),
            NeonText(
              'لوحة تحكم السيارات',
              style: TextStyle(
                fontSize: isMobile ? 28 : 40,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            if (!isMobile)
              AdminDateFilter(
                from: state.data.from,
                to: state.data.to,
                onDateChanged: (from, to) {
                  context.read<AdminCarsCubit>().getCars(from: from, to: to);
                },
              ),
            ElevatedButton.icon(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CreateCarBookingPage()),
                );
                if (result == true && context.mounted) {
                  context.read<AdminCarsCubit>().refresh();
                }
              },
              icon: const Icon(Icons.add, size: 20),
              label: Text(isMobile ? 'إضافة' : 'إضافة حجز'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 12 : 20,
                  vertical: isMobile ? 10 : 15,
                ),
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AdminCarBookingsPage()),
                );
              },
              icon: const Icon(Icons.list_alt, size: 20),
              label: Text(isMobile ? 'الحجوزات' : 'إدارة الحجوزات'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 12 : 20,
                  vertical: isMobile ? 10 : 15,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLoading() {
    return const Center(child: CircularProgressIndicator(color: AppColors.primary));
  }

  Widget _buildError(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Colors.redAccent, size: 48),
          const SizedBox(height: 16),
          Text(message, style: const TextStyle(color: Colors.white)),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => context.read<AdminCarsCubit>().getCars(),
            child: const Text('إعادة المحاولة'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 40),
          Icon(Icons.directions_car_outlined, color: Colors.white.withOpacity(0.1), size: 80),
          const SizedBox(height: 16),
          const Text(
            'لم يتم العثور على تأجير سيارات',
            style: TextStyle(color: AppColors.textMuted, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
