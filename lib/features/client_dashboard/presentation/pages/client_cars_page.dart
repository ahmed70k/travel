import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/neon_text.dart';
import '../../../../core/widgets/glass_container.dart';

class ClientCarsPage extends ConsumerStatefulWidget {
  const ClientCarsPage({super.key});

  @override
  ConsumerState<ClientCarsPage> createState() => _ClientCarsPageState();
}

class _ClientCarsPageState extends ConsumerState<ClientCarsPage> {
  String _activeFilter = 'all';

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

          // Car Stats
          _buildCarStats(isMobile),
          const SizedBox(height: 32),

          // Filters
          _buildFilters(isMobile),
          const SizedBox(height: 32),

          // Cars List
          _buildCarsList(isMobile),
          const SizedBox(height: 48),

          // Insurance Note
          _buildInsuranceBanner(),
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
            Icon(Icons.home, color: Colors.blueAccent, size: 14),
            SizedBox(width: 8),
            Text(
              'الرئيسية',
              style: TextStyle(color: AppColors.textMuted, fontSize: 12),
            ),
            SizedBox(width: 4),
            Icon(Icons.chevron_left, color: AppColors.textMuted, size: 12),
            SizedBox(width: 4),
            Text(
              'سياراتي المستأجرة',
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ],
        ),
        const SizedBox(height: 12),
        NeonText(
          'سياراتي المستأجرة',
          style: TextStyle(
            fontSize: isMobile ? 28 : 40,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'إدارة ومتابعة عقود تأجير السيارات الفاخرة',
          style: TextStyle(color: AppColors.textMuted),
        ),
      ],
    );
  }

  Widget _buildCarStats(bool isMobile) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: isMobile ? 2 : 3,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.8,
      children: [
        _buildStatCard(
          'إجمالي السيارات',
          '1',
          Icons.directions_car,
          Colors.blueAccent,
        ),
        _buildStatCard(
          'أيام التأجير',
          '5',
          Icons.event_available,
          Colors.greenAccent,
        ),
        _buildStatCard(
          'تكلفة النقل',
          '650\$',
          Icons.payments,
          Colors.purpleAccent,
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return GlassContainer(
      padding: const EdgeInsets.all(12),
      animateHover: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(height: 8),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Text(
            title,
            style: const TextStyle(color: AppColors.textMuted, fontSize: 10),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildFilters(bool isMobile) {
    return Row(
      children: [
        _buildFilterChip('الجميع', 'all'),
        _buildFilterChip('نشطة حالياً', 'active'),
        _buildFilterChip('سابقة', 'completed'),
      ],
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final isActive = _activeFilter == value;
    return GestureDetector(
      onTap: () => setState(() => _activeFilter = value),
      child: Container(
        margin: const EdgeInsets.only(left: 8),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          gradient: isActive
              ? const LinearGradient(
                  colors: [Colors.blueAccent, Colors.cyanAccent],
                )
              : null,
          color: isActive ? null : Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.white : AppColors.textMuted,
            fontSize: 12,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildCarsList(bool isMobile) {
    return _buildCarCard(
      name: 'مرسيدس بنز E-Class',
      type: 'سيدان فاخرة',
      price: '650\$',
      pickup: '10 يونيو 2025',
      dropoff: '15 يونيو 2025',
      location: 'مطار الدوحة الدولي (الاستلام)',
      status: 'نشط',
      statusColor: Colors.greenAccent,
      icon: Icons.directions_car,
      features: ['أوتوماتيك', 'تأمين شامل', 'نظام GPS'],
    );
  }

  Widget _buildCarCard({
    required String name,
    required String type,
    required String price,
    required String pickup,
    required String dropoff,
    required String location,
    required String status,
    required Color statusColor,
    required IconData icon,
    required List<String> features,
  }) {
    return GlassContainer(
      padding: const EdgeInsets.all(24),
      animateHover: true,
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.blueAccent.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.blueAccent.withOpacity(0.3)),
                ),
                child: Icon(icon, color: Colors.blueAccent, size: 40),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      type,
                      style: const TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    price,
                    style: const TextStyle(
                      color: Colors.blueAccent,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'إجمالي 5 أيام',
                    style: TextStyle(color: AppColors.textMuted, fontSize: 9),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Divider(color: AppColors.glassBorder),
          const SizedBox(height: 16),
          _buildLocationInfo(location),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildDateInfo('تاريخ الاستلام', pickup),
              _buildDateInfo('تاريخ الإعادة', dropoff),
            ],
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 8,
            runSpacing: 12,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: statusColor.withOpacity(0.3)),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ...features.map((f) => _buildFeatureTag(f)).toList(),
              _buildActionButton(label: 'تعديل الحجز'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({required String label}) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blueAccent.withOpacity(0.2),
        foregroundColor: Colors.white,
        side: const BorderSide(color: Colors.blueAccent),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      child: Text(label, style: const TextStyle(fontSize: 11)),
    );
  }

  Widget _buildLocationInfo(String location) {
    return Row(
      children: [
        const Icon(Icons.location_on, color: Colors.blueAccent, size: 16),
        const SizedBox(width: 8),
        Text(
          location,
          style: const TextStyle(color: Colors.white70, fontSize: 13),
        ),
      ],
    );
  }

  Widget _buildDateInfo(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: AppColors.textMuted, fontSize: 11),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureTag(String label) {
    return Container(
      margin: const EdgeInsets.only(left: 8),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: const TextStyle(color: Colors.white54, fontSize: 10),
      ),
    );
  }

  Widget _buildInsuranceBanner() {
    return GlassContainer(
      padding: const EdgeInsets.all(20),
      gradient: LinearGradient(
        colors: [Colors.blueAccent.withOpacity(0.2), Colors.transparent],
      ),
      child: const Row(
        children: [
          Icon(Icons.verified_user, color: Colors.blueAccent, size: 30),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'تأمين VIP شامل الحماية',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'حجزك الحالي يشمل حماية كاملة ضد الحوادث والسرقة لضمان راحتك.',
                  style: TextStyle(color: AppColors.textMuted, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
