import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/glass_container.dart';
import '../../../../core/widgets/neon_text.dart';
import '../cubit/b2b_hotel_bookings_cubit.dart';
import '../widgets/booking_card.dart';
import '../widgets/empty_state_widget.dart';
import '../widgets/b2b_create_hotel_booking_dialog.dart';

class B2bHotelBookingsPage extends StatefulWidget {
  const B2bHotelBookingsPage({super.key});

  @override
  State<B2bHotelBookingsPage> createState() => _B2bHotelBookingsPageState();
}

class _B2bHotelBookingsPageState extends State<B2bHotelBookingsPage> {
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
      create: (context) => sl<B2BHotelBookingsCubit>()..getHotelsBookings(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        floatingActionButton: BlocBuilder<B2BHotelBookingsCubit, B2BHotelBookingsState>(
          builder: (context, state) {
            return FloatingActionButton(
              onPressed: () => _showCreateBookingDialog(context),
              backgroundColor: Colors.orangeAccent,
              child: const Icon(Icons.add, color: Colors.white),
            );
          },
        ),
        body: Column(
          children: [
            _buildHeader(),
            _buildSearch(),
            Expanded(
              child: BlocConsumer<B2BHotelBookingsCubit, B2BHotelBookingsState>(
                listener: (context, state) {
                  if (state is B2BHotelBookingCreated) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('تم إنشاء حجز الفندق بنجاح')),
                    );
                    context.read<B2BHotelBookingsCubit>().getHotelsBookings();
                  } else if (state is B2BHotelBookingCreateError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('خطأ: ${state.message}')),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is B2BHotelBookingsLoading) {
                    return _buildLoadingState();
                  } else if (state is B2BHotelBookingsError) {
                    return _buildErrorState(context, state.message);
                  } else if (state is B2BHotelBookingsLoaded) {
                    final filtered = state.bookings.where((b) {
                      return b.hotelName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                             b.location.toLowerCase().contains(_searchQuery.toLowerCase());
                    }).toList();

                    if (filtered.isEmpty) {
                      return RefreshIndicator(
                        onRefresh: () => context.read<B2BHotelBookingsCubit>().getHotelsBookings(),
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.6,
                            child: const EmptyStateWidget(
                              title: 'لا توجد حجوزات فنادق',
                              message: 'لم يتم العثور على أي حجوزات تطابق بحثك.',
                              icon: Icons.hotel,
                            ),
                          ),
                        ),
                      );
                    }

                    return RefreshIndicator(
                      onRefresh: () => context.read<B2BHotelBookingsCubit>().getHotelsBookings(),
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
              const Icon(Icons.hotel, color: Colors.orangeAccent, size: 20),
              const SizedBox(width: 12),
              const NeonText(
                'حجوزات الفنادق',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'إدارة حجوزات الفنادق عبر /api/bookings/hotels',
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
            hintText: 'ابحث عن اسم الفندق أو المدينة...',
            hintStyle: const TextStyle(color: Colors.white30),
            prefixIcon: const Icon(Icons.search, color: Colors.orangeAccent),
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
            onPressed: () => context.read<B2BHotelBookingsCubit>().getHotelsBookings(),
            child: const Text('إعادة المحاولة'),
          ),
        ],
      ),
    );
  }

  void _showCreateBookingDialog(BuildContext context) {
    final cubit = context.read<B2BHotelBookingsCubit>();
    showDialog(
      context: context,
      builder: (context) => BlocProvider.value(
        value: cubit,
        child: const CreateB2BHotelBookingDialog(),
      ),
    );
  }
}
