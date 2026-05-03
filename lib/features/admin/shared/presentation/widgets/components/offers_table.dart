import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/widgets/glass_container.dart';
import '../../../../domain/entities/dashboard_models.dart';
import '../../state/admin_providers.dart';

class OffersTable extends ConsumerWidget {
  const OffersTable({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final offers = ref.watch(offersProvider);

    return GlassContainer(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              runSpacing: 16,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                const Row(
                  children: [
                    Icon(Icons.local_offer, color: AppColors.warning),
                    SizedBox(width: 8),
                    Text(
                      'العروض والخصومات الحالية',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                InkWell(
                  onTap: () {},
                  child: const Row(
                    children: [
                      Text(
                        'إضافة عرض جديد',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(Icons.add, color: AppColors.primary, size: 14),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.glassBorder),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowColor: MaterialStateProperty.all(
                AppColors.primary.withOpacity(0.1),
              ),
              dataRowColor: MaterialStateProperty.resolveWith<Color?>((
                Set<MaterialState> states,
              ) {
                if (states.contains(MaterialState.hovered)) {
                  return AppColors.primary.withOpacity(0.1);
                }
                return null;
              }),
              columns: const [
                DataColumn(
                  label: Text(
                    'العرض',
                    style: TextStyle(color: AppColors.textMuted),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'النوع',
                    style: TextStyle(color: AppColors.textMuted),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'الخصم',
                    style: TextStyle(color: AppColors.textMuted),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'الفترة',
                    style: TextStyle(color: AppColors.textMuted),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'الحالة',
                    style: TextStyle(color: AppColors.textMuted),
                  ),
                ),
              ],
              rows: offers.map((o) => _buildRow(o)).toList(),
            ),
          ),
        ],
      ),
    );
  }

  DataRow _buildRow(OfferModel offer) {
    return DataRow(
      cells: [
        DataCell(
          Text(
            offer.name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        DataCell(Text(offer.type)),
        DataCell(
          Text(
            offer.discount,
            style: const TextStyle(color: AppColors.success),
          ),
        ),
        DataCell(Text(offer.period)),
        DataCell(_buildStatusBadge(offer.isActive)),
      ],
    );
  }

  Widget _buildStatusBadge(bool isActive) {
    final color = isActive ? AppColors.success : Colors.grey;
    final label = isActive ? 'نشط' : 'منتهي';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(label, style: TextStyle(color: color, fontSize: 12)),
    );
  }
}
