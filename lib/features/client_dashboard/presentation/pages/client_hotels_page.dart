import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/neon_text.dart';
import '../../../../core/widgets/glass_container.dart';
import '../state/client_providers.dart';

class ClientHotelsPage extends ConsumerStatefulWidget {
  const ClientHotelsPage({super.key});

  @override
  ConsumerState<ClientHotelsPage> createState() => _ClientHotelsPageState();
}

class _ClientHotelsPageState extends ConsumerState<ClientHotelsPage> {
  String _activeFilter = 'all';
  String _sortBy = 'date';

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

          // Hotel Stats
          _buildHotelStats(isMobile),
          const SizedBox(height: 32),

          // Filters & Sort
          _buildFiltersAndSort(isMobile),
          const SizedBox(height: 32),

          // Hotels List
          _buildHotelsList(isMobile),
          const SizedBox(height: 48),

          // Recommendations
          _buildRecommendations(isMobile),
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
            Icon(Icons.home, color: Colors.purpleAccent, size: 14),
            SizedBox(width: 8),
            Text(
              'الرئيسية',
              style: TextStyle(color: AppColors.textMuted, fontSize: 12),
            ),
            SizedBox(width: 4),
            Icon(Icons.chevron_left, color: AppColors.textMuted, size: 12),
            SizedBox(width: 4),
            Text('فنادقي', style: TextStyle(color: Colors.white, fontSize: 12)),
          ],
        ),
        const SizedBox(height: 12),
        NeonText(
          'فنادقي',
          style: TextStyle(
            fontSize: isMobile ? 28 : 40,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'إدارة ومتابعة جميع حجوزات الفنادق والمنتجعات',
          style: TextStyle(color: AppColors.textMuted),
        ),
      ],
    );
  }

  Widget _buildHotelStats(bool isMobile) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: isMobile ? 2 : 4,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.6,
      children: [
        _buildStatCard('حجوزات الفنادق', '3', Icons.hotel, Colors.pinkAccent),
        _buildStatCard(
          'ليالي قادمة',
          '11',
          Icons.calendar_today,
          Colors.greenAccent,
        ),
        _buildStatCard(
          'إجمالي الإنفاق',
          '3,610\$',
          Icons.attach_money,
          Colors.amber,
        ),
        _buildStatCard('إلغاء مجاني', '2', Icons.shield, Colors.blueAccent),
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
            style: const TextStyle(color: AppColors.textMuted, fontSize: 9),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildFiltersAndSort(bool isMobile) {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildFilterChip('الجميع', 'all'),
            _buildFilterChip('قادمة', 'upcoming'),
            _buildFilterChip('سابقة', 'completed'),
          ],
        ),
        if (!isMobile)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'ترتيب حسب: ',
                style: TextStyle(color: AppColors.textMuted, fontSize: 12),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.glassBorder),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _sortBy,
                    dropdownColor: const Color(0xFF1E1A3A),
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                    items: const [
                      DropdownMenuItem(value: 'date', child: Text('التاريخ')),
                      DropdownMenuItem(value: 'price', child: Text('السعر')),
                      DropdownMenuItem(value: 'rating', child: Text('التقييم')),
                    ],
                    onChanged: (v) => setState(() => _sortBy = v!),
                  ),
                ),
              ),
            ],
          ),
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
                  colors: [Colors.purpleAccent, Colors.pinkAccent],
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

  Widget _buildHotelsList(bool isMobile) {
    return Column(
      children: [
        _buildHotelCard(
          name: 'فندق بورتو السخنة',
          location: 'العين السخنة، مصر',
          price: '580\$',
          rating: 4.5,
          ratingText: 'ممتاز',
          checkIn: '10 يونيو 2025',
          checkOut: '15 يونيو 2025',
          nights: '5 ليال',
          room: 'غرفة مزدوجة مطلة على البحر',
          status: 'مؤكد',
          statusColor: Colors.greenAccent,
          icon: Icons.hotel,
          image: Icons.beach_access,
        ),
        const SizedBox(height: 24),
        _buildHotelCard(
          name: 'فندق جميرا بيتش',
          location: 'دبي، الإمارات',
          price: '2,450\$',
          rating: 4.9,
          ratingText: 'رائع',
          checkIn: '01 يوليو 2025',
          checkOut: '07 يوليو 2025',
          nights: '6 ليال',
          room: 'جناح فاخر - إطلالة بحر',
          status: 'قيد الانتظار',
          statusColor: Colors.amber,
          icon: Icons.umbrella,
          image: Icons.nights_stay,
        ),
        const SizedBox(height: 24),
        _buildHotelCard(
          name: 'فندق إنتركونتنينتال',
          location: 'الرياض، السعودية',
          price: '1,480\$',
          rating: 4.7,
          ratingText: 'ممتاز',
          checkIn: '10 مارس 2025',
          checkOut: '15 مارس 2025',
          nights: '5 ليال',
          room: 'غرفة تنفيذية',
          status: 'مكتمل',
          statusColor: Colors.blueAccent,
          icon: Icons.business,
          image: Icons.location_city,
        ),
      ],
    );
  }

  Widget _buildHotelCard({
    required String name,
    required String location,
    required String price,
    required double rating,
    required String ratingText,
    required String checkIn,
    required String checkOut,
    required String nights,
    required String room,
    required String status,
    required Color statusColor,
    required IconData icon,
    required IconData image,
  }) {
    return GlassContainer(
      padding: const EdgeInsets.all(24),
      animateHover: true,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.glassBorder),
                ),
                child: Icon(
                  image,
                  color: Colors.pinkAccent.withOpacity(0.5),
                  size: 48,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          price,
                          style: const TextStyle(
                            color: Colors.pinkAccent,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          '$rating · $ratingText',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                        const Spacer(),
                        const Text(
                          'إجمالي الإقامة',
                          style: TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: Colors.pinkAccent,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          location,
                          style: const TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Divider(color: AppColors.glassBorder),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildDataNode('الوصول', checkIn),
                const SizedBox(width: 20),
                _buildDataNode('المغادرة', checkOut),
                const SizedBox(width: 20),
                _buildDataNode('المدة', nights),
                const SizedBox(width: 20),
                _buildDataNode('الغرفة', room),
              ],
            ),
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
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              _buildIconBadge(Icons.restaurant, 'إفطار شامل'),
              _buildIconBadge(Icons.wifi, 'وايفاي مجاني'),
              const SizedBox(width: 8),
              _buildActionButton('تفاصيل الحجز', Colors.white, isPrimary: true),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDataNode(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: AppColors.textMuted, fontSize: 10),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildIconBadge(IconData icon, String label) {
    return Container(
      margin: const EdgeInsets.only(left: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, size: 12, color: Colors.white54),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(color: Colors.white54, fontSize: 9),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    String label,
    Color color, {
    bool isPrimary = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: isPrimary
            ? const LinearGradient(
                colors: [Colors.purpleAccent, Colors.pinkAccent],
              )
            : null,
        border: isPrimary ? null : Border.all(color: color.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildRecommendations(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'قد يعجبك أيضاً',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'عرض المزيد',
              style: TextStyle(color: Colors.pinkAccent, fontSize: 12),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildRecItem(
                'منتجع موفنبيك',
                'الغردقة، مصر',
                '180\$',
                Icons.waves,
              ),
            ),
            const SizedBox(width: 16),
            if (!isMobile) ...[
              Expanded(
                child: _buildRecItem(
                  'ريتز كارلتون',
                  'الدوحة، قطر',
                  '320\$',
                  Icons.location_city,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildRecItem(
                  'فور سيزونز',
                  'اسطنبول، تركيا',
                  '280\$',
                  Icons.landscape,
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildRecItem(String name, String city, String price, IconData icon) {
    return GlassContainer(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Icon(icon, color: Colors.blueAccent, size: 32),
          const SizedBox(height: 12),
          Text(
            name,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            city,
            style: const TextStyle(color: AppColors.textMuted, fontSize: 10),
          ),
          const SizedBox(height: 8),
          Text(
            '$price / ليلة',
            style: const TextStyle(
              color: Colors.purpleAccent,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          _buildActionButton('احجز الآن', Colors.white, isPrimary: true),
        ],
      ),
    );
  }
}
