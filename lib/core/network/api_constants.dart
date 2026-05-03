class ApiConstants {
  static const String baseUrl = 'http://192.168.1.21:4000/api';

  // Auth Endpoints
  static const String login = '/auth/login';
  static const String logout = '/auth/logout';
  static const String refresh = '/auth/refresh';
  static const String me = '/auth/me';

  // Admin Dashboard Endpoints
  static const String adminOverview = '/dashboard/admin/overview';
}
