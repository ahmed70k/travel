import 'package:travle/core/network/dio_client.dart';
import 'package:travle/core/network/api_constants.dart';
import '../models/admin_users_model.dart';

abstract class AdminUsersRemoteDataSource {
  Future<UsersResponseModel> getUsers({
    int page = 1,
    int limit = 10,
    String? query,
    String? role,
    String? status,
    String? sortBy,
    String? sortOrder,
  });

  Future<UserModel> createUser({
    required String name,
    required String email,
    required String password,
    required String role,
    required String status,
  });

  Future<UserModel> updateUser({
    required String id,
    required String name,
    required String email,
    String? password,
    required String role,
    required String status,
  });

  Future<void> deleteUser(String id);
}

class AdminUsersRemoteDataSourceImpl implements AdminUsersRemoteDataSource {
  final DioClient dioClient;

  const AdminUsersRemoteDataSourceImpl(this.dioClient);

  @override
  Future<UsersResponseModel> getUsers({
    int page = 1,
    int limit = 10,
    String? query,
    String? role,
    String? status,
    String? sortBy,
    String? sortOrder,
  }) async {
    final response = await dioClient.dio.get(
      ApiConstants.users,
      queryParameters: {
        'page': page,
        'limit': limit,
        if (query != null && query.isNotEmpty) 'q': query,
        if (role != null && role != 'all') 'role': role,
        if (status != null && status != 'all') 'status': status,
        if (sortBy != null) 'sortBy': sortBy,
        if (sortOrder != null) 'sortOrder': sortOrder,
      },
    );
    return UsersResponseModel.fromJson(response.data);
  }

  @override
  Future<UserModel> createUser({
    required String name,
    required String email,
    required String password,
    required String role,
    required String status,
  }) async {
    final response = await dioClient.dio.post(
      ApiConstants.users,
      data: {
        'name': name,
        'email': email,
        'password': password,
        'role': role,
        'status': status,
      },
    );
    return UserModel.fromJson(response.data['data']);
  }

  @override
  Future<UserModel> updateUser({
    required String id,
    required String name,
    required String email,
    String? password,
    required String role,
    required String status,
  }) async {
    final response = await dioClient.dio.put(
      '${ApiConstants.users}/$id',
      data: {
        'name': name,
        'email': email,
        if (password != null && password.isNotEmpty) 'password': password,
        'role': role,
        'status': status,
      },
    );
    return UserModel.fromJson(response.data['data']);
  }

  @override
  Future<void> deleteUser(String id) async {
    await dioClient.dio.delete('${ApiConstants.users}/$id');
  }
}
