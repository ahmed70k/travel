import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/neon_text.dart';
import '../../../../core/widgets/glass_container.dart';
import '../../../admin/cars/presentation/cubit/admin_cars_cubit.dart';
import '../../../admin/cars/presentation/cubit/admin_cars_state.dart';
import '../../../admin/cars/domain/entities/admin_cars_entity.dart';

class ClientCarsPage extends StatefulWidget {
  const ClientCarsPage({super.key});

  @override
  State<ClientCarsPage> createState() => _ClientCarsPageState();
}

class _ClientCarsPageState extends State<ClientCarsPage> {
  String _activeFilter = 'الجميع';

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;

    return BlocBuilder<AdminCarsCubit, AdminCarsState>(
      builder: (context, state) {
        if (state is AdminCarsLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is AdminCarsError) {
          return Center(
            child: Text(
              state.message,
              style: const TextStyle(color: Colors.redAccent),
            ),
          );
        } else if (state is AdminCarsLoaded) {
          final carsData = state.data;
          return RefreshIndicator(
            onRefresh: () => context.read<AdminCarsCubit>().refresh(),
            child: SingleChildScrollView(
              padding: EdgeInsets.all(isMobile ? 16.0 : 32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  _buildHeader(isMobile),
                  const SizedBox(height: 32),

                  // Car Stats
                  _buildCarStats(carsData.kpis, isMobile),
                  const SizedBox(height: 32),

                  // Filters
                  _buildFilters(carsData.filters.categories),
                  const SizedBox(height: 32),

                  // Cars List
                  _buildCarsList(carsData.bookings, isMobile),
                  const SizedBox(height: 48),

                  // Insurance Note
                  _buildInsuranceBanner(),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildHeader(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.home, color: Colors.blueAccent, size: 14),
            SizedBox(width: 8),
            Text(
              'الرئيسية',
              style: TextStyle(color: AppColors.textMuted, fontSize: 12),
            ),
            SizedBox(width: 4),
            Icon(Icons.chevron_left, color: AppColors.textMuted, size: 12),
            SizedBox(width: 4),
            Text(
              'سياراتي المستأجرة',
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ],
        ),
        const SizedBox(height: 12),
        NeonText(
          'سياراتي المستأجرة',
          style: TextStyle(
            fontSize: isMobile ? 28 : 40,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'إدارة ومتابعة عقود تأجير السيارات الفاخرة',
          style: TextStyle(color: AppColors.textMuted),
        ),
      ],
    );
  }

  Widget _buildCarStats(CarKPIEntity kpis, bool isMobile) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: isMobile ? 2 : 4,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.8,
      children: [
        _buildStatCard(
          'إجمالي الحجوزات',
          kpis.totalCarBookings.toString(),
          Icons.directions_car,
          Colors.blueAccent,
        ),
        _buildStatCard(
          'إجمالي القيمة',
          '\$${kpis.carRevenue}',
          Icons.payments,
          Colors.greenAccent,
        ),
        _buildStatCard(
          'متوسط الأيام',
          '${kpis.avgRentalDays.toStringAsFixed(1)} يوم',
          Icons.event_available,
          Colors.purpleAccent,
        ),
        _buildStatCard(
          'الشركاء',
          kpis.carPartners.toString(),
          Icons.business,
          Colors.orangeAccent,
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return GlassContainer(
      padding: const EdgeInsets.all(12),
      animateHover: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(height: 8),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Text(
            title,
            style: const TextStyle(color: AppColors.textMuted, fontSize: 10),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildFilters(List<String> categories) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildFilterChip('الجميع', 'الجميع'),
          if (categories.isNotEmpty)
            ...categories.map((c) => _buildFilterChip(c, c)),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final isActive = _activeFilter == value;
    return GestureDetector(
      onTap: () => setState(() => _activeFilter = value),
      child: Container(
        margin: const EdgeInsets.only(left: 8),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          gradient: isActive
              ? const LinearGradient(
                  colors: [Colors.blueAccent, Colors.cyanAccent],
                )
              : null,
          color: isActive ? null : Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.white : AppColors.textMuted,
            fontSize: 12,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildCarsList(List<CarBookingEntity> bookings, bool isMobile) {
    if (bookings.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: Text(
            'لا توجد حجوزات سيارات',
            style: TextStyle(color: AppColors.textMuted),
          ),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: bookings.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final booking = bookings[index];
        return _buildCarCard(
          name: booking.car,
          type: 'سيارة مستأجرة',
          price: '\$${booking.price}',
          pickup: DateFormat('dd MMM yyyy').format(booking.pickupDate),
          dropoff: DateFormat('dd MMM yyyy').format(booking.returnDate),
          location: booking.route,
          status: booking.status,
          duration: booking.duration,
          statusColor: booking.status == 'confirmed'
              ? Colors.greenAccent
              : (booking.status == 'pending' ? Colors.orangeAccent : Colors.redAccent),
          icon: Icons.directions_car,
          features: ['تأمين شامل'],
        );
      },
    );
  }

  Widget _buildCarCard({
    required String name,
    required String type,
    required String price,
    required String pickup,
    required String dropoff,
    required String location,
    required String status,
    required String duration,
    required Color statusColor,
    required IconData icon,
    required List<String> features,
  }) {
    return GlassContainer(
      padding: const EdgeInsets.all(24),
      animateHover: true,
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.blueAccent.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.blueAccent.withOpacity(0.3)),
                ),
                child: Icon(icon, color: Colors.blueAccent, size: 40),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      type,
                      style: const TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    price,
                    style: const TextStyle(
                      color: Colors.blueAccent,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    duration,
                    style: const TextStyle(color: AppColors.textMuted, fontSize: 9),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Divider(color: AppColors.glassBorder),
          const SizedBox(height: 16),
          _buildLocationInfo(location),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildDateInfo('تاريخ الاستلام', pickup),
              _buildDateInfo('تاريخ الإعادة', dropoff),
            ],
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 8,
            runSpacing: 12,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: statusColor.withOpacity(0.3)),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ...features.map((f) => _buildFeatureTag(f)).toList(),
              _buildActionButton(label: 'تعديل الحجز'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({required String label}) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blueAccent.withOpacity(0.2),
        foregroundColor: Colors.white,
        side: const BorderSide(color: Colors.blueAccent),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      child: Text(label, style: const TextStyle(fontSize: 11)),
    );
  }

  Widget _buildLocationInfo(String location) {
    return Row(
      children: [
        const Icon(Icons.location_on, color: Colors.blueAccent, size: 16),
        const SizedBox(width: 8),
        Text(
          location,
          style: const TextStyle(color: Colors.white70, fontSize: 13),
        ),
      ],
    );
  }

  Widget _buildDateInfo(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: AppColors.textMuted, fontSize: 11),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureTag(String label) {
    return Container(
      margin: const EdgeInsets.only(left: 8),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: const TextStyle(color: Colors.white54, fontSize: 10),
      ),
    );
  }

  Widget _buildInsuranceBanner() {
    return GlassContainer(
      padding: const EdgeInsets.all(20),
      gradient: LinearGradient(
        colors: [Colors.blueAccent.withOpacity(0.2), Colors.transparent],
      ),
      child: const Row(
        children: [
          Icon(Icons.verified_user, color: Colors.blueAccent, size: 30),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'تأمين VIP شامل الحماية',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'حجزك الحالي يشمل حماية كاملة ضد الحوادث والسرقة لضمان راحتك.',
                  style: TextStyle(color: AppColors.textMuted, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
