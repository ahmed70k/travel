import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/neon_text.dart';
import '../../../../core/widgets/glass_container.dart';

class B2bFlightBookingsPage extends StatefulWidget {
  const B2bFlightBookingsPage({super.key});

  @override
  State<B2bFlightBookingsPage> createState() => _B2bFlightBookingsPageState();
}

class _B2bFlightBookingsPageState extends State<B2bFlightBookingsPage> {
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
                  'حجوزات الطيران',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 12),
            NeonText(
              'حجوزات الطيران',
              style: TextStyle(
                fontSize: isMobile ? 28 : 36,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'إدارة ومتابعة جميع حجوزات رحلات الطيران لعملائك',
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
            label: const Text('حجز جديد'),
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
          'إجمالي حجوزات الطيران',
          '142',
          Icons.flight,
          Colors.purpleAccent,
        ),
        _buildStatCard(
          'إجمالي المبيعات',
          '142.8k\$',
          Icons.attach_money,
          Colors.greenAccent,
        ),
        _buildStatCard(
          'عمولات الطيران',
          '21,420\$',
          Icons.percent,
          Colors.amber,
        ),
        _buildStatCard(
          'معدل الإشغال',
          '86%',
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
                    'من',
                    'المدينة أو المطار',
                    isMobile
                        ? constraints.maxWidth
                        : constraints.maxWidth / 5 - 16,
                  ),
                  _buildTextField(
                    'إلى',
                    'المدينة أو المطار',
                    isMobile
                        ? constraints.maxWidth
                        : constraints.maxWidth / 5 - 16,
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
                const Icon(Icons.list, color: Colors.purpleAccent),
                const SizedBox(width: 8),
                const Text(
                  'قائمة الحجوزات الحديثة',
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
          'الخطوط القطرية',
          'QR 217 · رحلة مباشرة',
          '09:30',
          'الدوحة (DOH)',
          '13:15',
          'القاهرة (CAI)',
          '320\$',
          'مؤكد',
          Colors.purpleAccent,
          'محمد علي',
          '#FL-1024',
          '48\$ (15%)',
          isMobile,
        ),
        const SizedBox(height: 16),
        _buildBookingCard(
          'طيران الإمارات',
          'EK 304 · رحلة مباشرة',
          '08:00',
          'دبي (DXB)',
          '12:15',
          'اسطنبول (IST)',
          '850\$',
          'مؤكد',
          Colors.blueAccent,
          'سارة أحمد',
          '#FL-2108',
          '127.5\$ (15%)',
          isMobile,
        ),
        const SizedBox(height: 16),
        _buildBookingCard(
          'الخطوط السعودية',
          'SV 102 · رحلة مباشرة',
          '22:15',
          'الرياض (RUH)',
          '00:45',
          'اسطنبول (IST)',
          '410\$',
          'قيد الانتظار',
          Colors.greenAccent,
          'خالد يوسف',
          '#FL-9823',
          '61.5\$ (15%)',
          isMobile,
        ),
      ],
    );
  }

  Widget _buildBookingCard(
    String airline,
    String details,
    String depTime,
    String depLoc,
    String arrTime,
    String arrLoc,
    String price,
    String status,
    Color color,
    String client,
    String bookingId,
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
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(Icons.flight, color: color),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                airline,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                details,
                                style: const TextStyle(
                                  color: AppColors.textMuted,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Text(
                              depTime,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              depLoc,
                              style: const TextStyle(
                                color: AppColors.textMuted,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        Icon(Icons.arrow_back, color: color),
                        Column(
                          children: [
                            Text(
                              arrTime,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              arrLoc,
                              style: const TextStyle(
                                color: AppColors.textMuted,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
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
                              'شامل الضرائب',
                              style: TextStyle(
                                color: AppColors.textMuted,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            _buildStatusBadge(status),
                            const SizedBox(width: 8),
                            IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.more_vert, color: color),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                )
              : Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.flight, color: color),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            airline,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            details,
                            style: const TextStyle(
                              color: AppColors.textMuted,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              Text(
                                depTime,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                depLoc,
                                style: const TextStyle(
                                  color: AppColors.textMuted,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          Icon(Icons.arrow_back, color: color),
                          Column(
                            children: [
                              Text(
                                arrTime,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                arrLoc,
                                style: const TextStyle(
                                  color: AppColors.textMuted,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
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
                            'شامل الضرائب',
                            style: TextStyle(
                              color: AppColors.textMuted,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        _buildStatusBadge(status),
                        const SizedBox(width: 12),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.more_vert, color: color),
                        ),
                      ],
                    ),
                  ],
                ),
          const SizedBox(height: 16),
          const Divider(color: AppColors.glassBorder),
          const SizedBox(height: 12),
          Wrap(
            spacing: 16,
            runSpacing: 8,
            alignment: WrapAlignment.spaceBetween,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.person,
                    size: 14,
                    color: AppColors.textMuted,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'العميل: $client',
                    style: const TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.calendar_today,
                    size: 14,
                    color: AppColors.textMuted,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'الحجز: $bookingId',
                    style: const TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.percent,
                    size: 14,
                    color: Colors.greenAccent,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'عمولة الوكيل: $commission',
                    style: const TextStyle(
                      color: Colors.greenAccent,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {},
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'تفاصيل الحجز',
                      style: TextStyle(color: color, fontSize: 12),
                    ),
                    const SizedBox(width: 4),
                    Icon(Icons.arrow_back, color: color, size: 12),
                  ],
                ),
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
                    const Icon(Icons.table_chart, color: Colors.purpleAccent),
                    const SizedBox(width: 8),
                    const Text(
                      'كشف تفصيلي للحجوزات',
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
                    color: Colors.purpleAccent,
                  ),
                  label: const Text(
                    'تصدير البيانات',
                    style: TextStyle(color: Colors.purpleAccent, fontSize: 12),
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
                    'العميل',
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'الرحلة',
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'التاريخ',
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
                DataColumn(
                  label: Text('السعر', style: TextStyle(color: Colors.white70)),
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
                  'FL-1024',
                  'محمد علي',
                  'الدوحة → القاهرة',
                  '2025-05-20',
                  '320\$',
                  '48\$',
                  'مؤكد',
                ),
                _buildTableRow(
                  'FL-2108',
                  'سارة أحمد',
                  'دبي → لندن',
                  '2025-05-22',
                  '850\$',
                  '127.5\$',
                  'مؤكد',
                ),
                _buildTableRow(
                  'FL-9823',
                  'خالد يوسف',
                  'الرياض → اسطنبول',
                  '2025-05-25',
                  '410\$',
                  '61.5\$',
                  'قيد الانتظار',
                ),
                _buildTableRow(
                  'FL-4561',
                  'نورة خالد',
                  'القاهرة → نيويورك',
                  '2025-06-01',
                  '1,250\$',
                  '187.5\$',
                  'مؤكد',
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
                  'عرض 4 من 142 حجز',
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
    String client,
    String flight,
    String date,
    String price,
    String commission,
    String status,
  ) {
    return DataRow(
      cells: [
        DataCell(Text(id, style: const TextStyle(color: Colors.white))),
        DataCell(Text(client, style: const TextStyle(color: Colors.white))),
        DataCell(Text(flight, style: const TextStyle(color: Colors.white))),
        DataCell(Text(date, style: const TextStyle(color: Colors.white))),
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
                status == 'مؤكد' ? Icons.edit : Icons.check,
                color: status == 'مؤكد' ? Colors.amber : Colors.greenAccent,
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
}
