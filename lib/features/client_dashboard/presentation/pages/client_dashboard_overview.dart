import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/neon_text.dart';
import '../../../../core/widgets/glass_container.dart';

class ClientDashboardOverview extends StatefulWidget {
  const ClientDashboardOverview({super.key});

  @override
  State<ClientDashboardOverview> createState() =>
      _ClientDashboardOverviewState();
}

class _ClientDashboardOverviewState extends State<ClientDashboardOverview> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    // Start at the far right for RTL
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;

    return SingleChildScrollView(
      padding: EdgeInsets.all(isMobile ? 16.0 : 32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome Header
          _buildWelcomeHeader(isMobile),
          const SizedBox(height: 32),

          // Offers Slider (Aligned with Admin)
          _buildOffersSlider(context, isMobile),
          const SizedBox(height: 32),

          // Quick Stats & Next Trip
          if (!isMobile)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 2, child: _buildNextTripCard()),
                const SizedBox(width: 24),
                Expanded(child: _buildLoyaltySmallCard()),
              ],
            )
          else ...[
            _buildNextTripCard(),
            const SizedBox(height: 24),
            _buildLoyaltySmallCard(),
          ],
          const SizedBox(height: 32),

          // Recent Activity
          const Text(
            'الأنشطة الأخيرة',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildRecentActivity(),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildWelcomeHeader(bool isMobile) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'مرحباً بك مجدداً،',
              style: TextStyle(color: AppColors.textMuted, fontSize: 16),
            ),
            const SizedBox(height: 4),
            NeonText(
              'محمد علي 👋',
              style: TextStyle(
                fontSize: isMobile ? 28 : 36,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        if (!isMobile) _buildWeatherWidget(),
      ],
    );
  }

  Widget _buildWeatherWidget() {
    return GlassContainer(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: const Row(
        children: [
          Icon(Icons.wb_sunny_rounded, color: Colors.amber, size: 24),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'الرياض، السعودية',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '32°C - مشمس',
                style: TextStyle(color: AppColors.textMuted, fontSize: 10),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOffersSlider(BuildContext context, bool isMobile) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'أفضل العروض المختارة لك',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: isMobile ? 200 : 250,
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: ListView(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 4),
              children: [
                _buildOfferSlide(
                  'استمتع بصيف المالديف',
                  'خصم يصل إلى 30% على المنتجعات الفاخرة',
                  Colors.cyanAccent,
                  Icons.beach_access,
                  screenWidth,
                ),
                const SizedBox(width: 20),
                _buildOfferSlide(
                  'موسم العروض في اسطنبول',
                  'تذاكر طيران تبدأ من 250\$ شاملة الوزن',
                  Colors.purpleAccent,
                  Icons.local_airport,
                  screenWidth,
                ),
                const SizedBox(width: 20),
                _buildOfferSlide(
                  'دبي ترحب بك',
                  'احجز ليلتين واحصل على الثالثة مجاناً',
                  Colors.orangeAccent,
                  Icons.location_city,
                  screenWidth,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOfferSlide(
    String title,
    String subtitle,
    Color color,
    IconData icon,
    double screenWidth,
  ) {
    return GlassContainer(
      width: screenWidth < 500 ? screenWidth * 0.8 : 400,
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [color.withOpacity(0.2), Colors.transparent],
      ),
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          Icon(icon, color: color.withOpacity(0.5), size: 60),
          const SizedBox(width: 20),
          Expanded(
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 11,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(0.1),
                      foregroundColor: Colors.white,
                      side: BorderSide(color: color.withOpacity(0.5)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                    child: const Text(
                      'احجز الآن',
                      style: TextStyle(fontSize: 11),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNextTripCard() {
    return GlassContainer(
      padding: const EdgeInsets.all(24),
      animateHover: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'رحلتك القادمة',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Icon(Icons.timer_outlined, color: Colors.greenAccent, size: 20),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              const Column(
                children: [
                  Text(
                    '12',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'يوماً',
                    style: TextStyle(color: AppColors.textMuted, fontSize: 12),
                  ),
                ],
              ),
              const SizedBox(width: 32),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'الدوحة ← لندن',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      '20 مايو 2025 · الخطوط القطرية',
                      style: TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 12),
                    LinearProgressIndicator(
                      value: 0.7,
                      backgroundColor: Colors.white.withOpacity(0.05),
                      valueColor: const AlwaysStoppedAnimation(
                        Colors.greenAccent,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLoyaltySmallCard() {
    return GlassContainer(
      padding: const EdgeInsets.all(24),
      gradient: const LinearGradient(
        colors: [Colors.purpleAccent, Colors.transparent],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(Icons.diamond_outlined, color: Colors.white, size: 24),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'المستوى الذهبي',
                  style: TextStyle(color: Colors.white, fontSize: 9),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            '24,500',
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text(
            'نقطة ولاء مكافأة',
            style: TextStyle(color: Colors.white70, fontSize: 12),
          ),
          const SizedBox(height: 16),
          const Text(
            'استبدل نقاطك الآن',
            style: TextStyle(
              color: Colors.white,
              fontSize: 11,
              decoration: TextDecoration.underline,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivity() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 3,
      itemBuilder: (context, index) {
        final items = [
          {
            'title': 'حجز فندق بورتو السخنة',
            'time': 'منذ ساعتين',
            'icon': Icons.hotel,
            'color': Colors.pinkAccent,
          },
          {
            'title': 'تم تأكيد حجز الطيران إلى لندن',
            'time': 'منذ يوم',
            'icon': Icons.flight,
            'color': Colors.greenAccent,
          },
          {
            'title': 'استلام سيارة مرسيدس في مطار الدوحة',
            'time': 'الأسبوع القادم',
            'icon': Icons.directions_car,
            'color': Colors.blueAccent,
          },
        ];
        final item = items[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.03),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.glassBorder),
          ),
          child: Row(
            children: [
              Icon(
                item['icon'] as IconData,
                color: item['color'] as Color,
                size: 20,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['title'] as String,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      item['time'] as String,
                      style: const TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: AppColors.textMuted,
                size: 16,
              ),
            ],
          ),
        );
      },
    );
  }
}
