import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/b2c_hotel_booking_entity.dart';
import '../repositories/b2c_bookings_repository.dart';

class CreateB2CHotelBookingUseCase {
  final B2CBookingsRepository repository;

  CreateB2CHotelBookingUseCase(this.repository);

  Future<Either<Failure, B2CHotelBookingEntity>> call(B2CHotelBookingEntity booking) async {
    return await repository.createHotelBooking(booking);
  }
}
