import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/neon_text.dart';
import '../cubit/b2b_overview_cubit.dart';
import '../cubit/b2b_overview_state.dart';
import '../cubit/my_bookings_cubit.dart';
import '../cubit/my_bookings_state.dart';
import '../widgets/b2b_kpi_card.dart';
import '../widgets/b2b_module_card.dart';
import '../cubit/flights_availability_cubit.dart';
import '../cubit/flights_availability_state.dart';
import '../cubit/hotels_availability_cubit.dart';
import '../cubit/cars_availability_cubit.dart';
import '../widgets/generic_availability_card.dart';
import '../widgets/flights_availability_skeleton.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/presentation/cubit/auth_state.dart';
import 'b2b_my_bookings_page.dart';
import 'b2b_flight_bookings_page.dart';
import 'b2b_hotel_bookings_page.dart';
import 'b2b_car_bookings_page.dart';
import '../../../bookings/presentation/widgets/booking_card.dart';
class B2bDashboardOverview extends StatelessWidget {
  const B2bDashboardOverview({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<B2BOverviewCubit>()..fetchOverview()),
        BlocProvider(create: (context) => sl<FlightsAvailabilityCubit>()..fetchAvailability()),
        BlocProvider(create: (context) => sl<HotelsAvailabilityCubit>()..fetchAvailability()),
        BlocProvider(create: (context) => sl<CarsAvailabilityCubit>()..fetchAvailability()),
      ],
      child: const B2bDashboardOverviewView(),
    );
  }
}

class B2bDashboardOverviewView extends StatelessWidget {
  const B2bDashboardOverviewView({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;

    return BlocBuilder<B2BOverviewCubit, B2BOverviewState>(
      builder: (context, state) {
        if (state is B2BOverviewLoading) {
          return const Center(child: CircularProgressIndicator(color: AppColors.primary));
        } else if (state is B2BOverviewError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(state.message, style: const TextStyle(color: Colors.redAccent)),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => context.read<B2BOverviewCubit>().fetchOverview(),
                  child: const Text('إعادة المحاولة'),
                ),
              ],
            ),
          );
        } else if (state is B2BOverviewLoaded) {
          final data = state.overview;
          return RefreshIndicator(
            onRefresh: () => context.read<B2BOverviewCubit>().fetchOverview(),
            color: AppColors.primary,
            child: SingleChildScrollView(
              padding: EdgeInsets.all(isMobile ? 16.0 : 32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(isMobile),
                  const SizedBox(height: 32),
                  _buildAvailabilitySection(isMobile),
                  const SizedBox(height: 32),
                  _buildKpis(data.kpis, isMobile),
                  const SizedBox(height: 32),
                  if (data.modules.accessibleModules.isNotEmpty) ...[
                    const Text(
                      'الخدمات المتاحة',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildModulesGrid(context, data.modules.accessibleModules, isMobile),
                    const SizedBox(height: 32),
                  ],
                  _buildRecentBookings(context, isMobile),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildHeader(bool isMobile) {
    return _buildHeaderText(isMobile);
  }

  Widget _buildHeaderText(bool isMobile) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        String userName = '';
        if (state is Authenticated) {
          userName = state.user.name;
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              userName.isNotEmpty ? 'مرحباً بك يا $userName،' : 'مرحباً بك في بوابة الشركات،',
              style: const TextStyle(color: AppColors.textMuted, fontSize: 16),
            ),
            const SizedBox(height: 4),
            NeonText(
              'نظرة عامة على النشاط 👋',
              style: TextStyle(
                fontSize: isMobile ? 24 : 32,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildAvailabilitySection(bool isMobile) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth < 600 ? 1 : (constraints.maxWidth < 1100 ? 2 : 3);
        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: isMobile ? 1.3 : 1.5,
          children: [
            _buildFlightsAvailability(),
            _buildHotelsAvailability(),
            _buildCarsAvailability(),
          ],
        );
      },
    );
  }

  Widget _buildFlightsAvailability() {
    return BlocBuilder<FlightsAvailabilityCubit, FlightsAvailabilityState>(
      builder: (context, state) {
        if (state is FlightsAvailabilityLoading) {
          return const FlightsAvailabilitySkeleton();
        } else if (state is FlightsAvailabilityLoaded) {
          return GenericAvailabilityCard(
            availability: state.availability,
            title: 'توفر الرحلات',
            icon: Icons.flight_takeoff,
            accentColor: Colors.blueAccent,
          );
        } else if (state is FlightsAvailabilityError) {
          return Center(child: Text(state.message, style: const TextStyle(color: Colors.redAccent)));
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildHotelsAvailability() {
    return BlocBuilder<HotelsAvailabilityCubit, HotelsAvailabilityState>(
      builder: (context, state) {
        if (state is HotelsAvailabilityLoading) {
          return const FlightsAvailabilitySkeleton();
        } else if (state is HotelsAvailabilityLoaded) {
          return GenericAvailabilityCard(
            availability: state.availability,
            title: 'توفر الفنادق',
            icon: Icons.hotel,
            accentColor: Colors.orangeAccent,
          );
        } else if (state is HotelsAvailabilityError) {
          return Center(child: Text(state.message, style: const TextStyle(color: Colors.redAccent)));
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildCarsAvailability() {
    return BlocBuilder<CarsAvailabilityCubit, CarsAvailabilityState>(
      builder: (context, state) {
        if (state is CarsAvailabilityLoading) {
          return const FlightsAvailabilitySkeleton();
        } else if (state is CarsAvailabilityLoaded) {
          return GenericAvailabilityCard(
            availability: state.availability,
            title: 'توفر السيارات',
            icon: Icons.car_rental,
            accentColor: Colors.greenAccent,
          );
        } else if (state is CarsAvailabilityError) {
          return Center(child: Text(state.message, style: const TextStyle(color: Colors.redAccent)));
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildKpis(var kpis, bool isMobile) {
    return GridView.count(
      crossAxisCount: isMobile ? 1 : 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: isMobile ? 2.2 : 1.4,
      children: [
        B2BKpiCard(
          title: 'إجمالي الإيرادات',
          value: '\$${kpis.totalRevenue.toStringAsFixed(0)}',
          icon: Icons.attach_money,
          color: Colors.greenAccent,
          subtitle: 'نمو مستمر',
        ),
        B2BKpiCard(
          title: 'إجمالي العمولات',
          value: '\$${kpis.totalCommission.toStringAsFixed(0)}',
          icon: Icons.account_balance_wallet,
          color: Colors.purpleAccent,
          subtitle: 'أرباح الوكلاء',
        ),
        B2BKpiCard(
          title: 'متوسط العمولات',
          value: '${kpis.avgCommissionRate.toStringAsFixed(1)}%',
          icon: Icons.trending_up,
          color: Colors.orangeAccent,
          subtitle: 'نسبة الأداء',
        ),
      ],
    );
  }

  Widget _buildModulesGrid(BuildContext context, List<String> modules, bool isMobile) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: modules.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isMobile ? 2 : 4,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.3,
      ),
      itemBuilder: (context, index) {
        final module = modules[index].toLowerCase();
        switch (module) {
          case 'flights':
            return B2BModuleCard(
              title: 'حجوزات الطيران',
              icon: Icons.flight_takeoff,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const B2bFlightBookingsPage()),
                );
              },
            );
          case 'hotels':
            return B2BModuleCard(
              title: 'حجوزات الفنادق',
              icon: Icons.hotel,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const B2bHotelBookingsPage()),
                );
              },
            );
          case 'cars':
            return B2BModuleCard(
              title: 'السيارات والتأجير',
              icon: Icons.car_rental,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const B2bCarBookingsPage()),
                );
              },
            );
          default:
            return const SizedBox.shrink();
        }
      },
    );
  }

  Widget _buildRecentBookings(BuildContext context, bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'أحدث الحجوزات',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {
                final cubit = context.read<B2BMyBookingsCubit>();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BlocProvider.value(
                      value: cubit,
                      child: const B2bMyBookingsPage(),
                    ),
                  ),
                );
              },
              child: const Text(
                'عرض الكل',
                style: TextStyle(color: AppColors.primary),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        BlocBuilder<B2BMyBookingsCubit, B2BMyBookingsState>(
          builder: (context, state) {
            if (state is B2BMyBookingsLoading) {
              return const Center(child: CircularProgressIndicator(color: AppColors.primary));
            } else if (state is B2BMyBookingsError) {
              return Center(
                child: Text(
                  state.message,
                  style: const TextStyle(color: Colors.redAccent),
                ),
              );
            } else if (state is B2BMyBookingsLoaded) {
              // combine some items for "recent" view
              final List<dynamic> all = [
                ...state.bookings.flights.take(1),
                ...state.bookings.hotels.take(1),
                ...state.bookings.cars.take(1),
              ];
              
              if (all.isEmpty) {
                return const Center(child: Text('لا توجد حجوزات حديثة', style: TextStyle(color: AppColors.textMuted)));
              }
              
              return Column(
                children: all.map((b) => const Text('حجز حديث', style: TextStyle(color: Colors.white70))).toList(),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: const Center(
        child: Column(
          children: [
            Icon(Icons.event_note, color: Colors.white24, size: 48),
            const SizedBox(height: 16),
            const Text(
              'لا توجد حجوزات حالياً',
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
