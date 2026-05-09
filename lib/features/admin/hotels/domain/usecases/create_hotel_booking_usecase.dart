import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../../data/models/create_hotel_booking_request.dart';
import '../repositories/hotel_bookings_repository.dart';

class CreateHotelBookingUseCase {
  final HotelBookingsRepository repository;

  const CreateHotelBookingUseCase(this.repository);

  Future<Either<Failure, Map<String, dynamic>>> call(CreateHotelBookingRequest request) {
    return repository.createBooking(request);
  }
}
