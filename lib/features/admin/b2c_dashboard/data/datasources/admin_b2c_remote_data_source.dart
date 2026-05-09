import 'package:dio/dio.dart';
import 'package:travle/features/admin/b2c_dashboard/data/models/admin_b2c_model.dart';
import '../../../../../core/network/api_constants.dart';

abstract class AdminB2CRemoteDataSource {
  Future<AdminB2CModel> getDashboard({DateTime? from, DateTime? to});
}

class AdminB2CRemoteDataSourceImpl implements AdminB2CRemoteDataSource {
  final Dio dio;

  const AdminB2CRemoteDataSourceImpl({required this.dio});

  @override
  Future<AdminB2CModel> getDashboard({DateTime? from, DateTime? to}) async {
    final Map<String, dynamic> queryParameters = {};
    if (from != null) {
      queryParameters['from'] = from.toIso8601String();
    }
    if (to != null) {
      queryParameters['to'] = to.toIso8601String();
    }

    final response = await dio.get(
      ApiConstants.adminB2C,
      queryParameters: queryParameters.isNotEmpty ? queryParameters : null,
    );

    final responseData = response.data['data'] ?? response.data;
    return AdminB2CModel.fromJson(responseData);
  }
}
