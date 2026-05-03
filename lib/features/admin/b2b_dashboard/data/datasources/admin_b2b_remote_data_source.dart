import 'package:dio/dio.dart';
import 'package:travle/features/admin/b2b_dashboard/data/models/admin_b2b_model.dart';

abstract class AdminB2BRemoteDataSource {
  Future<AdminB2BModel> getDashboard({DateTime? from, DateTime? to});
}

class AdminB2BRemoteDataSourceImpl implements AdminB2BRemoteDataSource {
  final Dio dio;

  const AdminB2BRemoteDataSourceImpl({required this.dio});

  @override
  Future<AdminB2BModel> getDashboard({DateTime? from, DateTime? to}) async {
    final Map<String, dynamic> queryParameters = {};
    if (from != null) {
      queryParameters['from'] = from.toIso8601String();
    }
    if (to != null) {
      queryParameters['to'] = to.toIso8601String();
    }

    final response = await dio.get(
      '/api/dashboard/admin/b2b',
      queryParameters: queryParameters.isNotEmpty ? queryParameters : null,
    );

    final responseData = response.data['data'] ?? response.data;
    return AdminB2BModel.fromJson(responseData);
  }
}
