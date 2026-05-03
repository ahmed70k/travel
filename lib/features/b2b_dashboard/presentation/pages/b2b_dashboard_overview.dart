import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/neon_text.dart';
import '../../../../core/widgets/glass_container.dart';

class B2bDashboardOverview extends StatefulWidget {
  const B2bDashboardOverview({super.key});

  @override
  State<B2bDashboardOverview> createState() => _B2bDashboardOverviewState();
}

class _B2bDashboardOverviewState extends State<B2bDashboardOverview> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;

    return SingleChildScrollView(
      padding: EdgeInsets.all(isMobile ? 16.0 : 32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome Header
          _buildWelcomeHeader(isMobile),
          const SizedBox(height: 32),

          // Corporate Quick Stats
          _buildCorporateStatsGrid(context, isMobile),
          const SizedBox(height: 32),

          // Active Employees Trips & Pending Approvals
          if (!isMobile)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 2, child: _buildActiveTripsCard()),
                const SizedBox(width: 24),
                Expanded(child: _buildPendingApprovalsCard()),
              ],
            )
          else ...[
            _buildActiveTripsCard(),
            const SizedBox(height: 24),
            _buildPendingApprovalsCard(),
          ],
          const SizedBox(height: 32),

          // Recent Corporate Activity
          const Text(
            'نشاط الشركة الأخير',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildRecentActivity(),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildWelcomeHeader(bool isMobile) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'مرحباً بك في بوابة الشركات،',
              style: TextStyle(color: AppColors.textMuted, fontSize: 16),
            ),
            const SizedBox(height: 4),
            NeonText(
              'شركة الرواد 👋',
              style: TextStyle(
                fontSize: isMobile ? 28 : 36,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        if (!isMobile) _buildCompanyStatusWidget(),
      ],
    );
  }

  Widget _buildCompanyStatusWidget() {
    return GlassContainer(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: const Row(
        children: [
          Icon(Icons.verified, color: Colors.blueAccent, size: 24),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'حساب موثق',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'مدير الحساب: أحمد يوسف',
                style: TextStyle(color: AppColors.textMuted, fontSize: 10),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCorporateStatsGrid(BuildContext context, bool isMobile) {
    return GridView.count(
      crossAxisCount: isMobile ? 1 : 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 24,
      mainAxisSpacing: 24,
      childAspectRatio: isMobile ? 2.0 : 1.5,
      children: [
        _buildStatCard(
          'إجمالي الإنفاق (هذا الشهر)',
          '\$45,200',
          Icons.account_balance_wallet_outlined,
          Colors.greenAccent,
          '+12% مقارنة بالشهر الماضي',
        ),
        _buildStatCard(
          'الرحلات النشطة',
          '24',
          Icons.flight_takeoff,
          Colors.blueAccent,
          '5 رحلات تبدأ اليوم',
        ),
        _buildStatCard(
          'الموظفين المسجلين',
          '156',
          Icons.people_outline,
          Colors.purpleAccent,
          '+3 موظفين جدد',
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
    return GlassContainer(
      padding: const EdgeInsets.all(20),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [color.withOpacity(0.1), Colors.transparent],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 28),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  subtitle,
                  style: TextStyle(
                    color: color,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(color: AppColors.textMuted, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveTripsCard() {
    return GlassContainer(
      padding: const EdgeInsets.all(24),
      animateHover: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'رحلات الموظفين الحالية',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Icon(
                Icons.connecting_airports,
                color: Colors.blueAccent,
                size: 20,
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildTripRow('سارة أحمد', 'الرياض ← دبي', 'اليوم', 0.8),
          const SizedBox(height: 16),
          _buildTripRow('محمد خالد', 'جدة ← لندن', 'غداً', 0.3),
          const SizedBox(height: 16),
          _buildTripRow(
            'فريق المبيعات (4)',
            'الدمام ← القاهرة',
            'بعد يومين',
            0.1,
          ),
        ],
      ),
    );
  }

  Widget _buildTripRow(
    String employee,
    String route,
    String time,
    double progress,
  ) {
    return Row(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: Colors.white.withOpacity(0.1),
          child: const Icon(Icons.person, color: Colors.white70, size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    employee,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    time,
                    style: const TextStyle(
                      color: Colors.blueAccent,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                route,
                style: const TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.white.withOpacity(0.05),
                valueColor: AlwaysStoppedAnimation(
                  progress > 0.5 ? Colors.greenAccent : Colors.orangeAccent,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPendingApprovalsCard() {
    return GlassContainer(
      padding: const EdgeInsets.all(24),
      gradient: const LinearGradient(
        colors: [Color(0xFF2C1C30), Colors.transparent],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'بانتظار الموافقة',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: Colors.redAccent,
                  shape: BoxShape.circle,
                ),
                child: const Text(
                  '3',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildApprovalItem(
            'طلب طيران (درجة أعمال)',
            'د. ياسر علي',
            '\$1,200',
          ),
          const Divider(color: AppColors.glassBorder, height: 24),
          _buildApprovalItem('حجز فندق 5 نجوم', 'فريق التسويق', '\$850'),
          const Divider(color: AppColors.glassBorder, height: 24),
          _buildApprovalItem('تأجير سيارات', 'وفد الشركة', '\$400'),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent.withOpacity(0.2),
                foregroundColor: Colors.blueAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('عرض كل الطلبات'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildApprovalItem(String title, String requester, String amount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(color: Colors.white, fontSize: 13),
            ),
            const SizedBox(height: 4),
            Text(
              'بواسطة: $requester',
              style: const TextStyle(color: AppColors.textMuted, fontSize: 11),
            ),
          ],
        ),
        Text(
          amount,
          style: const TextStyle(
            color: Colors.orangeAccent,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildRecentActivity() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 4,
      itemBuilder: (context, index) {
        final items = [
          {
            'title': 'تمت الموافقة على حجز فندق لفريق المبيعات',
            'time': 'منذ ساعة',
            'icon': Icons.check_circle_outline,
            'color': Colors.greenAccent,
          },
          {
            'title': 'تم إصدار الفاتورة الشهرية #INV-2025-05',
            'time': 'منذ 3 ساعات',
            'icon': Icons.receipt,
            'color': Colors.blueAccent,
          },
          {
            'title': 'إضافة موظف جديد (كريم حسن)',
            'time': 'أمس',
            'icon': Icons.person_add,
            'color': Colors.purpleAccent,
          },
          {
            'title': 'تجاوز ميزانية السفر للربع الثاني',
            'time': 'منذ يومين',
            'icon': Icons.warning_amber_rounded,
            'color': Colors.orangeAccent,
          },
        ];
        final item = items[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.03),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.glassBorder),
          ),
          child: Row(
            children: [
              Icon(
                item['icon'] as IconData,
                color: item['color'] as Color,
                size: 20,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['title'] as String,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      item['time'] as String,
                      style: const TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: AppColors.textMuted,
                size: 16,
              ),
            ],
          ),
        );
      },
    );
  }
}
