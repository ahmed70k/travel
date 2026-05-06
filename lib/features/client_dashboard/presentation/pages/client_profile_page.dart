import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/neon_text.dart';
import '../../../../core/widgets/glass_container.dart';
import '../state/me_dashboard_cubit.dart';
import '../state/me_dashboard_state.dart';
import '../../domain/entities/me_dashboard_entity.dart';

class ClientProfilePage extends StatelessWidget {
  const ClientProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;

    return BlocBuilder<MeDashboardCubit, MeDashboardState>(
      builder: (context, state) {
        if (state is MeDashboardLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is MeDashboardError) {
          return Center(
            child: Text(
              state.message,
              style: const TextStyle(color: Colors.redAccent),
            ),
          );
        } else if (state is MeDashboardLoaded) {
          return RefreshIndicator(
            onRefresh: () => context.read<MeDashboardCubit>().refresh(),
            child: SingleChildScrollView(
              padding: EdgeInsets.all(isMobile ? 16.0 : 32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(isMobile),
                  const SizedBox(height: 32),
                  _buildRoleBadgeCard(state.data),
                  const SizedBox(height: 32),
                  _buildKPIGrid(state.data.kpis, isMobile),
                  const SizedBox(height: 32),
                  if (!isMobile)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 2, child: _buildPersonalInfo()),
                        const SizedBox(width: 24),
                        Expanded(child: _buildSideSettings()),
                      ],
                    )
                  else ...[
                    _buildPersonalInfo(),
                    const SizedBox(height: 24),
                    _buildSideSettings(),
                  ],
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.person_outline, color: Colors.blueAccent, size: 14),
            SizedBox(width: 8),
            Text(
              'الرئيسية',
              style: TextStyle(color: AppColors.textMuted, fontSize: 12),
            ),
            SizedBox(width: 4),
            Icon(Icons.chevron_left, color: AppColors.textMuted, size: 12),
            SizedBox(width: 4),
            Text(
              'ملفي الشخصي',
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ],
        ),
        const SizedBox(height: 12),
        NeonText(
          'إعدادات الحساب',
          style: TextStyle(
            fontSize: isMobile ? 28 : 40,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildRoleBadgeCard(MeDashboardEntity data) {
    final roleLabel = _roleLabel(data.role);
    final roleColor = _roleColor(data.role);

    return GlassContainer(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: roleColor.withOpacity(0.1),
                child: Icon(
                  Icons.person,
                  color: roleColor,
                  size: 40,
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.pinkAccent,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'مستخدم النظام',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'دور: $roleLabel',
                  style: const TextStyle(
                      color: AppColors.textMuted, fontSize: 13),
                ),
                const SizedBox(height: 12),
                _buildBadge(roleLabel, roleColor),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKPIGrid(MeDashboardKPIEntity kpis, bool isMobile) {
    return GridView.count(
      crossAxisCount: isMobile ? 2 : 4,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.5,
      children: [
        _buildKPICard(
          'وكالات B2B',
          kpis.b2bAgencies.toString(),
          kpis.b2bDelta,
          Icons.business,
          Colors.purpleAccent,
        ),
        _buildKPICard(
          'عملاء B2C',
          kpis.b2cCustomers.toString(),
          kpis.b2cDelta,
          Icons.people_outline,
          Colors.blueAccent,
        ),
        _buildKPICard(
          'إجمالي الأرباح',
          kpis.formattedProfit,
          kpis.profitDelta,
          Icons.attach_money,
          Colors.greenAccent,
        ),
        _buildKPICard(
          'إجمالي الحجوزات',
          kpis.totalBookings.toString(),
          kpis.bookingsDelta,
          Icons.airplane_ticket_outlined,
          Colors.orangeAccent,
        ),
      ],
    );
  }

  Widget _buildKPICard(
    String title,
    String value,
    String delta,
    IconData icon,
    Color color,
  ) {
    return GlassContainer(
      padding: const EdgeInsets.all(16),
      animateHover: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                      color: AppColors.textMuted, fontSize: 11),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (delta.isNotEmpty)
            Text(
              delta,
              style: TextStyle(color: color, fontSize: 10),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
        ],
      ),
    );
  }

  Widget _buildBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildPersonalInfo() {
    return GlassContainer(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'المعلومات الشخصية',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          _buildTextField('الاسم الكامل', 'مستخدم النظام'),
          const SizedBox(height: 16),
          _buildTextField('رقم الهاتف', '+966 50 123 4567'),
          const SizedBox(height: 16),
          _buildTextField('تاريخ الميلاد', '15 / 05 / 1992'),
          const SizedBox(height: 16),
          _buildTextField('العنوان', 'الرياض، المملكة العربية السعودية'),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('حفظ التغييرات'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.02),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.glassBorder),
          ),
          child: Text(value, style: const TextStyle(color: Colors.white)),
        ),
      ],
    );
  }

  Widget _buildSideSettings() {
    return Column(
      children: [
        _buildSettingsGroup('الأمان وخصوصية الحساب', [
          _buildSettingsItem(Icons.lock_outline, 'تغيير كلمة المرور'),
          _buildSettingsItem(Icons.security, 'المصادقة الثنائية'),
          _buildSettingsItem(Icons.notifications_none, 'إشعارات الحساب'),
        ]),
        const SizedBox(height: 24),
        _buildSettingsGroup('تفضيلات التطبيق', [
          _buildSettingsItem(Icons.language, 'اللغة العربية'),
          _buildSettingsItem(Icons.monetization_on_outlined, 'العملة (SAR)'),
          _buildSettingsItem(Icons.color_lens_outlined, 'المظهر (Dark Mode)'),
        ]),
      ],
    );
  }

  Widget _buildSettingsGroup(String title, List<Widget> items) {
    return GlassContainer(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...items,
        ],
      ),
    );
  }

  Widget _buildSettingsItem(IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(icon, color: AppColors.textMuted, size: 20),
          const SizedBox(width: 16),
          Text(
            title,
            style: const TextStyle(color: Colors.white70, fontSize: 13),
          ),
          const Spacer(),
          const Icon(Icons.chevron_right,
              color: AppColors.textMuted, size: 16),
        ],
      ),
    );
  }

  String _roleLabel(String role) {
    switch (role) {
      case 'admin':
        return 'مدير النظام';
      case 'b2b':
        return 'وكالة سفر';
      case 'b2c':
        return 'عميل';
      default:
        return role;
    }
  }

  Color _roleColor(String role) {
    switch (role) {
      case 'admin':
        return Colors.purpleAccent;
      case 'b2b':
        return Colors.blueAccent;
      case 'b2c':
        return Colors.orangeAccent;
      default:
        return Colors.white;
    }
  }
}
