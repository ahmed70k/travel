import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/glass_container.dart';
import '../../../../core/widgets/neon_text.dart';
import '../../domain/entities/booking_entities.dart';
import '../cubit/my_bookings_cubit.dart';
import '../cubit/my_bookings_state.dart';

class B2bBookingsSummaryPage extends StatelessWidget {
  const B2bBookingsSummaryPage({super.key});

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
            child: BlocBuilder<B2BMyBookingsCubit, B2BMyBookingsState>(
              builder: (context, state) {
                if (state is B2BMyBookingsLoading) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  );
                } else if (state is B2BMyBookingsError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, size: 60, color: Colors.redAccent),
                        const SizedBox(height: 16),
                        Text(state.message, style: const TextStyle(color: Colors.white70)),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () => context.read<B2BMyBookingsCubit>().getMyBookings(forceRefresh: true),
                          child: const Text('إعادة المحاولة'),
                        ),
                      ],
                    ),
                  );
                } else if (state is B2BMyBookingsLoaded) {
                  final bookings = state.bookings;
                  final totalCount = bookings.flights.length + bookings.hotels.length + bookings.cars.length;
                  if (totalCount == 0) {
                    return const Center(
                      child: Text(
                        'لا توجد حجوزات لعرضها',
                        style: TextStyle(color: AppColors.textMuted, fontSize: 16),
                      ),
                    );
                  }
                  return _buildSummaryTable(bookings);
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
          'ملخص الحجوزات',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Text(
          'عرض شامل لجميع حجوزات الشركة (طيران، فنادق، سيارات) في جدول واحد',
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

  Widget _buildSummaryTable(MyBookingsEntity bookings) {
    final rows = <DataRow>[
      ...bookings.flights.map((f) => DataRow(cells: [
        DataCell(Text(f.id, style: const TextStyle(color: Colors.white, fontSize: 12))),
        DataCell(Text('طيران', style: TextStyle(color: _typeColor('flight'), fontWeight: FontWeight.bold))),
        DataCell(Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${f.from} ← ${f.to}', style: const TextStyle(color: Colors.white, fontSize: 13)),
            Text(f.airlineName, style: const TextStyle(color: Colors.white54, fontSize: 11)),
          ],
        )),
        DataCell(_statusBadge(f.status)),
        DataCell(Text('\$${f.price.toStringAsFixed(0)}', style: const TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold))),
      ])),
      ...bookings.hotels.map((h) => DataRow(cells: [
        DataCell(Text(h.id, style: const TextStyle(color: Colors.white, fontSize: 12))),
        DataCell(Text('فندق', style: TextStyle(color: _typeColor('hotel'), fontWeight: FontWeight.bold))),
        DataCell(Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(h.hotelName, style: const TextStyle(color: Colors.white, fontSize: 13)),
            Text(h.location, style: const TextStyle(color: Colors.white54, fontSize: 11)),
          ],
        )),
        DataCell(_statusBadge(h.status)),
        DataCell(Text('\$${h.price.toStringAsFixed(0)}', style: const TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold))),
      ])),
      ...bookings.cars.map((c) => DataRow(cells: [
        DataCell(Text(c.id, style: const TextStyle(color: Colors.white, fontSize: 12))),
        DataCell(Text('سيارة', style: TextStyle(color: _typeColor('car'), fontWeight: FontWeight.bold))),
        DataCell(Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(c.carModel, style: const TextStyle(color: Colors.white, fontSize: 13)),
            Text('${c.pickupLocation} ← ${c.returnLocation}', style: const TextStyle(color: Colors.white54, fontSize: 11)),
          ],
        )),
        DataCell(_statusBadge(c.status)),
        DataCell(Text('\$${c.totalPrice.toStringAsFixed(0)}', style: const TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold))),
      ])),
    ];

    return GlassContainer(
      padding: EdgeInsets.zero,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          child: DataTable(
            headingRowColor: WidgetStateProperty.all(Colors.white.withValues(alpha: 0.05)),
            dataRowMinHeight: 56,
            dataRowMaxHeight: 72,
            columns: const [
              DataColumn(label: Text('المعرف', style: TextStyle(color: Colors.white70))),
              DataColumn(label: Text('النوع', style: TextStyle(color: Colors.white70))),
              DataColumn(label: Text('التفاصيل', style: TextStyle(color: Colors.white70))),
              DataColumn(label: Text('الحالة', style: TextStyle(color: Colors.white70))),
              DataColumn(label: Text('السعر', style: TextStyle(color: Colors.white70))),
            ],
            rows: rows,
          ),
        ),
      ),
    );
  }

  Widget _statusBadge(String status) {
    final isConfirmed = status.toLowerCase() == 'confirmed';
    final isCancelled = status.toLowerCase() == 'cancelled';
    final color = isConfirmed ? Colors.greenAccent : isCancelled ? Colors.redAccent : Colors.orangeAccent;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(status, style: TextStyle(color: color, fontSize: 12)),
    );
  }
}
