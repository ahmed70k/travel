import 'package:dio/dio.dart';
import 'package:travle/core/network/api_constants.dart';
import '../models/car_booking_model.dart';

abstract class CarBookingRemoteDataSource {
  Future<CarBookingModel> createCarBooking(CarBookingModel booking);
}

class CarBookingRemoteDataSourceImpl implements CarBookingRemoteDataSource {
  final Dio dio;

  CarBookingRemoteDataSourceImpl(this.dio);

  @override
  Future<CarBookingModel> createCarBooking(CarBookingModel booking) async {
    try {
      final response = await dio.post(
        ApiConstants.adminCarsBookings,
        data: booking.toJson(),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return CarBookingModel.fromJson(response.data);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
        );
      }
    } catch (e) {
      rethrow;
    }
  }
}
