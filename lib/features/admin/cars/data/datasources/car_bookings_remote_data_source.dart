import 'package:travle/core/network/dio_client.dart';
import 'package:travle/core/network/api_constants.dart';
import '../models/car_booking_model.dart';

abstract class CarBookingsRemoteDataSource {
  Future<CarBookingsResponseModel> getCarBookings({
    int page = 1,
    int limit = 10,
    String? search,
    String? status,
    String sortBy = "pickupDate",
    String sortOrder = "desc",
  });
}

class CarBookingsRemoteDataSourceImpl implements CarBookingsRemoteDataSource {
  final DioClient dioClient;

  const CarBookingsRemoteDataSourceImpl(this.dioClient);

  @override
  Future<CarBookingsResponseModel> getCarBookings({
    int page = 1,
    int limit = 10,
    String? search,
    String? status,
    String sortBy = "pickupDate",
    String sortOrder = "desc",
  }) async {
    final response = await dioClient.dio.get(
      ApiConstants.adminCarsBookings,
      queryParameters: {
        'page': page,
        'limit': limit,
        if (search != null && search.isNotEmpty) 'q': search,
        if (status != null && status != 'all') 'status': status,
        'sortBy': sortBy,
        'sortOrder': sortOrder,
      },
    );
    return CarBookingsResponseModel.fromJson(response.data);
  }
}
