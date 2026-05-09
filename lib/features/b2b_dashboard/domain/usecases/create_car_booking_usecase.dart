import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/booking_entities.dart';
import '../repositories/bookings_repository.dart';

class CreateB2BCarBookingUseCase {
  final BookingsRepository repository;

  CreateB2BCarBookingUseCase({required this.repository});

  Future<Either<Failure, CarBookingEntity>> call(CarBookingEntity booking) async {
    return await repository.createCarBooking(booking);
  }
}
