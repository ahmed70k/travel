import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/neon_text.dart';
import '../../../../core/widgets/glass_container.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ClientSupportPage extends StatelessWidget {
  const ClientSupportPage({super.key});

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

          // Search Help
          _buildSearchBar(),
          const SizedBox(height: 32),

          // Quick Contact Options
          const Text(
            'تواصل سريع',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildQuickContact(isMobile),
          const SizedBox(height: 32),

          // FAQ Section
          const Text(
            'الأسئلة الشائعة',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildFAQList(),
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
            Icon(
              Icons.headset_mic_outlined,
              color: Colors.purpleAccent,
              size: 14,
            ),
            SizedBox(width: 8),
            Text(
              'الرئيسية',
              style: TextStyle(color: AppColors.textMuted, fontSize: 12),
            ),
            SizedBox(width: 4),
            Icon(Icons.chevron_left, color: AppColors.textMuted, size: 12),
            SizedBox(width: 4),
            Text(
              'مركز الدعم',
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ],
        ),
        const SizedBox(height: 12),
        NeonText(
          'كيف يمكننا مساعدتك؟',
          style: TextStyle(
            fontSize: isMobile ? 28 : 40,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: const TextField(
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'ابحث عن إجابات لأسئلتك...',
          hintStyle: TextStyle(color: AppColors.textMuted, fontSize: 14),
          border: InputBorder.none,
          icon: Icon(Icons.search, color: Colors.purpleAccent),
        ),
      ),
    );
  }

  Widget _buildQuickContact(bool isMobile) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: isMobile ? 2 : 4,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.2,
      children: [
        _buildContactCard(
          Icons.chat_bubble_outline,
          'دردشة مباشرة',
          'متاح 24/7',
          Colors.greenAccent,
        ),
        _buildContactCard(
          Icons.phone_in_talk_outlined,
          'اتصال هاتفي',
          'دعم دولي',
          Colors.blueAccent,
        ),
        _buildContactCard(
          Icons.mail_outline,
          'بريد إلكتروني',
          'رد خلال 24 ساعة',
          Colors.purpleAccent,
        ),
        _buildContactCard(
          FontAwesomeIcons.whatsapp,
          'واتساب',
          'تواصل سريع',
          Colors.green,
        ),
      ],
    );
  }

  Widget _buildContactCard(
    dynamic icon,
    String title,
    String subtitle,
    Color color,
  ) {
    return GlassContainer(
      padding: const EdgeInsets.all(16),
      animateHover: true,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildIconWidget(icon, color),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            subtitle,
            style: const TextStyle(color: AppColors.textMuted, fontSize: 9),
          ),
        ],
      ),
    );
  }

  Widget _buildIconWidget(dynamic icon, Color color) {
    if (icon is IconData) {
      return Icon(icon, color: color, size: 28);
    } else {
      return FaIcon(icon, color: color, size: 24);
    }
  }

  Widget _buildFAQList() {
    final faqs = [
      {
        'q': 'كيف يمكنني إلغاء حجز الفندق؟',
        'a':
            'يمكنك إلغاء الحجز من صفحة "فنادقي" عبر الضغط على زر الإلغاء قبل الموعد بـ 24 ساعة.',
      },
      {
        'q': 'هل يمكنني تغيير موعد رحلة الطيران؟',
        'a':
            'نعم، يتوجب عليك التواصل مع الدعم الفني لمراجعة شروط الدرجة السعرية لتذكرتك.',
      },
      {
        'q': 'كيف أحصل على نقاط ولاء إضافية؟',
        'a': 'تحصل على النقاط تلقائياً عند كل عملية حجز تتم من خلال التطبيق.',
      },
      {
        'q': 'ما هي سياسة تأمين السيارات؟',
        'a': 'كافة السيارات المتاحة في تطبيقنا تشمل تأمين VIP شامل الحماية.',
      },
    ];

    return Column(
      children: faqs.map((faq) => _buildFAQItem(faq['q']!, faq['a']!)).toList(),
    );
  }

  Widget _buildFAQItem(String question, String answer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.01),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: ExpansionTile(
        title: Text(
          question,
          style: const TextStyle(color: Colors.white, fontSize: 14),
        ),
        iconColor: Colors.purpleAccent,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              answer,
              style: const TextStyle(
                color: AppColors.textMuted,
                fontSize: 13,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
