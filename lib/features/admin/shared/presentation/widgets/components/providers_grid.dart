import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/widgets/glass_container.dart';
import '../../../../domain/entities/dashboard_models.dart';
import '../../state/admin_providers.dart';
import '../modals/add_provider_dialog.dart';

class ProvidersGrid extends ConsumerWidget {
  const ProvidersGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final providers = ref.watch(providersProvider);

    return GlassContainer(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            runSpacing: 16,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              const Row(
                children: [
                  Icon(
                    Icons.electrical_services,
                    color: AppColors.primary,
                  ), // Use an alternative instead of font_awesome plug
                  SizedBox(width: 8),
                  Text(
                    'مزودي الخدمة (APIs)',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => const AddProviderDialog(),
                  );
                },
                icon: const Icon(Icons.add, size: 16),
                label: const Text('إضافة مزود جديد'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: MediaQuery.of(context).size.width < 800 ? 1 : 3,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: MediaQuery.of(context).size.width < 800
                  ? 1.5
                  : 1.5,
            ),
            itemCount: providers.length,
            itemBuilder: (context, index) {
              return _ProviderCard(provider: providers[index]);
            },
          ),
        ],
      ),
    );
  }
}

class _ProviderCard extends StatelessWidget {
  final ProviderModel provider;

  const _ProviderCard({required this.provider});

  @override
  Widget build(BuildContext context) {
    final isTrial = provider.status == ProviderStatus.trial;
    final color = isTrial ? AppColors.warning : AppColors.success;
    final iconColor = provider.type.contains('طيران')
        ? AppColors.primary
        : (provider.type.contains('فنادق')
              ? AppColors.secondary
              : AppColors.warning);

    return GlassContainer(
      animateHover: true,
      borderRadius: 12,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    provider.type.contains('طيران')
                        ? Icons.flight
                        : Icons.hotel,
                    color: iconColor,
                    size: 28,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    provider.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    provider.type,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: color.withOpacity(0.3)),
                ),
                child: Text(
                  isTrial ? 'تجريبي' : 'نشط',
                  style: TextStyle(color: color, fontSize: 10),
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.vpn_key, color: iconColor, size: 14),
                  const SizedBox(width: 4),
                  Text(
                    'API Key: ${provider.apiKeyPartial}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.bar_chart, color: iconColor, size: 14),
                  const SizedBox(width: 4),
                  Text(
                    'الطلبات اليوم: ${provider.requestsToday}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
