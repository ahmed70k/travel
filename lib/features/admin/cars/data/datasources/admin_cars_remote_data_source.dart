import 'package:travle/core/network/dio_client.dart';
import '../models/admin_cars_model.dart';

abstract class AdminCarsRemoteDataSource {
  Future<AdminCarsModel> getCars({
    String? from,
    String? to,
    String? carType,
    String? category,
  });
}

class AdminCarsRemoteDataSourceImpl implements AdminCarsRemoteDataSource {
  final DioClient dioClient;

  const AdminCarsRemoteDataSourceImpl(this.dioClient);

  @override
  Future<AdminCarsModel> getCars({
    String? from,
    String? to,
    String? carType,
    String? category,
  }) async {
    final response = await dioClient.dio.get(
      '/dashboard/admin/cars',
      queryParameters: {
        if (from != null) 'from': from,
        if (to != null) 'to': to,
        if (carType != null) 'carType': carType,
        if (category != null) 'category': category,
      },
    );
    return AdminCarsModel.fromJson(response.data);
  }
}
