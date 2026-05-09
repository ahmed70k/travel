import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/booking_entities.dart';
import '../repositories/bookings_repository.dart';

class GetB2BCarsBookingsUseCase {
  final BookingsRepository repository;

  GetB2BCarsBookingsUseCase({required this.repository});

  Future<Either<Failure, List<CarBookingEntity>>> call() async {
    return await repository.getCarsBookings();
  }
}
