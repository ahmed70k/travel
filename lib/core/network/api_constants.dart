class ApiConstants {
  static const String baseUrl = 'https://office10.runasp.net/api/';

  // Auth Endpoints
  static const String login = 'auth/login';
  static const String logout = 'auth/logout';
  static const String refresh = 'auth/refresh';
  static const String me = 'auth/me';

  // Admin Dashboard Endpoints
  static const String adminOverview = 'dashboard/admin/overview';
  static const String adminB2B = 'dashboard/admin/b2b';
  static const String adminB2C = 'dashboard/admin/b2c';
  static const String b2bOverview = 'dashboard/b2b/overview';
  static const String b2cOverview = 'dashboard/b2c/overview';
  static const String dashboardMe = 'dashboard/me';
  static const String adminFlightsBookings = 'bookings/flights';
  static const String adminHotelBookings = 'bookings/hotels';
  static const String adminCarsBookings = 'bookings/cars';
  static const String myBookings = 'bookings/my';
  static const String flightsAvailability = 'availability/flights';
  static const String hotelsAvailability = 'availability/hotels';
  static const String carsAvailability = 'availability/cars';
  static const String users = 'users';
}
