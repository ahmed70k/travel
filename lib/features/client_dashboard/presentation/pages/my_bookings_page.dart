import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/neon_text.dart';
import '../../../../core/widgets/glass_container.dart';
import '../../../admin/domain/entities/dashboard_models.dart';
import '../state/client_providers.dart';

class MyBookingsPage extends ConsumerStatefulWidget {
  const MyBookingsPage({super.key});

  @override
  ConsumerState<MyBookingsPage> createState() => _MyBookingsPageState();
}

class _MyBookingsPageState extends ConsumerState<MyBookingsPage> {
  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;
    final activeFilter = ref.watch(clientBookingFilterProvider);
    final statusFilter = ref.watch(clientStatusFilterProvider);
    final allBookings = ref.watch(clientBookingsProvider);

    // Apply Filter logic (Simulated for UI)
    final filteredBookings = allBookings;

    return SingleChildScrollView(
      padding: EdgeInsets.all(isMobile ? 16.0 : 32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(isMobile),
          const SizedBox(height: 32),
          _buildClientStats(isMobile),
          const SizedBox(height: 32),
          _buildFilters(isMobile),
          const SizedBox(height: 32),

          // Booking Sections
          if (activeFilter == 'all' || activeFilter == 'flight') ...[
            _buildSectionHeader(
              'حجوزات الطيران',
              Icons.flight_takeoff,
              Colors.purpleAccent,
            ),
            const SizedBox(height: 16),
            _buildFlightBookings(),
            const SizedBox(height: 32),
          ],

          if (activeFilter == 'all' || activeFilter == 'hotel') ...[
            _buildSectionHeader(
              'حجوزات الفنادق',
              Icons.hotel,
              Colors.pinkAccent,
            ),
            const SizedBox(height: 16),
            _buildHotelBookings(),
            const SizedBox(height: 32),
          ],

          if (activeFilter == 'all' || activeFilter == 'car') ...[
            _buildSectionHeader(
              'تأجير السيارات',
              Icons.directions_car,
              Colors.blueAccent,
            ),
            const SizedBox(height: 16),
            _buildCarBookings(),
            const SizedBox(height: 32),
          ],

          const Text(
            'ملخص جميع الحجوزات',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildSummaryTable(filteredBookings),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildHeader(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.home, color: Colors.purpleAccent, size: 14),
            const SizedBox(width: 8),
            const Text(
              'الرئيسية',
              style: TextStyle(color: AppColors.textMuted, fontSize: 12),
            ),
            const SizedBox(width: 4),
            const Icon(
              Icons.chevron_left,
              color: AppColors.textMuted,
              size: 12,
            ),
            const SizedBox(width: 4),
            const Text(
              'حجوزاتي',
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ],
        ),
        const SizedBox(height: 12),
        NeonText(
          'حجوزاتي',
          style: TextStyle(
            fontSize: isMobile ? 28 : 40,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'جميع حجوزات الرحلات والفنادق والسيارات في مكان واحد',
          style: TextStyle(color: AppColors.textMuted),
        ),
      ],
    );
  }

  Widget _buildClientStats(bool isMobile) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: isMobile ? 2 : 4,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.5,
      children: [
        _buildStatCard(
          'إجمالي الحجوزات',
          '12',
          Icons.calendar_today,
          Colors.purpleAccent,
        ),
        _buildStatCard('رحلات قادمة', '2', Icons.flight, Colors.greenAccent),
        _buildStatCard('فنادق محجوزة', '3', Icons.hotel, Colors.pinkAccent),
        _buildStatCard('سيارات', '1', Icons.directions_car, Colors.blueAccent),
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
      padding: const EdgeInsets.all(16),
      animateHover: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 11,
                ),
              ),
              Icon(icon, color: color, size: 16),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters(bool isMobile) {
    final activeFilter = ref.watch(clientBookingFilterProvider);
    final statusFilter = ref.watch(clientStatusFilterProvider);

    return GlassContainer(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          _buildFilterChip('الجميع', 'all', activeFilter),
          _buildFilterChip('رحلات طيران', 'flight', activeFilter),
          _buildFilterChip('فنادق', 'hotel', activeFilter),
          _buildFilterChip('سيارات', 'car', activeFilter),
          const Spacer(),
          if (!isMobile)
            DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: statusFilter,
                dropdownColor: const Color(0xFF1E1A3A),
                style: const TextStyle(color: Colors.white, fontSize: 12),
                items: ['الجميع', 'مؤكد', 'قيد الانتظار', 'ملغي']
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                onChanged: (v) =>
                    ref.read(clientStatusFilterProvider.notifier).setStatus(v!),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String value, String activeFilter) {
    final isActive = activeFilter == value;
    return GestureDetector(
      onTap: () =>
          ref.read(clientBookingFilterProvider.notifier).setFilter(value),
      child: Container(
        margin: const EdgeInsets.only(left: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          gradient: isActive
              ? const LinearGradient(
                  colors: [Colors.purpleAccent, Colors.pinkAccent],
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

  Widget _buildSectionHeader(String title, IconData icon, Color color) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 24,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 12),
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildFlightBookings() {
    return _buildBookingCard(
      title: 'الخطوط القطرية',
      subtitle: 'QR 217 · رحلة مباشرة',
      price: '320\$',
      date: '20 مايو 2025',
      id: '#FL-1024',
      status: 'مؤكد',
      statusColor: Colors.greenAccent,
      icon: Icons.flight,
      iconBg: Colors.purpleAccent,
      details: Row(
        children: [
          _buildTimeNode('09:30', 'الدوحة'),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Icon(Icons.arrow_right_alt, color: Colors.purpleAccent),
          ),
          _buildTimeNode('13:15', 'القاهرة'),
        ],
      ),
    );
  }

  Widget _buildTimeNode(String time, String city) {
    return Column(
      children: [
        Text(
          time,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          city,
          style: const TextStyle(color: AppColors.textMuted, fontSize: 11),
        ),
      ],
    );
  }

  Widget _buildHotelBookings() {
    return _buildBookingCard(
      title: 'فندق بورتو السخنة',
      subtitle: 'العين السخنة، مصر',
      price: '580\$',
      date: '10-15 يونيو 2025',
      id: '#H-4502',
      status: 'مؤكد',
      statusColor: Colors.greenAccent,
      icon: Icons.hotel,
      iconBg: Colors.pinkAccent,
      details: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _SimpleField('الوصول', '10 يونيو'),
          _SimpleField('المغادرة', '15 يونيو'),
          _SimpleField('الغرفة', 'جناح ملكي'),
        ],
      ),
    );
  }

  Widget _buildCarBookings() {
    return _buildBookingCard(
      title: 'مرسيدس E-Class',
      subtitle: 'فاخرة · أوتوماتيك',
      price: '650\$',
      date: '10-15 يونيو 2025',
      id: '#C-8821',
      status: 'قيد الانتظار',
      statusColor: Colors.amber,
      icon: Icons.directions_car,
      iconBg: Colors.blueAccent,
      details: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _SimpleField('الاستلام', 'مطار الدوحة'),
          _SimpleField('المدة', '5 أيام'),
          _SimpleField('التأمين', 'شامل'),
        ],
      ),
    );
  }

  Widget _buildBookingCard({
    required String title,
    required String subtitle,
    required String price,
    required String date,
    required String id,
    required String status,
    required Color statusColor,
    required IconData icon,
    required Color iconBg,
    required Widget details,
  }) {
    return GlassContainer(
      padding: const EdgeInsets.all(20),
      animateHover: true,
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: iconBg.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: iconBg.withOpacity(0.3)),
                ),
                child: Icon(icon, color: iconBg, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    price,
                    style: const TextStyle(
                      color: Colors.purpleAccent,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    id,
                    style: const TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          details,
          const SizedBox(height: 24),
          const Divider(color: AppColors.glassBorder),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.calendar_today,
                    color: AppColors.textMuted,
                    size: 14,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    date,
                    style: const TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
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
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryTable(List<BookingModel> bookings) {
    return GlassContainer(
      padding: EdgeInsets.zero,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowColor: MaterialStateProperty.all(
            AppColors.primary.withOpacity(0.1),
          ),
          columns: const [
            DataColumn(
              label: Text(
                'رقم الحجز',
                style: TextStyle(color: AppColors.textMuted),
              ),
            ),
            DataColumn(
              label: Text(
                'الخدمة',
                style: TextStyle(color: AppColors.textMuted),
              ),
            ),
            DataColumn(
              label: Text(
                'التاريخ',
                style: TextStyle(color: AppColors.textMuted),
              ),
            ),
            DataColumn(
              label: Text(
                'السعر',
                style: TextStyle(color: AppColors.textMuted),
              ),
            ),
            DataColumn(
              label: Text(
                'الحالة',
                style: TextStyle(color: AppColors.textMuted),
              ),
            ),
          ],
          rows: bookings
              .map(
                (b) => DataRow(
                  cells: [
                    DataCell(
                      Text(b.id, style: const TextStyle(color: Colors.white70)),
                    ),
                    DataCell(
                      Text(
                        b.flightPath,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    DataCell(
                      Text(
                        b.date,
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ),
                    DataCell(
                      Text(
                        b.price,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    DataCell(_buildSmallBadge(b.status)),
                  ],
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  Widget _buildSmallBadge(BookingStatus status) {
    Color color = Colors.greenAccent;
    String label = 'مؤكد';
    if (status == BookingStatus.pending) {
      color = Colors.amber;
      label = 'قيد الانتظار';
    } else if (status == BookingStatus.payment_pending) {
      color = Colors.orangeAccent;
      label = 'انتظار الدفع';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(label, style: TextStyle(color: color, fontSize: 10)),
    );
  }
}

class _SimpleField extends StatelessWidget {
  final String label;
  final String value;
  const _SimpleField(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(color: AppColors.textMuted, fontSize: 10),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
