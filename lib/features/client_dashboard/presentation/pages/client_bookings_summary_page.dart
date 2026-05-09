import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/glass_container.dart';
import '../../../../core/widgets/neon_text.dart';
import '../../../bookings/domain/entities/my_bookings_entity.dart';
import '../../../bookings/presentation/cubit/my_bookings_cubit.dart';

class ClientBookingsSummaryPage extends StatelessWidget {
  const ClientBookingsSummaryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 32),
          Expanded(
            child: BlocBuilder<MyBookingsCubit, MyBookingsState>(
              builder: (context, state) {
                if (state is MyBookingsLoading) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  );
                } else if (state is MyBookingsError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, size: 60, color: Colors.redAccent),
                        const SizedBox(height: 16),
                        Text(state.message, style: const TextStyle(color: Colors.white70)),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () => context.read<MyBookingsCubit>().getMyBookings(forceRefresh: true),
                          child: const Text('إعادة المحاولة'),
                        ),
                      ],
                    ),
                  );
                } else if (state is MyBookingsLoaded) {
                  final all = state.bookings.allBookings;
                  if (all.isEmpty) {
                    return const Center(
                      child: Text(
                        'لا توجد حجوزات لعرضها',
                        style: TextStyle(color: AppColors.textMuted, fontSize: 16),
                      ),
                    );
                  }
                  return _buildSummaryTable(all);
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        NeonText(
          'ملخص جميع الحجوزات',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Text(
          'عرض شامل لجميع حجوزاتك (طيران، فنادق، سيارات) في جدول واحد',
          style: TextStyle(color: AppColors.textMuted, fontSize: 14),
        ),
      ],
    );
  }

  Color _typeColor(String type) {
    switch (type.toLowerCase()) {
      case 'flight': return Colors.purpleAccent;
      case 'hotel': return Colors.pinkAccent;
      case 'car': return Colors.blueAccent;
      default: return Colors.white70;
    }
  }

  String _typeLabel(String type) {
    switch (type.toLowerCase()) {
      case 'flight': return 'طيران';
      case 'hotel': return 'فندق';
      case 'car': return 'سيارة';
      default: return type;
    }
  }

  Widget _buildSummaryTable(List<BookingItemEntity> bookings) {
    return GlassContainer(
      padding: EdgeInsets.zero,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          child: DataTable(
            headingRowColor: WidgetStateProperty.all(Colors.white.withValues(alpha: 0.05)),
            columns: const [
              DataColumn(label: Text('المعرف', style: TextStyle(color: Colors.white70))),
              DataColumn(label: Text('النوع', style: TextStyle(color: Colors.white70))),
              DataColumn(label: Text('التفاصيل', style: TextStyle(color: Colors.white70))),
              DataColumn(label: Text('الحالة', style: TextStyle(color: Colors.white70))),
              DataColumn(label: Text('السعر', style: TextStyle(color: Colors.white70))),
            ],
            rows: bookings.map((b) => DataRow(cells: [
              DataCell(Text(b.id, style: const TextStyle(color: Colors.white, fontSize: 12))),
              DataCell(Text(
                _typeLabel(b.bookingType),
                style: TextStyle(color: _typeColor(b.bookingType), fontWeight: FontWeight.bold),
              )),
              DataCell(Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(b.title, style: const TextStyle(color: Colors.white, fontSize: 13)),
                  Text(b.subtitle, style: const TextStyle(color: Colors.white54, fontSize: 11)),
                ],
              )),
              DataCell(Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: b.status.toLowerCase() == 'confirmed'
                      ? Colors.greenAccent.withValues(alpha: 0.15)
                      : b.status.toLowerCase() == 'cancelled'
                          ? Colors.redAccent.withValues(alpha: 0.15)
                          : Colors.orangeAccent.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  b.status,
                  style: TextStyle(
                    color: b.status.toLowerCase() == 'confirmed'
                        ? Colors.greenAccent
                        : b.status.toLowerCase() == 'cancelled'
                            ? Colors.redAccent
                            : Colors.orangeAccent,
                    fontSize: 12,
                  ),
                ),
              )),
              DataCell(Text(
                '\$${b.price.toStringAsFixed(0)}',
                style: const TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold),
              )),
            ])).toList(),
          ),
        ),
      ),
    );
  }
}
