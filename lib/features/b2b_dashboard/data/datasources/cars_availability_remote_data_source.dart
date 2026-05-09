import 'package:dio/dio.dart';
import '../../../../core/network/api_constants.dart';
import '../models/availability_model.dart';

abstract class CarsAvailabilityRemoteDataSource {
  Future<AvailabilityModel> getAvailability({String? from, String? to});
}

class CarsAvailabilityRemoteDataSourceImpl implements CarsAvailabilityRemoteDataSource {
  final Dio dio;

  CarsAvailabilityRemoteDataSourceImpl({required this.dio});

  @override
  Future<AvailabilityModel> getAvailability({String? from, String? to}) async {
    final response = await dio.get(
      ApiConstants.carsAvailability,
      queryParameters: {
        if (from != null) 'from': from,
        if (to != null) 'to': to,
      },
    );

    if (response.statusCode == 200) {
      return AvailabilityModel.fromJson(response.data);
    } else {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
      );
    }
  }
}
