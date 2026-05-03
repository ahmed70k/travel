import 'dart:ui';
import 'package:flutter/material.dart';

class B2bCustomer {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String tier;
  final int totalBookings;
  final double totalSpent;
  final List<Map<String, dynamic>> bookingsHistory;

  B2bCustomer({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.tier,
    required this.totalBookings,
    required this.totalSpent,
    required this.bookingsHistory,
  });
}

class B2bCustomersPage extends StatefulWidget {
  const B2bCustomersPage({super.key});

  @override
  State<B2bCustomersPage> createState() => _B2bCustomersPageState();
}

class _B2bCustomersPageState extends State<B2bCustomersPage> {
  List<B2bCustomer> _customers = [
    B2bCustomer(
      id: 1,
      name: "محمد علي",
      email: "mohamed@example.com",
      phone: "+966501234567",
      tier: "بلاتينيوم",
      totalBookings: 12,
      totalSpent: 12500,
      bookingsHistory: [
        {"type": "طيران", "date": "2025-05-20", "amount": 320.0},
        {"type": "فندق", "date": "2025-04-10", "amount": 850.0},
        {"type": "سيارة", "date": "2025-05-01", "amount": 180.0},
      ],
    ),
    B2bCustomer(
      id: 2,
      name: "سارة أحمد",
      email: "sara@example.com",
      phone: "+966502345678",
      tier: "ذهبي",
      totalBookings: 8,
      totalSpent: 6800,
      bookingsHistory: [
        {"type": "طيران", "date": "2025-05-22", "amount": 850.0},
        {"type": "فندق", "date": "2025-04-15", "amount": 420.0},
      ],
    ),
    B2bCustomer(
      id: 3,
      name: "خالد يوسف",
      email: "khalid@example.com",
      phone: "+966503456789",
      tier: "ذهبي",
      totalBookings: 5,
      totalSpent: 3200,
      bookingsHistory: [
        {"type": "سيارة", "date": "2025-05-18", "amount": 350.0},
        {"type": "طيران", "date": "2025-05-01", "amount": 410.0},
      ],
    ),
    B2bCustomer(
      id: 4,
      name: "نورة خالد",
      email: "nora@example.com",
      phone: "+966504567890",
      tier: "بلاتينيوم",
      totalBookings: 10,
      totalSpent: 9800,
      bookingsHistory: [
        {"type": "طيران", "date": "2025-06-01", "amount": 720.0},
        {"type": "فندق", "date": "2025-05-25", "amount": 1100.0},
      ],
    ),
    B2bCustomer(
      id: 5,
      name: "فيصل القحطاني",
      email: "faisal@travel.com",
      phone: "+966505678901",
      tier: "بلاتينيوم",
      totalBookings: 22,
      totalSpent: 28400,
      bookingsHistory: [
        {"type": "طيران", "date": "2025-06-10", "amount": 1200.0},
        {"type": "سيارة", "date": "2025-06-05", "amount": 1140.0},
      ],
    ),
    B2bCustomer(
      id: 6,
      name: "أحمد رضا",
      email: "ahmed@example.com",
      phone: "+966506789012",
      tier: "فضي",
      totalBookings: 3,
      totalSpent: 1250,
      bookingsHistory: [
        {"type": "سيارة", "date": "2025-05-10", "amount": 280.0},
      ],
    ),
    B2bCustomer(
      id: 7,
      name: "منى السيد",
      email: "mona@example.com",
      phone: "+966507890123",
      tier: "ذهبي",
      totalBookings: 7,
      totalSpent: 5540,
      bookingsHistory: [
        {"type": "طيران", "date": "2025-06-05", "amount": 930.0},
        {"type": "فندق", "date": "2025-05-12", "amount": 670.0},
      ],
    ),
    B2bCustomer(
      id: 8,
      name: "عمر فهد",
      email: "omar@example.com",
      phone: "+966508901234",
      tier: "فضي",
      totalBookings: 2,
      totalSpent: 890,
      bookingsHistory: [
        {"type": "طيران", "date": "2025-05-30", "amount": 480.0},
      ],
    ),
  ];

  B2bCustomer? _selectedCustomer;

  // Filters
  String _searchQuery = '';
  String _selectedTier = 'الكل';
  int _minBookings = 0;

  @override
  void initState() {
    super.initState();
    if (_customers.isNotEmpty) {
      _selectedCustomer = _customers[0];
    }
  }

  List<B2bCustomer> get _filteredCustomers {
    return _customers.where((c) {
      final matchesSearch =
          c.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          c.email.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesTier = _selectedTier == 'الكل' || c.tier == _selectedTier;
      final matchesMinBookings = c.totalBookings >= _minBookings;
      return matchesSearch && matchesTier && matchesMinBookings;
    }).toList();
  }

  int get _totalCustomers => _customers.length;
  int get _activeCustomers =>
      _customers.where((c) => c.totalBookings > 0).length;
  int get _totalBookings =>
      _customers.fold(0, (sum, c) => sum + c.totalBookings);
  double get _totalSpent =>
      _customers.fold(0.0, (sum, c) => sum + c.totalSpent);

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
          _buildFiltersRow(isDesktop),
          const SizedBox(height: 24),
          isDesktop
              ? IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: SizedBox(
                          height: 600,
                          child: _buildCustomersTable(),
                        ),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        flex: 1,
                        child: SizedBox(
                          height: 600,
                          child: _buildCustomerDetailsPanel(),
                        ),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    SizedBox(height: 500, child: _buildCustomersTable()),
                    if (_selectedCustomer != null) ...[
                      const SizedBox(height: 24),
                      SizedBox(
                        height: 500,
                        child: _buildCustomerDetailsPanel(),
                      ),
                    ],
                  ],
                ),
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
              children: [
                const Icon(Icons.home, color: Colors.purpleAccent, size: 16),
                const SizedBox(width: 8),
                const Text(
                  'الرئيسية',
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.chevron_left, color: Colors.grey, size: 16),
                const SizedBox(width: 8),
                const Text(
                  'قاعدة العملاء',
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
                'قائمة العملاء',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'إدارة بيانات العملاء، تتبع الحجوزات، وتصنيف العملاء المميزين.',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ],
        ),
        _buildGradientButton(
          label: 'عميل جديد',
          icon: Icons.person_add,
          onTap: _showAddCustomerDialog,
        ),
      ],
    );
  }

  Widget _buildStatsGrid(bool isDesktop) {
    return GridView.count(
      crossAxisCount: isDesktop ? 4 : 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: isDesktop ? 2.5 : 1.5,
      children: [
        _buildStatCard(
          'إجمالي العملاء',
          '$_totalCustomers',
          Icons.people,
          Colors.purpleAccent,
          '+18%',
        ),
        _buildStatCard(
          'عملاء نشطون (حجوزات)',
          '$_activeCustomers',
          Icons.verified_user,
          Colors.greenAccent,
          null,
        ),
        _buildStatCard(
          'إجمالي الحجوزات',
          '$_totalBookings',
          Icons.calendar_today,
          Colors.blueAccent,
          null,
        ),
        _buildStatCard(
          'إجمالي الإنفاق',
          '\$${_totalSpent.toStringAsFixed(0)}',
          Icons.show_chart,
          Colors.amberAccent,
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
    return _GlassContainer(
      padding: const EdgeInsets.all(16),
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
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 6,
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
                      const Icon(
                        Icons.arrow_upward,
                        color: Colors.greenAccent,
                        size: 12,
                      ),
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
          Icon(icon, color: color, size: 36),
        ],
      ),
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
            width: isDesktop ? 200 : double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'بحث بالاسم أو البريد',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                const SizedBox(height: 8),
                TextField(
                  style: const TextStyle(color: Colors.white),
                  decoration: _inputDecoration('اسم العميل أو الإيميل'),
                  onChanged: (val) => setState(() => _searchQuery = val),
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
                  'نوع العميل',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: _selectedTier,
                  dropdownColor: const Color(0xFF14122C),
                  style: const TextStyle(color: Colors.white),
                  decoration: _inputDecoration(''),
                  items: ['الكل', 'بلاتينيوم', 'ذهبي', 'فضي']
                      .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                      .toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _selectedTier = val);
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
                  'الحد الأدنى للحجوزات',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                const SizedBox(height: 8),
                TextField(
                  style: const TextStyle(color: Colors.white),
                  keyboardType: TextInputType.number,
                  decoration: _inputDecoration('0'),
                  onChanged: (val) =>
                      setState(() => _minBookings = int.tryParse(val) ?? 0),
                ),
              ],
            ),
          ),
          SizedBox(
            width: isDesktop ? 150 : double.infinity,
            height: 48,
            child: OutlinedButton.icon(
              onPressed: () {
                setState(() {
                  _searchQuery = '';
                  _selectedTier = 'الكل';
                  _minBookings = 0;
                });
              },
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

  Widget _buildCustomersTable() {
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
                      Icons.contacts,
                      color: Colors.purpleAccent,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'قاعدة العملاء',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Text(
                  'عرض ${_filteredCustomers.length} من $_totalCustomers',
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
          const Divider(color: Colors.white10, height: 1),
          Expanded(
            child: _filteredCustomers.isEmpty
                ? const Center(
                    child: Text(
                      'لا يوجد عملاء مطابقون',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.separated(
                    itemCount: _filteredCustomers.length,
                    separatorBuilder: (context, index) =>
                        const Divider(color: Colors.white10, height: 1),
                    itemBuilder: (context, index) {
                      final customer = _filteredCustomers[index];
                      final isSelected = _selectedCustomer?.id == customer.id;

                      return InkWell(
                        onTap: () =>
                            setState(() => _selectedCustomer = customer),
                        hoverColor: Colors.purpleAccent.withOpacity(0.1),
                        child: Container(
                          color: isSelected
                              ? Colors.purpleAccent.withOpacity(0.1)
                              : Colors.transparent,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: Colors.purpleAccent,
                                      child: Text(
                                        customer.name.substring(0, 1),
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        customer.name,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  customer.email,
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 13,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.blueAccent.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    '${customer.totalBookings}',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Colors.lightBlueAccent,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(
                                  '\$${customer.totalSpent.toStringAsFixed(0)}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: _buildTierBadge(customer.tier),
                              ),
                              const Icon(
                                Icons.chevron_left,
                                color: Colors.purpleAccent,
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildTierBadge(String tier) {
    Color bgColor;
    Color textColor;
    if (tier == 'بلاتينيوم') {
      bgColor = Colors.pinkAccent.withOpacity(0.2);
      textColor = Colors.pinkAccent;
    } else if (tier == 'ذهبي') {
      bgColor = Colors.amberAccent.withOpacity(0.2);
      textColor = Colors.amberAccent;
    } else {
      bgColor = Colors.grey.withOpacity(0.2);
      textColor = Colors.grey;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        tier,
        textAlign: TextAlign.center,
        style: TextStyle(color: textColor, fontSize: 12),
      ),
    );
  }

  Widget _buildCustomerDetailsPanel() {
    if (_selectedCustomer == null) {
      return _GlassContainer(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.account_circle,
                size: 64,
                color: Colors.purpleAccent.withOpacity(0.5),
              ),
              const SizedBox(height: 16),
              const Text(
                'اختر عميلاً من القائمة لعرض التفاصيل الكاملة\nوتاريخ الحجوزات',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }

    final c = _selectedCustomer!;

    return _GlassContainer(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 32,
                backgroundColor: Colors.purpleAccent,
                child: Text(
                  c.name.substring(0, 1),
                  style: const TextStyle(color: Colors.white, fontSize: 28),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      c.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${c.tier} · ${c.totalBookings} حجز',
                      style: const TextStyle(
                        color: Colors.purpleAccent,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Divider(color: Colors.white10),
          const SizedBox(height: 16),
          _buildDetailCard(Icons.email, c.email),
          const SizedBox(height: 8),
          _buildDetailCard(Icons.phone, c.phone),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.03),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.show_chart,
                      color: Colors.amberAccent,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'إجمالي الإنفاق',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
                Text(
                  '\$${c.totalSpent.toStringAsFixed(0)}',
                  style: const TextStyle(
                    color: Colors.greenAccent,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              const Icon(
                Icons.history,
                color: Colors.lightBlueAccent,
                size: 16,
              ),
              const SizedBox(width: 8),
              const Text(
                'آخر الحجوزات',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: c.bookingsHistory.isEmpty
                ? const Center(
                    child: Text(
                      'لا توجد حجوزات مسجلة',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.separated(
                    itemCount: c.bookingsHistory.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final b = c.bookingsHistory[index];
                      IconData icon;
                      if (b['type'] == 'طيران') {
                        icon = Icons.flight;
                      } else if (b['type'] == 'فندق') {
                        icon = Icons.hotel;
                      } else {
                        icon = Icons.directions_car;
                      }

                      return Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.03),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  icon,
                                  color: Colors.purpleAccent,
                                  size: 16,
                                ),
                                const SizedBox(width: 8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      b['type'],
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                      ),
                                    ),
                                    Text(
                                      b['date'],
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Text(
                              '\$${b['amount']}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.purpleAccent.withOpacity(0.3)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'تعديل بيانات العميل',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailCard(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey, size: 16),
          const SizedBox(width: 12),
          Text(
            text,
            style: const TextStyle(color: Colors.white30, fontSize: 14),
          ), // Used white30 but actual value should be clearer. Wait, Colors.grey/white is fine.
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.grey, fontSize: 12),
      filled: true,
      fillColor: Colors.white.withOpacity(0.05),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
    );
  }

  Widget _buildGradientButton({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: const LinearGradient(
            colors: [Colors.purpleAccent, Colors.pinkAccent],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.purpleAccent.withOpacity(0.5),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddCustomerDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return _AddCustomerDialog(
          onAdd: (name, email, phone, tier) {
            setState(() {
              _customers.add(
                B2bCustomer(
                  id: DateTime.now().millisecondsSinceEpoch,
                  name: name,
                  email: email,
                  phone: phone.isEmpty ? "غير محدد" : phone,
                  tier: tier,
                  totalBookings: 0,
                  totalSpent: 0,
                  bookingsHistory: [],
                ),
              );
            });
            Navigator.pop(context);
          },
        );
      },
    );
  }
}

class _AddCustomerDialog extends StatefulWidget {
  final Function(String name, String email, String phone, String tier) onAdd;

  const _AddCustomerDialog({required this.onAdd});

  @override
  State<_AddCustomerDialog> createState() => _AddCustomerDialogState();
}

class _AddCustomerDialogState extends State<_AddCustomerDialog> {
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  String _tier = 'فضي';

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(16),
      child: Container(
        width: 500,
        decoration: BoxDecoration(
          color: const Color(0xFF14122C),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.purpleAccent.withOpacity(0.4)),
          boxShadow: const [
            BoxShadow(color: Colors.black54, blurRadius: 20, spreadRadius: 5),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.person_add, color: Colors.purpleAccent),
                      SizedBox(width: 8),
                      Text(
                        'إضافة عميل جديد',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.grey),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            const Divider(color: Colors.white10, height: 1),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInputLabel('الاسم الكامل *'),
                  _buildTextField(_nameCtrl, 'مثال: عبدالله المنصور'),
                  const SizedBox(height: 16),
                  _buildInputLabel('البريد الإلكتروني *'),
                  _buildTextField(
                    _emailCtrl,
                    'customer@example.com',
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),
                  _buildInputLabel('رقم الهاتف'),
                  _buildTextField(
                    _phoneCtrl,
                    '+966 5xxxxxxxx',
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 16),
                  _buildInputLabel('المستوى الافتتاحي'),
                  DropdownButtonFormField<String>(
                    value: _tier,
                    dropdownColor: const Color(0xFF14122C),
                    style: const TextStyle(color: Colors.white),
                    decoration: _inputDecoration(''),
                    items: ['فضي', 'ذهبي', 'بلاتينيوم']
                        .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                        .toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _tier = val);
                    },
                  ),
                  const SizedBox(height: 32),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            if (_nameCtrl.text.isEmpty ||
                                _emailCtrl.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'يرجى إدخال الاسم والبريد الإلكتروني',
                                  ),
                                ),
                              );
                              return;
                            }
                            widget.onAdd(
                              _nameCtrl.text,
                              _emailCtrl.text,
                              _phoneCtrl.text,
                              _tier,
                            );
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Colors.purpleAccent,
                                  Colors.pinkAccent,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'إضافة العميل',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: InkWell(
                          onTap: () => Navigator.pop(context),
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'إلغاء',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white70, fontSize: 13),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String hint, {
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white),
      decoration: _inputDecoration(hint),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.grey, fontSize: 12),
      filled: true,
      fillColor: Colors.white.withOpacity(0.05),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
    );
  }
}

class _GlassContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;

  const _GlassContainer({required this.child, this.padding});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: const Color(0xFF0F0C29).withOpacity(0.6),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.purpleAccent.withOpacity(0.2)),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 32,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}
