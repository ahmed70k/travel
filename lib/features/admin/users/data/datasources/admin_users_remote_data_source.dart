import 'package:travle/core/network/dio_client.dart';
import '../models/admin_users_model.dart';

abstract class AdminUsersRemoteDataSource {
  Future<AdminUsersModel> getUsers({
    String? query,
    String? accountType,
    String? status,
  });
}

class AdminUsersRemoteDataSourceImpl implements AdminUsersRemoteDataSource {
  final DioClient dioClient;

  const AdminUsersRemoteDataSourceImpl(this.dioClient);

  @override
  Future<AdminUsersModel> getUsers({
    String? query,
    String? accountType,
    String? status,
  }) async {
    final response = await dioClient.dio.get(
      '/dashboard/admin/users',
      queryParameters: {
        if (query != null) 'query': query,
        if (accountType != null) 'accountType': accountType,
        if (status != null) 'status': status,
      },
    );
    return AdminUsersModel.fromJson(response.data);
  }
}
