import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/neon_text.dart';
import '../../../../core/widgets/glass_container.dart';

class ClientLoyaltyPage extends StatelessWidget {
  const ClientLoyaltyPage({super.key});

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

          // Main Card
          _buildLoyaltyCard(isMobile),
          const SizedBox(height: 32),

          // Benefits Section
          const Text(
            'مميزات مستواك الحالي',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildBenefitsList(isMobile),
          const SizedBox(height: 32),

          // Operations History
          const Text(
            'سجل النقاط',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildHistoryTable(),
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
            Icon(Icons.diamond_outlined, color: Colors.purpleAccent, size: 14),
            SizedBox(width: 8),
            Text(
              'الرئيسية',
              style: TextStyle(color: AppColors.textMuted, fontSize: 12),
            ),
            SizedBox(width: 4),
            Icon(Icons.chevron_left, color: AppColors.textMuted, size: 12),
            SizedBox(width: 4),
            Text(
              'نقاط الولاء',
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ],
        ),
        const SizedBox(height: 12),
        NeonText(
          'مركز الولاء والمكافآت',
          style: TextStyle(
            fontSize: isMobile ? 28 : 40,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildLoyaltyCard(bool isMobile) {
    return GlassContainer(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'رصيدك من النقاط',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  Text(
                    '24,500',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  const Icon(Icons.diamond, color: Colors.white, size: 40),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'المستوى الذهبي',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              const Text(
                'إلى المستوى البلاتيني',
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
              const Spacer(),
              const Text(
                '5,500 نقطة متبقية',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: 0.8,
            backgroundColor: Colors.white.withOpacity(0.1),
            valueColor: const AlwaysStoppedAnimation(Colors.white),
            borderRadius: BorderRadius.circular(10),
            minHeight: 10,
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildCardAction(Icons.redeem, 'استبدال النقاط'),
              const SizedBox(width: 24),
              _buildCardAction(Icons.history, 'التاريخ'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCardAction(IconData icon, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.white),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
      ],
    );
  }

  Widget _buildBenefitsList(bool isMobile) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: isMobile ? 1 : 3,
      childAspectRatio: 3,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      children: [
        _buildBenefitItem(Icons.airport_shuttle, 'نقل مجاني من المطار'),
        _buildBenefitItem(Icons.upgrade, 'ترقية مجانية لدرجة الأعمال'),
        _buildBenefitItem(Icons.access_time, 'تسجيل وصول مبكر'),
      ],
    );
  }

  Widget _buildBenefitItem(IconData icon, String label) {
    return GlassContainer(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.purpleAccent.withOpacity(0.1),
            child: Icon(icon, color: Colors.purpleAccent, size: 20),
          ),
          const SizedBox(width: 16),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryTable() {
    return GlassContainer(
      padding: EdgeInsets.zero,
      child: DataTable(
        columns: const [
          DataColumn(
            label: Text(
              'العملية',
              style: TextStyle(color: AppColors.textMuted),
            ),
          ),
          DataColumn(
            label: Text(
              'التاريخ',
              style: TextStyle(color: AppColors.textMuted),
            ),
          ),
          DataColumn(
            label: Text('النقاط', style: TextStyle(color: AppColors.textMuted)),
          ),
        ],
        rows: [
          _buildHistoryRow('حجز رحلة لندن', '15 أبريل 2025', '+ 2,400', true),
          _buildHistoryRow('إقامة فندق بورتو', '10 مارس 2025', '+ 1,500', true),
          _buildHistoryRow('ترقية حجز سيارة', '01 مارس 2025', '- 500', false),
        ],
      ),
    );
  }

  DataRow _buildHistoryRow(
    String title,
    String date,
    String points,
    bool isPositive,
  ) {
    return DataRow(
      cells: [
        DataCell(Text(title, style: const TextStyle(color: Colors.white))),
        DataCell(
          Text(
            date,
            style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
          ),
        ),
        DataCell(
          Text(
            points,
            style: TextStyle(
              color: isPositive ? Colors.greenAccent : Colors.redAccent,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
