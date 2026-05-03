import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../admin/domain/entities/dashboard_models.dart';

// Mock data provider for client bookings
final clientBookingsProvider = Provider<List<BookingModel>>((ref) {
  return [
    BookingModel(
      id: 'FL-1024',
      clientName: 'محمد علي',
      flightPath: 'الدوحة ← القاهرة',
      date: '20 مايو 2025',
      price: '320\$',
      status: BookingStatus.confirmed,
    ),
    BookingModel(
      id: 'H-4502',
      clientName: 'محمد علي',
      flightPath: 'فندق بورتو السخنة',
      date: '10-15 يونيو 2025',
      price: '580\$',
      status: BookingStatus.confirmed,
    ),
    BookingModel(
      id: 'C-8821',
      clientName: 'محمد علي',
      flightPath: 'مرسيدس E-Class',
      date: '10-15 يونيو 2025',
      price: '650\$',
      status: BookingStatus.pending,
    ),
    BookingModel(
      id: 'H-9921',
      clientName: 'محمد علي',
      flightPath: 'فندق جميرا بيتش',
      date: '01-07 يوليو 2025',
      price: '2,450\$',
      status: BookingStatus.payment_pending,
    ),
  ];
});

// Category Filter Notifier
class ClientBookingFilterNotifier extends Notifier<String> {
  @override
  String build() => 'all';

  void setFilter(String filter) => state = filter;
}

final clientBookingFilterProvider =
    NotifierProvider<ClientBookingFilterNotifier, String>(
      ClientBookingFilterNotifier.new,
    );

// Status Filter Notifier
class ClientStatusFilterNotifier extends Notifier<String> {
  @override
  String build() => 'الجميع';

  void setStatus(String status) => state = status;
}

final clientStatusFilterProvider =
    NotifierProvider<ClientStatusFilterNotifier, String>(
      ClientStatusFilterNotifier.new,
    );
