import 'package:travle/core/network/dio_client.dart';
import '../models/create_flight_booking_request.dart';
import '../models/admin_flights_model.dart';

abstract class AdminFlightsRemoteDataSource {
  Future<AdminFlightsModel> getFlights({
    String? from,
    String? to,
    String? tripType,
    String? category,
  });

  Future<FlightBookingModel> createFlight(CreateFlightBookingRequest request);
}

class AdminFlightsRemoteDataSourceImpl implements AdminFlightsRemoteDataSource {
  final DioClient dioClient;

  const AdminFlightsRemoteDataSourceImpl(this.dioClient);

  @override
  Future<AdminFlightsModel> getFlights({
    String? from,
    String? to,
    String? tripType,
    String? category,
  }) async {
    final response = await dioClient.dio.get(
      '/dashboard/admin/flights',
      queryParameters: {
        if (from != null) 'from': from,
        if (to != null) 'to': to,
        if (tripType != null) 'tripType': tripType,
        if (category != null) 'category': category,
      },
    );
    return AdminFlightsModel.fromJson(response.data);
  }

  @override
  Future<FlightBookingModel> createFlight(CreateFlightBookingRequest request) async {
    final response = await dioClient.dio.post(
      '/bookings/flights',
      data: request.toJson(),
    );
    return FlightBookingModel.fromJson(response.data);
  }
}
