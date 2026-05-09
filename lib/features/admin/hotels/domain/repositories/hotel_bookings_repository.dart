import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../../data/models/create_hotel_booking_request.dart';

abstract class HotelBookingsRepository {
  Future<Either<Failure, Map<String, dynamic>>> createBooking(CreateHotelBookingRequest request);
}
