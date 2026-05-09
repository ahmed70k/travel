import 'package:dio/dio.dart';
import '../../../../core/network/api_constants.dart';
import '../models/flight_booking_model.dart';
import '../models/hotel_booking_model.dart';
import '../models/car_booking_model.dart';

abstract class B2CBookingsRemoteDataSource {
  Future<List<B2CFlightBookingModel>> getFlightBookings();
  Future<B2CFlightBookingModel> createFlightBooking(B2CFlightBookingModel booking);
  
  Future<List<B2CHotelBookingModel>> getHotelBookings();
  Future<B2CHotelBookingModel> createHotelBooking(B2CHotelBookingModel booking);

  Future<List<B2CCarBookingModel>> getCarBookings();
  Future<B2CCarBookingModel> createCarBooking(B2CCarBookingModel booking);
}

class B2CBookingsRemoteDataSourceImpl implements B2CBookingsRemoteDataSource {
  final Dio dio;

  B2CBookingsRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<B2CFlightBookingModel>> getFlightBookings() async {
    final response = await dio.get(ApiConstants.myBookings);
    if (response.statusCode == 200) {
      final data = response.data['data'];
      final List flights = data['flights'] ?? [];
      return flights.map((e) => B2CFlightBookingModel.fromJson(e)).toList();
    } else {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
      );
    }
  }

  @override
  Future<B2CFlightBookingModel> createFlightBooking(B2CFlightBookingModel booking) async {
    final response = await dio.post(
      ApiConstants.adminFlightsBookings,
      data: booking.toJson(),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return B2CFlightBookingModel.fromJson(response.data['data'] ?? response.data);
    } else {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
      );
    }
  }

  @override
  Future<List<B2CHotelBookingModel>> getHotelBookings() async {
    final response = await dio.get(ApiConstants.myBookings);
    if (response.statusCode == 200) {
      final data = response.data['data'];
      final List hotels = data['hotels'] ?? [];
      return hotels.map((e) => B2CHotelBookingModel.fromJson(e)).toList();
    } else {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
      );
    }
  }

  @override
  Future<B2CHotelBookingModel> createHotelBooking(B2CHotelBookingModel booking) async {
    final response = await dio.post(
      ApiConstants.adminHotelBookings,
      data: booking.toJson(),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return B2CHotelBookingModel.fromJson(response.data['data'] ?? response.data);
    } else {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
      );
    }
  }

  @override
  Future<List<B2CCarBookingModel>> getCarBookings() async {
    final response = await dio.get(ApiConstants.myBookings);
    if (response.statusCode == 200) {
      final data = response.data['data'];
      final List cars = data['cars'] ?? [];
      return cars.map((e) => B2CCarBookingModel.fromJson(e)).toList();
    } else {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
      );
    }
  }

  @override
  Future<B2CCarBookingModel> createCarBooking(B2CCarBookingModel booking) async {
    final response = await dio.post(
      ApiConstants.adminCarsBookings,
      data: booking.toJson(),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return B2CCarBookingModel.fromJson(response.data['data'] ?? response.data);
    } else {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
      );
    }
  }
}
