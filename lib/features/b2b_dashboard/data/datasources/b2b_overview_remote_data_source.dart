import 'package:dio/dio.dart';
import '../../../../core/network/api_constants.dart';
import '../models/b2b_overview_model.dart';

abstract class B2BOverviewRemoteDataSource {
  Future<B2BOverviewModel> getOverview({DateTime? from, DateTime? to});
}

class B2BOverviewRemoteDataSourceImpl implements B2BOverviewRemoteDataSource {
  final Dio dio;

  B2BOverviewRemoteDataSourceImpl(this.dio);

  @override
  Future<B2BOverviewModel> getOverview({DateTime? from, DateTime? to}) async {
    final Map<String, dynamic> queryParameters = {};
    if (from != null) {
      queryParameters['from'] = from.toIso8601String();
    }
    if (to != null) {
      queryParameters['to'] = to.toIso8601String();
    }

    final response = await dio.get(
      ApiConstants.b2bOverview,
      queryParameters: queryParameters,
    );

    // Assuming the response structure has a 'data' field or is the object itself
    final responseData = response.data['data'] ?? response.data;
    return B2BOverviewModel.fromJson(responseData);
  }
}
