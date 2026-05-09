import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/glass_container.dart';
import '../../../../core/widgets/neon_text.dart';
import '../../domain/entities/booking_entities.dart';
import '../cubit/my_bookings_cubit.dart';
import '../cubit/my_bookings_state.dart';
import '../widgets/booking_card.dart';
import '../widgets/empty_state_widget.dart';

class B2bMyBookingsPage extends StatefulWidget {
  const B2bMyBookingsPage({super.key});

  @override
  State<B2bMyBookingsPage> createState() => _B2bMyBookingsPageState();
}

class _B2bMyBookingsPageState extends State<B2bMyBookingsPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _statusFilter = 'All';
  
  final Map<String, String> _statusLabels = {
    'All': 'جميع الحالات',
    'Confirmed': 'مؤكد',
    'Pending': 'قيد الانتظار',
    'Cancelled': 'ملغى',
  };

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            _buildHeader(),
            _buildFilters(),
            const TabBar(
              tabs: [
                Tab(text: 'رحلات الطيران'),
                Tab(text: 'الفنادق'),
                Tab(text: 'السيارات'),
              ],
              labelColor: Colors.blueAccent,
              unselectedLabelColor: AppColors.textMuted,
              indicatorColor: Colors.blueAccent,
              indicatorWeight: 3,
            ),
            Expanded(
              child: BlocBuilder<B2BMyBookingsCubit, B2BMyBookingsState>(
                builder: (context, state) {
                  if (state is B2BMyBookingsLoading) {
                    return _buildLoadingState();
                  } else if (state is B2BMyBookingsError) {
                    return _buildErrorState(context, state.message);
                  } else if (state is B2BMyBookingsLoaded) {
                    return RefreshIndicator(
                      onRefresh: () => context.read<B2BMyBookingsCubit>().getMyBookings(forceRefresh: true),
                      child: TabBarView(
                        children: [
                          _buildBookingsList(context, _filterBookings(state.bookings.flights), 'flights'),
                          _buildBookingsList(context, _filterBookings(state.bookings.hotels), 'hotels'),
                          _buildBookingsList(context, _filterBookings(state.bookings.cars), 'cars'),
                        ],
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
              const Icon(Icons.home, color: Colors.blueAccent, size: 16),
              const SizedBox(width: 8),
              const Text('الرئيسية', style: TextStyle(color: AppColors.textMuted, fontSize: 14)),
              const SizedBox(width: 8),
              const Icon(Icons.chevron_left, color: AppColors.textMuted, size: 16),
              const SizedBox(width: 8),
              const Text('حجوزاتي', style: TextStyle(color: Colors.white, fontSize: 14)),
            ],
          ),
          const SizedBox(height: 12),
          const NeonText(
            'قائمة حجوزاتي',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'متابعة وإدارة جميع حجوزاتك الشخصية والمؤسسية',
            style: TextStyle(color: AppColors.textMuted, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
      child: GlassContainer(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _searchController,
                onChanged: (value) => setState(() => _searchQuery = value),
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'ابحث عن حجز...',
                  hintStyle: const TextStyle(color: Colors.white30),
                  prefixIcon: const Icon(Icons.search, color: Colors.blueAccent),
                  filled: true,
                  fillColor: Colors.white.withValues(alpha: 0.05),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            _buildStatusFilter(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusFilter() {
    return PopupMenuButton<String>(
      onSelected: (value) => setState(() => _statusFilter = value),
      itemBuilder: (context) => _statusLabels.entries.map((entry) {
        return PopupMenuItem<String>(
          value: entry.key,
          child: Text(entry.value),
        );
      }).toList(),
      child: GlassContainer(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            const Icon(Icons.filter_list, color: Colors.blueAccent, size: 20),
            const SizedBox(width: 8),
            Text(
              _statusLabels[_statusFilter] ?? _statusFilter,
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  List<dynamic> _filterBookings(List<dynamic> bookings) {
    if (_searchQuery.isEmpty && _statusFilter == 'All') return bookings;

    return bookings.where((booking) {
      // 1. Status Filter
      final bool matchesStatus = _statusFilter == 'All' || 
          (booking.status != null && 
           booking.status.toString().toLowerCase() == _statusFilter.toLowerCase());

      if (!matchesStatus) return false;

      // 2. Search Filter
      if (_searchQuery.isEmpty) return true;

      final query = _searchQuery.toLowerCase();
      
      if (booking is FlightBookingEntity) {
        return (booking.from.toLowerCase().contains(query) ||
                booking.to.toLowerCase().contains(query) ||
                booking.airlineName.toLowerCase().contains(query) ||
                booking.airlineCode.toLowerCase().contains(query));
      } else if (booking is HotelBookingEntity) {
        return (booking.hotelName.toLowerCase().contains(query) ||
                booking.location.toLowerCase().contains(query) ||
                booking.roomType.toLowerCase().contains(query));
      } else if (booking is CarBookingEntity) {
        return (booking.carModel.toLowerCase().contains(query) ||
                booking.pickupLocation.toLowerCase().contains(query) ||
                booking.returnLocation.toLowerCase().contains(query));
      }

      return false;
    }).toList();
  }

  Widget _buildBookingsList(BuildContext context, List<dynamic> bookings, String type) {
    if (bookings.isEmpty) {
      String title;
      String message;
      IconData icon;

      switch (type) {
        case 'flights':
          title = 'لا توجد حجوزات طيران';
          message = 'لم تقم بحجز أي رحلات طيران بعد.';
          icon = Icons.flight_takeoff;
          break;
        case 'hotels':
          title = 'لا توجد حجوزات فنادق';
          message = 'ابحث عن مكان إقامتك المفضل الآن.';
          icon = Icons.hotel;
          break;
        default:
          title = 'لا توجد حجوزات سيارات';
          message = 'استأجر سيارة لمغامرتك القادمة.';
          icon = Icons.directions_car;
      }

      return SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.5,
          child: EmptyStateWidget(
            title: title,
            message: message,
            icon: icon,
          ),
        ),
      );
    }

    final isTablet = MediaQuery.of(context).size.width > 900;

    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: isTablet ? (bookings.length / 2).ceil() : bookings.length,
      itemBuilder: (context, index) {
        if (!isTablet) {
          return BookingCard(booking: bookings[index]);
        }

        final firstIndex = index * 2;
        final secondIndex = firstIndex + 1;

        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: BookingCard(booking: bookings[firstIndex])),
              const SizedBox(width: 16),
              Expanded(
                child: secondIndex < bookings.length
                    ? BookingCard(booking: bookings[secondIndex])
                    : const SizedBox(),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLoadingState() {
    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: 5,
      itemBuilder: (context, index) => _buildSkeletonCard(),
    );
  }

  Widget _buildSkeletonCard() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: GlassContainer(
        height: 180,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(width: 80, height: 20, color: Colors.white10),
                Container(width: 60, height: 20, color: Colors.white10),
              ],
            ),
            const SizedBox(height: 20),
            Container(width: double.infinity, height: 24, color: Colors.white10),
            const SizedBox(height: 12),
            Container(width: 200, height: 16, color: Colors.white10),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(width: 100, height: 32, color: Colors.white10),
                Container(width: 120, height: 40, color: Colors.white10),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 60, color: Colors.redAccent),
          const SizedBox(height: 16),
          Text(
            message,
            style: const TextStyle(fontSize: 16, color: Colors.white70),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => context.read<B2BMyBookingsCubit>().getMyBookings(),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
            child: const Text('إعادة المحاولة'),
          ),
        ],
      ),
    );
  }
}
