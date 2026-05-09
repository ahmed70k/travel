import 'package:dio/dio.dart';
import '../../../../core/network/api_constants.dart';
import '../models/dashboard_me_model.dart';

abstract class DashboardRemoteDataSource {
  Future<DashboardMeResponseModel> getDashboardMe({DateTime? from, DateTime? to});
}

class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  final Dio dio;

  DashboardRemoteDataSourceImpl({required this.dio});

  @override
  Future<DashboardMeResponseModel> getDashboardMe({DateTime? from, DateTime? to}) async {
    final Map<String, dynamic> queryParameters = {};
    if (from != null) queryParameters['from'] = from.toIso8601String();
    if (to != null) queryParameters['to'] = to.toIso8601String();

    try {
      final response = await dio.get(
        ApiConstants.dashboardMe,
        queryParameters: queryParameters,
      );

      if (response.statusCode == 200) {
        return DashboardMeResponseModel.fromJson(response.data);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
        );
      }
    } catch (e) {
      rethrow;
    }
  }
}
