import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/booking_entities.dart';
import '../repositories/bookings_repository.dart';

class CreateB2BHotelBookingUseCase {
  final BookingsRepository repository;

  CreateB2BHotelBookingUseCase({required this.repository});

  Future<Either<Failure, HotelBookingEntity>> call(HotelBookingEntity booking) async {
    return await repository.createHotelBooking(booking);
  }
}
