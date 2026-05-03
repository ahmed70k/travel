import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/neon_text.dart';
import '../../../../core/widgets/glass_container.dart';

class B2bFavoritesPage extends StatefulWidget {
  const B2bFavoritesPage({super.key});

  @override
  State<B2bFavoritesPage> createState() => _B2bFavoritesPageState();
}

class _B2bFavoritesPageState extends State<B2bFavoritesPage> {
  String _activeFilter = 'all';

  void _setFilter(String filter) {
    setState(() {
      _activeFilter = filter;
    });
  }

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

          // Stats
          _buildStatsGrid(isMobile),
          const SizedBox(height: 32),

          // Filters
          _buildFilters(),
          const SizedBox(height: 32),

          // Favorites List
          _buildFavoritesList(),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildHeader(bool isMobile) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.home, color: Colors.purpleAccent, size: 16),
                const SizedBox(width: 8),
                const Text(
                  'الرئيسية',
                  style: TextStyle(color: AppColors.textMuted, fontSize: 14),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.chevron_left,
                  color: AppColors.textMuted,
                  size: 16,
                ),
                const SizedBox(width: 8),
                const Text(
                  'المفضلة',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 12),
            NeonText(
              'المفضلة',
              style: TextStyle(
                fontSize: isMobile ? 28 : 36,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'رحلاتك وفنادقك وسياراتك المفضلة في مكان واحد',
              style: TextStyle(color: AppColors.textMuted, fontSize: 14),
            ),
          ],
        ),
        if (!isMobile)
          Row(
            children: [
              _buildIconButton(Icons.notifications_none),
              const SizedBox(width: 12),
              _buildIconButton(Icons.settings_outlined),
            ],
          ),
      ],
    );
  }

  Widget _buildIconButton(IconData icon) {
    return GlassContainer(
      padding: const EdgeInsets.all(12),
      child: Icon(icon, color: AppColors.textMuted, size: 20),
    );
  }

  Widget _buildStatsGrid(bool isMobile) {
    return GridView.count(
      crossAxisCount: isMobile ? 2 : 4,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: isMobile ? 1.5 : 2.0,
      children: [
        _buildStatCard('إجمالي المفضلة', '8', Icons.favorite, Colors.redAccent),
        _buildStatCard('رحلات طيران', '3', Icons.flight, Colors.purpleAccent),
        _buildStatCard('فنادق', '3', Icons.hotel, Colors.pinkAccent),
        _buildStatCard('سيارات', '2', Icons.directions_car, Colors.blueAccent),
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
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [color.withOpacity(0.1), Colors.transparent],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 12,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    color: title == 'إجمالي المفضلة' ? Colors.white : color,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return GlassContainer(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 16,
        runSpacing: 16,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildFilterChip('all', 'الجميع'),
              _buildFilterChip('flight', 'رحلات طيران'),
              _buildFilterChip('hotel', 'فنادق'),
              _buildFilterChip('car', 'سيارات'),
            ],
          ),
          TextButton.icon(
            onPressed: () {},
            style: TextButton.styleFrom(
              backgroundColor: Colors.redAccent.withOpacity(0.2),
              foregroundColor: Colors.redAccent,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: const Icon(Icons.delete_outline, size: 18),
            label: const Text('حذف الكل', style: TextStyle(fontSize: 13)),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String value, String label) {
    final isActive = _activeFilter == value;
    return GestureDetector(
      onTap: () => _setFilter(value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? null : Colors.white.withOpacity(0.05),
          gradient: isActive
              ? const LinearGradient(
                  colors: [AppColors.primary, AppColors.secondary],
                )
              : null,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.white : AppColors.textMuted,
            fontSize: 13,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildFavoritesList() {
    final isMobile = MediaQuery.of(context).size.width < 800;
    return Column(
      children: [
        if (_activeFilter == 'all' || _activeFilter == 'flight') ...[
          _buildFlightCard(
            'الخطوط القطرية',
            'QR 217 · رحلة مباشرة',
            '09:30',
            'الدوحة (DOH)',
            '13:15',
            'القاهرة (CAI)',
            '320\$',
            'درجة اقتصادية',
            Colors.purpleAccent,
            isMobile,
          ),
          const SizedBox(height: 16),
          _buildFlightCard(
            'طيران الإمارات',
            'EK 304 · رحلة مباشرة',
            '08:00',
            'دبي (DXB)',
            '12:15',
            'اسطنبول (IST)',
            '520\$',
            'درجة رجال أعمال',
            Colors.blueAccent,
            isMobile,
          ),
          const SizedBox(height: 16),
          _buildFlightCard(
            'الخطوط السعودية',
            'SV 102 · رحلة مباشرة',
            '22:15',
            'جدة (JED)',
            '23:45',
            'القاهرة (CAI)',
            '280\$',
            'درجة اقتصادية',
            Colors.greenAccent,
            isMobile,
          ),
          const SizedBox(height: 16),
        ],
        if (_activeFilter == 'all' || _activeFilter == 'hotel') ...[
          _buildHotelCard(
            'فندق بورتو السخنة',
            'العين السخنة، مصر',
            '4.5',
            '116\$/ليلة',
            ['إفطار شامل', 'مسبح', 'وايفاي مجاني'],
            Colors.pinkAccent,
            isMobile,
          ),
          const SizedBox(height: 16),
          _buildHotelCard(
            'فندق جميرا بيتش',
            'دبي، الإمارات',
            '4.9',
            '408\$/ليلة',
            ['إفطار + عشاء', 'سبا مجاني', 'مواصلات مجانية'],
            Colors.blueAccent,
            isMobile,
          ),
          const SizedBox(height: 16),
          _buildHotelCard(
            'فندق ريتز كارلتون',
            'الدوحة، قطر',
            '4.8',
            '320\$/ليلة',
            ['ترحيبية مجانية', 'جيم'],
            Colors.amber,
            isMobile,
          ),
          const SizedBox(height: 16),
        ],
        if (_activeFilter == 'all' || _activeFilter == 'car') ...[
          _buildCarCard(
            'مرسيدس E-Class',
            'فاخرة · أوتوماتيك · 4 أبواب',
            '130\$/يوم',
            'شامل',
            Colors.cyan,
            isMobile,
          ),
          const SizedBox(height: 16),
          _buildCarCard(
            'تويوتا لاند كروزر',
            'SUV · 7 مقاعد · 4x4',
            '120\$/يوم',
            'شامل',
            Colors.green,
            isMobile,
          ),
        ],
      ],
    );
  }

  Widget _buildFlightCard(
    String airline,
    String details,
    String depTime,
    String depLoc,
    String arrTime,
    String arrLoc,
    String price,
    String clazz,
    Color color,
    bool isMobile,
  ) {
    return GlassContainer(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          isMobile
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(Icons.flight, color: color),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                airline,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                details,
                                style: const TextStyle(
                                  color: AppColors.textMuted,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Text(
                              depTime,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              depLoc,
                              style: const TextStyle(
                                color: AppColors.textMuted,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        Icon(Icons.arrow_back, color: color),
                        Column(
                          children: [
                            Text(
                              arrTime,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              arrLoc,
                              style: const TextStyle(
                                color: AppColors.textMuted,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              price,
                              style: const TextStyle(
                                color: Colors.purpleAccent,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              clazz,
                              style: const TextStyle(
                                color: AppColors.textMuted,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.purpleAccent,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text('احجز الآن'),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.heart_broken,
                                color: Colors.redAccent,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                )
              : Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.flight, color: color),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            airline,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            details,
                            style: const TextStyle(
                              color: AppColors.textMuted,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              Text(
                                depTime,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                depLoc,
                                style: const TextStyle(
                                  color: AppColors.textMuted,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          Icon(Icons.arrow_back, color: color),
                          Column(
                            children: [
                              Text(
                                arrTime,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                arrLoc,
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
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            price,
                            style: const TextStyle(
                              color: Colors.purpleAccent,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            clazz,
                            style: const TextStyle(
                              color: AppColors.textMuted,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purpleAccent,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text('احجز الآن'),
                        ),
                        const SizedBox(width: 12),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.heart_broken,
                            color: Colors.redAccent,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
          const SizedBox(height: 16),
          const Divider(color: AppColors.glassBorder),
          const SizedBox(height: 12),
          Wrap(
            spacing: 16,
            runSpacing: 8,
            alignment: WrapAlignment.spaceBetween,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.calendar_today,
                    size: 14,
                    color: AppColors.textMuted,
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    'رحلات يومية',
                    style: TextStyle(color: AppColors.textMuted, fontSize: 12),
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.access_time,
                    size: 14,
                    color: AppColors.textMuted,
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    'المدة: 3 ساعات 45 د',
                    style: TextStyle(color: AppColors.textMuted, fontSize: 12),
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.luggage,
                    size: 14,
                    color: AppColors.textMuted,
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    '30 كجم أمتعة',
                    style: TextStyle(color: AppColors.textMuted, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHotelCard(
    String name,
    String location,
    String rating,
    String price,
    List<String> tags,
    Color color,
    bool isMobile,
  ) {
    return GlassContainer(
      padding: const EdgeInsets.all(20),
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        Icons.hotel,
                        color: color.withOpacity(0.5),
                        size: 40,
                      ),
                    ),
                    const SizedBox(width: 16),
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
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 14,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '$rating · رائع',
                                style: const TextStyle(
                                  color: AppColors.textMuted,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.location_on, color: color, size: 14),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  location,
                                  style: const TextStyle(
                                    color: AppColors.textMuted,
                                    fontSize: 12,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            price,
                            style: const TextStyle(
                              color: Colors.purpleAccent,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: tags
                      .map(
                        (tag) => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            tag,
                            style: TextStyle(color: color, fontSize: 10),
                          ),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purpleAccent,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('احجز الآن'),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.heart_broken,
                        color: Colors.redAccent,
                      ),
                    ),
                  ],
                ),
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 150,
                  height: 120,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    Icons.hotel,
                    color: color.withOpacity(0.5),
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
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                    size: 14,
                                  ),
                                  const Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                    size: 14,
                                  ),
                                  const Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                    size: 14,
                                  ),
                                  const Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                    size: 14,
                                  ),
                                  const Icon(
                                    Icons.star_half,
                                    color: Colors.amber,
                                    size: 14,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    '$rating · رائع',
                                    style: const TextStyle(
                                      color: AppColors.textMuted,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(
                                    Icons.location_on,
                                    color: color,
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
                          Text(
                            price,
                            style: const TextStyle(
                              color: Colors.purpleAccent,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: tags
                            .map(
                              (tag) => Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: color.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  tag,
                                  style: TextStyle(color: color, fontSize: 10),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.purpleAccent,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text('احجز الآن'),
                          ),
                          const SizedBox(width: 12),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.heart_broken,
                              color: Colors.redAccent,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildCarCard(
    String name,
    String details,
    String price,
    String insurance,
    Color color,
    bool isMobile,
  ) {
    return GlassContainer(
      padding: const EdgeInsets.all(20),
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(Icons.directions_car, color: color, size: 32),
                    ),
                    const SizedBox(width: 16),
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
                          ),
                          Text(
                            details,
                            style: const TextStyle(
                              color: AppColors.textMuted,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'السعر اليومي',
                          style: TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          price,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'التأمين',
                          style: TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          insurance,
                          style: const TextStyle(
                            color: Colors.greenAccent,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purpleAccent,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('استأجر الآن'),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.heart_broken,
                        color: Colors.redAccent,
                      ),
                    ),
                  ],
                ),
              ],
            )
          : Row(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(Icons.directions_car, color: color, size: 32),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 2,
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
                      ),
                      Text(
                        details,
                        style: const TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'السعر اليومي',
                        style: TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        price,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'التأمين',
                        style: TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        insurance,
                        style: const TextStyle(
                          color: Colors.greenAccent,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purpleAccent,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('استأجر الآن'),
                    ),
                    const SizedBox(width: 12),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.heart_broken,
                        color: Colors.redAccent,
                      ),
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}
