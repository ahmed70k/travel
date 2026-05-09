import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../cubit/b2b_car_bookings_cubit.dart';
import '../cubit/b2b_flight_bookings_cubit.dart';
import '../cubit/b2b_hotel_bookings_cubit.dart';
import '../cubit/my_bookings_cubit.dart';
import 'b2b_dashboard_overview.dart';
import 'b2b_my_bookings_page.dart';
import 'b2b_profile_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/presentation/cubit/auth_state.dart';
import 'b2b_bookings_summary_page.dart';
import '../widgets/b2b_create_flight_booking_dialog.dart';
import '../widgets/b2b_create_hotel_booking_dialog.dart';
import '../widgets/b2b_create_car_booking_dialog.dart';

class B2bMainLayout extends StatefulWidget {
  const B2bMainLayout({super.key});

  @override
  State<B2bMainLayout> createState() => _B2bMainLayoutState();
}

class _B2bMainLayoutState extends State<B2bMainLayout> {
  int _selectedIndex = 0;

  final List<Map<String, dynamic>> _menuItems = [
    {'title': 'لوحة تحكم الشركات', 'icon': Icons.dashboard_outlined},
    {'title': 'حجوزاتي', 'icon': Icons.book_online_outlined},
    {'title': 'ملخص الحجوزات', 'icon': Icons.list_alt},
    {'title': 'إضافة حجز جديد', 'icon': Icons.add_circle_outline, 'isAction': true},
    {'title': 'الملف الشخصي', 'icon': Icons.person_outline},
  ];

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<B2BMyBookingsCubit>()..getMyBookings()),
        BlocProvider(create: (context) => sl<B2BFlightBookingsCubit>()..getFlightsBookings()),
        BlocProvider(create: (context) => sl<B2BHotelBookingsCubit>()..getHotelsBookings()),
        BlocProvider(create: (context) => sl<B2BCarBookingsCubit>()..getCarsBookings()),
        BlocProvider(create: (context) => sl<AuthCubit>()..checkAuth()),
      ],
      child: Builder(
        builder: (context) {
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
              drawer: isMobile ? _buildSidebar(context, isMobile) : null,
              body: Row(
                children: [
                  if (!isMobile) _buildSidebar(context, isMobile),
                  Expanded(child: _getPage(_selectedIndex)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSidebar(BuildContext context, bool isMobile) {
    return Container(
      width: 280,
      decoration: BoxDecoration(
        color: const Color(0xFF0F0C29).withOpacity(0.8),
        border: const Border(left: BorderSide(color: AppColors.glassBorder)),
      ),
      child: SafeArea(
        child: Column(
          children: [
            _buildLogo(),
            const SizedBox(height: 32),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  ...List.generate(_menuItems.length, (index) {
                    return _buildMenuItem(
                      context,
                      index,
                      _menuItems[index]['title'],
                      _menuItems[index]['icon'],
                      _selectedIndex == index,
                      isMobile,
                      isAction: _menuItems[index]['isAction'] ?? false,
                    );
                  }),
                ],
              ),
            ),
            _buildUserCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
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
          if (isAction) {
            final flightCubit = innerContext.read<B2BFlightBookingsCubit>();
            final hotelCubit = innerContext.read<B2BHotelBookingsCubit>();
            final carCubit = innerContext.read<B2BCarBookingsCubit>();
            final myBookingsCubit = innerContext.read<B2BMyBookingsCubit>();
            if (isMobile) Navigator.pop(innerContext);
            _showNewBookingSelector(flightCubit, hotelCubit, carCubit, myBookingsCubit);
          } else {
            setState(() => _selectedIndex = index);
            if (isMobile) Navigator.pop(innerContext);
          }
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
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        String name = 'جاري التحميل...';
        String email = '...';

        if (state is Authenticated) {
          name = state.user.name;
          email = state.user.email;
        }

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
                child: const Icon(Icons.person, color: Colors.white, size: 18),
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
              IconButton(
                icon: const Icon(
                  Icons.logout,
                  color: AppColors.textMuted,
                  size: 18,
                ),
                onPressed: () => context.read<AuthCubit>().logout(),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return const B2bDashboardOverview();
      case 1:
        return const B2bMyBookingsPage();
      case 2:
        return const B2bBookingsSummaryPage();
      case 3:
        return const SizedBox(); // Placeholder for the 'Add' action index if it was selectable, but it's not.
      case 4:
        return const B2bProfilePage();
      default:
        return const B2bDashboardOverview();
    }
  }

  void _showNewBookingSelector(
    B2BFlightBookingsCubit flightCubit,
    B2BHotelBookingsCubit hotelCubit,
    B2BCarBookingsCubit carCubit,
    B2BMyBookingsCubit myBookingsCubit,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF161333),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (bottomSheetContext) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'اختر نوع الحجز (B2B)',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            ListTile(
              leading: const Icon(Icons.flight, color: Colors.blueAccent),
              title: const Text('حجز طيران', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(bottomSheetContext);
                showDialog(
                  context: context,
                  builder: (dialogContext) => BlocProvider.value(
                    value: flightCubit,
                    child: const CreateB2BFlightBookingDialog(),
                  ),
                ).then((_) => myBookingsCubit.getMyBookings(forceRefresh: true));
              },
            ),
            ListTile(
              leading: const Icon(Icons.hotel, color: Colors.orangeAccent),
              title: const Text('حجز فندق', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(bottomSheetContext);
                showDialog(
                  context: context,
                  builder: (dialogContext) => BlocProvider.value(
                    value: hotelCubit,
                    child: const CreateB2BHotelBookingDialog(),
                  ),
                ).then((_) => myBookingsCubit.getMyBookings(forceRefresh: true));
              },
            ),
            ListTile(
              leading: const Icon(Icons.directions_car, color: Colors.greenAccent),
              title: const Text('تأجير سيارة', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(bottomSheetContext);
                showDialog(
                  context: context,
                  builder: (dialogContext) => BlocProvider.value(
                    value: carCubit,
                    child: const CreateB2BCarBookingDialog(),
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
