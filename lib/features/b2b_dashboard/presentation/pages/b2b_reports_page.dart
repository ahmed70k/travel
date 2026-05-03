import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../core/theme/app_colors.dart';

class B2bReportsPage extends StatefulWidget {
  const B2bReportsPage({super.key});

  @override
  State<B2bReportsPage> createState() => _B2bReportsPageState();
}

class _B2bReportsPageState extends State<B2bReportsPage> {
  // Mock Data
  final List<Map<String, dynamic>> _allCommissions = [
    {
      'id': 1,
      'date': "2025-05-20",
      'customer': "محمد علي",
      'service': "طيران",
      'bookingRef': "FL-SV110",
      'amount': 320,
      'rate': 15,
      'commission': 48.0,
      'status': "paid",
    },
    {
      'id': 2,
      'date': "2025-05-22",
      'customer': "سارة أحمد",
      'service': "طيران",
      'bookingRef': "FL-EK205",
      'amount': 850,
      'rate': 15,
      'commission': 127.5,
      'status': "pending",
    },
    {
      'id': 3,
      'date': "2025-05-25",
      'customer': "خالد يوسف",
      'service': "طيران",
      'bookingRef': "FL-TK789",
      'amount': 410,
      'rate': 15,
      'commission': 61.5,
      'status': "paid",
    },
    {
      'id': 4,
      'date': "2025-05-18",
      'customer': "محمد علي",
      'service': "سيارة",
      'bookingRef': "CR-101",
      'amount': 180,
      'rate': 8,
      'commission': 14.4,
      'status': "paid",
    },
    {
      'id': 5,
      'date': "2025-05-20",
      'customer': "سارة أحمد",
      'service': "سيارة",
      'bookingRef': "CR-102",
      'amount': 425,
      'rate': 8,
      'commission': 34.0,
      'status': "processing",
    },
    {
      'id': 6,
      'date': "2025-05-22",
      'customer': "خالد يوسف",
      'service': "سيارة",
      'bookingRef': "CR-103",
      'amount': 900,
      'rate': 8,
      'commission': 72.0,
      'status': "pending",
    },
    {
      'id': 7,
      'date': "2025-05-10",
      'customer': "نورة خالد",
      'service': "فندق",
      'bookingRef': "HT-202",
      'amount': 1100,
      'rate': 10,
      'commission': 110.0,
      'status': "paid",
    },
    {
      'id': 8,
      'date': "2025-06-01",
      'customer': "نورة خالد",
      'service': "طيران",
      'bookingRef': "FL-QR101",
      'amount': 720,
      'rate': 15,
      'commission': 108.0,
      'status': "paid",
    },
    {
      'id': 9,
      'date': "2025-06-05",
      'customer': "فيصل القحطاني",
      'service': "سيارة",
      'bookingRef': "CR-108",
      'amount': 1140,
      'rate': 8,
      'commission': 91.2,
      'status': "pending",
    },
    {
      'id': 10,
      'date': "2025-06-10",
      'customer': "عمر فهد",
      'service': "طيران",
      'bookingRef': "FL-MS665",
      'amount': 1200,
      'rate': 15,
      'commission': 180.0,
      'status': "processing",
    },
    {
      'id': 11,
      'date': "2025-04-15",
      'customer': "أحمد رضا",
      'service': "فندق",
      'bookingRef': "HT-450",
      'amount': 670,
      'rate': 10,
      'commission': 67.0,
      'status': "paid",
    },
    {
      'id': 12,
      'date': "2025-04-22",
      'customer': "منى السيد",
      'service': "طيران",
      'bookingRef': "FL-BA149",
      'amount': 930,
      'rate': 15,
      'commission': 139.5,
      'status': "paid",
    },
    {
      'id': 13,
      'date': "2025-06-15",
      'customer': "عبدالله العتيبي",
      'service': "فندق",
      'bookingRef': "HT-512",
      'amount': 450,
      'rate': 10,
      'commission': 45.0,
      'status': "pending",
    },
    {
      'id': 14,
      'date': "2025-06-18",
      'customer': "ريم خالد",
      'service': "طيران",
      'bookingRef': "FL-SV333",
      'amount': 560,
      'rate': 15,
      'commission': 84.0,
      'status': "paid",
    },
  ];

  late List<Map<String, dynamic>> _filteredCommissions;

  String _selectedService = 'الكل';
  String _selectedStatus = 'الكل';
  String _dateFrom = '';
  String _dateTo = '';

  @override
  void initState() {
    super.initState();
    _filteredCommissions = List.from(_allCommissions);
  }

  void _applyFilters() {
    setState(() {
      _filteredCommissions = _allCommissions.where((c) {
        if (_selectedService != 'الكل' && c['service'] != _selectedService)
          return false;

        final statusMap = {
          'paid': 'مدفوعة',
          'pending': 'مستحقة',
          'processing': 'قيد المعالجة',
        };
        final cStatusAr = statusMap[c['status']] ?? 'الكل';
        if (_selectedStatus != 'الكل' && cStatusAr != _selectedStatus)
          return false;

        if (_dateFrom.isNotEmpty && c['date'].compareTo(_dateFrom) < 0)
          return false;
        if (_dateTo.isNotEmpty && c['date'].compareTo(_dateTo) > 0)
          return false;

        return true;
      }).toList();
    });
  }

  void _resetFilters() {
    setState(() {
      _selectedService = 'الكل';
      _selectedStatus = 'الكل';
      _dateFrom = '';
      _dateTo = '';
      _applyFilters();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 1000;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 24),
          _buildStatsGrid(isDesktop),
          const SizedBox(height: 24),
          if (isDesktop)
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(flex: 1, child: _buildMonthlyChartCard()),
                  const SizedBox(width: 24),
                  Expanded(flex: 1, child: _buildDistributionChartCard()),
                ],
              ),
            )
          else
            Column(
              children: [
                _buildMonthlyChartCard(),
                const SizedBox(height: 24),
                _buildDistributionChartCard(),
              ],
            ),
          const SizedBox(height: 24),
          _buildFiltersRow(isDesktop),
          const SizedBox(height: 24),
          SizedBox(height: 500, child: _buildCommissionsTable()),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 16,
      runSpacing: 16,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.home, color: Colors.purpleAccent, size: 14),
                const SizedBox(width: 8),
                const Text(
                  'الرئيسية',
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.chevron_left, color: Colors.grey, size: 14),
                const SizedBox(width: 8),
                const Text(
                  'تقارير العمولات',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [Colors.purpleAccent, Colors.pinkAccent],
              ).createShader(bounds),
              child: const Text(
                'تقارير العمولات',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'تحليل شامل لأرباح العمولات حسب الخدمة والفترة الزمنية',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ],
        ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            OutlinedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('سيتم تصدير PDF قريباً')),
                );
              },
              icon: const Icon(
                Icons.picture_as_pdf,
                color: Colors.purpleAccent,
              ),
              label: const Text(
                'تصدير PDF',
                style: TextStyle(color: Colors.purpleAccent),
              ),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                side: const BorderSide(color: Colors.purpleAccent),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            OutlinedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('سيتم تصدير Excel قريباً')),
                );
              },
              icon: const Icon(Icons.table_chart, color: Colors.greenAccent),
              label: const Text(
                'تصدير Excel',
                style: TextStyle(color: Colors.greenAccent),
              ),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                side: const BorderSide(color: Colors.greenAccent),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatsGrid(bool isDesktop) {
    double total = _filteredCommissions.fold(
      0,
      (sum, c) => sum + (c['commission'] as double),
    );
    double pending = _filteredCommissions
        .where((c) => c['status'] == 'pending')
        .fold(0, (sum, c) => sum + (c['commission'] as double));
    double paid = _filteredCommissions
        .where((c) => c['status'] == 'paid')
        .fold(0, (sum, c) => sum + (c['commission'] as double));
    double avgRate = _filteredCommissions.isEmpty
        ? 0
        : _filteredCommissions.fold(0.0, (sum, c) => sum + (c['rate'] as num)) /
              _filteredCommissions.length;

    return GridView.count(
      crossAxisCount: isDesktop
          ? 4
          : (MediaQuery.of(context).size.width > 600 ? 2 : 1),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: isDesktop ? 2.5 : 1.5,
      children: [
        _buildStatCard(
          'إجمالي العمولات',
          '\$${total.toStringAsFixed(1)}',
          Icons.trending_up,
          Colors.purpleAccent,
          '+18% عن الشهر الماضي',
        ),
        _buildStatCard(
          'العمولات المستحقة',
          '\$${pending.toStringAsFixed(1)}',
          Icons.schedule,
          Colors.amberAccent,
          'غير مصروفة بعد',
        ),
        _buildStatCard(
          'العمولات المدفوعة',
          '\$${paid.toStringAsFixed(1)}',
          Icons.check_circle,
          Colors.greenAccent,
          'تم التحويل للبنك',
        ),
        _buildStatCard(
          'متوسط نسبة العمولة',
          '${avgRate.toStringAsFixed(1)}%',
          Icons.percent,
          Colors.lightBlueAccent,
          'عبر جميع الخدمات',
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
    String subtitle,
  ) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.purpleAccent.withOpacity(0.12),
            Colors.pinkAccent.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                  overflow: TextOverflow.ellipsis,
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
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  style: TextStyle(color: color.withOpacity(0.8), fontSize: 11),
                  overflow: TextOverflow.ellipsis,
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
            child: Icon(icon, color: color, size: 28),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthlyChartCard() {
    return _GlassContainer(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.show_chart, color: Colors.purpleAccent),
              const SizedBox(width: 8),
              const Text(
                'تطور العمولات الشهرية',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 250,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 8000,
                barTouchData: BarTouchData(enabled: false),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const months = [
                          'يناير',
                          'فبراير',
                          'مارس',
                          'أبريل',
                          'مايو',
                          'يونيو',
                        ];
                        if (value.toInt() >= 0 &&
                            value.toInt() < months.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              months[value.toInt()],
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          );
                        }
                        return const Text('');
                      },
                      reservedSize: 30,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 10,
                          ),
                        );
                      },
                    ),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: Colors.white.withOpacity(0.05),
                    strokeWidth: 1,
                  ),
                ),
                borderData: FlBorderData(show: false),
                barGroups: [
                  _makeBarData(0, 3250),
                  _makeBarData(1, 4120),
                  _makeBarData(2, 3880),
                  _makeBarData(3, 5100),
                  _makeBarData(4, 6280),
                  _makeBarData(5, 7340),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  BarChartGroupData _makeBarData(int x, double y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: Colors.purpleAccent,
          width: 16,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: 8000,
            color: Colors.white.withOpacity(0.05),
          ),
        ),
      ],
    );
  }

  Widget _buildDistributionChartCard() {
    double flightTotal = _filteredCommissions
        .where((c) => c['service'] == 'طيران')
        .fold(0, (sum, c) => sum + (c['commission'] as double));
    double hotelTotal = _filteredCommissions
        .where((c) => c['service'] == 'فندق')
        .fold(0, (sum, c) => sum + (c['commission'] as double));
    double carTotal = _filteredCommissions
        .where((c) => c['service'] == 'سيارة')
        .fold(0, (sum, c) => sum + (c['commission'] as double));

    return _GlassContainer(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.pie_chart, color: Colors.pinkAccent),
              const SizedBox(width: 8),
              const Text(
                'توزيع العمولات حسب الخدمة',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 250,
            child: PieChart(
              PieChartData(
                sectionsSpace: 2,
                centerSpaceRadius: 60,
                sections: [
                  PieChartSectionData(
                    color: Colors.purpleAccent,
                    value: flightTotal,
                    title: 'طيران',
                    radius: 30,
                    titleStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  PieChartSectionData(
                    color: Colors.pinkAccent,
                    value: hotelTotal,
                    title: 'فنادق',
                    radius: 30,
                    titleStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  PieChartSectionData(
                    color: Colors.blueAccent,
                    value: carTotal,
                    title: 'سيارات',
                    radius: 30,
                    titleStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
      filled: true,
      fillColor: Colors.white.withOpacity(0.05),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.purpleAccent.withOpacity(0.3)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.purpleAccent.withOpacity(0.3)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.purpleAccent),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }

  Widget _buildFiltersRow(bool isDesktop) {
    return _GlassContainer(
      padding: const EdgeInsets.all(20),
      child: Wrap(
        spacing: 16,
        runSpacing: 16,
        crossAxisAlignment: WrapCrossAlignment.end,
        children: [
          SizedBox(
            width: isDesktop ? 150 : double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'نوع الخدمة',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: _selectedService,
                  dropdownColor: const Color(0xFF14122C),
                  style: const TextStyle(color: Colors.white),
                  decoration: _inputDecoration(''),
                  items: ['الكل', 'طيران', 'فندق', 'سيارة']
                      .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                      .toList(),
                  onChanged: (val) {
                    if (val != null) {
                      _selectedService = val;
                      _applyFilters();
                    }
                  },
                ),
              ],
            ),
          ),
          SizedBox(
            width: isDesktop ? 150 : double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'حالة العمولة',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: _selectedStatus,
                  dropdownColor: const Color(0xFF14122C),
                  style: const TextStyle(color: Colors.white),
                  decoration: _inputDecoration(''),
                  items: ['الكل', 'مدفوعة', 'مستحقة', 'قيد المعالجة']
                      .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                      .toList(),
                  onChanged: (val) {
                    if (val != null) {
                      _selectedStatus = val;
                      _applyFilters();
                    }
                  },
                ),
              ],
            ),
          ),
          SizedBox(
            width: isDesktop ? 150 : double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'من تاريخ',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                const SizedBox(height: 8),
                TextField(
                  style: const TextStyle(color: Colors.white),
                  decoration: _inputDecoration('YYYY-MM-DD'),
                  onChanged: (val) {
                    _dateFrom = val;
                    _applyFilters();
                  },
                ),
              ],
            ),
          ),
          SizedBox(
            width: isDesktop ? 150 : double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'إلى تاريخ',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                const SizedBox(height: 8),
                TextField(
                  style: const TextStyle(color: Colors.white),
                  decoration: _inputDecoration('YYYY-MM-DD'),
                  onChanged: (val) {
                    _dateTo = val;
                    _applyFilters();
                  },
                ),
              ],
            ),
          ),
          SizedBox(
            width: isDesktop ? 150 : double.infinity,
            height: 48,
            child: OutlinedButton.icon(
              onPressed: _resetFilters,
              icon: const Icon(
                Icons.undo,
                color: Colors.purpleAccent,
                size: 16,
              ),
              label: const Text(
                'إعادة تعيين',
                style: TextStyle(color: Colors.purpleAccent),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.purpleAccent),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommissionsTable() {
    return _GlassContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.table_view,
                      color: Colors.purpleAccent,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'سجل العمولات التفصيلي',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Text(
                  'عرض ${_filteredCommissions.length} سجل',
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
          const Divider(color: Colors.white10, height: 1),
          Expanded(
            child: _filteredCommissions.isEmpty
                ? const Center(
                    child: Text(
                      'لا توجد عمولات مطابقة للبحث',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: MediaQuery.of(context).size.width - 100,
                      ),
                      child: DataTable(
                        headingRowColor: WidgetStateProperty.all(
                          Colors.purpleAccent.withOpacity(0.1),
                        ),
                        dataRowColor: WidgetStateProperty.resolveWith<Color?>((
                          Set<WidgetState> states,
                        ) {
                          if (states.contains(WidgetState.hovered))
                            return Colors.purpleAccent.withOpacity(0.05);
                          return null;
                        }),
                        columns: const [
                          DataColumn(
                            label: Text(
                              'تاريخ الحجز',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'العميل',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'الخدمة',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'رقم الحجز',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'المبلغ (\$)',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'نسبة العمولة',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'قيمة العمولة (\$)',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'الحالة',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ],
                        rows: _filteredCommissions.map((c) {
                          return DataRow(
                            cells: [
                              DataCell(
                                Text(
                                  c['date'],
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                              DataCell(
                                Text(
                                  c['customer'],
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                              DataCell(
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.purpleAccent.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    c['service'],
                                    style: const TextStyle(
                                      color: Colors.purpleAccent,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                              DataCell(
                                Text(
                                  c['bookingRef'],
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              ),
                              DataCell(
                                Text(
                                  '\$${c['amount']}',
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                              DataCell(
                                Text(
                                  '${c['rate']}%',
                                  style: const TextStyle(
                                    color: Colors.lightBlueAccent,
                                  ),
                                ),
                              ),
                              DataCell(
                                Text(
                                  '\$${c['commission']}',
                                  style: const TextStyle(
                                    color: Colors.greenAccent,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              DataCell(_buildStatusBadge(c['status'])),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    String text;
    if (status == 'paid') {
      color = Colors.greenAccent;
      text = 'مدفوعة';
    } else if (status == 'pending') {
      color = Colors.amberAccent;
      text = 'مستحقة';
    } else {
      color = Colors.blueAccent;
      text = 'قيد المعالجة';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        border: Border.all(color: color.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(text, style: TextStyle(color: color, fontSize: 12)),
    );
  }
}

class _GlassContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;

  const _GlassContainer({required this.child, this.padding});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: const Color(0xFF0F0C29).withOpacity(0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.purpleAccent.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 32,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: child,
        ),
      ),
    );
  }
}
