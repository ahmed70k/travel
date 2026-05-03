import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import 'b2b_flight_bookings_page.dart';
import 'b2b_hotel_bookings_page.dart';
import 'b2b_car_bookings_page.dart';
import 'b2b_dashboard_overview.dart';
import 'b2b_customers_page.dart';
import 'b2b_reports_page.dart';
import 'b2b_financial_dues_page.dart';
import 'b2b_favorites_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../auth/presentation/cubit/logout_cubit.dart';
import '../../../auth/presentation/cubit/logout_state.dart';
import '../../../auth/presentation/pages/login_page.dart';

class B2bMainLayout extends StatefulWidget {
  const B2bMainLayout({super.key});

  @override
  State<B2bMainLayout> createState() => _B2bMainLayoutState();
}

class _B2bMainLayoutState extends State<B2bMainLayout> {
  int _selectedIndex = 0;

  final List<Map<String, dynamic>> _menuItems = [
    {'title': 'لوحة تحكم الشركات', 'icon': Icons.dashboard_outlined},
    {'title': 'حجوزات الطيران', 'icon': Icons.flight_outlined},
    {'title': 'حجوزات الفنادق', 'icon': Icons.hotel_outlined},
    {'title': 'السيارات والتأجير', 'icon': Icons.car_rental},
    {'title': 'قائمة العملاء', 'icon': Icons.people_outline},
    {'title': 'تقارير العمولات', 'icon': Icons.receipt_long_outlined},
    {
      'title': 'المستحقات المالية',
      'icon': Icons.account_balance_wallet_outlined,
    },
    {'title': 'المفضلة', 'icon': Icons.favorite_border},
  ];

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 1100;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFF0A081C),
        appBar: isMobile
            ? AppBar(
                backgroundColor: const Color(0xFF0F0C29).withOpacity(0.8),
                elevation: 0,
                leading: Builder(
                  builder: (context) => IconButton(
                    icon: const Icon(Icons.menu_open, color: Colors.blueAccent),
                    onPressed: () => Scaffold.of(context).openDrawer(),
                  ),
                ),
                title: const Text(
                  'وكالة السفر للشركات',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : null,
        drawer: isMobile ? _buildSidebar(isMobile) : null,
        body: Row(
          children: [
            if (!isMobile) _buildSidebar(isMobile),
            Expanded(child: _getPage(_selectedIndex)),
          ],
        ),
      ),
    );
  }

  Widget _buildSidebar(bool isMobile) {
    return Container(
      width: 280,
      decoration: BoxDecoration(
        color: const Color(0xFF0F0C29).withOpacity(0.8),
        border: const Border(left: BorderSide(color: AppColors.glassBorder)),
      ),
      child: Column(
        children: [
          _buildLogo(),
          const SizedBox(height: 32),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _menuItems.length,
              itemBuilder: (context, index) {
                final item = _menuItems[index];
                final isActive = _selectedIndex == index;
                return _buildMenuItem(
                  index,
                  item['title'],
                  item['icon'],
                  isActive,
                  isMobile,
                );
              },
            ),
          ),
          _buildUserCard(),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [Colors.blueAccent, Colors.cyanAccent],
            ).createShader(bounds),
            child: const Icon(
              Icons.corporate_fare,
              size: 32,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 12),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'وكالة السفر',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              Text(
                'B2B Portal',
                style: TextStyle(color: AppColors.textMuted, fontSize: 10),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    int index,
    String title,
    IconData icon,
    bool isActive,
    bool isMobile,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: isActive
            ? LinearGradient(
                colors: [
                  Colors.blueAccent.withOpacity(0.3),
                  Colors.transparent,
                ],
              )
            : null,
        border: isActive
            ? const Border(
                right: BorderSide(color: Colors.blueAccent, width: 3),
              )
            : null,
      ),
      child: ListTile(
        onTap: () {
          setState(() => _selectedIndex = index);
          if (isMobile) Navigator.pop(context);
        },
        leading: Icon(
          icon,
          color: isActive ? Colors.blueAccent : AppColors.textMuted,
          size: 22,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isActive ? Colors.white : AppColors.textMuted,
            fontSize: 14,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildUserCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.blueGrey,
            child: const Icon(Icons.business, color: Colors.white, size: 18),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'شركة الرواد',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'حساب أعمال مميز',
                  style: TextStyle(color: AppColors.textMuted, fontSize: 10),
                ),
              ],
            ),
          ),
          BlocProvider(
            create: (context) => sl<LogoutCubit>(),
            child: BlocConsumer<LogoutCubit, LogoutState>(
              listener: (context, state) {
                if (state is LogoutSuccess || state is LogoutError) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const LoginPage()),
                    (route) => false,
                  );
                }
              },
              builder: (context, state) {
                if (state is LogoutLoading) {
                  return const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.blueAccent,
                    ),
                  );
                }
                return IconButton(
                  icon: const Icon(
                    Icons.logout,
                    color: AppColors.textMuted,
                    size: 18,
                  ),
                  onPressed: () => context.read<LogoutCubit>().logout(),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return const B2bDashboardOverview();
      case 1:
        return const B2bFlightBookingsPage();
      case 2:
        return const B2bHotelBookingsPage();
      case 3:
        return const B2bCarBookingsPage();
      case 4:
        return const B2bCustomersPage();
      case 5:
        return const B2bReportsPage();
      case 6:
        return const B2bFinancialDuesPage();
      case 7:
        return const B2bFavoritesPage();
      default:
        return Center(
          child: Text(
            _menuItems[index]['title'],
            style: const TextStyle(color: Colors.white),
          ),
        );
    }
  }
}
