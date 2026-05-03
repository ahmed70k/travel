import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travle/core/di/dependency_injection.dart';
import 'package:travle/core/theme/app_colors.dart';
import 'package:travle/core/widgets/neon_text.dart';
import '../cubit/admin_hotels_cubit.dart';
import '../cubit/admin_hotels_state.dart';
import '../../../../admin/dashboard/presentation/widgets/admin_date_filter.dart';
import '../widgets/admin_hotel_kpi_cards.dart';
import '../widgets/admin_hotel_filters.dart';
import '../widgets/admin_hotel_booking_card.dart';
import '../widgets/detailed_hotel_table.dart';

class AdminHotelsPage extends StatelessWidget {
  const AdminHotelsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;

    return BlocProvider(
      create: (context) => sl<AdminHotelsCubit>()..getHotels(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: BlocBuilder<AdminHotelsCubit, AdminHotelsState>(
          builder: (context, state) {
            if (state is AdminHotelsLoading) {
              return _buildLoading();
            } else if (state is AdminHotelsLoaded) {
              return RefreshIndicator(
                onRefresh: () => context.read<AdminHotelsCubit>().refresh(),
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(isMobile ? 16.0 : 32.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(context, state, isMobile),
                      const SizedBox(height: 32),
                      AdminHotelKPICards(kpis: state.data.kpis),
                      const SizedBox(height: 32),
                      AdminHotelFilters(
                        filters: state.data.filters,
                        onFilterChanged: (guestsCount, category) {
                          context.read<AdminHotelsCubit>().getHotels(
                            guestsCount: guestsCount,
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
                              Icon(Icons.hotel_outlined, color: AppColors.primary),
                              SizedBox(width: 8),
                              Text(
                                'Recent Bookings',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            'Total: ${state.data.bookings.length}',
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
                              AdminHotelBookingCard(booking: state.data.bookings[index]),
                        ),
                      const SizedBox(height: 32),
                      if (!isMobile) ...[
                        DetailedHotelTable(bookings: state.data.bookings),
                        const SizedBox(height: 40),
                      ],
                    ],
                  ),
                ),
              );
            } else if (state is AdminHotelsError) {
              return _buildError(context, state.message);
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AdminHotelsLoaded state, bool isMobile) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Text('Admin', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
                SizedBox(width: 4),
                Icon(Icons.chevron_left, color: AppColors.textMuted, size: 12),
                SizedBox(width: 4),
                Text('Hotels', style: TextStyle(color: Colors.white, fontSize: 12)),
              ],
            ),
            const SizedBox(height: 12),
            NeonText(
              'Hotels Dashboard',
              style: TextStyle(
                fontSize: isMobile ? 28 : 40,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        if (!isMobile)
          AdminDateFilter(
            from: state.data.from,
            to: state.data.to,
            onDateChanged: (from, to) {
              context.read<AdminHotelsCubit>().getHotels(from: from, to: to);
            },
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
            onPressed: () => context.read<AdminHotelsCubit>().getHotels(),
            child: const Text('Retry'),
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
          Icon(Icons.hotel_outlined, color: Colors.white.withOpacity(0.1), size: 80),
          const SizedBox(height: 16),
          const Text(
            'No hotel bookings found',
            style: TextStyle(color: AppColors.textMuted, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
