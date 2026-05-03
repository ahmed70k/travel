import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/neon_text.dart';
import '../../../../core/widgets/glass_container.dart';

class ClientProfilePage extends StatelessWidget {
  const ClientProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;

    return SingleChildScrollView(
      padding: EdgeInsets.all(isMobile ? 16.0 : 32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          _buildHeader(isMobile),
          const SizedBox(height: 32),

          // Profile Header Card
          _buildProfileHeaderCard(isMobile),
          const SizedBox(height: 32),

          // Main Settings Grid
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

  Widget _buildProfileHeaderCard(bool isMobile) {
    return GlassContainer(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: isMobile ? 40 : 50,
                backgroundColor: Colors.blueAccent.withOpacity(0.1),
                child: const Icon(
                  Icons.person,
                  color: Colors.blueAccent,
                  size: 40,
                ),
              ),
              Position8(
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
                  'محمد علي',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'moh.ali@example.com',
                  style: TextStyle(color: AppColors.textMuted, fontSize: 13),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildBadge('عميل متميز (Gold)', Colors.amber),
                    _buildBadge('عضو منذ 2023', Colors.blueAccent),
                  ],
                ),
              ],
            ),
          ),
          if (!isMobile)
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white.withOpacity(0.05),
                foregroundColor: Colors.white,
                side: const BorderSide(color: AppColors.glassBorder),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              child: const Text('تعديل الملف'),
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
          _buildTextField('الاسم الكامل', 'محمد علي'),
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
          const Icon(Icons.chevron_right, color: AppColors.textMuted, size: 16),
        ],
      ),
    );
  }
}

class Position8 extends StatelessWidget {
  final Widget child;
  final double? bottom;
  final double? right;
  const Position8({super.key, required this.child, this.bottom, this.right});
  @override
  Widget build(BuildContext context) {
    return Positioned(bottom: bottom, right: right, child: child);
  }
}
