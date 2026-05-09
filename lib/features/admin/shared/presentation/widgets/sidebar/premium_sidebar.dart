import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../../core/di/dependency_injection.dart';
import '../../../../../../../core/theme/app_colors.dart';
import '../../../../../../../core/widgets/glass_container.dart';
import '../../../../../../../core/widgets/neon_text.dart';
import '../../../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../../../auth/presentation/cubit/auth_state.dart';
import '../../../../../auth/presentation/cubit/logout_cubit.dart';
import '../../../../../auth/presentation/cubit/logout_state.dart';
import '../../../../../auth/presentation/pages/login_page.dart';
import '../../state/sidebar_state.dart';

class PremiumSidebar extends ConsumerWidget {
  const PremiumSidebar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GlassContainer(
      borderRadius: 0,
      width: 280, // w-80 mapped approx to 320, here 280 for better fit
      padding: const EdgeInsets.only(top: 0),
      child: SafeArea(
        bottom: false,
        child: Column(
        children: [
          // Header Logo
          Container(
            padding: const EdgeInsets.only(top: 48, left: 24, right: 24, bottom: 24),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.glassBorder)),
            ),
            child: Row(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primary.withOpacity(0.5),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.5),
                            blurRadius: 15,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                    ),
                    const NeonText('✈', style: TextStyle(fontSize: 24)),
                  ],
                ),
                const SizedBox(width: 12),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    NeonText(
                      'وكالة السفر',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Admin Dashboard Pro',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(
                vertical: 24.0,
                horizontal: 16.0,
              ),
              children: [
                _buildSectionTitle('الرئيسية'),
                const SidebarItem(
                  title: 'لوحة التحكم',
                  icon: Icons.dashboard,
                  hasArrow: true,
                ),

                const SizedBox(height: 24),
                _buildSectionTitle('الحجوزات'),
                const SidebarItem(
                  title: 'حجوزات الطيران',
                  icon: Icons.flight,
                ),
                const SidebarItem(
                  title: 'حجوزات الفنادق',
                  icon: Icons.hotel,
                ),
                const SidebarItem(
                  title: 'السيارات والتأجير',
                  icon: Icons.directions_car,
                ),

                const SizedBox(height: 24),
                _buildSectionTitle('المستخدمين'),
                const SidebarItem(title: 'جميع المستخدمين', icon: Icons.people),
                const SidebarItem(title: 'الوكلاء B2B', icon: Icons.business),
                const SidebarItem(title: 'العملاء B2C', icon: Icons.person),
                const SizedBox(height: 24),
                _buildSectionTitle('الحساب'),
                const SidebarItem(title: 'الملف الشخصي', icon: Icons.person_outline),
              ],
            ),
          ),

          // Profiler
          Container(
            margin: const EdgeInsets.all(16.0),
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: AppColors.glassBackground,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.glassBorder),
            ),
            child: Row(
              children: [
                Expanded(
                  child: BlocBuilder<AuthCubit, AuthState>(
                    builder: (context, state) {
                      String name = 'جاري التحميل...';
                      String email = '...';
                      String initials = 'أم';

                      if (state is Authenticated) {
                        name = state.user.name;
                        email = state.user.email;
                        initials = name.length >= 2 ? name.substring(0, 2) : name;
                      }

                      return Row(
                        children: [
                          Stack(
                            children: [
                              CircleAvatar(
                                backgroundColor: AppColors.primary,
                                child: Text(initials,
                                    style: const TextStyle(color: Colors.white)),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color: AppColors.success,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: AppColors.backgroundStart,
                                      width: 2,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  email,
                                  style: const TextStyle(
                                    color: AppColors.textMuted,
                                    fontSize: 12,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                BlocProvider(
                  create: (context) => sl<LogoutCubit>(),
                  child: BlocConsumer<LogoutCubit, LogoutState>(
                    listener: (context, state) {
                      if (state is LogoutSuccess) {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (_) => const LoginPage()),
                          (route) => false,
                        );
                      } else if (state is LogoutError) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Logout failed: ${state.message}'),
                          ),
                        );
                        // Still navigate or stay? Usually force logout locally is safer
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (_) => const LoginPage()),
                          (route) => false,
                        );
                      }
                    },
                    builder: (context, state) {
                      if (state is LogoutLoading) {
                        return const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        );
                      }
                      return IconButton(
                        icon: const Icon(
                          Icons.logout,
                          color: AppColors.textMuted,
                          size: 20,
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
          ),
        ],
      ),
     ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 12,
          color: AppColors.textMuted,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.0,
        ),
      ),
    );
  }
}

class SidebarItem extends ConsumerWidget {
  final String title;
  final IconData icon;
  final String? badge;
  final Color? badgeColor;
  final bool hasArrow;

  const SidebarItem({
    super.key,
    required this.title,
    required this.icon,
    this.badge,
    this.badgeColor,
    this.hasArrow = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isActive = ref.watch(activeSidebarItemProvider) == title;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          ref.read(activeSidebarItemProvider.notifier).setItem(title);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.only(bottom: 4.0),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: isActive
                ? LinearGradient(
                    colors: [
                      AppColors.primary.withOpacity(0.3),
                      Colors.transparent,
                    ],
                    begin: Alignment.centerRight,
                    end: Alignment.centerLeft,
                  )
                : null,
            border: isActive
                ? const Border(
                    right: BorderSide(color: AppColors.primary, width: 3),
                  )
                : null,
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: isActive ? AppColors.primary : AppColors.textMuted,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: isActive ? Colors.white : AppColors.textMuted,
                    fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
              if (badge != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 2.0,
                  ),
                  decoration: BoxDecoration(
                    color: (badgeColor ?? AppColors.primary).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    badge!,
                    style: TextStyle(
                      fontSize: 10,
                      color: badgeColor ?? AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              if (hasArrow && badge == null)
                Icon(
                  Icons.show_chart,
                  size: 16,
                  color: isActive ? AppColors.primary : AppColors.textMuted,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
