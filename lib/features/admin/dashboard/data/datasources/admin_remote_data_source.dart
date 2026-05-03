import 'package:dio/dio.dart';
import '../../../../../core/network/api_constants.dart';
import '../../../../../core/network/error_handler.dart';
import '../models/admin_overview_model.dart';

abstract class AdminRemoteDataSource {
  Future<AdminOverviewModel> getAdminOverview({String? from, String? to});
}

class AdminRemoteDataSourceImpl implements AdminRemoteDataSource {
  final Dio dio;

  AdminRemoteDataSourceImpl({required this.dio});

  @override
  Future<AdminOverviewModel> getAdminOverview({
    String? from,
    String? to,
  }) async {
    try {
      final response = await dio.get(
        ApiConstants.adminOverview,
        queryParameters: {
          if (from != null) 'from': from,
          if (to != null) 'to': to,
        },
      );
      return AdminOverviewModel.fromJson(response.data);
    } catch (e) {
      throw Exception(ErrorHandler.handle(e));
    }
  }
}
