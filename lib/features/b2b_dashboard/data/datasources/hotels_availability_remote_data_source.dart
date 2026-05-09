import 'package:dio/dio.dart';
import '../../../../core/network/api_constants.dart';
import '../models/availability_model.dart';

abstract class HotelsAvailabilityRemoteDataSource {
  Future<AvailabilityModel> getAvailability({String? from, String? to});
}

class HotelsAvailabilityRemoteDataSourceImpl implements HotelsAvailabilityRemoteDataSource {
  final Dio dio;

  HotelsAvailabilityRemoteDataSourceImpl({required this.dio});

  @override
  Future<AvailabilityModel> getAvailability({String? from, String? to}) async {
    final response = await dio.get(
      ApiConstants.hotelsAvailability,
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
