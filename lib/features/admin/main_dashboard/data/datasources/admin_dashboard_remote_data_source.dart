import 'package:dio/dio.dart';
import '../../../../../core/network/api_constants.dart';
import '../models/admin_dashboard_model.dart';

abstract class AdminDashboardRemoteDataSource {
  Future<AdminDashboardModel> getMyDashboard({String? from, String? to});
}

class AdminDashboardRemoteDataSourceImpl implements AdminDashboardRemoteDataSource {
  final Dio dio;

  AdminDashboardRemoteDataSourceImpl(this.dio);

  @override
  Future<AdminDashboardModel> getMyDashboard({String? from, String? to}) async {
    final Map<String, dynamic> queryParameters = {};
    if (from != null) queryParameters['from'] = from;
    if (to != null) queryParameters['to'] = to;

    final response = await dio.get(
      ApiConstants.dashboardMe,
      queryParameters: queryParameters,
    );

    return AdminDashboardModel.fromJson(response.data);
  }
}
