import 'package:equatable/equatable.dart';

class GreetingEntity extends Equatable {
  final String title;
  final String subtitle;

  const GreetingEntity({required this.title, required this.subtitle});

  @override
  List<Object?> get props => [title, subtitle];
}

class KPIEntity extends Equatable {
  final int b2bAgencies;
  final String b2bDelta;
  final int b2cCustomers;
  final String b2cDelta;
  final double totalProfit;
  final String formattedProfit;
  final String profitDelta;
  final int totalBookings;
  final String bookingsDelta;

  const KPIEntity({
    required this.b2bAgencies,
    required this.b2bDelta,
    required this.b2cCustomers,
    required this.b2cDelta,
    required this.totalProfit,
    required this.formattedProfit,
    required this.profitDelta,
    required this.totalBookings,
    required this.bookingsDelta,
  });

  @override
  List<Object?> get props => [
    b2bAgencies,
    b2bDelta,
    b2cCustomers,
    b2cDelta,
    totalProfit,
    formattedProfit,
    profitDelta,
    totalBookings,
    bookingsDelta,
  ];
}

class BookingEntity extends Equatable {
  final String id;
  final String customer;
  final String route;
  final DateTime date;
  final double price;
  final String status; // confirmed / pending / cancelled

  const BookingEntity({
    required this.id,
    required this.customer,
    required this.route,
    required this.date,
    required this.price,
    required this.status,
  });

  @override
  List<Object?> get props => [id, customer, route, date, price, status];
}

class AdminOverviewEntity extends Equatable {
  final GreetingEntity greeting;
  final KPIEntity kpis;
  final List<BookingEntity> bookings;
  final List<String> quickActions;
  final DateTime from;
  final DateTime to;

  const AdminOverviewEntity({
    required this.greeting,
    required this.kpis,
    required this.bookings,
    required this.quickActions,
    required this.from,
    required this.to,
  });

  @override
  List<Object?> get props => [greeting, kpis, bookings, quickActions, from, to];
}
