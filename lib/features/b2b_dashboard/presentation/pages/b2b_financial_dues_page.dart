import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class B2bFinancialDuesPage extends StatefulWidget {
  const B2bFinancialDuesPage({super.key});

  @override
  State<B2bFinancialDuesPage> createState() => _B2bFinancialDuesPageState();
}

class _B2bFinancialDuesPageState extends State<B2bFinancialDuesPage> {
  // Mock Data
  final List<Map<String, dynamic>> _transactions = [
    {
      'id': 1,
      'date': "2025-05-20",
      'description': "عمولة حجز طيران - محمد علي",
      'service': "طيران",
      'bookingRef': "FL-SV110",
      'amount': 48.0,
      'type': "commission",
      'status': "paid",
    },
    {
      'id': 2,
      'date': "2025-05-22",
      'description': "عمولة حجز طيران - سارة أحمد",
      'service': "طيران",
      'bookingRef': "FL-EK205",
      'amount': 127.5,
      'type': "commission",
      'status': "pending",
    },
    {
      'id': 3,
      'date': "2025-05-25",
      'description': "عمولة حجز طيران - خالد يوسف",
      'service': "طيران",
      'bookingRef': "FL-TK789",
      'amount': 61.5,
      'type': "commission",
      'status': "paid",
    },
    {
      'id': 4,
      'date': "2025-05-18",
      'description': "عمولة حجز سيارة - محمد علي",
      'service': "سيارة",
      'bookingRef': "CR-101",
      'amount': 14.4,
      'type': "commission",
      'status': "paid",
    },
    {
      'id': 5,
      'date': "2025-05-20",
      'description': "عمولة حجز سيارة - سارة أحمد",
      'service': "سيارة",
      'bookingRef': "CR-102",
      'amount': 34.0,
      'type': "commission",
      'status': "processing",
    },
    {
      'id': 6,
      'date': "2025-05-22",
      'description': "عمولة حجز سيارة - خالد يوسف",
      'service': "سيارة",
      'bookingRef': "CR-103",
      'amount': 72.0,
      'type': "commission",
      'status': "pending",
    },
    {
      'id': 7,
      'date': "2025-05-10",
      'description': "عمولة حجز فندق - نورة خالد",
      'service': "فندق",
      'bookingRef': "HT-202",
      'amount': 110.0,
      'type': "commission",
      'status': "paid",
    },
    {
      'id': 8,
      'date': "2025-06-01",
      'description': "عمولة حجز طيران - نورة خالد",
      'service': "طيران",
      'bookingRef': "FL-QR101",
      'amount': 108.0,
      'type': "commission",
      'status': "paid",
    },
    {
      'id': 9,
      'date': "2025-06-05",
      'description': "عمولة حجز سيارة - فيصل القحطاني",
      'service': "سيارة",
      'bookingRef': "CR-108",
      'amount': 91.2,
      'type': "commission",
      'status': "pending",
    },
    {
      'id': 10,
      'date': "2025-06-10",
      'description': "عمولة حجز طيران - عمر فهد",
      'service': "طيران",
      'bookingRef': "FL-MS665",
      'amount': 180.0,
      'type': "commission",
      'status': "processing",
    },
    {
      'id': 11,
      'date': "2025-04-15",
      'description': "عمولة حجز فندق - أحمد رضا",
      'service': "فندق",
      'bookingRef': "HT-450",
      'amount': 67.0,
      'type': "commission",
      'status': "paid",
    },
    {
      'id': 12,
      'date': "2025-06-15",
      'description': "عمولة حجز طيران - منى السيد",
      'service': "طيران",
      'bookingRef': "FL-BA149",
      'amount': 139.5,
      'type': "commission",
      'status': "paid",
    },
  ];

  final List<Map<String, dynamic>> _withdrawals = [
    {
      'id': 101,
      'date': "2025-04-15",
      'description': "سحب أرباح - تحويل بنكي",
      'service': "سحب",
      'bookingRef': "WD-001",
      'amount': 250.0,
      'type': "withdrawal",
      'status': "completed",
    },
    {
      'id': 102,
      'date': "2025-03-10",
      'description': "سحب أرباح - تحويل بنكي",
      'service': "سحب",
      'bookingRef': "WD-002",
      'amount': 180.0,
      'type': "withdrawal",
      'status': "completed",
    },
  ];

  late List<Map<String, dynamic>> _allTransactions;
  double _currentBalance = 0;
  double _processingAmount = 0;
  double _totalWithdrawn = 0;

  @override
  void initState() {
    super.initState();
    _calculateBalances();
  }

  void _calculateBalances() {
    _allTransactions = [..._transactions, ..._withdrawals]
      ..sort((a, b) => b['date'].compareTo(a['date']));

    double paidCommissions = _transactions
        .where((t) => t['type'] == 'commission' && t['status'] == 'paid')
        .fold(0, (sum, t) => sum + (t['amount'] as double));
    double processingCommissions = _transactions
        .where((t) => t['type'] == 'commission' && t['status'] == 'processing')
        .fold(0, (sum, t) => sum + (t['amount'] as double));

    _totalWithdrawn = _withdrawals.fold(
      0,
      (sum, w) => sum + (w['amount'] as double),
    );
    _currentBalance = paidCommissions - _totalWithdrawn;
    _processingAmount = processingCommissions;
  }

  void _requestWithdraw() {
    if (_currentBalance <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            '⚠️ لا يوجد رصيد متاح للسحب حالياً',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    final controller = TextEditingController(
      text: _currentBalance.toStringAsFixed(0),
    );

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF14122C),
        title: const Text(
          'طلب سحب مستحقات',
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'الرصيد المتاح: \$${_currentBalance.toStringAsFixed(2)}',
              style: const TextStyle(
                color: Colors.greenAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'أدخل المبلغ المطلوب سحبه (الحد الأدنى \$100):',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white.withOpacity(0.05),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Colors.purpleAccent.withOpacity(0.3),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.purpleAccent),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('إلغاء', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purpleAccent,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              final val = double.tryParse(controller.text) ?? 0;
              if (val >= 100 && val <= _currentBalance) {
                setState(() {
                  _withdrawals.insert(0, {
                    'id': DateTime.now().millisecondsSinceEpoch,
                    'date': DateTime.now().toIso8601String().substring(0, 10),
                    'description': 'طلب سحب أرباح - تحويل بنكي',
                    'service': 'سحب',
                    'bookingRef':
                        'WD-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
                    'amount': val,
                    'type': 'withdrawal',
                    'status': 'processing',
                  });
                  _calculateBalances();
                });
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        const Icon(
                          Icons.check_circle,
                          color: Colors.greenAccent,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '✅ تم إرسال طلب سحب بمبلغ \$$val بنجاح',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                    backgroundColor: const Color(0xFF0F0C29),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(color: Colors.greenAccent),
                    ),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      '⚠️ المبلغ غير صالح أو أقل من الحد الأدنى \$100 أو يتجاوز الرصيد',
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Colors.redAccent,
                  ),
                );
              }
            },
            child: const Text('تأكيد الطلب'),
          ),
        ],
      ),
    );
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
                  Expanded(flex: 1, child: _buildEarningsChartCard()),
                  const SizedBox(width: 24),
                  Expanded(flex: 1, child: _buildDistributionChartCard()),
                ],
              ),
            )
          else
            Column(
              children: [
                _buildEarningsChartCard(),
                const SizedBox(height: 24),
                _buildDistributionChartCard(),
              ],
            ),
          const SizedBox(height: 24),
          SizedBox(height: 500, child: _buildTransactionsTable()),
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
                  'المستحقات المالية',
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
                'المستحقات المالية',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'إدارة الأرباح، المدفوعات المستحقة، وسجل التحويلات',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ],
        ),
        Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Colors.purpleAccent, Colors.pinkAccent],
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.purpleAccent.withOpacity(0.5),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ElevatedButton.icon(
            onPressed: _requestWithdraw,
            icon: const Icon(Icons.handshake, color: Colors.white),
            label: const Text(
              'طلب سحب مستحقات',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsGrid(bool isDesktop) {
    String lastPaymentDate = '--';
    String lastPaymentAmount = '\$0';
    if (_withdrawals.isNotEmpty) {
      lastPaymentDate = _withdrawals[0]['date'];
      lastPaymentAmount = '\$${_withdrawals[0]['amount'].toStringAsFixed(1)}';
    }

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
          'الرصيد الحالي',
          '\$${_currentBalance.toStringAsFixed(1)}',
          Icons.attach_money,
          Colors.greenAccent,
          'متاح للسحب',
        ),
        _buildStatCard(
          'المستحقات تحت المعالجة',
          '\$${_processingAmount.toStringAsFixed(1)}',
          Icons.schedule,
          Colors.amberAccent,
          'قيد المراجعة',
        ),
        _buildStatCard(
          'إجمالي المدفوعات',
          '\$${_totalWithdrawn.toStringAsFixed(1)}',
          Icons.history,
          Colors.blueAccent,
          'جميع التحويلات',
        ),
        _buildStatCard(
          'آخر دفعة',
          lastPaymentAmount,
          Icons.receipt_long,
          Colors.purpleAccent,
          lastPaymentDate,
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

  Widget _buildEarningsChartCard() {
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
                'تطور المستحقات (آخر 6 أشهر)',
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
            child: LineChart(
              LineChartData(
                lineTouchData: const LineTouchData(enabled: true),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: Colors.white.withOpacity(0.05),
                    strokeWidth: 1,
                  ),
                ),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
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
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: 5,
                minY: 0,
                maxY: 8000,
                lineBarsData: [
                  LineChartBarData(
                    spots: const [
                      FlSpot(0, 3250),
                      FlSpot(1, 4120),
                      FlSpot(2, 3880),
                      FlSpot(3, 5100),
                      FlSpot(4, 6280),
                      FlSpot(5, 7340),
                    ],
                    isCurved: true,
                    color: Colors.purpleAccent,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: true),
                    belowBarData: BarAreaData(
                      show: true,
                      color: Colors.purpleAccent.withOpacity(0.1),
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

  Widget _buildDistributionChartCard() {
    double flightTotal = _transactions
        .where((t) => t['service'] == 'طيران' && t['type'] == 'commission')
        .fold(0, (sum, c) => sum + (c['amount'] as double));
    double hotelTotal = _transactions
        .where((t) => t['service'] == 'فندق' && t['type'] == 'commission')
        .fold(0, (sum, c) => sum + (c['amount'] as double));
    double carTotal = _transactions
        .where((t) => t['service'] == 'سيارة' && t['type'] == 'commission')
        .fold(0, (sum, c) => sum + (c['amount'] as double));

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
                'توزيع المستحقات حسب الخدمة',
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

  Widget _buildTransactionsTable() {
    return _GlassContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      const Icon(
                        Icons.list_alt,
                        color: Colors.purpleAccent,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          'سجل المستحقات والمدفوعات',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'عرض ${_allTransactions.length} معاملة',
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
          const Divider(color: Colors.white10, height: 1),
          Expanded(
            child: _allTransactions.isEmpty
                ? const Center(
                    child: Text(
                      'لا توجد معاملات مالية',
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
                              'التاريخ',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'الوصف',
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
                              'النوع',
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
                        rows: _allTransactions.map((t) {
                          final isCommission = t['type'] == 'commission';
                          return DataRow(
                            cells: [
                              DataCell(
                                Text(
                                  t['date'],
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                              DataCell(
                                Text(
                                  t['description'],
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                              DataCell(
                                t['service'] != 'سحب'
                                    ? Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.purpleAccent
                                              .withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Text(
                                          t['service'],
                                          style: const TextStyle(
                                            color: Colors.purpleAccent,
                                            fontSize: 12,
                                          ),
                                        ),
                                      )
                                    : const Text(
                                        'تحويل بنكي',
                                        style: TextStyle(color: Colors.white),
                                      ),
                              ),
                              DataCell(
                                Text(
                                  t['bookingRef'],
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              ),
                              DataCell(
                                Text(
                                  '${isCommission ? '+' : '-'}\$${t['amount']}',
                                  style: TextStyle(
                                    color: isCommission
                                        ? Colors.greenAccent
                                        : Colors.redAccent,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              DataCell(
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      isCommission
                                          ? Icons.arrow_upward
                                          : Icons.arrow_downward,
                                      color: isCommission
                                          ? Colors.greenAccent
                                          : Colors.redAccent,
                                      size: 14,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      isCommission ? 'إيداع' : 'سحب',
                                      style: TextStyle(
                                        color: isCommission
                                            ? Colors.greenAccent
                                            : Colors.redAccent,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              DataCell(_buildStatusBadge(t)),
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

  Widget _buildStatusBadge(Map<String, dynamic> t) {
    Color color;
    String text;
    if (t['type'] == 'commission') {
      if (t['status'] == 'paid') {
        color = Colors.greenAccent;
        text = 'مدفوعة';
      } else if (t['status'] == 'pending') {
        color = Colors.amberAccent;
        text = 'مستحقة';
      } else {
        color = Colors.blueAccent;
        text = 'قيد المعالجة';
      }
    } else {
      if (t['status'] == 'completed') {
        color = Colors.greenAccent;
        text = 'تم السحب';
      } else {
        color = Colors.amberAccent;
        text = 'قيد المعالجة';
      }
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
