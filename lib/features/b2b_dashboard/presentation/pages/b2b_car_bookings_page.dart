import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/glass_container.dart';
import '../../../../core/widgets/neon_text.dart';
import '../cubit/b2b_car_bookings_cubit.dart';
import '../widgets/booking_card.dart';
import '../widgets/empty_state_widget.dart';
import '../widgets/b2b_create_car_booking_dialog.dart';

class B2bCarBookingsPage extends StatefulWidget {
  const B2bCarBookingsPage({super.key});

  @override
  State<B2bCarBookingsPage> createState() => _B2bCarBookingsPageState();
}

class _B2bCarBookingsPageState extends State<B2bCarBookingsPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<B2BCarBookingsCubit>()..getCarsBookings(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        floatingActionButton: BlocBuilder<B2BCarBookingsCubit, B2BCarBookingsState>(
          builder: (context, state) {
            return FloatingActionButton(
              onPressed: () => _showCreateBookingDialog(context),
              backgroundColor: Colors.greenAccent,
              child: const Icon(Icons.add, color: Colors.white),
            );
          },
        ),
        body: Column(
          children: [
            _buildHeader(),
            _buildSearch(),
            Expanded(
              child: BlocConsumer<B2BCarBookingsCubit, B2BCarBookingsState>(
                listener: (context, state) {
                  if (state is B2BCarBookingCreated) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('تم إنشاء حجز السيارة بنجاح')),
                    );
                    context.read<B2BCarBookingsCubit>().getCarsBookings();
                  } else if (state is B2BCarBookingCreateError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('خطأ: ${state.message}')),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is B2BCarBookingsLoading) {
                    return _buildLoadingState();
                  } else if (state is B2BCarBookingsError) {
                    return _buildErrorState(context, state.message);
                  } else if (state is B2BCarBookingsLoaded) {
                    final filtered = state.bookings.where((b) {
                      return b.carModel.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                             b.pickupLocation.toLowerCase().contains(_searchQuery.toLowerCase());
                    }).toList();

                    if (filtered.isEmpty) {
                      return RefreshIndicator(
                        onRefresh: () => context.read<B2BCarBookingsCubit>().getCarsBookings(),
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.6,
                            child: const EmptyStateWidget(
                              title: 'لا توجد حجوزات سيارات',
                              message: 'لم يتم العثور على أي حجوزات تطابق بحثك.',
                              icon: Icons.directions_car,
                            ),
                          ),
                        ),
                      );
                    }

                    return RefreshIndicator(
                      onRefresh: () => context.read<B2BCarBookingsCubit>().getCarsBookings(),
                      child: ListView.builder(
                        padding: const EdgeInsets.all(24),
                        itemCount: filtered.length,
                        itemBuilder: (context, index) => BookingCard(booking: filtered[index]),
                      ),
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.directions_car, color: Colors.greenAccent, size: 20),
              const SizedBox(width: 12),
              const NeonText(
                'حجوزات السيارات',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'إدارة حجوزات تأجير السيارات عبر /api/bookings/cars',
            style: TextStyle(color: AppColors.textMuted, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildSearch() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
      child: GlassContainer(
        padding: const EdgeInsets.all(8),
        child: TextField(
          controller: _searchController,
          onChanged: (value) => setState(() => _searchQuery = value),
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'ابحث عن موديل السيارة أو موقع الاستلام...',
            hintStyle: const TextStyle(color: Colors.white30),
            prefixIcon: const Icon(Icons.search, color: Colors.greenAccent),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 12),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(child: CircularProgressIndicator(color: AppColors.primary));
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 60, color: Colors.redAccent),
          const SizedBox(height: 16),
          Text(message, style: const TextStyle(color: Colors.white70)),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => context.read<B2BCarBookingsCubit>().getCarsBookings(),
            child: const Text('إعادة المحاولة'),
          ),
        ],
      ),
    );
  }

  void _showCreateBookingDialog(BuildContext context) {
    final cubit = context.read<B2BCarBookingsCubit>();
    showDialog(
      context: context,
      builder: (context) => BlocProvider.value(
        value: cubit,
        child: const CreateB2BCarBookingDialog(),
      ),
    );
  }
}
