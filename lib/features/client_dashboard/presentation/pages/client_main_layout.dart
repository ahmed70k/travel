import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/presentation/cubit/logout_cubit.dart';
import '../../../auth/presentation/cubit/logout_state.dart';
import '../../../auth/presentation/pages/login_page.dart';
import 'my_bookings_page.dart';
import 'client_hotels_page.dart';
import 'client_cars_page.dart';
import 'client_dashboard_overview.dart';
import 'client_loyalty_page.dart';
import 'client_profile_page.dart';
import 'client_support_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/dependency_injection.dart';
import '../state/b2c_overview_cubit.dart';
import '../../../admin/cars/presentation/cubit/admin_cars_cubit.dart';
import '../state/me_dashboard_cubit.dart';

class ClientMainLayout extends StatefulWidget {
  const ClientMainLayout({super.key});

  @override
  State<ClientMainLayout> createState() => _ClientMainLayoutState();
}

class _ClientMainLayoutState extends State<ClientMainLayout> {
  int _selectedIndex = 0; // Modern behavior: Start with Dashboard Overview

  final List<Map<String, dynamic>> _menuItems = [
    {'title': 'لوحة التحكم', 'icon': Icons.dashboard_outlined},
    {'title': 'حجوزاتي', 'icon': Icons.airplane_ticket_outlined},
    {'title': 'فنادقي', 'icon': Icons.hotel_outlined},
    {'title': 'سياراتي', 'icon': Icons.directions_car_outlined},
    {'title': 'ملفي الشخصي', 'icon': Icons.person_outline},
    {'title': 'نقاط الولاء', 'icon': Icons.diamond_outlined},
    {'title': 'الدعم الفني', 'icon': Icons.headset_mic_outlined},
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
                    icon: const Icon(
                      Icons.menu_open,
                      color: Colors.purpleAccent,
                    ),
                    onPressed: () => Scaffold.of(context).openDrawer(),
                  ),
                ),
                title: const Text(
                  'وكالة السفر',
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
              colors: [Colors.purpleAccent, Colors.pinkAccent],
            ).createShader(bounds),
            child: const Icon(
              Icons.flight_takeoff,
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
                'Client Portal',
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
                  AppColors.primary.withOpacity(0.3),
                  Colors.transparent,
                ],
              )
            : null,
        border: isActive
            ? const Border(
                right: BorderSide(color: AppColors.primary, width: 3),
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
          color: isActive ? AppColors.primary : AppColors.textMuted,
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
            backgroundColor: AppColors.primary,
            child: const Text(
              'MA',
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'محمد علي',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'عميل متميز',
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
                      color: AppColors.primary,
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

  Widget _buildPage(int index) {
    return _getPage(index);
  }

  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return BlocProvider(
          create: (_) => sl<B2COverviewCubit>()..getOverview(),
          child: const ClientDashboardOverview(),
        );
      case 1:
        return const MyBookingsPage();
      case 2:
        return const ClientHotelsPage();
      case 3:
        return BlocProvider(
          create: (_) => sl<AdminCarsCubit>()..getCars(),
          child: const ClientCarsPage(),
        );
      case 4:
        return BlocProvider(
          create: (_) => sl<MeDashboardCubit>()..fetchDashboard(),
          child: const ClientProfilePage(),
        );
      case 5:
        return const ClientLoyaltyPage();
      case 6:
        return const ClientSupportPage();
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
