import 'package:dio/dio.dart';
import '../../../../core/network/api_constants.dart';
import '../../../../core/network/error_handler.dart';
import '../models/me_dashboard_model.dart';

abstract class MeDashboardRemoteDataSource {
  Future<MeDashboardModel> getMyDashboard({String? from, String? to});
}

class MeDashboardRemoteDataSourceImpl implements MeDashboardRemoteDataSource {
  final Dio dio;

  MeDashboardRemoteDataSourceImpl({required this.dio});

  @override
  Future<MeDashboardModel> getMyDashboard({
    String? from,
    String? to,
  }) async {
    try {
      final response = await dio.get(
        ApiConstants.meDashboard,
        queryParameters: {
          if (from != null) 'from': from,
          if (to != null) 'to': to,
        },
      );
      return MeDashboardModel.fromJson(response.data);
    } catch (e) {
      throw Exception(ErrorHandler.handle(e));
    }
  }
}
