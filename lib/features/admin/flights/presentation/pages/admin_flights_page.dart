import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travle/core/di/dependency_injection.dart';
import 'package:travle/core/theme/app_colors.dart';
import 'package:travle/core/widgets/neon_text.dart';
import '../cubit/admin_flights_cubit.dart';
import '../cubit/admin_flights_state.dart';
import '../../../shared/presentation/widgets/components/admin_date_filter.dart';
import '../widgets/admin_flight_kpi_cards.dart';
import '../widgets/admin_flight_filters.dart';
import '../widgets/admin_flight_booking_card.dart';
import '../widgets/detailed_flight_table.dart';
import '../widgets/create_flight_booking_dialog.dart';
import '../cubit/create_flight_booking_cubit.dart';

class AdminFlightsPage extends StatelessWidget {
  const AdminFlightsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;

    return BlocProvider(
      create: (context) => sl<AdminFlightsCubit>()..getFlights(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: BlocBuilder<AdminFlightsCubit, AdminFlightsState>(
          builder: (context, state) {
            if (state is AdminFlightsLoading) {
              return _buildLoading(isMobile);
            } else if (state is AdminFlightsLoaded) {
              return RefreshIndicator(
                onRefresh: () => context.read<AdminFlightsCubit>().refresh(),
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(isMobile ? 16.0 : 32.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(context, state, isMobile),
                      const SizedBox(height: 32),
                      AdminFlightKPICards(kpis: state.data.kpis),
                      const SizedBox(height: 32),
                      AdminFlightFilters(
                        filters: state.data.filters,
                        onFilterChanged: (tripType, category) {
                          context.read<AdminFlightsCubit>().getFlights(
                            tripType: tripType,
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
                              Icon(Icons.airplane_ticket, color: AppColors.primary),
                              SizedBox(width: 8),
                              Text(
                                'الحجوزات الأخيرة',
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
                              AdminFlightBookingCard(booking: state.data.bookings[index]),
                        ),
                      const SizedBox(height: 32),
                      if (!isMobile) ...[
                        DetailedFlightTable(bookings: state.data.bookings),
                        const SizedBox(height: 40),
                      ],
                    ],
                  ),
                ),
              );
            } else if (state is AdminFlightsError) {
              return _buildError(context, state.message);
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AdminFlightsLoaded state, bool isMobile) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Text('الإدارة', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
                SizedBox(width: 4),
                Icon(Icons.chevron_left, color: AppColors.textMuted, size: 12),
                SizedBox(width: 4),
                Text('الطيران', style: TextStyle(color: Colors.white, fontSize: 12)),
              ],
            ),
            const SizedBox(height: 12),
            NeonText(
              'لوحة تحكم الطيران',
              style: TextStyle(
                fontSize: isMobile ? 28 : 40,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Row(
          children: [
            if (!isMobile)
              AdminDateFilter(
                from: state.data.from,
                to: state.data.to,
                onDateChanged: (from, to) {
                  context.read<AdminFlightsCubit>().getFlights(from: from, to: to);
                },
              ),
            const SizedBox(width: 16),
            ElevatedButton.icon(
              onPressed: () => _showCreateDialog(context),
              icon: const Icon(Icons.add, size: 20),
              label: Text(isMobile ? 'إضافة' : 'إضافة حجز'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 12 : 20,
                  vertical: isMobile ? 10 : 15,
                ),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showCreateDialog(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (_) => BlocProvider.value(
        value: sl<CreateFlightBookingCubit>(),
        child: const CreateAdminFlightBookingDialog(),
      ),
    );

    if (result == true) {
      if (context.mounted) {
        context.read<AdminFlightsCubit>().refresh();
      }
    }
  }

  Widget _buildLoading(bool isMobile) {
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
            onPressed: () => context.read<AdminFlightsCubit>().getFlights(),
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
          Icon(Icons.airplane_ticket_outlined, color: Colors.white.withOpacity(0.1), size: 80),
          const SizedBox(height: 16),
          const Text(
            'لم يتم العثور على حجوزات طيران',
            style: TextStyle(color: AppColors.textMuted, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
