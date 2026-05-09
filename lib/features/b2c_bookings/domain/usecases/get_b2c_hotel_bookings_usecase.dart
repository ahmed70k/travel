import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/b2c_hotel_booking_entity.dart';
import '../repositories/b2c_bookings_repository.dart';

class GetB2CHotelBookingsUseCase {
  final B2CBookingsRepository repository;

  GetB2CHotelBookingsUseCase(this.repository);

  Future<Either<Failure, List<B2CHotelBookingEntity>>> call() async {
    return await repository.getHotelBookings();
  }
}
