import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/neon_text.dart';
import '../../../../core/widgets/glass_container.dart';

class B2bHotelBookingsPage extends StatefulWidget {
  const B2bHotelBookingsPage({super.key});

  @override
  State<B2bHotelBookingsPage> createState() => _B2bHotelBookingsPageState();
}

class _B2bHotelBookingsPageState extends State<B2bHotelBookingsPage> {
  String _activeFilter = 'all';

  void _setFilter(String filter) {
    setState(() {
      _activeFilter = filter;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;

    return SingleChildScrollView(
      padding: EdgeInsets.all(isMobile ? 16.0 : 32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          _buildHeader(isMobile),
          const SizedBox(height: 32),

          // Stats
          _buildStatsGrid(isMobile),
          const SizedBox(height: 32),

          // Filters
          _buildFilters(),
          const SizedBox(height: 32),

          // Recent Bookings Cards
          _buildRecentBookingsList(isMobile),
          const SizedBox(height: 32),

          // Detailed Table
          _buildDetailedTable(isMobile),
          const SizedBox(height: 32),

          // Partner Companies
          _buildPartnerCompanies(isMobile),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildHeader(bool isMobile) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.home, color: Colors.purpleAccent, size: 16),
                const SizedBox(width: 8),
                const Text(
                  'الرئيسية',
                  style: TextStyle(color: AppColors.textMuted, fontSize: 14),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.chevron_left,
                  color: AppColors.textMuted,
                  size: 16,
                ),
                const SizedBox(width: 8),
                const Text(
                  'الحجوزات',
                  style: TextStyle(color: AppColors.textMuted, fontSize: 14),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.chevron_left,
                  color: AppColors.textMuted,
                  size: 16,
                ),
                const SizedBox(width: 8),
                const Text(
                  'حجوزات الفنادق',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 12),
            NeonText(
              'حجوزات الفنادق',
              style: TextStyle(
                fontSize: isMobile ? 28 : 36,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'إدارة ومتابعة جميع حجوزات الفنادق والمنتجعات لعملائك',
              style: TextStyle(color: AppColors.textMuted, fontSize: 14),
            ),
          ],
        ),
        if (!isMobile)
          ElevatedButton.icon(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purpleAccent,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: const Icon(Icons.add_circle_outline),
            label: const Text('حجز فندق جديد'),
          ),
      ],
    );
  }

  Widget _buildStatsGrid(bool isMobile) {
    return GridView.count(
      crossAxisCount: isMobile ? 2 : 4,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: isMobile ? 1.4 : 2.0,
      children: [
        _buildStatCard(
          'إجمالي حجوزات الفنادق',
          '98',
          Icons.hotel,
          Colors.pinkAccent,
        ),
        _buildStatCard(
          'إجمالي المبيعات',
          '89.6k\$',
          Icons.attach_money,
          Colors.greenAccent,
        ),
        _buildStatCard(
          'عمولات الفنادق',
          '8,960\$',
          Icons.percent,
          Colors.amber,
        ),
        _buildStatCard(
          'متوسط الإشغال',
          '74%',
          Icons.show_chart,
          Colors.blueAccent,
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
      padding: const EdgeInsets.all(16),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [color.withOpacity(0.1), Colors.transparent],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 12,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
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
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return GlassContainer(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final isMobile = constraints.maxWidth < 600;
              return Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  _buildTextField(
                    'الوجهة',
                    'المدينة أو اسم الفندق',
                    isMobile
                        ? constraints.maxWidth
                        : constraints.maxWidth / 5 - 16,
                  ),
                  _buildTextField(
                    'تاريخ الوصول',
                    'تاريخ',
                    isMobile
                        ? constraints.maxWidth
                        : constraints.maxWidth / 5 - 16,
                    isDate: true,
                  ),
                  _buildTextField(
                    'تاريخ المغادرة',
                    'تاريخ',
                    isMobile
                        ? constraints.maxWidth
                        : constraints.maxWidth / 5 - 16,
                    isDate: true,
                  ),
                  _buildDropdown(
                    'العميل',
                    ['جميع العملاء', 'محمد علي', 'سارة أحمد'],
                    isMobile
                        ? constraints.maxWidth
                        : constraints.maxWidth / 5 - 16,
                  ),
                  Container(
                    width: isMobile
                        ? constraints.maxWidth
                        : constraints.maxWidth / 5 - 16,
                    padding: const EdgeInsets.only(top: 24),
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purpleAccent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(Icons.search, size: 18),
                      label: const Text('بحث'),
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 16),
          const Divider(color: AppColors.glassBorder),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildFilterChip('all', 'جميع الحجوزات'),
              _buildFilterChip('confirmed', 'مؤكدة'),
              _buildFilterChip('pending', 'قيد الانتظار'),
              _buildFilterChip('cancelled', 'ملغية'),
              _buildFilterChip('completed', 'مكتملة'),
              _buildFilterChip('5stars', '5 نجوم'),
              _buildFilterChip('4stars', '4 نجوم'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    String label,
    String hint,
    double width, {
    bool isDate = false,
  }) {
    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
          ),
          const SizedBox(height: 8),
          TextField(
            style: const TextStyle(color: Colors.white, fontSize: 14),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: Colors.white30),
              filled: true,
              fillColor: Colors.white.withOpacity(0.05),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Colors.purpleAccent.withOpacity(0.3),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Colors.purpleAccent.withOpacity(0.3),
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              suffixIcon: isDate
                  ? const Icon(
                      Icons.calendar_today,
                      color: Colors.white54,
                      size: 18,
                    )
                  : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown(String label, List<String> items, double width) {
    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            dropdownColor: AppColors.backgroundStart,
            style: const TextStyle(color: Colors.white, fontSize: 14),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white.withOpacity(0.05),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Colors.purpleAccent.withOpacity(0.3),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Colors.purpleAccent.withOpacity(0.3),
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
            value: items.first,
            items: items
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: (val) {},
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String value, String label) {
    final isActive = _activeFilter == value;
    return GestureDetector(
      onTap: () => _setFilter(value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? null : Colors.white.withOpacity(0.05),
          gradient: isActive
              ? const LinearGradient(
                  colors: [AppColors.primary, AppColors.secondary],
                )
              : null,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.white : AppColors.textMuted,
            fontSize: 13,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildRecentBookingsList(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 16,
          runSpacing: 8,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.list, color: Colors.pinkAccent),
                const SizedBox(width: 8),
                const Text(
                  'قائمة حجوزات الفنادق',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Text(
              'آخر تحديث: اليوم 14:30',
              style: TextStyle(color: AppColors.textMuted, fontSize: 12),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildBookingCard(
          'فندق بورتو السخنة',
          'العين السخنة، مصر',
          4.5,
          '580\$',
          '10 يونيو 2025',
          '15 يونيو 2025',
          '5 ليال',
          'محمد علي',
          'مؤكد',
          Colors.pinkAccent,
          ['إفطار شامل'],
          '58\$ (10%)',
          isMobile,
        ),
        const SizedBox(height: 16),
        _buildBookingCard(
          'فندق جميرا بيتش',
          'دبي، الإمارات العربية المتحدة',
          4.9,
          '2,450\$',
          '01 يوليو 2025',
          '07 يوليو 2025',
          '6 ليال',
          'سارة أحمد',
          'مؤكد',
          Colors.blueAccent,
          ['إفطار + عشاء', 'مسبح خاص'],
          '245\$ (10%)',
          isMobile,
        ),
        const SizedBox(height: 16),
        _buildBookingCard(
          'فندق فور سيزونز',
          'القاهرة، مصر',
          4.8,
          '1,120\$',
          '28 مايو 2025',
          '30 مايو 2025',
          'ليلتان',
          'خالد يوسف',
          'قيد الانتظار',
          Colors.greenAccent,
          ['وايفاي مجاني'],
          '112\$ (10%)',
          isMobile,
        ),
      ],
    );
  }

  Widget _buildBookingCard(
    String hotel,
    String location,
    double rating,
    String price,
    String checkIn,
    String checkOut,
    String nights,
    String client,
    String status,
    Color color,
    List<String> amenities,
    String commission,
    bool isMobile,
  ) {
    return GlassContainer(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          isMobile
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(Icons.hotel, color: color, size: 28),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                hotel,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Row(
                                    children: List.generate(5, (index) {
                                      if (index < rating.floor()) {
                                        return const Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                          size: 14,
                                        );
                                      } else if (index == rating.floor() &&
                                          rating % 1 != 0) {
                                        return const Icon(
                                          Icons.star_half,
                                          color: Colors.amber,
                                          size: 14,
                                        );
                                      } else {
                                        return const Icon(
                                          Icons.star_border,
                                          color: Colors.amber,
                                          size: 14,
                                        );
                                      }
                                    }),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '$rating',
                                    style: const TextStyle(
                                      color: AppColors.textMuted,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(
                                    Icons.location_on,
                                    color: color,
                                    size: 12,
                                  ),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      location,
                                      style: const TextStyle(
                                        color: AppColors.textMuted,
                                        fontSize: 12,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          price,
                          style: const TextStyle(
                            color: Colors.purpleAccent,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          'إجمالي الإقامة',
                          style: TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 160,
                      height: 120,
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(Icons.hotel, color: color, size: 48),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    hotel,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Row(
                                        children: List.generate(5, (index) {
                                          if (index < rating.floor()) {
                                            return const Icon(
                                              Icons.star,
                                              color: Colors.amber,
                                              size: 14,
                                            );
                                          } else if (index == rating.floor() &&
                                              rating % 1 != 0) {
                                            return const Icon(
                                              Icons.star_half,
                                              color: Colors.amber,
                                              size: 14,
                                            );
                                          } else {
                                            return const Icon(
                                              Icons.star_border,
                                              color: Colors.amber,
                                              size: 14,
                                            );
                                          }
                                        }),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '$rating',
                                        style: const TextStyle(
                                          color: AppColors.textMuted,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.location_on,
                                        color: color,
                                        size: 14,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        location,
                                        style: const TextStyle(
                                          color: AppColors.textMuted,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    price,
                                    style: const TextStyle(
                                      color: Colors.purpleAccent,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Text(
                                    'إجمالي الإقامة',
                                    style: TextStyle(
                                      color: AppColors.textMuted,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
          const SizedBox(height: 16),
          const Divider(color: AppColors.glassBorder),
          const SizedBox(height: 16),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            alignment: WrapAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'الوصول',
                    style: TextStyle(color: AppColors.textMuted, fontSize: 12),
                  ),
                  Text(
                    checkIn,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'المغادرة',
                    style: TextStyle(color: AppColors.textMuted, fontSize: 12),
                  ),
                  Text(
                    checkOut,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'عدد الليالي',
                    style: TextStyle(color: AppColors.textMuted, fontSize: 12),
                  ),
                  Text(
                    nights,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'العميل',
                    style: TextStyle(color: AppColors.textMuted, fontSize: 12),
                  ),
                  Text(
                    client,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildStatusBadge(status),
                  ...amenities.map(
                    (e) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.greenAccent.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        e,
                        style: const TextStyle(
                          color: Colors.greenAccent,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.purpleAccent.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'عمولة: $commission',
                      style: const TextStyle(
                        color: Colors.purpleAccent,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              Wrap(
                spacing: 8,
                children: [
                  TextButton.icon(
                    onPressed: () {},
                    icon: Icon(Icons.remove_red_eye, size: 14, color: color),
                    label: Text(
                      'تفاصيل',
                      style: TextStyle(color: color, fontSize: 12),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.edit,
                      size: 14,
                      color: Colors.purpleAccent,
                    ),
                    label: const Text(
                      'تعديل',
                      style: TextStyle(
                        color: Colors.purpleAccent,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color bg;
    Color fg;
    if (status == 'مؤكد') {
      bg = Colors.greenAccent.withOpacity(0.2);
      fg = Colors.greenAccent;
    } else if (status == 'قيد الانتظار') {
      bg = Colors.amber.withOpacity(0.2);
      fg = Colors.amber;
    } else if (status == 'مكتمل') {
      bg = Colors.blueAccent.withOpacity(0.2);
      fg = Colors.blueAccent;
    } else {
      bg = Colors.grey.withOpacity(0.2);
      fg = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: fg.withOpacity(0.3)),
      ),
      child: Text(status, style: TextStyle(color: fg, fontSize: 12)),
    );
  }

  Widget _buildDetailedTable(bool isMobile) {
    return GlassContainer(
      padding: const EdgeInsets.all(0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 16,
              runSpacing: 8,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.table_chart, color: Colors.pinkAccent),
                    const SizedBox(width: 8),
                    const Text(
                      'كشف تفصيلي لحجوزات الفنادق',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.download,
                    size: 16,
                    color: Colors.pinkAccent,
                  ),
                  label: const Text(
                    'تصدير البيانات',
                    style: TextStyle(color: Colors.pinkAccent, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
          const Divider(color: AppColors.glassBorder, height: 1),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowColor: MaterialStateProperty.all(
                Colors.purpleAccent.withOpacity(0.1),
              ),
              dataRowColor: MaterialStateProperty.all(Colors.transparent),
              dividerThickness: 1,
              columns: const [
                DataColumn(
                  label: Text(
                    '# الحجز',
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'الفندق',
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'العميل',
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'الوصول',
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'المغادرة',
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'السعر الإجمالي',
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'عمولة الوكيل',
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'الحالة',
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'إجراءات',
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
              ],
              rows: [
                _buildTableRow(
                  'H-2034',
                  'بورتو السخنة',
                  'محمد علي',
                  '2025-06-10',
                  '2025-06-15',
                  '580\$',
                  '58\$',
                  'مؤكد',
                ),
                _buildTableRow(
                  'H-4512',
                  'جميرا بيتش',
                  'سارة أحمد',
                  '2025-07-01',
                  '2025-07-07',
                  '2,450\$',
                  '245\$',
                  'مؤكد',
                ),
                _buildTableRow(
                  'H-6723',
                  'فور سيزونز',
                  'خالد يوسف',
                  '2025-05-28',
                  '2025-05-30',
                  '1,120\$',
                  '112\$',
                  'قيد الانتظار',
                ),
                _buildTableRow(
                  'H-8901',
                  'هيلتون جاردن',
                  'نورة عبدالله',
                  '2025-04-10',
                  '2025-04-13',
                  '390\$',
                  '39\$',
                  'مكتمل',
                ),
              ],
            ),
          ),
          const Divider(color: AppColors.glassBorder, height: 1),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 16,
              runSpacing: 16,
              children: [
                const Text(
                  'عرض 4 من 98 حجز',
                  style: TextStyle(color: AppColors.textMuted, fontSize: 12),
                ),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildPageBtn('السابق', false),
                    _buildPageBtn('1', true),
                    _buildPageBtn('2', false),
                    _buildPageBtn('3', false),
                    _buildPageBtn('التالي', false),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  DataRow _buildTableRow(
    String id,
    String hotel,
    String client,
    String checkIn,
    String checkOut,
    String price,
    String commission,
    String status,
  ) {
    return DataRow(
      cells: [
        DataCell(Text(id, style: const TextStyle(color: Colors.white))),
        DataCell(Text(hotel, style: const TextStyle(color: Colors.white))),
        DataCell(Text(client, style: const TextStyle(color: Colors.white))),
        DataCell(Text(checkIn, style: const TextStyle(color: Colors.white))),
        DataCell(Text(checkOut, style: const TextStyle(color: Colors.white))),
        DataCell(
          Text(
            price,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        DataCell(
          Text(commission, style: const TextStyle(color: Colors.greenAccent)),
        ),
        DataCell(_buildStatusBadge(status)),
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.remove_red_eye,
                color: Colors.purpleAccent,
                size: 18,
              ),
              const SizedBox(width: 12),
              Icon(
                status == 'مؤكد' || status == 'مكتمل'
                    ? Icons.edit
                    : Icons.check,
                color: status == 'مؤكد' || status == 'مكتمل'
                    ? Colors.amber
                    : Colors.greenAccent,
                size: 18,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPageBtn(String text, bool active) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: active
            ? Colors.purpleAccent.withOpacity(0.3)
            : Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: active ? Colors.white : AppColors.textMuted,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildPartnerCompanies(bool isMobile) {
    return GlassContainer(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.handshake, color: Colors.pinkAccent),
              const SizedBox(width: 8),
              const Text(
                'شركات الفنادق الشريكة (مزودي الخدمة)',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: isMobile ? 2 : 4,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 2.5,
            children: [
              _buildPartnerCard(
                'HotelBeds',
                '3,200+ فندق',
                Icons.business,
                Colors.pinkAccent,
              ),
              _buildPartnerCard(
                'Booking.com',
                '2,800+ فندق',
                Icons.business,
                Colors.purpleAccent,
              ),
              _buildPartnerCard(
                'Expedia',
                '1,900+ فندق',
                Icons.business,
                Colors.blueAccent,
              ),
              _buildPartnerCard(
                'Agoda',
                '1,500+ فندق',
                Icons.business,
                Colors.greenAccent,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPartnerCard(
    String name,
    String details,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  details,
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
