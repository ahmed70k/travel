class ApiConstants {
  static const String baseUrl = 'https://office10.runasp.net/api';

  // Auth Endpoints
  static const String login = '/auth/login';
  static const String logout = '/auth/logout';
  static const String refresh = '/auth/refresh';
  static const String me = '/auth/me';

  // Admin Dashboard Endpoints
  static const String adminOverview = '/dashboard/admin/overview';

  // B2C Dashboard Endpoints
  static const String b2cOverview = '/dashboard/b2c/overview';

  // Current User Dashboard
  static const String meDashboard = '/dashboard/me';
}
