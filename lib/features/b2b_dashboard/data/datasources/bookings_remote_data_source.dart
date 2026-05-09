import 'package:dio/dio.dart';
import '../../../../core/network/api_constants.dart';
import '../models/booking_models.dart';

abstract class BookingsRemoteDataSource {
  Future<MyBookingsModel> getMyBookings();
  
  // New GET methods
  Future<List<FlightBookingModel>> getFlightsBookings();
  Future<List<HotelBookingModel>> getHotelsBookings();
  Future<List<CarBookingModel>> getCarsBookings();

  // New POST methods
  Future<FlightBookingModel> createFlightBooking(FlightBookingModel booking);
  Future<HotelBookingModel> createHotelBooking(HotelBookingModel booking);
  Future<CarBookingModel> createCarBooking(CarBookingModel booking);
}

class BookingsRemoteDataSourceImpl implements BookingsRemoteDataSource {
  final Dio dio;

  BookingsRemoteDataSourceImpl({required this.dio});

  @override
  Future<MyBookingsModel> getMyBookings() async {
    final response = await dio.get(ApiConstants.myBookings);
    if (response.statusCode == 200) {
      if (response.data is List) {
        return MyBookingsModel.fromJson({'data': response.data});
      }
      return MyBookingsModel.fromJson(response.data);
    } else {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
      );
    }
  }

  @override
  Future<List<FlightBookingModel>> getFlightsBookings() async {
    final response = await dio.get(ApiConstants.adminFlightsBookings);
    if (response.statusCode == 200) {
      final List data = response.data['data'] ?? response.data;
      return data.map((e) => FlightBookingModel.fromJson(e)).toList();
    } else {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
      );
    }
  }

  @override
  Future<List<HotelBookingModel>> getHotelsBookings() async {
    final response = await dio.get(ApiConstants.adminHotelBookings);
    if (response.statusCode == 200) {
      final List data = response.data['data'] ?? response.data;
      return data.map((e) => HotelBookingModel.fromJson(e)).toList();
    } else {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
      );
    }
  }

  @override
  Future<List<CarBookingModel>> getCarsBookings() async {
    final response = await dio.get(ApiConstants.adminCarsBookings);
    if (response.statusCode == 200) {
      final List data = response.data['data'] ?? response.data;
      return data.map((e) => CarBookingModel.fromJson(e)).toList();
    } else {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
      );
    }
  }

  @override
  Future<FlightBookingModel> createFlightBooking(FlightBookingModel booking) async {
    final response = await dio.post(
      ApiConstants.adminFlightsBookings,
      data: booking.toJson(),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return FlightBookingModel.fromJson(response.data['data'] ?? response.data);
    } else {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
      );
    }
  }

  @override
  Future<HotelBookingModel> createHotelBooking(HotelBookingModel booking) async {
    final response = await dio.post(
      ApiConstants.adminHotelBookings,
      data: booking.toJson(),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return HotelBookingModel.fromJson(response.data['data'] ?? response.data);
    } else {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
      );
    }
  }

  @override
  Future<CarBookingModel> createCarBooking(CarBookingModel booking) async {
    final response = await dio.post(
      ApiConstants.adminCarsBookings,
      data: booking.toJson(),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return CarBookingModel.fromJson(response.data['data'] ?? response.data);
    } else {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
      );
    }
  }
}
