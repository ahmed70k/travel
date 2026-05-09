import 'package:travle/core/network/dio_client.dart';
import 'package:travle/core/network/api_constants.dart';
import '../models/create_hotel_booking_request.dart';


abstract class HotelBookingRemoteDataSource {
  Future<Map<String, dynamic>> createBooking(CreateHotelBookingRequest request);
}

class HotelBookingRemoteDataSourceImpl implements HotelBookingRemoteDataSource {
  final DioClient dioClient;

  const HotelBookingRemoteDataSourceImpl(this.dioClient);

  @override
  Future<Map<String, dynamic>> createBooking(CreateHotelBookingRequest request) async {
    final response = await dioClient.dio.post(
      ApiConstants.adminHotelBookings,
      data: request.toJson(),
    );
    return response.data;
  }
}
