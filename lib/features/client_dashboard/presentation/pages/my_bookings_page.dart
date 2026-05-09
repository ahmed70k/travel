import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/neon_text.dart';
import '../../../../core/widgets/glass_container.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../b2c_bookings/presentation/cubit/b2c_car_bookings_cubit.dart';
import '../../../b2c_bookings/presentation/cubit/b2c_flight_bookings_cubit.dart';
import '../../../b2c_bookings/presentation/cubit/b2c_hotel_bookings_cubit.dart';
import '../../../bookings/presentation/cubit/my_bookings_cubit.dart';
import '../../../bookings/domain/entities/my_bookings_entity.dart';
import '../../../bookings/presentation/widgets/booking_card.dart';
import '../widgets/create_flight_booking_dialog.dart';
import '../widgets/create_hotel_booking_dialog.dart';
import '../widgets/create_car_booking_dialog.dart';

class MyBookingsPage extends StatefulWidget {
  const MyBookingsPage({super.key});

  @override
  State<MyBookingsPage> createState() => _MyBookingsPageState();
}

class _MyBookingsPageState extends State<MyBookingsPage> {
  String _activeFilter = 'all';

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;

    return BlocListener<MyBookingsCubit, MyBookingsState>(
      listener: (context, state) {
        if (state is MyBookingsError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      child: BlocBuilder<MyBookingsCubit, MyBookingsState>(
        builder: (context, state) {
          if (state is MyBookingsLoading) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primary));
          }
          if (state is MyBookingsLoaded) {
            final bookings = state.bookings;
            return SingleChildScrollView(
              padding: EdgeInsets.all(isMobile ? 16.0 : 32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context, isMobile),
                  const SizedBox(height: 32),
                  _buildCombinedStats(bookings, isMobile),
                  const SizedBox(height: 32),
                  _buildFilters(isMobile),
                  const SizedBox(height: 32),

                  if (_activeFilter == 'all' || _activeFilter == 'flight') ...[
                    _buildSectionHeader('حجوزات الطيران', Icons.flight_takeoff, Colors.purpleAccent),
                    const SizedBox(height: 16),
                    _buildFlightSection(bookings.flights),
                    const SizedBox(height: 32),
                  ],

                  if (_activeFilter == 'all' || _activeFilter == 'hotel') ...[
                    _buildSectionHeader('حجوزات الفنادق', Icons.hotel, Colors.pinkAccent),
                    const SizedBox(height: 16),
                    _buildHotelSection(bookings.hotels),
                    const SizedBox(height: 32),
                  ],

                  if (_activeFilter == 'all' || _activeFilter == 'car') ...[
                    _buildSectionHeader('تأجير السيارات', Icons.directions_car, Colors.blueAccent),
                    const SizedBox(height: 16),
                    _buildCarSection(bookings.cars),
                    const SizedBox(height: 32),
                  ],


                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildCombinedStats(MyBookingsEntity bookings, bool isMobile) {
    final stats = [
      _buildStatCard('الإجمالي', bookings.allBookings.length.toString(), Icons.calendar_today, Colors.white),
      _buildStatCard('طيران', bookings.flights.length.toString(), Icons.flight, Colors.purpleAccent),
      _buildStatCard('فنادق', bookings.hotels.length.toString(), Icons.hotel, Colors.pinkAccent),
      _buildStatCard('سيارات', bookings.cars.length.toString(), Icons.directions_car, Colors.blueAccent),
    ];

    if (isMobile) {
      return GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.5,
        children: stats,
      );
    }

    return Row(
      children: [
        Expanded(child: stats[0]),
        const SizedBox(width: 12),
        Expanded(child: stats[1]),
        const SizedBox(width: 12),
        Expanded(child: stats[2]),
        const SizedBox(width: 12),
        Expanded(child: stats[3]),
      ],
    );
  }

  Widget _buildFlightSection(List<BookingItemEntity> flights) {
    if (flights.isEmpty) {
      return const Center(child: Text('لا يوجد حجوزات طيران حالياً', style: TextStyle(color: AppColors.textMuted)));
    }
    return Column(
      children: flights.map((f) => Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: BookingCard(booking: f),
      )).toList(),
    );
  }

  Widget _buildHotelSection(List<BookingItemEntity> hotels) {
    if (hotels.isEmpty) {
      return const Center(child: Text('لا يوجد حجوزات فنادق حالياً', style: TextStyle(color: AppColors.textMuted)));
    }
    return Column(
      children: hotels.map((h) => Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: BookingCard(booking: h),
      )).toList(),
    );
  }

  Widget _buildCarSection(List<BookingItemEntity> cars) {
    if (cars.isEmpty) {
      return const Center(child: Text('لا يوجد حجوزات سيارات حالياً', style: TextStyle(color: AppColors.textMuted)));
    }
    return Column(
      children: cars.map((c) => Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: BookingCard(booking: c),
      )).toList(),
    );
  }

  void _showBookingTypeSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E1A3A),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      builder: (bottomSheetContext) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'اختر نوع الحجز',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            _buildBookingTypeItem(
              icon: Icons.flight_takeoff,
              color: Colors.purpleAccent,
              title: 'حجز طيران',
              onTap: () {
                final cubit = context.read<B2CFlightBookingsCubit>();
                final myBookingsCubit = context.read<MyBookingsCubit>();
                Navigator.pop(bottomSheetContext);
                showDialog(
                  context: context,
                  builder: (context) => BlocProvider.value(
                    value: cubit,
                    child: const CreateB2CFlightBookingDialog(),
                  ),
                ).then((_) => myBookingsCubit.getMyBookings(forceRefresh: true));
              },
            ),
            _buildBookingTypeItem(
              icon: Icons.hotel,
              color: Colors.pinkAccent,
              title: 'حجز فندق',
              onTap: () {
                final cubit = context.read<B2CHotelBookingsCubit>();
                final myBookingsCubit = context.read<MyBookingsCubit>();
                Navigator.pop(bottomSheetContext);
                showDialog(
                  context: context,
                  builder: (context) => BlocProvider.value(
                    value: cubit,
                    child: const CreateB2CHotelBookingDialog(),
                  ),
                ).then((_) => myBookingsCubit.getMyBookings(forceRefresh: true));
              },
            ),
            _buildBookingTypeItem(
              icon: Icons.directions_car,
              color: Colors.blueAccent,
              title: 'تأجير سيارة',
              onTap: () {
                final cubit = context.read<B2CCarBookingsCubit>();
                final myBookingsCubit = context.read<MyBookingsCubit>();
                Navigator.pop(bottomSheetContext);
                showDialog(
                  context: context,
                  builder: (context) => BlocProvider.value(
                    value: cubit,
                    child: const CreateB2CCarBookingDialog(),
                  ),
                ).then((_) => myBookingsCubit.getMyBookings(forceRefresh: true));
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingTypeItem({
    required IconData icon,
    required Color color,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      onTap: onTap,
    );
  }

  Widget _buildHeader(BuildContext context, bool isMobile) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const NeonText(
              'حجوزاتي',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            Text(
              'إدارة جميع رحلاتك وحجوزاتك في مكان واحد',
              style: TextStyle(color: AppColors.textMuted, fontSize: isMobile ? 12 : 14),
            ),
          ],
        ),
        ElevatedButton.icon(
          onPressed: () => _showBookingTypeSelector(context),
          icon: const Icon(Icons.add),
          label: const Text('حجز جديد'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return GlassContainer(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
              Icon(icon, color: color, size: 16),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(color: color, fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters(bool isMobile) {
    return GlassContainer(
      padding: const EdgeInsets.all(12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildFilterChip('الجميع', 'all', _activeFilter),
            _buildFilterChip('طيران', 'flight', _activeFilter),
            _buildFilterChip('فنادق', 'hotel', _activeFilter),
            _buildFilterChip('سيارات', 'car', _activeFilter),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, String value, String activeFilter) {
    final isActive = activeFilter == value;
    return GestureDetector(
      onTap: () => setState(() => _activeFilter = value),
      child: Container(
        margin: const EdgeInsets.only(left: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary.withOpacity(0.2) : Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isActive ? AppColors.primary : Colors.white10,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(color: isActive ? Colors.white : AppColors.textMuted, fontSize: 12),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 8),
        Text(title, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildSummaryTable(List<BookingItemEntity> bookings) {
    return GlassContainer(
      padding: EdgeInsets.zero,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: const [
            DataColumn(label: Text('المعرف', style: TextStyle(color: Colors.white70))),
            DataColumn(label: Text('النوع', style: TextStyle(color: Colors.white70))),
            DataColumn(label: Text('العنوان', style: TextStyle(color: Colors.white70))),
            DataColumn(label: Text('الحالة', style: TextStyle(color: Colors.white70))),
            DataColumn(label: Text('السعر', style: TextStyle(color: Colors.white70))),
          ],
          rows: bookings.map((b) => DataRow(cells: [
            DataCell(Text(b.id, style: const TextStyle(color: Colors.white))),
            DataCell(Text(b.bookingType, style: const TextStyle(color: Colors.white70))),
            DataCell(Text(b.title, style: const TextStyle(color: Colors.white))),
            DataCell(Text(b.status, style: const TextStyle(color: Colors.white70))),
            DataCell(Text('\$${b.price}', style: const TextStyle(color: Colors.greenAccent))),
          ])).toList(),
        ),
      ),
    );
  }
}
