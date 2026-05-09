import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/presentation/cubit/auth_state.dart';
import 'client_bookings_summary_page.dart';
import '../../../auth/presentation/cubit/logout_cubit.dart';
import '../../../auth/presentation/cubit/logout_state.dart';
import '../../../auth/presentation/pages/login_page.dart';
import 'my_bookings_page.dart';
import 'client_dashboard_overview.dart';
import 'client_profile_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/create_flight_booking_dialog.dart';
import '../widgets/create_hotel_booking_dialog.dart';
import '../widgets/create_car_booking_dialog.dart';
import '../../../b2c_bookings/presentation/cubit/b2c_flight_bookings_cubit.dart';
import '../../../b2c_bookings/presentation/cubit/b2c_hotel_bookings_cubit.dart';
import '../../../b2c_bookings/presentation/cubit/b2c_car_bookings_cubit.dart';
import '../../../bookings/presentation/cubit/my_bookings_cubit.dart';
import '../../../../core/di/dependency_injection.dart';

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
    {'title': 'ملخص الحجوزات', 'icon': Icons.list_alt},
    {'title': 'إضافة حجز جديد', 'icon': Icons.add_circle_outline, 'isAction': true},
    {'title': 'ملفي الشخصي', 'icon': Icons.person_outline},
  ];

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 1100;

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<B2CFlightBookingsCubit>()..getFlightBookings()),
        BlocProvider(create: (context) => sl<B2CHotelBookingsCubit>()..getHotelBookings()),
        BlocProvider(create: (context) => sl<B2CCarBookingsCubit>()..getCarBookings()),
        BlocProvider(create: (context) => sl<MyBookingsCubit>()..getMyBookings()),
      ],
      child: Directionality(
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
              itemBuilder: (innerContext, index) {
                final item = _menuItems[index];
                final isActive = _selectedIndex == index;
                return _buildMenuItem(
                  innerContext,
                  index,
                  item['title'],
                  item['icon'],
                  isActive,
                  isMobile,
                  isAction: item['isAction'] ?? false,
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
    BuildContext innerContext,
    int index,
    String title,
    IconData icon,
    bool isActive,
    bool isMobile, {
    bool isAction = false,
  }) {
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
          if (isAction) {
            // Capture cubits while innerContext is still valid (before drawer closes)
            final flightCubit = innerContext.read<B2CFlightBookingsCubit>();
            final hotelCubit = innerContext.read<B2CHotelBookingsCubit>();
            final carCubit = innerContext.read<B2CCarBookingsCubit>();
            final myBookingsCubit = innerContext.read<MyBookingsCubit>();
            if (isMobile) Navigator.pop(innerContext);
            // Use State's context (always valid) for showing dialogs
            _showNewBookingSelector(flightCubit, hotelCubit, carCubit, myBookingsCubit);
          } else {
            setState(() => _selectedIndex = index);
            if (isMobile) Navigator.pop(innerContext);
          }
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
      child: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          String name = 'جاري التحميل...';
          String email = '...';
          String initials = 'MA';

          if (state is Authenticated) {
            name = state.user.name;
            email = state.user.email;
            initials = name.length >= 2 ? name.substring(0, 2) : name;
          }

          return Row(
            children: [
              CircleAvatar(
                backgroundColor: AppColors.primary,
                child: Text(
                  initials,
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      email,
                      style: const TextStyle(color: AppColors.textMuted, fontSize: 10),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
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
          );
        },
      ),
    );
  }

  Widget _buildPage(int index) {
    return _getPage(index);
  }

  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return const ClientDashboardOverview();
      case 1:
        return const MyBookingsPage();
      case 2:
        return const ClientBookingsSummaryPage();
      case 4:
        return const ClientProfilePage();
      default:
        return const ClientDashboardOverview();
    }
  }

  void _showNewBookingSelector(
    B2CFlightBookingsCubit flightCubit,
    B2CHotelBookingsCubit hotelCubit,
    B2CCarBookingsCubit carCubit,
    MyBookingsCubit myBookingsCubit,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E1A3A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (bottomSheetContext) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'اختر نوع الحجز',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            ListTile(
              leading: const Icon(Icons.flight, color: Colors.purpleAccent),
              title: const Text('حجز طيران', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(bottomSheetContext);
                showDialog(
                  context: context,
                  builder: (dialogContext) => BlocProvider.value(
                    value: flightCubit,
                    child: const CreateB2CFlightBookingDialog(),
                  ),
                ).then((_) => myBookingsCubit.getMyBookings(forceRefresh: true));
              },
            ),
            ListTile(
              leading: const Icon(Icons.hotel, color: Colors.pinkAccent),
              title: const Text('حجز فندق', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(bottomSheetContext);
                showDialog(
                  context: context,
                  builder: (dialogContext) => BlocProvider.value(
                    value: hotelCubit,
                    child: const CreateB2CHotelBookingDialog(),
                  ),
                ).then((_) => myBookingsCubit.getMyBookings(forceRefresh: true));
              },
            ),
            ListTile(
              leading: const Icon(Icons.directions_car, color: Colors.blueAccent),
              title: const Text('تأجير سيارة', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(bottomSheetContext);
                showDialog(
                  context: context,
                  builder: (dialogContext) => BlocProvider.value(
                    value: carCubit,
                    child: const CreateB2CCarBookingDialog(),
                  ),
                ).then((_) => myBookingsCubit.getMyBookings(forceRefresh: true));
              },
            ),
          ],
        ),
      ),
    );
  }
}
