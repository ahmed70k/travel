import 'package:dio/dio.dart';
import '../../../../core/network/api_constants.dart';
import '../../../../core/network/error_handler.dart';
import '../models/b2c_overview_model.dart';

abstract class B2CRemoteDataSource {
  Future<B2COverviewModel> getB2COverview({String? from, String? to});
}

class B2CRemoteDataSourceImpl implements B2CRemoteDataSource {
  final Dio dio;

  B2CRemoteDataSourceImpl({required this.dio});

  @override
  Future<B2COverviewModel> getB2COverview({
    String? from,
    String? to,
  }) async {
    try {
      final response = await dio.get(
        ApiConstants.b2cOverview,
        queryParameters: {
          if (from != null) 'from': from,
          if (to != null) 'to': to,
        },
      );
      return B2COverviewModel.fromJson(response.data);
    } catch (e) {
      throw Exception(ErrorHandler.handle(e));
    }
  }
}
