import 'package:travle/core/network/dio_client.dart';
import '../models/admin_hotels_model.dart';

abstract class AdminHotelsRemoteDataSource {
  Future<AdminHotelsModel> getHotels({
    String? from,
    String? to,
    String? guestsCount,
    String? category,
  });
}

class AdminHotelsRemoteDataSourceImpl implements AdminHotelsRemoteDataSource {
  final DioClient dioClient;

  const AdminHotelsRemoteDataSourceImpl(this.dioClient);

  @override
  Future<AdminHotelsModel> getHotels({
    String? from,
    String? to,
    String? guestsCount,
    String? category,
  }) async {
    final response = await dioClient.dio.get(
      '/dashboard/admin/hotels',
      queryParameters: {
        if (from != null) 'from': from,
        if (to != null) 'to': to,
        if (guestsCount != null) 'guestsCount': guestsCount,
        if (category != null) 'category': category,
      },
    );
    return AdminHotelsModel.fromJson(response.data);
  }
}
