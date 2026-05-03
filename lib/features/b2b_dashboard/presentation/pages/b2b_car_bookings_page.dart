import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/neon_text.dart';
import '../../../../core/widgets/glass_container.dart';

class B2bCarBookingsPage extends StatefulWidget {
  const B2bCarBookingsPage({super.key});

  @override
  State<B2bCarBookingsPage> createState() => _B2bCarBookingsPageState();
}

class _B2bCarBookingsPageState extends State<B2bCarBookingsPage> {
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

          // Detailed Table
          _buildDetailedTable(isMobile),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildHeader(bool isMobile) {
    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 16,
      runSpacing: 16,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 8,
              children: [
                const Icon(Icons.home, color: Colors.blueAccent, size: 16),
                const Text(
                  'الرئيسية',
                  style: TextStyle(color: AppColors.textMuted, fontSize: 14),
                ),
                const Icon(
                  Icons.chevron_left,
                  color: AppColors.textMuted,
                  size: 16,
                ),
                const Text(
                  'الحجوزات',
                  style: TextStyle(color: AppColors.textMuted, fontSize: 14),
                ),
                const Icon(
                  Icons.chevron_left,
                  color: AppColors.textMuted,
                  size: 16,
                ),
                const Text(
                  'السيارات والتأجير',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 12),
            NeonText(
              'السيارات والتأجير',
              style: TextStyle(
                fontSize: isMobile ? 28 : 36,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'إدارة حجوزات تأجير السيارات، العروض والعمولات.',
              style: TextStyle(color: AppColors.textMuted, fontSize: 14),
            ),
          ],
        ),
        ElevatedButton.icon(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          icon: const Icon(Icons.add_circle_outline),
          label: const Text('حجز سيارة جديد'),
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
          'إجمالي حجوزات السيارات',
          '67',
          Icons.directions_car,
          Colors.blueAccent,
          '+9%',
        ),
        _buildStatCard(
          'الحجوزات النشطة',
          '43',
          Icons.check_circle_outline,
          Colors.greenAccent,
          null,
        ),
        _buildStatCard(
          'قيد الانتظار',
          '16',
          Icons.access_time,
          Colors.amber,
          null,
        ),
        _buildStatCard(
          'إجمالي العمولات (8%)',
          '\$4,289',
          Icons.percent,
          Colors.purpleAccent,
          null,
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
    String? trend,
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
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      value,
                      style: TextStyle(
                        color: color,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (trend != null) ...[
                      const SizedBox(width: 8),
                      Text(
                        trend,
                        style: const TextStyle(
                          color: Colors.greenAccent,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ],
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
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 600;
          final double itemWidth = isMobile
              ? constraints.maxWidth
              : (constraints.maxWidth / 6) - 16;
          return Wrap(
            spacing: 16,
            runSpacing: 16,
            crossAxisAlignment: WrapCrossAlignment.end,
            children: [
              _buildTextField('اسم العميل', 'بحث باسم العميل', itemWidth),
              _buildTextField(
                'الموديل / السيارة',
                'مثال: تويوتا كامري',
                itemWidth,
              ),
              _buildDropdown('فئة السيارة', [
                'الكل',
                'اقتصادية',
                'SUV / دفع رباعي',
                'فاخرة',
              ], itemWidth),
              _buildDropdown('الحالة', [
                'الكل',
                'مؤكد',
                'قيد الانتظار',
                'مكتمل',
              ], itemWidth),
              _buildTextField(
                'تاريخ الاستلام من',
                'اختر تاريخ',
                itemWidth,
                isDate: true,
              ),
              SizedBox(
                width: itemWidth,
                child: OutlinedButton.icon(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.blueAccent,
                    side: const BorderSide(color: Colors.blueAccent),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.undo, size: 18),
                  label: const Text('إعادة تعيين'),
                ),
              ),
            ],
          );
        },
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
                  color: Colors.blueAccent.withOpacity(0.3),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Colors.blueAccent.withOpacity(0.3),
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
                  color: Colors.blueAccent.withOpacity(0.3),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Colors.blueAccent.withOpacity(0.3),
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
                    const Icon(Icons.directions_car, color: Colors.blueAccent),
                    const SizedBox(width: 8),
                    const Text(
                      'قائمة حجوزات السيارات والتأجير',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const Text(
                  'عرض 8 من 67',
                  style: TextStyle(color: AppColors.textMuted, fontSize: 12),
                ),
              ],
            ),
          ),
          const Divider(color: AppColors.glassBorder, height: 1),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowColor: MaterialStateProperty.all(
                Colors.blueAccent.withOpacity(0.1),
              ),
              dataRowColor: MaterialStateProperty.all(Colors.transparent),
              dividerThickness: 1,
              columns: const [
                DataColumn(
                  label: Text(
                    'العميل',
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'السيارة / الموديل',
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
                DataColumn(
                  label: Text('الفئة', style: TextStyle(color: Colors.white70)),
                ),
                DataColumn(
                  label: Text(
                    'تاريخ الاستلام',
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'تاريخ الرد',
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'السعر/اليوم',
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'الإجمالي',
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'العمولة',
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
                  'محمد علي',
                  'تويوتا كامري',
                  'اقتصادية',
                  '2025-05-18',
                  '2025-05-22',
                  '\$45',
                  '\$180',
                  '\$14.4',
                  'مؤكد',
                ),
                _buildTableRow(
                  'سارة أحمد',
                  'هوندا سي آر في',
                  'SUV',
                  '2025-05-20',
                  '2025-05-25',
                  '\$85',
                  '\$425',
                  '\$34.0',
                  'مؤكد',
                ),
                _buildTableRow(
                  'خالد يوسف',
                  'بي إم دبليو X5',
                  'فاخرة',
                  '2025-05-22',
                  '2025-05-28',
                  '\$150',
                  '\$900',
                  '\$72.0',
                  'قيد الانتظار',
                ),
                _buildTableRow(
                  'نورة خالد',
                  'شيفروليه ماليبو',
                  'اقتصادية',
                  '2025-06-01',
                  '2025-06-05',
                  '\$50',
                  '\$200',
                  '\$16.0',
                  'مؤكد',
                ),
                _buildTableRow(
                  'فيصل القحطاني',
                  'مرسيدس S-Class',
                  'فاخرة',
                  '2025-06-10',
                  '2025-06-15',
                  '\$220',
                  '\$1100',
                  '\$88.0',
                  'مؤكد',
                ),
                _buildTableRow(
                  'أحمد رضا',
                  'هيونداي توسان',
                  'SUV',
                  '2025-05-25',
                  '2025-05-30',
                  '\$70',
                  '\$350',
                  '\$28.0',
                  'مكتمل',
                ),
                _buildTableRow(
                  'منى السيد',
                  'نيسان صني',
                  'اقتصادية',
                  '2025-06-05',
                  '2025-06-09',
                  '\$35',
                  '\$140',
                  '\$11.2',
                  'قيد الانتظار',
                ),
                _buildTableRow(
                  'عمر فهد',
                  'لاند روفر رينج',
                  'فاخرة',
                  '2025-06-12',
                  '2025-06-18',
                  '\$190',
                  '\$1140',
                  '\$91.2',
                  'مؤكد',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  DataRow _buildTableRow(
    String client,
    String car,
    String category,
    String pickup,
    String dropoff,
    String dailyRate,
    String total,
    String commission,
    String status,
  ) {
    return DataRow(
      cells: [
        DataCell(
          Text(
            client,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.blueAccent.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              car,
              style: const TextStyle(
                color: Colors.lightBlueAccent,
                fontSize: 12,
              ),
            ),
          ),
        ),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.blueAccent.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              category,
              style: const TextStyle(
                color: Colors.lightBlueAccent,
                fontSize: 11,
              ),
            ),
          ),
        ),
        DataCell(Text(pickup, style: const TextStyle(color: Colors.white))),
        DataCell(Text(dropoff, style: const TextStyle(color: Colors.white))),
        DataCell(Text(dailyRate, style: const TextStyle(color: Colors.white))),
        DataCell(
          Text(
            total,
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
                color: Colors.blueAccent,
                size: 18,
              ),
              const SizedBox(width: 12),
              const Icon(
                Icons.delete_outline,
                color: Colors.redAccent,
                size: 18,
              ),
            ],
          ),
        ),
      ],
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
      bg = Colors.grey.withOpacity(0.2);
      fg = Colors.grey;
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
}
