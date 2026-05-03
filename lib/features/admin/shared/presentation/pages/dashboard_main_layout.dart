import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../widgets/sidebar/premium_sidebar.dart';
import '../state/admin_providers.dart';
import '../../../dashboard/presentation/pages/admin_dashboard_overview.dart';
import '../../../flights/presentation/pages/admin_flights_page.dart';
import '../../../hotels/presentation/pages/admin_hotels_page.dart';
import '../../../cars/presentation/pages/admin_cars_page.dart';
import '../../../cars/presentation/pages/admin_cars_page.dart';
import '../../../users/presentation/pages/admin_users_page.dart';

class DashboardLayout extends ConsumerWidget {
  const DashboardLayout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeTab = ref.watch(activeSidebarItemProvider);

    Widget activeContent;
    switch (activeTab) {
      case 'لوحة التحكم':
        activeContent = const AdminDashboardOverview();
        break;
      case 'حجوزات الطيران':
        activeContent = const AdminFlightsPage();
        break;
      case 'حجوزات الفنادق':
        activeContent = const AdminHotelsPage();
        break;
      case 'السيارات والتأجير':
        activeContent = const AdminCarsPage();
        break;
      case 'جميع المستخدمين':
        activeContent = const AdminUsersPage();
        break;
      case 'الوكلاء B2B':
        activeContent = const AdminUsersPage(initialAccountType: 'B2B');
        break;
      case 'العملاء B2C':
        activeContent = const AdminUsersPage(initialAccountType: 'B2C');
        break;
      default:
        activeContent = const AdminDashboardOverview();
    }

    final isDesktop = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: isDesktop
          ? null
          : AppBar(
              backgroundColor: AppColors.backgroundStart,
              elevation: 0,
              iconTheme: const IconThemeData(color: Colors.white),
            ),
      drawer: isDesktop ? null : const PremiumSidebar(),
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(-0.6, -0.4),
            radius: 1.5,
            colors: [
              AppColors.backgroundStart,
              AppColors.backgroundMiddle,
              AppColors.backgroundEnd,
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: isDesktop
            ? Row(
                children: [
                  const PremiumSidebar(),
                  Expanded(
                    child: ClipRRect(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: activeContent,
                      ),
                    ),
                  ),
                ],
              )
            : ClipRRect(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: activeContent,
                ),
              ),
      ),
    );
  }
}
