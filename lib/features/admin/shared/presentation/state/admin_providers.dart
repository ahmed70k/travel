import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/repositories/mock_dashboard_repository.dart';
import '../../../domain/entities/dashboard_models.dart';

final dashboardRepositoryProvider = Provider<MockDashboardRepository>((ref) {
  return MockDashboardRepository();
});

final statsProvider = Provider<List<StatModel>>((ref) {
  return ref.watch(dashboardRepositoryProvider).getStats();
});

final recentBookingsProvider = Provider<List<BookingModel>>((ref) {
  return ref.watch(dashboardRepositoryProvider).getRecentBookings();
});

final topB2bProvider = Provider<List<TopB2bModel>>((ref) {
  return ref.watch(dashboardRepositoryProvider).getTopB2b();
});

final providersProvider = Provider<List<ProviderModel>>((ref) {
  return ref.watch(dashboardRepositoryProvider).getProviders();
});

final offersProvider = Provider<List<OfferModel>>((ref) {
  return ref.watch(dashboardRepositoryProvider).getOffers();
});

class ActiveSidebarItemNotifier extends Notifier<String> {
  @override
  String build() => 'لوحة التحكم';

  void setItem(String item) {
    state = item;
  }
}

final activeSidebarItemProvider =
    NotifierProvider<ActiveSidebarItemNotifier, String>(() {
      return ActiveSidebarItemNotifier();
    });

final flightStatsProvider = Provider<List<StatModel>>((ref) {
  return ref.watch(dashboardRepositoryProvider).getFlightStats();
});

final flightBookingsProvider = Provider<List<DetailedFlightBooking>>((ref) {
  return ref.watch(dashboardRepositoryProvider).getDetailedFlightBookings();
});

class FlightFilterNotifier extends Notifier<String> {
  @override
  String build() => 'جميع الرحلات';

  void setFilter(String filter) {
    state = filter;
  }
}

final selectedFlightFilterProvider =
    NotifierProvider<FlightFilterNotifier, String>(() {
      return FlightFilterNotifier();
    });

final hotelStatsProvider = Provider<List<StatModel>>((ref) {
  return ref.watch(dashboardRepositoryProvider).getHotelStats();
});

final hotelBookingsProvider = Provider<List<HotelBooking>>((ref) {
  return ref.watch(dashboardRepositoryProvider).getHotelBookings();
});

class HotelFilterNotifier extends Notifier<String> {
  @override
  String build() => 'جميع الفنادق';

  void setFilter(String filter) {
    state = filter;
  }
}

final selectedHotelFilterProvider =
    NotifierProvider<HotelFilterNotifier, String>(() {
      return HotelFilterNotifier();
    });

final carStatsProvider = Provider<List<StatModel>>((ref) {
  return ref.watch(dashboardRepositoryProvider).getCarStats();
});

final carBookingsProvider = Provider<List<CarBooking>>((ref) {
  return ref.watch(dashboardRepositoryProvider).getCarBookings();
});

class CarFilterNotifier extends Notifier<String> {
  @override
  String build() => 'جميع السيارات';

  void setFilter(String filter) {
    state = filter;
  }
}

final selectedCarFilterProvider = NotifierProvider<CarFilterNotifier, String>(
  () {
    return CarFilterNotifier();
  },
);

final usersStatsProvider = Provider<List<StatModel>>((ref) {
  return ref.watch(dashboardRepositoryProvider).getUsersStats();
});

final usersProvider = Provider<List<AdminUserModel>>((ref) {
  return ref.watch(dashboardRepositoryProvider).getUsers();
});

class UserFilterNotifier extends Notifier<String> {
  @override
  String build() => 'جميع المستخدمين';

  void setFilter(String filter) {
    state = filter;
  }
}

final selectedUserFilterProvider = NotifierProvider<UserFilterNotifier, String>(
  () {
    return UserFilterNotifier();
  },
);
